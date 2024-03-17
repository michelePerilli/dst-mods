local KingTracker = Class(function(self, inst)
	self.inst = inst
	self.maxhunger = 200
	self.currenthunger = 1
end)

function KingTracker:Update(new)
	self.currenthunger = new
	self.inst:PushEvent("kinghungerdelta", { newval = self.currenthunger})
end

function KingTracker:GetHunger()
	return self.currenthunger * self.maxhunger
end

function KingTracker:GetMaxHunger()
	return self.maxhunger
end
return KingTracker
