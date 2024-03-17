AddRecipe("armor_sanity",
        {
            Ingredient("nightmarefuel", 12),
            Ingredient("armorgrass", 1)
        },
        GLOBAL.RECIPETABS.MAGIC,
        GLOBAL.TECH.MAGIC_THREE
)


AddPrefabPostInit("armor_sanity", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst.components.armor:InitCondition(150 * 5, .95)
    end
end)