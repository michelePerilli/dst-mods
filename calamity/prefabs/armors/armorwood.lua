GLOBAL.TUNING.ARMORWOOD = 350
GLOBAL.TUNING.ARMORWOOD_ABSORPTION = .7

AddPrefabPostInit("armorwood", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALL / 2)

end)