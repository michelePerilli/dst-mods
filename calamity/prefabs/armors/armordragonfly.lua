GLOBAL.TUNING.ARMORDRAGONFLY = 1200
GLOBAL.TUNING.ARMORDRAGONFLY_ABSORPTION = .8

local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_dragonfly")
    else
        owner.AnimState:OverrideSymbol("swap_body", "torso_dragonfly", "swap_body")
    end

    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)

    if owner.components.health ~= nil then
        owner.components.health.externalfiredamagemultipliers:SetModifier(inst, 1 - GLOBAL.TUNING.ARMORDRAGONFLY_FIRE_RESIST)
    end

end

AddPrefabPostInit("armordragonfly", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALL)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(GLOBAL.TUNING.INSULATION_SMALL)

    if inst.components.equippable == nil then
        return
    end
    inst.components.equippable:SetOnEquip(onequip)

end)