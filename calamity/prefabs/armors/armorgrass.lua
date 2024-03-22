GLOBAL.TUNING.ARMORGRASS = 200
GLOBAL.TUNING.ARMORGRASS_ABSORPTION = .5


-- TODO la bruciatura del player dura 40% in piu

AddPrefabPostInit("armorgrass", function(inst)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(GLOBAL.TUNING.WATERPROOFNESS_SMALL/2)

end)