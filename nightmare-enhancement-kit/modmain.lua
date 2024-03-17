local postinit_prefab = {
    "nightsword",
    "armor_sanity",
    "beargervestmod"
}

for _, v in pairs(postinit_prefab) do modimport("prefabs/" .. v ..".lua") end
