AddRecipe("nightsword",
        {
            Ingredient("nightmarefuel", 8),
            Ingredient("spear", 1),
            Ingredient("livinglog", 2)
        },
        GLOBAL.RECIPETABS.MAGIC,
        GLOBAL.TECH.MAGIC_THREE
)

local function onAttack(inst, attacker, target)
    if not inst.components.fueled:IsEmpty() then
        inst.components.fueled:DoDelta(-(TUNING.MED_LARGE_FUEL / 10))
    end
    -- fai qualcosa al target
end

local function onFuelChanged(inst, data)
    if data and data.percent then
        if data.percent > 0.8 then
            -- 80% o piu'
            inst.components.equippable.dapperness = TUNING.CRAZINESS_SMALL
            inst.components.weapon:SetRange(nil)
            inst.components.weapon:SetDamage(62)
        elseif data.percent > 0.4 then
            -- dal 40% all'80%
            inst.components.equippable.dapperness = TUNING.CRAZINESS_MED
            inst.components.weapon:SetRange(0.5)
            inst.components.weapon:SetDamage(68)
        elseif data.percent > 0 then
            -- 40% o meno
            inst.components.equippable.dapperness = TUNING.CRAZINESS_MED * 2
            inst.components.weapon:SetRange(1)
            inst.components.weapon:SetDamage(74)
        end
    end
end

local function CLIENT_PlayFuelSound(inst)
    local parent = inst.entity:GetParent()
    local container = parent ~= nil and (parent.replica.inventory or parent.replica.container) or nil
    if container ~= nil and container:IsOpenedBy(ThePlayer) then
        TheFocalPoint.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    end
end

local function SERVER_PlayFuelSound(inst)
    local owner = inst.components.inventoryitem.owner
    if owner == nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    elseif inst.components.equippable:IsEquipped() and owner.SoundEmitter ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")
    else
        inst.playfuelsound:push()
        --Dedicated server does not need to trigger sfx
        if not GLOBAL.TheNet:IsDedicated() then
            CLIENT_PlayFuelSound(inst)
        end
    end
end

AddPrefabPostInit("nightsword", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst.entity:AddSoundEmitter()
        inst.components.weapon:SetOnAttack(onAttack)
        inst.playfuelsound = GLOBAL.net_event(inst.GUID, "nightsword.playfuelsound")
        inst:DoTaskInTime(0, inst.ListenForEvent, "nightsword.playfuelsound", CLIENT_PlayFuelSound)

        inst:RemoveComponent("finiteuses")
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "NIGHTMARE"
        inst.components.fueled:InitializeFuelLevel(TUNING.MED_LARGE_FUEL * 10)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)

        inst.components.fueled.accepting = true
        inst.components.fueled:SetTakeFuelFn(SERVER_PlayFuelSound)
        inst.components.fueled:SetDepletedFn(inst.Remove)

        inst:ListenForEvent("percentusedchange", onFuelChanged)
        inst:DoTaskInTime(0, function()
            onFuelChanged(inst, { percent = inst.components.fueled:GetPercent() })
        end)

    end
end)