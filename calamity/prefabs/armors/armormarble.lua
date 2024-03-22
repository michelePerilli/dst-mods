GLOBAL.TUNING.ARMORMARBLE = 1000
GLOBAL.TUNING.ARMORMARBLE_ABSORPTION = .85
GLOBAL.TUNING.ARMORMARBLE_SLOW = .8

AddPrefabPostInit("armormarble", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALLMED / 2)

end)