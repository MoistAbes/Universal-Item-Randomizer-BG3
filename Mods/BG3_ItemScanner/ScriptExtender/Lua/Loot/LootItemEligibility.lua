ULF_LootItemEligibility = {}

-- ============================================================
-- CHECK ITEM ELIGIBILITY
-- ============================================================

function ULF_LootItemEligibility.IsEligible(record)

    if not record then
        return false
    end

    if record.IsQuestItem == true then
        return false
    end

    local category =
        record.Category

    if not category then
        return false
    end

    return
        ULF_LootConfig.AllowedCategories[category] == true
end