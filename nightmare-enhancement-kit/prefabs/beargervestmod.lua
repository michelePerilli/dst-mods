local function doWarmMe(owner)
    owner.components.temperature:DoDelta(1)
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "torso_bearger")
    else
        owner.AnimState:OverrideSymbol("swap_body", "torso_bearger", "swap_body")
    end

    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.ARMORBEARGER_SLOW_HUNGER)
    end
    inst.components.fueled:StartConsuming()
    if (inst.warming ~= nil) then
        inst.warming:Cancel()
    end
    inst.warming = owner:DoPeriodicTask(10, doWarmMe, nil, inst)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
    inst.components.fueled:StopConsuming()

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    if (inst.warming ~= nil) then
        inst.warming:Cancel()
        inst.warming = nil
    end
end

AddPrefabPostInit("beargervest", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
    end
end)