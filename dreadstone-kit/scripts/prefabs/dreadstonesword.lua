local ANIM_SMOKE_TEXTURE = "fx/miasma.tex"
local assets = {
    Asset("ANIM", "anim/dreadstonesword.zip"),
    Asset("ANIM", "anim/swap_dreadstonesword.zip"),

    Asset("ATLAS", "images/inventoryimages/dreadstonesword.xml"),
    Asset("IMAGE", "images/inventoryimages/dreadstonesword.tex"),

    Asset("IMAGE", ANIM_SMOKE_TEXTURE),
}

local function SetupParticles(inst)
    if InitEnvelope ~= nil then
        InitEnvelope()
    end

    local effect = inst.entity:AddVFXEffect()
    effect:InitEmitters(2)

    -- SMOKE
    effect:SetRenderResources(0, ANIM_SMOKE_TEXTURE, SMOKE_SHADER)
    effect:SetMaxNumParticles(0, 50)
    effect:SetRotationStatus(0, true)
    effect:SetMaxLifetime(0, SMOKE_MAX_LIFETIME)
    effect:SetColourEnvelope(0, COLOUR_ENVELOPE_NAME_SMOKE)
    effect:SetScaleEnvelope(0, SCALE_ENVELOPE_NAME_SMOKE)
    effect:SetUVFrameSize(0, 0.5, 1)
    effect:SetBlendMode(0, BLENDMODE.AlphaBlended)
    effect:SetSortOrder(0, 0)
    effect:SetSortOffset(0, 0)
    effect:SetRadius(0, SMOKE_RADIUS) --only needed on a single emitter
    effect:SetDragCoefficient(0, .1)

    -- EMBER
    effect:SetRenderResources(1, EMBER_TEXTURE, EMBER_SHADER)
    effect:SetMaxNumParticles(1, 128)
    effect:SetMaxLifetime(1, EMBER_MAX_LIFETIME)
    effect:SetColourEnvelope(1, COLOUR_ENVELOPE_NAME_EMBER)
    effect:SetScaleEnvelope(1, SCALE_ENVELOPE_NAME_EMBER)
    effect:SetBlendMode(1, BLENDMODE.Additive)
    effect:EnableBloomPass(1, true)
    effect:SetSortOrder(1, 0)
    effect:SetSortOffset(1, 0)
    effect:SetDragCoefficient(1, 0.07)

    -----------------------------------------------------
    -- Local cache for when FX are emitted.
    local _world = TheWorld
    local _sim = TheSim

    local smoke_circle_emitter = CreateCircleEmitter(SMOKE_RADIUS)
    local ember_sphere_emitter = CreateSphereEmitter(SMOKE_SIZE)

    local particles_per_tick = 2 * TheSim:GetTickTime() -- Half intensity with particle placement folding.
    local num_to_emit = 0
    EmitterManager:AddEmitter(inst, nil, function()
        local _player = ThePlayer
        if _player then
            local parent = inst.entity:GetParent()
            if parent and (parent.IsCloudEnabled == nil or parent:IsCloudEnabled()) then
                local px, _, pz = _player.Transform:GetWorldPosition()
                local ex, _, ez = parent.Transform:GetWorldPosition()
                local isdiminishing = parent._diminishing:value()
                local isfront = inst._frontsemicircle

                num_to_emit = num_to_emit + particles_per_tick
                while num_to_emit > 1 do
                    emit_smoke_fn(effect, smoke_circle_emitter, ember_sphere_emitter, px, pz, ex, ez, isdiminishing, isfront, _world, _sim)
                    num_to_emit = num_to_emit - 1
                end
            end
        end
    end)
end

local function isDamaged(inst)
    return inst.components.finiteuses:GetPercent() < 1
end
local function GetSetBonusEquip(inst, owner)
    local hat = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
    local armor = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
    local dreadstonevalue = 0
    if (hat ~= nil) then dreadstonevalue = dreadstonevalue + 1 end
    if (armor ~= nil) then dreadstonevalue = dreadstonevalue + 1 end
    return dreadstonevalue
end

local function DoRegen(inst, owner)
    local bonusRegen = GetSetBonusEquip(inst, owner)
    if owner.components.sanity ~= nil and owner.components.sanity:IsInsanityMode() then
        local setbonus = inst.components.setbonus ~= nil and inst.components.setbonus:IsEnabled(EQUIPMENTSETNAMES.DREADSTONE) and TUNING.ARMOR_DREADSTONE_REGEN_SETBONUS or 1
        local rate = 1 / Lerp(1 / TUNING.ARMOR_DREADSTONE_REGEN_MAXRATE, 1 / TUNING.ARMOR_DREADSTONE_REGEN_MINRATE, owner.components.sanity:GetPercent())
        inst.components.finiteuses:Use(-TUNING.DREADSTONESWORD_USES * rate * setbonus * (bonusRegen / 2))
    end
    if not isDamaged(inst) then
        inst.regentask:Cancel()
        inst.regentask = nil
    end
end

local function StartRegen(inst, owner)
    if inst.regentask == nil then
        inst.regentask = inst:DoPeriodicTask(TUNING.ARMOR_DREADSTONE_REGEN_PERIOD, DoRegen, nil, owner)
    end
end

local function StopRegen(inst)
    if inst.regentask ~= nil then
        inst.regentask:Cancel()
        inst.regentask = nil
    end
end

local function CalcDapperness(inst, owner)
    local insanity = owner.components.sanity ~= nil and owner.components.sanity:IsInsanityMode()
    local bonus = GetSetBonusEquip(inst, owner)
    if bonus == 2 then
        return insanity and inst.regentask ~= nil and 0 or 0
    elseif bonus == 1 then
        return insanity and inst.regentask ~= nil and TUNING.CRAZINESS_MED or 0
    else
        return insanity and inst.regentask ~= nil and TUNING.CRAZINESS_MED * 2 or 0
    end
end



local function onEquip(inst, owner)

    owner.AnimState:OverrideSymbol("swap_object", "swap_dreadstonesword", "dreadstonesword")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner.components.sanity ~= nil and isDamaged(inst) then
        StartRegen(inst, owner)
    else
        StopRegen(inst)
    end
end

local function onUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function onAttack(inst, attacker, target)
    if GetSetBonusEquip(inst, attacker) == 2 then
        if math.random() < TUNING.DREADSTONESWORD_CRIT_RATE then
            inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
            inst.components.epicscare:Scare(3)
            local front = SpawnPrefab("miasma_cloud_fx")
            front.entity:SetParent(attacker.entity)
        end
    end
end


local function dreadstonesword_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("dreadstonesword")
    inst.AnimState:SetBuild("dreadstonesword")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddTag("sharp")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.DREADSTONESWORD_BASE_DAMAGE)
    inst.components.weapon:SetRange(0.7)
    inst.components.weapon:SetOnAttack(onAttack)

    inst:AddComponent("inspectable")
    inst:AddComponent("talker")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "dreadstonesword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dreadstonesword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onEquip)
    inst.components.equippable:SetOnUnequip(onUnequip)
    inst.components.equippable.dapperfn = CalcDapperness
    inst.components.equippable.is_magic_dapperness = true

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.DREADSTONESWORD_USES)
    inst.components.finiteuses:SetUses(TUNING.DREADSTONESWORD_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("epicscare")
    inst.components.epicscare:SetRange(TUNING.BEEQUEEN_EPICSCARE_RANGE)

    --inst:ListenForEvent("attacked", onHit)

    local setbonus = inst:AddComponent("setbonus")
    setbonus:SetSetName(EQUIPMENTSETNAMES.DREADSTONE)

    return inst
end

STRINGS.NAMES.DREADSTONESWORD = "Dreadstone Sword"
STRINGS.RECIPE_DESC.DREADSTONESWORD = "Coming soon.."

return Prefab("common/inventory/dreadstonesword", dreadstonesword_fn, assets, prefabs)
