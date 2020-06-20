-- Event frame
local EventFrame = CreateFrame("Frame")

-- Label frame
local FreeSlotsLabel = MainMenuBarBackpackButton:CreateFontString("FreeSlotsLabel", "OVERLAY", "GameTooltipText")
FreeSlotsLabel:SetFont("Fonts\\ARIALN.TTF", 14, "THINOUTLINE")
FreeSlotsLabel:SetPoint("BOTTOM", 0, 3)
FreeSlotsLabel:SetTextColor(1, 1, 1)

-- Return number of total free slots
local function CountFreeSlots()
    local totalFreeSlots = 0
    for i = 0, NUM_BAG_SLOTS do
        local freeSlots, bagType = GetContainerNumFreeSlots(i)
        if (bagType == 0) then
            totalFreeSlots = totalFreeSlots + freeSlots
        end
    end
    return totalFreeSlots
end

-- Update label
local function UpdateLabel()
    FreeSlotsLabel:SetFormattedText("(%d)", CountFreeSlots())
end

-- Event hook
local function OnEvent(self, event, bagId)
    if (bagId >= 0 and bagId <= NUM_BAG_SLOTS) then
        UpdateLabel()
    end
end

-- Register all events
local function RegisterEvents()
    EventFrame:SetScript("OnEvent", OnEvent)
    EventFrame:RegisterEvent("BAG_UPDATE")
    EventFrame:RegisterEvent("PLAYER_LOGIN")
end

-- Init
RegisterEvents()
