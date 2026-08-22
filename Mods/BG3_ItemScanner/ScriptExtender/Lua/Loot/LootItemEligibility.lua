ULF_LootItemEligibility = {}

-- ============================================================
-- CHECK ITEM ELIGIBILITY
-- ============================================================

function ULF_LootItemEligibility.IsEligible(
    record,
    stat
)

    if not record or not stat then
        return false
    end

    if record.IsStoryItem == true then
        return false
    end

    local category =
        stat.Category

    if not category then
        return false
    end

    return
        ULF_LootConfig.AllowedCategories[category] == true
end