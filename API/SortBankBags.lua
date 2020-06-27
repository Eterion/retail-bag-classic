BankAutosortDisabled = nil

-- Set bank autosort state
function SetBankAutosortDisabled(value)
    BankAutosortDisabled = value
end

-- Get bank autosort state
function GetBankAutosortDisabled()
    return BankAutosortDisabled
end

function SortBankBags()
    print("BankAutosortDisabled", BankAutosortDisabled)
end
