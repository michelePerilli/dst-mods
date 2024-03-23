local function onpickedfn(inst, picker)
    local pos = inst:GetPosition()

    if picker ~= nil then
        if picker.components.sanity ~= nil and not picker:HasTag("plantkin") then
            picker.components.sanity:DoDelta(-GLOBAL.TUNING.SANITY_SUPERTINY)
        end

        if inst.animname == "rose" and
                picker.components.combat ~= nil and
                not (picker.components.inventory ~= nil and picker.components.inventory:EquipHasTag("bramble_resistant")) and not picker:HasTag("shadowminion") then
            picker.components.combat:GetAttacked(inst, GLOBAL.TUNING.ROSE_DAMAGE)
            picker:PushEvent("thorns")
        end
    end

    GLOBAL.TheWorld:PushEvent("plantkilled", { doer = picker, pos = pos }) --this event is pushed in other places too
end

AddPrefabPostInit("flower", function(inst)
    if inst.components.pickable == nil then
        return
    end
    inst.components.pickable.onpickedfn = onpickedfn
    --inst:AddComponent("transformer")
    --inst.components.transformer:SetTransformWorldEvent("isfullmoon", true)
    --inst.components.transformer:SetRevertWorldEvent("isfullmoon", false)
    --inst.components.transformer:SetOnLoadCheck(testfortransformonload)
    --inst.components.transformer.transformPrefab = "flower_evil"
end)