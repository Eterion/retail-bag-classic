-- Display bag filter icon
hooksecurefunc("ContainerFrame_OnShow", function (self)
    local id = self:GetID()
    self.FilterIcon:Hide()
    if (id > 0 and not IsInventoryItemProfessionBag("player", ContainerIDToInventoryID(id))) then
        for i = LE_BAG_FILTER_FLAG_EQUIPMENT, NUM_LE_BAG_FILTER_FLAGS do
            local active = false
            if (id > NUM_BAG_SLOTS) then
                active = GetBankBagSlotFlag(id - NUM_BAG_SLOTS, i)
            else
                active = GetBagSlotFlag(id, i)
            end
            if (active) then
                self.FilterIcon.Icon:SetAtlas(BAG_FILTER_ICONS[i], true)
                self.FilterIcon:Show()
                break
            end
        end
    end
end)

-- Display coin icon on junk items
hooksecurefunc("ContainerFrame_Update", function (self)
    local id = self:GetID()
    local name = self:GetName()
    local itemButton
    local texture, itemCount, locked, quality, readable, _, itemLink, isFiltered, noValue, itemID
    for i = 1, self.size do
        itemButton = _G[name.."Item"..i]
        texture, itemCount, locked, quality, readable, _, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(id, itemButton:GetID())

        -- Junk
        itemButton.JunkIcon:Hide()
        local itemLocation = ItemLocation:CreateFromBagAndSlot(id, itemButton:GetID())
        if C_Item.DoesItemExist(itemLocation) then
            local isJunk = quality == LE_ITEM_QUALITY_POOR and not noValue and MerchantFrame:IsShown()
            itemButton.JunkIcon:SetShown(isJunk)
        end
    end
end)
