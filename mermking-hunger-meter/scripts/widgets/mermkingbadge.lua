local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local TINT = { 120/255, 127/255, 86/255, 1 }


local MermKingBadge = Class(Badge, function(self, owner)
    Badge._ctor(self, nil, owner, TINT, "status_mermking", nil, nil, true)

	self.cur_mermking_hunger = nil

    self.circleframe:GetAnimState():SetBank ("status_wolfgang")
    self.circleframe:GetAnimState():SetBuild("status_wolfgang")
	self.dont_animate_circleframe = true

    self:StartUpdating()
end)

local RATE_SCALE_ANIM =
{
    [RATE_SCALE.INCREASE_HIGH] = "arrow_loop_increase_most",
    [RATE_SCALE.INCREASE_MED] = "arrow_loop_increase_more",
    [RATE_SCALE.INCREASE_LOW] = "arrow_loop_increase",
    [RATE_SCALE.DECREASE_HIGH] = "arrow_loop_decrease_most",
    [RATE_SCALE.DECREASE_MED] = "arrow_loop_decrease_more",
    [RATE_SCALE.DECREASE_LOW] = "arrow_loop_decrease",
}
function MermKingBadge:OnShow()
    self.mode =
    (self.owner:HasTag("beaver") and "beaver") or
            (self.owner:HasTag("weremoose") and "moose") or
            (--[[self.owner:HasTag("weregoose") and]] "goose")
    ShowAnimMode(self.circleframe2:GetAnimState(), self.mode)
    self.circleframe2:GetAnimState():SetPercent("new", 1)
    if self.val > 0 then
        self:StartUpdating()
    end
end

function MermKingBadge:OnHide()
    self:StopUpdating()
end

function MermKingBadge:OnUpdate(dt)
    if TheNet:IsServerPaused() then return end
    --if GLOBAL.TheWorld.components.mermkingmanager then
    --
    --end
end

function MermKingBadge:SetPercent(val)

    local original_val = val
    local max = 200

    if self.circular_meter ~= nil then
        self.circular_meter:GetAnimState():SetPercent("meter", val)
    else
        self.anim:GetAnimState():SetPercent("anim", 1 - val)
        if self.circleframe ~= nil and not self.dont_animate_circleframe then
            self.circleframe:GetAnimState():SetPercent("frame", 1 - val)
        end
    end

    --print(val, max, val * max)
    self.num:SetString(tostring(math.ceil(original_val * max)))
    self.percent = val
end

return MermKingBadge
