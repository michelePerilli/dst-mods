local postinit_prefab = {
    "pebbles", "walter"
}
for _, v in pairs(postinit_prefab) do modimport("prefabs/" .. v ..".lua") end
