AddPrefabPostInit("dragonheadhat", function(inst)
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORDRAGONFLY * 3 / 4, TUNING.ARMORDRAGONFLY_ABSORPTION * 3 / 4)
end)

AddPrefabPostInit("dragonbodyhat", function(inst)
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORDRAGONFLY * 3 / 4, TUNING.ARMORDRAGONFLY_ABSORPTION * 3 / 4)
end)


AddPrefabPostInit("dragontailhat", function(inst)
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORDRAGONFLY * 3 / 4, TUNING.ARMORDRAGONFLY_ABSORPTION * 3 / 4)
end)
