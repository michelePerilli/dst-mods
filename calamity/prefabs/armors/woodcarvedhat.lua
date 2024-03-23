GLOBAL.TUNING.ARMOR_WOODCARVED_HAT = 300
GLOBAL.TUNING.ARMOR_WOODCARVED_HAT_ABSORPTION = .5

AddPrefabPostInit("woodcarvedhat", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALL / 2)

end)