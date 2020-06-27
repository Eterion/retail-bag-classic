BackpackAutosortDisabled = nil

-- Set backpack autosort state
function SetBackpackAutosortDisabled(value)
    BackpackAutosortDisabled = value
end

-- Get backpack autosort state
function GetBackpackAutosortDisabled()
    return BackpackAutosortDisabled
end

function SortBags()
    print("BackpackAutoSortDisabled", BackpackAutoSortDisabled)
    local freeSlots, bagType = GetContainerNumFreeSlots(0)
    print("Free Slots:", freeSlots, "Bag Type:", bagType)
end
