GLOBAL.TUNING.ARMOR_COOKIECUTTERHAT = 600
GLOBAL.TUNING.ARMOR_COOKIECUTTERHAT_ABSORPTION = .6

local oldonequipfn
local oldonunequipfn

local newonequip = function(inst, owner)
    oldonequipfn(inst, owner)
    inst.thorns = function(attacked, data)
        local damage = 3 + (attacked.components.health.currenthealth * .05)
        data.attacker.components.combat:GetAttacked(owner, damage, inst, nil, nil)
    end

    inst:ListenForEvent("attacked", inst.thorns, owner)
end
local newonunequip = function(inst, owner)
    oldonunequipfn(inst, owner)
    inst:RemoveEventCallback("attacked", inst.thorns, owner)
end

AddPrefabPostInit("cookiecutterhat", function(inst)
    if inst.components.equippable == nil then
        return
    end
    oldonequipfn = inst.components.equippable.onequipfn
    oldonunequipfn = inst.components.equippable.onunequipfn
    inst.components.equippable:SetOnEquip(newonequip)
    inst.components.equippable:SetOnUnequip(newonunequip)
end)