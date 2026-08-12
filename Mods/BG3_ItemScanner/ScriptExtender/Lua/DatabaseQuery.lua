print("[ULF] DatabaseQuery.lua LOADED")

ULF_DatabaseQuery = {}


-- ============================================================
-- INTERNAL: RANDOM ITEM FROM INDEX
-- ============================================================

local function GetRandomFromIndex(index, value)

    if not ULF_Database then

        print(
            "[ULF][QUERY] ERROR: ULF_Database is nil"
        )

        return nil
    end


    if not ULF_Database.Indexes then

        print(
            "[ULF][QUERY] ERROR: Indexes are missing"
        )

        return nil
    end


    if not index then

        print(
            "[ULF][QUERY] ERROR: Index is missing"
        )

        return nil
    end


    local items =
        index[value]


    if not items or #items == 0 then

        print(
            "[ULF][QUERY] No items found for value: " ..
            tostring(value)
        )

        return nil
    end


    -- ========================================================
    -- RANDOM ENTRY
    -- ========================================================

    local randomIndex =
        math.random(1, #items)


    local rootTemplate =
        items[randomIndex]


    -- ========================================================
    -- RESOLVE RECORD
    -- ========================================================

    local record =
        ULF_Database.Items[rootTemplate]


    if not record then

        print(
            "[ULF][QUERY] ERROR: Indexed item not found: " ..
            tostring(rootTemplate)
        )

        return nil
    end


    return record
end


-- ============================================================
-- RANDOM BY CATEGORY
-- ============================================================

function ULF_DatabaseQuery.GetRandomByCategory(category)

    local categoryIndex =
        ULF_Database.Indexes
        and ULF_Database.Indexes.Category


    if not categoryIndex then

        print(
            "[ULF][QUERY] ERROR: Category index is missing"
        )

        return nil
    end


    return GetRandomFromIndex(
        categoryIndex,
        category
    )
end


-- ============================================================
-- RANDOM BY RARITY
-- ============================================================

function ULF_DatabaseQuery.GetRandomByRarity(rarity)

    local rarityIndex =
        ULF_Database.Indexes
        and ULF_Database.Indexes.Rarity


    if not rarityIndex then

        print(
            "[ULF][QUERY] ERROR: Rarity index is missing"
        )

        return nil
    end


    return GetRandomFromIndex(
        rarityIndex,
        rarity
    )
end


-- ============================================================
-- TEST API
-- ============================================================

function ULF_DatabaseQuery.Test()

    return "QUERY_OK"

end


-- ============================================================
-- API EXPORT
-- ============================================================

print(
    "[ULF][QUERY] API exported: " ..
    tostring(type(ULF_DatabaseQuery))
)