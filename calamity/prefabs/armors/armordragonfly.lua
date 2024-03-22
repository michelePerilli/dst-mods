GLOBAL.TUNING.ARMORDRAGONFLY = 1500
GLOBAL.TUNING.ARMORDRAGONFLY_ABSORPTION = .8

AddPrefabPostInit("armordragonfly", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALL)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(GLOBAL.TUNING.INSULATION_SMALL)

end)