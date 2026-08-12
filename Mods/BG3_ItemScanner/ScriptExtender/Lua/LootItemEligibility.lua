print("[ULF] LootItemEligibility.lua LOADED")

ULF_LootItemEligibility = {}

-- ============================================================
-- CONFIGURATION
-- ============================================================

local EXCLUDED_CATEGORIES = {

    Book = true,
    Material = true,
    Other = true

}

-- ============================================================
-- CHECK ITEM ELIGIBILITY
-- ============================================================

function ULF_LootItemEligibility.IsEligible(record)

    if not record then
        return false
    end

    local category =
        record.Category

    if not category then
        return false
    end

    if not ULF_LootConfig
        or not ULF_LootConfig.AllowedCategories then

        print(
            "[ULF][LOOT] ERROR: Category configuration missing"
        )

        return false
    end

    return
        ULF_LootConfig.AllowedCategories[category] == true
end


-- ============================================================
-- TEST API
-- ============================================================

function ULF_LootItemEligibility.Test()

    return "ITEM_ELIGIBILITY_OK"

end


-- ============================================================
-- API EXPORT
-- ============================================================

print(
    "[ULF][LOOT] Item Eligibility API exported"
)