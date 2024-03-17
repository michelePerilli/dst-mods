local MermKingBadge = require("mermking-hunger-meter/widgets/mermkingbadge")



AddPrefabPostInit("mermking", function(inst)
    local function onHungerDelta(_, data)
        print("onHungerDelta")
        print(inst)
        print(data.newpercent * 200)
        inst:PushEvent("onmermkinghungerchanged", { hunger = data.newpercent * 200 })
    end
    inst:ListenForEvent("hungerdelta", function(_, data)
        onHungerDelta(inst, data)
    end)
end)

AddPlayerPostInit("wurt", function(wurt)
    local function onHungerDelta(_, data)
        print("onHungerDelta")
        print(wurt)
        print(data.hunger)
        wurt:PushEvent("onmermkinghungerchanged", { hunger = data.hunger })
    end
    if GLOBAL.TheWorld.components.mermkingmanager and GLOBAL.TheWorld.components.mermkingmanager:HasKing() then
        local king = GLOBAL.TheWorld.components.mermkingmanager:GetKing()
        wurt:ListenForEvent("onmermkinghungerchanged", function(owner, data)
            onHungerDelta(wurt, data)
        end, king)
    end
end)

AddClassPostConstruct("widgets/statusdisplays", function(self)
    if not self.owner or self.owner.prefab ~= "wurt" then
        return
    end
    function self:HungerDelta(owner, values)
        print("-----")
        print(owner.prefab)
        print(owner.hunger)
        print(values)
        self.mermkingbadge:SetPercent(0.5, 200)
    end
    self.mermkingbadge = self:AddChild(MermKingBadge(self.owner, true))
    self.mermkingbadge:SetPosition(-124, -52)
    self.mermkingbadge:SetPercent(1, 200)
    self.inst:ListenForEvent("akunamatata", function(owner, data)
        self:HungerDelta(owner, data)
    end, self.owner)

end)