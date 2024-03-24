local postinit_prefab = {
    --"dreadstone-kit",
    --"mermking-hunger-meter",
    --"nightmare-enhancement-kit",
    --"walter-rebalance"
}
for _, v in pairs(postinit_prefab) do modimport("" .. v .."/all-modmain.lua") end
