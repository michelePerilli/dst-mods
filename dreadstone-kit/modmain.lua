PrefabFiles = {
    "dreadstonehilt",
    "dreadstonesword",
}
TUNING = GLOBAL.TUNING
RECIPETABS = GLOBAL.RECIPETABS
TECH = GLOBAL.TECH
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT
TUNING.DREADSTONESWORD_USES = 420
TUNING.DREADSTONESWORD_CRIT_RATE = 0.1
TUNING.DREADSTONESWORD_BASE_DAMAGE = 75

AddRecipe(
        "dreadstonehilt", {
            Ingredient("dreadstone", 1),
            Ingredient("thulecite_pieces", 2),
            Ingredient("redgem", 1),
        },
        RECIPETABS.WAR,
        {
            ANCIENT = 4
        }, nil, nil, nil, nil, nil, "images/inventoryimages/dreadstonehilt.xml"
)
local hilt = Ingredient("dreadstonehilt", 1)
hilt.atlas = "images/inventoryimages/dreadstonehilt.xml"
AddRecipe(
        "dreadstonesword", {
            hilt,
            Ingredient("horrorfuel", 1),
            Ingredient("nightsword", 1),
        },
        RECIPETABS.WAR,
        {
            ANCIENT = 4
        }, nil, nil, nil, nil, nil, "images/inventoryimages/dreadstonesword.xml"
)
