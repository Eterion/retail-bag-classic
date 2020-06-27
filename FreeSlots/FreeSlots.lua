SetCVar("displayFreeBagSlots", "1", MainMenuBarBackpackButton)
local BACKPACK_FREESLOTS_FORMAT = "(%s)"

-- Update total free slots
hooksecurefunc("MainMenuBarBackpackButton_UpdateFreeSlots", function ()
    local totalFree = CalculateTotalNumberOfFreeBagSlots()
	MainMenuBarBackpackButtonCount:SetText(BACKPACK_FREESLOTS_FORMAT:format(totalFree))
end)
