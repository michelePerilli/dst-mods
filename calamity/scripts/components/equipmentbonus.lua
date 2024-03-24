local HEAD = EQUIPSLOTS.HEAD
local BODY = EQUIPSLOTS.BODY
local HAND = EQUIPSLOTS.HANDS

local function AlterDamage(inst, damageMult)
    if damageMult == nil then
        inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "kitcombo")
        return
    end
    inst.components.combat.externaldamagemultipliers:SetModifier(inst, damageMult, "kitcombo")
end

local function AlterHealth(inst, health)
    if health == nil then
        inst.components.health.externalabsorbmodifiers:RemoveModifier(inst, "kitcombo")
        return
    end
    inst.components.health.externalabsorbmodifiers:SetModifier(inst, health, "kitcombo")
end

local function AlterHunger(inst, hungerBurnRateMult)
    if hungerBurnRateMult == nil then
        inst.components.hunger.burnratemodifiers:RemoveModifier(inst, "kitcombo")
        return
    end
    inst.components.hunger.burnratemodifiers:SetModifier(inst, hungerBurnRateMult, "kitcombo")
end

local function AlterSanity(inst, sanityAuraModMult)
    if sanityAuraModMult == nil then
        inst.components.sanity.neg_aura_modifiers:RemoveModifier(inst, "kitcombo")
        return
    end
    inst.components.sanity.neg_aura_modifiers:SetModifier(inst, sanityAuraModMult, "kitcombo")
end

local function AlterSpeed(inst, speedMult)
    if speedMult == nil then
        inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
        return
    end
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED * speedMult
end

local sets = {
    ["dragonflyhead"] = {
        [HEAD] = "dragonheadhat",
        [BODY] = "armordragonfly",
        [HAND] = nil
    },
    ["dragonflybody"] = {
        [HEAD] = "dragonbodyhat",
        [BODY] = "armordragonfly",
        [HAND] = nil
    },
    ["dragonflytail"] = {
        [HEAD] = "dragontailhat",
        [BODY] = "armordragonfly",
        [HAND] = nil
    }, ["ruins"] = {
        [HEAD] = "",
        [BODY] = "",
        [HAND] = ""
    } --, ecc
}

local function RemoveBonus(player)
    AlterHealth(player, nil)
    AlterDamage(player, nil)
    AlterHunger(player, nil)
    AlterSanity(player, nil)
    AlterSpeed(player, nil)
end

local function ApplyBonus(player, name)
    RemoveBonus(player)
    if name == "dragonflyhead" then
        AlterDamage(player, 4)
    end
    if name == "dragonflybody" then
        AlterHealth(player, 200)
    end
    if name == "dragonflytail" then
        AlterSpeed(player, 2)
    end
end



local function HasValidEquippedSetPiece(owner)
    local inventory = owner.components.inventory;
    if inventory == nil then
        return nil
    end

    local head = inventory:GetEquippedItem(HEAD) and inventory:GetEquippedItem(HEAD).prefab or nil
    local body = inventory:GetEquippedItem(BODY) and inventory:GetEquippedItem(BODY).prefab or nil
    local hand = inventory:GetEquippedItem(HAND) and inventory:GetEquippedItem(HAND).prefab or nil

    for name, set in pairs(sets) do
        if (true and set[HEAD] == nil or set[HEAD] == head)
                and (set[BODY] == nil or set[BODY] == body)
                and (set[HAND] == nil or set[HAND] == hand) then

            return name
        end
    end
    return nil
end

local function onEquippedSetChanged(inst, data)
    if data == nil or data.item == nil or data.item.components.inventoryitem == nil then
        return
    end
    local owner = data.item.components.inventoryitem.owner
    local bonusName = HasValidEquippedSetPiece(owner)
    if bonusName ~= nil then
        owner:AddTag("kitcombo")
        ApplyBonus(owner, bonusName)
    else
        owner:RemoveTag("kitcombo")
        RemoveBonus(owner)
    end

end

local EquipmentBonus = Class(function(self, inst)
    self.inst = inst
    inst:ListenForEvent("equip", onEquippedSetChanged)
    inst:ListenForEvent("unequip", onEquippedSetChanged)
end)

return EquipmentBonus

