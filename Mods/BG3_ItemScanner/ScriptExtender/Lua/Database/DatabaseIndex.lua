print("[ULF] DatabaseIndex.lua LOADED")

ULF_DatabaseIndex = {}

-- ============================================================
-- CATEGORY INDEX
-- ============================================================

function ULF_DatabaseIndex.BuildCategoryIndex(database)

    print("[ULF][INDEX] Building Category index...")

    if not database or not database.Items then

        print(
            "[ULF][INDEX] ERROR: Database.Items is missing"
        )

        return nil
    end

    local index = {}

    for rootTemplate, record in pairs(database.Items) do

        if record and record.Category then

            local category =
                record.Category

            if not index[category] then
                index[category] = {}
            end

            table.insert(
                index[category],
                rootTemplate
            )
        end
    end

    print(
        "[ULF][INDEX] Category index built"
    )

    for category, items in pairs(index) do

        print(
            "[ULF][INDEX] " ..
            tostring(category) ..
            ": " ..
            tostring(#items)
        )

    end

    return index
end


-- ============================================================
-- RARITY INDEX
-- ============================================================

function ULF_DatabaseIndex.BuildRarityIndex(database)

    print("[ULF][INDEX] Building Rarity index...")

    if not database or not database.Items then

        print(
            "[ULF][INDEX] ERROR: Database.Items is missing"
        )

        return nil
    end

    local index = {}

    for rootTemplate, record in pairs(database.Items) do

        if record and record.Rarity then

            local rarity =
                record.Rarity

            if not index[rarity] then
                index[rarity] = {}
            end

            table.insert(
                index[rarity],
                rootTemplate
            )
        end
    end

    print(
        "[ULF][INDEX] Rarity index built"
    )

    for rarity, items in pairs(index) do

        print(
            "[ULF][INDEX] " ..
            tostring(rarity) ..
            ": " ..
            tostring(#items)
        )

    end

    return index
end


-- ============================================================
-- BUILD ALL INDEXES
-- ============================================================

function ULF_DatabaseIndex.Build(database)

    print("")
    print("[ULF][INDEX] ========================================")
    print("[ULF][INDEX] BUILDING DATABASE INDEXES")
    print("[ULF][INDEX] ========================================")

    if not database or not database.Items then

        print(
            "[ULF][INDEX] ERROR: Database.Items is missing"
        )

        return nil
    end

    local indexes = {}


    -- ========================================================
    -- CATEGORY
    -- ========================================================

    indexes.Category =
        ULF_DatabaseIndex.BuildCategoryIndex(
            database
        )


    -- ========================================================
    -- RARITY
    -- ========================================================

    indexes.Rarity =
        ULF_DatabaseIndex.BuildRarityIndex(
            database
        )


    -- ========================================================
    -- FINISHED
    -- ========================================================

    print("")
    print(
        "[ULF][INDEX] All indexes built"
    )

    print(
        "[ULF][INDEX] ========================================"
    )

    return indexes
end