-- Display deposit reagengs button
hooksecurefunc("UpdateBagSlotStatus", function (self)
    local numSlots, full = GetNumBankSlots()
    if (full) then
        BankDepositReagentsButton:Show()
    else
        BankDepositReagentsButton:Hide()
    end
end)
