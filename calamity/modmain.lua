local prefabs = {
    ["armors"] = {
        "armordragonfly",
        "armorgrass",
        "armormarble",
        "armorwood",
        "beehat",
        "cookiecutterhat",
        "footballhat",
        "wathgrithrhat"
    },
    ["weapons"] = {

    }
}

for folder, current_prefabs in pairs(prefabs) do
    for _, prefab in pairs(current_prefabs) do
        print(prefab)
        modimport("prefabs/" .. folder .. "/" .. prefab .. ".lua")
    end
end