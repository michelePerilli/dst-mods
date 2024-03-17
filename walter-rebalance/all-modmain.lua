local postinit_prefab = {
    "pebbles", "walter"
}
for _, v in pairs(postinit_prefab) do modimport("walter-rebalance/prefabs/" .. v ..".lua") end
