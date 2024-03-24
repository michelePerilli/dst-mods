local prefabs = {
    ["armors"] = {
        "armorbramble",
        "armordragonfly",
        "armorgrass",
        "armormarble",
        "armorwood",
        "beehat",
        "cookiecutterhat",
        "dragonflyhats",
        "footballhat",
        "wathgrithrhat",
        "woodcarvedhat"
    },
    ["nature"] = {
        "flower"
    },
    ["tools"] = {
        "axe",
        "hammer",
        "hoe",
        "multitool",
        "pickaxe",
        "sewingkit",
        "shovel",
        "torch"
    },
    ["weapons"] = {
        "boomerang",
        "hambat",
        "thuleciteclub",
        "whip"
    }
}

for folder, current_prefabs in pairs(prefabs) do
    for _, prefab in pairs(current_prefabs) do
        modimport("prefabs/" .. folder .. "/" .. prefab .. ".lua")
    end
end

AddPlayerPostInit(function(inst)
    inst:AddComponent("equipmentbonus")
end)