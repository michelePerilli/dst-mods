TUNING = GLOBAL.TUNING
TECH = GLOBAL.TECH
AllRecipes = GLOBAL.AllRecipes
require("recipe")

TUNING.WALTER_HEALTH = 100
TUNING.WALTER_HUNGER = 150
TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS = 24                             -- 17
TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD = 38                              -- 34
TUNING.SLINGSHOT_AMMO_DAMAGE_MARBLE = 52                            -- 51
TUNING.SLINGSHOT_AMMO_DAMAGE_THULECITE = 55                         -- 51
TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW = 17                              -- 17
TUNING.SLINGSHOT_AMMO_DAMAGE_TRINKET_1 = 59.5                       -- 59.5
TUNING.SLINGSHOT_AMMO_MOVESPEED_MULT = 2

AddRecipe2("healingsalve_walter", { Ingredient("rocks", 1), Ingredient("spidergland", 1), Ingredient("walterhat", 0) }, TECH.NONE, { builder_tag = "pinetreepioneer", product = "healingsalve", numtogive = 1 }, {"CHARACTER"})
AllRecipes["slingshotammo_rock"].numtogive = 15
AllRecipes["slingshotammo_gold"].numtogive = 15
AllRecipes["slingshotammo_marble"].numtogive = 15
AllRecipes["slingshotammo_poop"].numtogive = 15
AllRecipes["slingshotammo_freeze"].numtogive = 15
AllRecipes["slingshotammo_slow"].numtogive = 15
AllRecipes["slingshotammo_thulecite"].numtogive = 15
