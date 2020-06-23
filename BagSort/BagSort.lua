BankAutosortDisabled = nil
BackpackAutosortDisabled = nil

local function SetBankAutosortDisabled(value)
    BankAutosortDisabled = value
end

local function SetBackpackAutosortDisabled(value)
    BackpackAutosortDisabled = value
end

local function GetBankAutosortDisabled()
    return BankAutosortDisabled
end

local function GetBackpackAutosortDisabled()
    return BackpackAutosortDisabled
end

-- Filters
BAG_FILTER_LABELS = {
    [LE_BAG_FILTER_FLAG_EQUIPMENT] = BAG_FILTER_EQUIPMENT,
    [LE_BAG_FILTER_FLAG_CONSUMABLES] = BAG_FILTER_CONSUMABLES,
    [LE_BAG_FILTER_FLAG_TRADE_GOODS] = BAG_FILTER_TRADE_GOODS,
    [LE_BAG_FILTER_FLAG_JUNK] = BAG_FILTER_JUNK,
}

-- Icons
BAG_FILTER_ICONS = {
	[LE_BAG_FILTER_FLAG_EQUIPMENT] = "bags-icon-equipment",
	[LE_BAG_FILTER_FLAG_CONSUMABLES] = "bags-icon-consumables",
	[LE_BAG_FILTER_FLAG_TRADE_GOODS] = "bags-icon-tradegoods",
}

local function ContainerFrameFilterDropDown_Initialize(self)
    local parent = self:GetParent()
    local id = parent:GetID()

    if (id > NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
        return
    end

    if (id > 0 and not IsInventoryItemProfessionBag("player", ContainerIDToInventoryID(id))) then
        -- Group: Assign To
        local AssignTo = UIDropDownMenu_CreateInfo()
        AssignTo.text = BAG_FILTER_ASSIGN_TO
        AssignTo.isTitle = 1
        AssignTo.notCheckable = 1
        UIDropDownMenu_AddButton(AssignTo)

        -- Flags
        for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
            if (i ~= LE_BAG_FILTER_FLAG_JUNK) then
                local Flag = UIDropDownMenu_CreateInfo()
                Flag.text = BAG_FILTER_LABELS[i]
                Flag.func = function (_, _, _, value)
                    value = not value
                    if (id > NUM_BAG_SLOTS) then
                        SetBankBagSlotFlag(id - NUM_BAG_SLOTS, i ,value)
                    else
                        SetBagSlotFlag(id, i, value)
                    end
                    if (value) then
                        parent.localFlag = i
                        parent.FilterIcon.Icon:SetAtlas(BAG_FILTER_ICONS[i])
                        parent.FilterIcon:Show()
                    else
                        parent.FilterIcon:Hide()
                        parent.localFlag = -1
                    end
                end
                if (parent.localFlag) then
                    Flag.checked = parent.localFlag == i
                else
                    if (id > NUM_BAG_SLOTS) then
                        Flag.checked = GetBankBagSlotFlag(id - NUM_BAG_SLOTS, i)
                    else
                        Flag.checked = GetBagSlotFlag(id, i)
                    end
                end
                Flag.disabled = nil
                Flag.tooltipOnButton = 1
                Flag.tooltipTitle = nil
                Flag.tooltipWhileDisabled = 1
                UIDropDownMenu_AddButton(Flag)
            end
        end
    end

    -- Group: CleanUp
    local CleanUp = UIDropDownMenu_CreateInfo()
    CleanUp.text = BAG_FILTER_CLEANUP
    CleanUp.isTitle = 1
    CleanUp.notCheckable = 1
    UIDropDownMenu_AddButton(CleanUp)

    -- Ignore
    local Ignore = UIDropDownMenu_CreateInfo()
    Ignore.text = BAG_FILTER_IGNORE
    Ignore.isNotRadio = true
    Ignore.func = function (_, _, _, value)
        if (id == -1) then
            SetBankAutosortDisabled(not value)
        elseif (id == 0) then
            SetBackpackAutosortDisabled(not value)
        elseif (id > NUM_BAG_SLOTS) then
            SetBankBagSlotFlag(id - NUM_BAG_SLOTS, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP, not value)
        else
            SetBagSlotFlag(id, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP, not value)
        end
    end
    if (id == -1) then
        Ignore.checked = GetBankAutosortDisabled()
    elseif (id == 0) then
        Ignore.checked = GetBackpackAutosortDisabled()
    elseif (id > NUM_BAG_SLOTS) then
        Ignore.checked = GetBankBagSlotFlag(id - NUM_BAG_SLOTS, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP)
    else
        Ignore.checked = GetBagSlotFlag(id, LE_BAG_FILTER_FLAG_IGNORE_CLEANUP)
    end
    UIDropDownMenu_AddButton(Ignore)
end

local function ContainerFramePortraitButton_OnEnter(self)
    local parent = self:GetParent()
    local id = parent:GetID()
    self.Highlight:Show()
    if (id > 0) then
        if (parent.localFlag and BAG_FILTER_LABELS[parent.localFlag]) then
            GameTooltip:AddLine(BAG_FILTER_ASSIGNED_TO:format(BAG_FILTER_LABELS[parent.localFlag]))
        elseif (not parent.localFlag) then
            for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
                if (GetBagSlotFlag(id, i)) then
                    GameTooltip:AddLine(BAG_FILTER_ASSIGNED_TO:format(BAG_FILTER_LABELS[i]))
                    break
                end
            end
        end
    end
    GameTooltip:AddLine(CLICK_BAG_SETTINGS)
    GameTooltip:Show()
end

local function ContainerFramePortraitButton_OnLeave(self)
    local parent = self:GetParent()
    local id = parent:GetID()
    if (id >= 0) then
        self.Highlight:Hide()
    end
end

local function ContainerFramePortraitButton_OnClick(self)
    local parent = self:GetParent()
    local id = parent:GetID()
    if (id >= 0) then
        local parent = self:GetParent()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        ToggleDropDownMenu(1, nil, parent.FilterDropDown, self:GetName(), 0, 0)
    end
end

local function RegisterPortraitButtonEvents(PortraitButton)
    PortraitButton:HookScript("OnEnter", ContainerFramePortraitButton_OnEnter)
    PortraitButton:HookScript("OnLeave", ContainerFramePortraitButton_OnLeave)
    PortraitButton:HookScript("OnClick", ContainerFramePortraitButton_OnClick)
end

hooksecurefunc("ContainerFrame_OnShow", function (self)
    local id = self:GetID()
    self.FilterIcon:Hide()
    if (id > 0 and id ~= KEYRING_CONTAINER) then
        if (not IsInventoryItemProfessionBag("player", ContainerIDToInventoryID(self:GetID()))) then
            for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
                if (GetBagSlotFlag(id, i)) then
                    self.FilterIcon.Icon:SetAtlas(BAG_FILTER_ICONS[i])
                    self.FilterIcon:Show()
                end
            end
        end
    end
end)

for i = 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
    local ContainerFrame = _G["ContainerFrame"..i]
    RegisterPortraitButtonEvents(ContainerFrame.PortraitButton)
    ContainerFrame.PortraitButton:CreateTexture(nil, "OVERLAY", "ContainerFramePortraitButtonHighlightTemplate")
    CreateFrame("Button", nil, ContainerFrame, "FilterIconTemplate")
    CreateFrame("Frame", "$parentFilterDropdown", ContainerFrame, "FilterDropDownTemplate")
    UIDropDownMenu_Initialize(ContainerFrame.FilterDropDown, ContainerFrameFilterDropDown_Initialize, "MENU")
end

for i, child in ipairs({ BankFrame:GetRegions() }) do
    if (i == 4) then
        child:ClearAllPoints()
        child:SetPoint("TOPLEFT", 80, -48)
        child:SetJustifyH("LEFT")
    end
end

hooksecurefunc("UpdateBagSlotStatus", function (self)
    local numSlots, full = GetNumBankSlots()
    if (full) then
        BankDepositReagentsButton:Show()
    else
        BankDepositReagentsButton:Hide()
    end
end)
