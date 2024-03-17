local assets = {
    Asset("ANIM", "anim/dreadstonehilt.zip"),

    Asset("ATLAS", "images/inventoryimages/dreadstonehilt.xml"),
    Asset("IMAGE", "images/inventoryimages/dreadstonehilt.tex"),
}

local function dreadstonehilt_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("dreadstonehilt")
    inst.AnimState:SetBuild("dreadstonehilt")
    inst.AnimState:PlayAnimation("idle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddTag("sharp")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "dreadstonehilt"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dreadstonehilt.xml"

    return inst
end

STRINGS.NAMES.DREADSTONEHILT = "Dreadstone Hilt"
STRINGS.RECIPE_DESC.DREADSTONEHILT = "Use it for a demoniac sword"

return Prefab("common/inventory/dreadstonehilt", dreadstonehilt_fn, assets, prefabs)
