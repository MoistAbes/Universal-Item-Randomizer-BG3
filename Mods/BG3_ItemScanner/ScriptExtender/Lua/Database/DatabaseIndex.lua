ULF_DatabaseIndex = {}

-- ============================================================
-- CATEGORY INDEX
-- ============================================================

function ULF_DatabaseIndex.BuildCategoryIndex(database)

    ULF_Debug.Print("[DATABASE INDEX] Building Category index...")

    if not database or not database.Items then

        ULF_Debug.Error(
            "[DATABASE INDEX] Database.Items is missing"
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

    ULF_Debug.Print(
        "[DATABASE INDEX] Category index built"
    )

    for category, items in pairs(index) do

        ULF_Debug.Print(
            "[DATABASE INDEX] " ..
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

    ULF_Debug.Print("[DATABASE INDEX] Building Rarity index...")

    if not database or not database.Items then

        ULF_Debug.Error(
            "[DATABASE INDEX] Database.Items is missing"
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

    ULF_Debug.Print(
        "[DATABASE INDEX] Rarity index built"
    )

    for rarity, items in pairs(index) do

        ULF_Debug.Print(
            "[DATABASE INDEX] " ..
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

    ULF_Debug.Print("")
    ULF_Debug.Print("[DATABASE INDEX] BUILDING DATABASE INDEXES")

    if not database or not database.Items then

        ULF_Debug.Error(
            "[DATABASE INDEX] Database.Items is missing"
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

    ULF_Debug.Print("[DATABASE INDEX] All indexes built")
    ULF_Debug.Print("")

    return indexes
end