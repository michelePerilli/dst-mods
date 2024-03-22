GLOBAL.TUNING.ARMORWOOD = 350
GLOBAL.TUNING.ARMORWOOD_ABSORPTION = .7

-- TODO la bruciatura del player dura 20% in piu

AddPrefabPostInit("armorgrass", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALL / 2)

end)