ULF_DatabaseIndex = {}

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

        if record and record.Stats then

            for _, stat in ipairs(record.Stats) do

                if stat and stat.Rarity then

                    local rarity = stat.Rarity

                    if not index[rarity] then
                        index[rarity] = {}
                    end

                    table.insert(
                        index[rarity],
                        ULF_ItemIndexEntryModel.New(
                            rootTemplate,
                            stat.Stat
                        )
                    )
                end
            end
        end
    end

    ULF_Debug.Print("[DATABASE INDEX] Rarity index built")

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
-- BUILD
-- ============================================================

function ULF_DatabaseIndex.Build(database)

    ULF_Debug.Print("")
    ULF_Debug.Print("[DATABASE INDEX] BUILDING DATABASE INDEX")

    if not database or not database.Items then

        ULF_Debug.Error(
            "[DATABASE INDEX] Database.Items is missing"
        )

        return nil
    end

    local indexes = {}

    indexes.Rarity =
        ULF_DatabaseIndex.BuildRarityIndex(
            database
        )

    ULF_Debug.Print("[DATABASE INDEX] Index built")
    ULF_Debug.Print("")

    return indexes
end