local function GetSetBonusEquip(inst, owner)
    local hat = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) or nil
    return hat ~= nil and hat.prefab == "dreadstonehat" and hat or nil
end

local function CalcDapperness(inst, owner)
    local insanity = owner.components.sanity ~= nil and owner.components.sanity:IsInsanityMode()
    local other = GetSetBonusEquip(inst, owner)
    if other ~= nil then
        return (insanity and (inst.regentask ~= nil or other.regentask ~= nil) and TUNING.CRAZINESS_MED or 0) * 0.5
    end
    return insanity and inst.regentask ~= nil and TUNING.CRAZINESS_MED or 0
end

AddPrefabPostInit("dreadstonehat", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst.components.equippable.dapperfn = CalcDapperness
    end
end)