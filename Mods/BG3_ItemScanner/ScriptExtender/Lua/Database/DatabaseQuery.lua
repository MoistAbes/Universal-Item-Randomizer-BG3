ULF_DatabaseQuery = {}

function ULF_DatabaseQuery.GetByRarity(rarity)

    local rarityIndex =
        ULF_Database.Indexes.Rarity

    if not rarityIndex then
        return {}
    end

    local entries =
        rarityIndex[rarity]

    if not entries then
        return {}
    end

    local results = {}

    for _, entry in ipairs(entries) do

        local record =
            ULF_Database.Items[
                entry.RootTemplate
            ]

        if record and record.Stats then

            for _, stat in ipairs(record.Stats) do

                if stat.Stat == entry.Stat then

                    table.insert(
                        results,
                        ULF_LootItemQueryResultModel.New(
                            record,
                            stat
                        )
                    )

                    break
                end

            end

        end

    end

    return results
end

-- ============================================================
-- DEBUG: SCAN ITEM CATEGORIES
-- ============================================================

function ULF_DatabaseQuery.ScanCategories()

    local categories = {}

    for _, record in pairs(ULF_Database.Items) do

        local category =
            record.Category

        if category then

            categories[category] =
                (categories[category] or 0) + 1

        end

    end


    ULF_Debug.Print("")
    ULF_Debug.Print("[DATABASE QUERY] ITEM CATEGORIES")

    local count = 0
    local total = 0

    for category, amount in pairs(categories) do

        count = count + 1
        total = total + amount

        ULF_Debug.Print(
            "[DATABASE QUERY] " ..
            tostring(category) ..
            " -> " ..
            tostring(amount)
        )

    end


    ULF_Debug.Print(
        "[DATABASE QUERY] Unique categories: " ..
        tostring(count)
    )

    ULF_Debug.Print(
        "[DATABASE QUERY] Categorized items: " ..
        tostring(total)
    )

    ULF_Debug.Print(
        "[DATABASE QUERY] Total database items: " ..
        tostring(#ULF_Database.Items)
    )

    ULF_Debug.Print("[DATABASE QUERY] ===============================")

end

-- ============================================================
-- DEBUG: SCAN OTHER STAT PREFIXES
-- ============================================================

function ULF_DatabaseQuery.ScanOtherStatPrefixes()

    local prefixes = {}

    local otherStats = {
        WPN = 0,
        ALCH = 0,
        OBJ = 0,
        UNI = 0,
        Other = 0
    }

    for _, record in pairs(ULF_Database.Items) do

        if record.Category == "Other"
            and record.Stat then

            local stat =
                record.Stat


            -- =================================================
            -- PREFIX
            -- =================================================

            local prefix =
                string.match(
                    stat,
                    "^([^_]+_)"
                )

            if prefix then

                prefixes[prefix] =
                    (prefixes[prefix] or 0) + 1

            end


            -- =================================================
            -- RESEARCH GROUPS
            -- =================================================

            if string.sub(stat, 1, 4) == "WPN_" then

                otherStats.WPN =
                    otherStats.WPN + 1


            elseif string.sub(stat, 1, 5) == "ALCH_" then

                otherStats.ALCH =
                    otherStats.ALCH + 1


            elseif string.sub(stat, 1, 4) == "OBJ_" then

                otherStats.OBJ =
                    otherStats.OBJ + 1


            elseif string.sub(stat, 1, 4) == "UNI_" then

                otherStats.UNI =
                    otherStats.UNI + 1


            else

                otherStats.Other =
                    otherStats.Other + 1

            end

        end

    end


    print("")
    print("[DATABASE QUERY] ===============================")
    print("[DATABASE QUERY] OTHER STAT RESEARCH")
    print("[DATABASE QUERY] ===============================")


    print(
        "[DATABASE QUERY] WPN-like: " ..
        tostring(otherStats.WPN)
    )

    print(
        "[DATABASE QUERY] ALCH-like: " ..
        tostring(otherStats.ALCH)
    )

    print(
        "[DATABASE QUERY] OBJ-like: " ..
        tostring(otherStats.OBJ)
    )

    print(
        "[DATABASE QUERY] UNI-like: " ..
        tostring(otherStats.UNI)
    )

    print(
        "[DATABASE QUERY] Other: " ..
        tostring(otherStats.Other)
    )


    print("")
    print("[DATABASE QUERY] PREFIX BREAKDOWN")
    print("[DATABASE QUERY] ===============================")


    local count = 0

    for prefix, amount in pairs(prefixes) do

        count = count + 1

        print(
            "[DATABASE QUERY] " ..
            tostring(prefix) ..
            " -> " ..
            tostring(amount)
        )

    end


    print(
        "[DATABASE QUERY] Unique prefixes: " ..
        tostring(count)
    )

    print("[DATABASE QUERY] ===============================")

end

-- ============================================================
-- DEBUG: LOOT ELIGIBILITY SIGNAL SCAN
-- ============================================================

function ULF_DatabaseQuery.ScanLootEligibilitySignals()

    -- ========================================================
    -- LOOT CATEGORIES
    -- ========================================================

    local LOOT_CATEGORIES = {

        Weapon = true,
        Armor = true,
        Accessory = true,
        Consumable = true,
        Scroll = true,
        Grenade = true,
        Food = true

    }


    -- ========================================================
    -- SIGNAL PATTERNS
    -- ========================================================

    local SIGNAL_PATTERNS = {

        Blank = {
            "blank"
        },

        Test = {
            "test"
        },

        Dummy = {
            "dummy"
        },

        Placeholder = {
            "placeholder"
        },

        Quest = {
            "quest"
        },

        Reward = {
            "reward"
        }

    }


    -- ========================================================
    -- HELPERS
    -- ========================================================

    local function ContainsPattern(value, pattern)

        if not value then
            return false
        end

        return string.find(
            string.lower(tostring(value)),
            string.lower(pattern),
            1,
            true
        ) ~= nil

    end


    local function FindSignal(record)

        if not record then
            return nil, nil
        end


        local stat =
            tostring(record.Stat or "")

        local displayName =
            tostring(record.DisplayName or "")


        -- ----------------------------------------------------
        -- STAT
        -- ----------------------------------------------------

        for signal, patterns in pairs(
            SIGNAL_PATTERNS
        ) do

            for _, pattern in ipairs(patterns) do

                if ContainsPattern(
                    stat,
                    pattern
                ) then

                    return signal, "Stat"

                end

            end

        end


        -- ----------------------------------------------------
        -- DISPLAY NAME
        -- ----------------------------------------------------

        for signal, patterns in pairs(
            SIGNAL_PATTERNS
        ) do

            for _, pattern in ipairs(patterns) do

                if ContainsPattern(
                    displayName,
                    pattern
                ) then

                    return signal, "Name"

                end

            end

        end


        return nil, nil
    end


    -- ========================================================
    -- RESULTS
    -- ========================================================

    local counts = {

        Blank = 0,
        Test = 0,
        Dummy = 0,
        Placeholder = 0,
        Quest = 0,
        Reward = 0

    }


    local examples = {

        Blank = {},
        Test = {},
        Dummy = {},
        Placeholder = {},
        Quest = {},
        Reward = {}

    }


    local MAX_EXAMPLES = 5


    local scanned = 0
    local matched = 0


    -- ========================================================
    -- SCAN DATABASE
    -- ========================================================

    for rootTemplate, record in pairs(
        ULF_Database.Items
    ) do

        if record
            and LOOT_CATEGORIES[record.Category] then

            scanned = scanned + 1


            local signal, source =
                FindSignal(record)


            if signal then

                matched = matched + 1

                counts[signal] =
                    counts[signal] + 1


                if #examples[signal]
                    < MAX_EXAMPLES then

                    examples[signal][#examples[signal] + 1] = {

                        RootTemplate =
                            record.RootTemplate
                            or rootTemplate,

                        Category =
                            record.Category,

                        Rarity =
                            record.Rarity,

                        Stat =
                            record.Stat,

                        DisplayName =
                            record.DisplayName,

                        Source =
                            source

                    }

                end

            end

        end

    end


    -- ========================================================
    -- OUTPUT
    -- ========================================================

    print(
        "[DATABASE QUERY] ==============================="
    )

    print(
        "[DATABASE QUERY] LOOT ELIGIBILITY SIGNAL SUMMARY"
    )

    print(
        "[DATABASE QUERY] ==============================="
    )

    print(
        "[DATABASE QUERY] Items scanned: " ..
        tostring(scanned)
    )

    print(
        "[DATABASE QUERY] Items matched: " ..
        tostring(matched)
    )


    -- ========================================================
    -- SIGNAL SUMMARY
    -- ========================================================

    for signal, count in pairs(counts) do

        print(
            "[DATABASE QUERY] " ..
            tostring(signal) ..
            ": " ..
            tostring(count)
        )

    end


    -- ========================================================
    -- EXAMPLES
    -- ========================================================

    for signal, items in pairs(examples) do

        if #items > 0 then

            print(
                "[DATABASE QUERY] --------------------------------"
            )

            print(
                "[DATABASE QUERY] SIGNAL: " ..
                tostring(signal)
            )


            for _, item in ipairs(items) do

                print(
                    "[DATABASE QUERY] RootTemplate: " ..
                    tostring(item.RootTemplate)
                )

                print(
                    "[DATABASE QUERY] Category: " ..
                    tostring(item.Category)
                )

                print(
                    "[DATABASE QUERY] Rarity: " ..
                    tostring(item.Rarity)
                )

                print(
                    "[DATABASE QUERY] Stat: " ..
                    tostring(item.Stat)
                )

                print(
                    "[DATABASE QUERY] DisplayName: " ..
                    tostring(item.DisplayName)
                )

                print(
                    "[DATABASE QUERY] Source: " ..
                    tostring(item.Source)
                )

                print(
                    "[DATABASE QUERY] ~"
                )

            end

        end

    end


    print(
        "[DATABASE QUERY] ==============================="
    )


    return {

        Scanned = scanned,

        Matched = matched,

        Counts = counts,

        Examples = examples

    }

end


local function ResearchValue(object, property)
    local value, errorCode = SafeGet(object, property)

    if errorCode then
        print(
            "[RESEARCH] "
            .. property
            .. " = <"
            .. tostring(errorCode)
            .. ">"
        )
        return
    end

    if value == nil then
        print(
            "[RESEARCH] "
            .. property
            .. " = <nil>"
        )
        return
    end

    local ok, text = pcall(function()
        return tostring(value)
    end)

    if ok then
        print(
            "[RESEARCH] "
            .. property
            .. " = "
            .. text
        )
    else
        print(
            "[RESEARCH] "
            .. property
            .. " = <unprintable>"
        )
    end
end

function SafeGet(object, property)

    if not object then
        return nil, "NoObject"
    end

    local ok, value = pcall(function()

        return object[property]

    end)

    if not ok then

        return nil, "PropertyError"

    end

    return value, nil
end

function ULF_DatabaseQuery.ResearchItem(statName)

    print("")
    print("[RESEARCH] ========================================")
    print("[RESEARCH] ITEM: " .. tostring(statName))
    print("[RESEARCH] ========================================")

    local stat = Ext.Stats.Get(statName)

    if not stat then
        print("[RESEARCH] STAT NOT FOUND")
        return
    end

    print("")
    print("[RESEARCH] --- STAT ---")

    local statProperties = {
        "RootTemplate",
        "DisplayName",
        "Description",
        "Rarity",
        "Level",
        "Icon",
        "Weapon Group",
        "Proficiency Group",
        "Value",
        "Weight",
        "Damage",
        "Damage Type",
        "UseCosts",
        "Boosts",
        "Passives",
        "StatusOnEquip",
        "StatusOnUse",
        "Skills",
        "SpellProperties",
        "Unique",
        "ObjectCategory",
        "Category"
    }

    for _, property in ipairs(statProperties) do
        ResearchValue(stat, property)
    end

    local rootTemplate = SafeGet(stat, "RootTemplate")

    if not rootTemplate or rootTemplate == "" then
        print("[RESEARCH] NO ROOT TEMPLATE")
        return
    end

    local template = Ext.Template.GetRootTemplate(rootTemplate)

    if not template then
        print("[RESEARCH] TEMPLATE NOT FOUND")
        return
    end

    print("")
    print("[RESEARCH] --- TEMPLATE ---")

    local templateProperties = {
        "Name",
        "TemplateType",
        "DisplayName",
        "Description",
        "Icon",
        "RootTemplate",
        "MapKey",
        "Stats",
        "Children",
        "Parent",
        "Flags",
        "UseActions",
        "OnUse",
        "ObjectCategory"
    }

    for _, property in ipairs(templateProperties) do
        ResearchValue(template, property)
    end

    print("")
    print("[RESEARCH] --- TAGS ---")
    if template.Tags then
        print("[RESEARCH] Tag container structure:")
        for key, value in pairs(template.Tags) do
            print("[RESEARCH] " .. tostring(key) .. " => " .. type(value))
            
            -- Jeśli to tablica/kontener, iteruj po nim
            if type(value) == "table" then
                for tagName in pairs(value) do
                    print("[RESEARCH]   └─ " .. tostring(tagName))
                end
            end
        end
    else
        print("[RESEARCH] Tags: <nil>")
    end

    print("")
    print("[RESEARCH] ========================================")
    print("[RESEARCH] END")
    print("[RESEARCH] ========================================")
end

-- ============================================================
-- SUSPICIOUS LOOT ITEMS
-- ============================================================

function ULF_DatabaseQuery.FindSuspiciousLootItems()

    -- ========================================================
    -- CONFIGURATION
    -- ========================================================

    local LOOT_CATEGORIES = {

        Weapon = true,
        Armor = true,
        Accessory = true,
        Consumable = true,
        Scroll = true,
        Grenade = true,
        Food = true

    }


    local SUSPICIOUS_STAT_PATTERNS = {

        "story",
        "quest",
        "reward",
        "blank",
        "template",
        "dummy",
        "test",
        "debug",
        "loot",
        "unique"

    }


    local SUSPICIOUS_NAME_PATTERNS = {

        "blank",
        "placeholder",
        "dummy",
        "test item",
        "quest item",
        "story item"

    }


    -- ========================================================
    -- HELPERS
    -- ========================================================

    local function ContainsPattern(value, pattern)

        if not value then
            return false
        end

        return string.find(
            string.lower(tostring(value)),
            pattern,
            1,
            true
        ) ~= nil

    end


    local function FindStatMatch(stat)

        if not stat then
            return nil
        end

        for _, pattern in ipairs(
            SUSPICIOUS_STAT_PATTERNS
        ) do

            if ContainsPattern(stat, pattern) then
                return pattern
            end

        end

        return nil
    end


    local function FindNameMatch(name)

        if not name then
            return nil
        end

        for _, pattern in ipairs(
            SUSPICIOUS_NAME_PATTERNS
        ) do

            if ContainsPattern(name, pattern) then
                return pattern
            end

        end

        return nil
    end


    -- ========================================================
    -- SCAN
    -- ========================================================

    local scanned = 0
    local suspicious = 0

    local results = {}


    for rootTemplate, record in pairs(
        ULF_Database.Items
    ) do

        if record
            and LOOT_CATEGORIES[record.Category] then

            scanned = scanned + 1

            local statMatch =
                FindStatMatch(record.Stat)

            local nameMatch =
                FindNameMatch(record.DisplayName)


            if statMatch or nameMatch then

                suspicious = suspicious + 1

                results[#results + 1] = {

                    RootTemplate =
                        record.RootTemplate
                        or rootTemplate,

                    Category =
                        record.Category,

                    Rarity =
                        record.Rarity,

                    Stat =
                        record.Stat,

                    DisplayName =
                        record.DisplayName,

                    Type =
                        record.Type,

                    StatMatch =
                        statMatch,

                    NameMatch =
                        nameMatch

                }

            end

        end

    end


    -- ========================================================
    -- OUTPUT
    -- ========================================================

    print(
        "[DATABASE QUERY] ==============================="
    )

    print(
        "[DATABASE QUERY] SUSPICIOUS LOOT ITEMS"
    )

    print(
        "[DATABASE QUERY] ==============================="
    )

    print(
        "[DATABASE QUERY] Scanned loot-category items: " ..
        tostring(scanned)
    )

    print(
        "[DATABASE QUERY] Suspicious matches: " ..
        tostring(suspicious)
    )


    for _, item in ipairs(results) do

        print(
            "[DATABASE QUERY] --------------------------------"
        )

        print(
            "[DATABASE QUERY] RootTemplate: " ..
            tostring(item.RootTemplate)
        )

        print(
            "[DATABASE QUERY] Category: " ..
            tostring(item.Category)
        )

        print(
            "[DATABASE QUERY] Rarity: " ..
            tostring(item.Rarity)
        )

        print(
            "[DATABASE QUERY] Stat: " ..
            tostring(item.Stat)
        )

        print(
            "[DATABASE QUERY] DisplayName: " ..
            tostring(item.DisplayName)
        )

        print(
            "[DATABASE QUERY] Type: " ..
            tostring(item.Type)
        )


        if item.StatMatch then

            print(
                "[DATABASE QUERY] Stat match: " ..
                tostring(item.StatMatch)
            )

        end


        if item.NameMatch then

            print(
                "[DATABASE QUERY] Name match: " ..
                tostring(item.NameMatch)
            )

        end

    end


    print(
        "[DATABASE QUERY] ==============================="
    )


    return results
end


-- ============================================================
-- DEBUG: SCAN LOOT DATA QUALITY
-- ============================================================

function ULF_DatabaseQuery.ScanLootDataQuality()

    local total = 0

    local categoryPresent = 0
    local categoryMissing = 0

    local statPresent = 0
    local statMissing = 0

    local rootTemplatePresent = 0
    local rootTemplateMissing = 0

    local rarityPresent = 0
    local rarityMissing = 0


    local missingCategoryExamples = {}
    local missingStatExamples = {}
    local missingRootTemplateExamples = {}
    local missingRarityExamples = {}


    local function AddExample(list, value)

        if #list >= 10 then
            return
        end

        list[#list + 1] =
            tostring(value)

    end


    -- ========================================================
    -- SCAN DATABASE
    -- ========================================================

    for rootTemplate, record in pairs(
        ULF_Database.Items
    ) do

        total = total + 1


        if record then

            -- =================================================
            -- CATEGORY
            -- =================================================

            if record.Category
                and record.Category ~= "" then

                categoryPresent =
                    categoryPresent + 1

            else

                categoryMissing =
                    categoryMissing + 1

                AddExample(
                    missingCategoryExamples,
                    rootTemplate
                )

            end


            -- =================================================
            -- STAT
            -- =================================================

            if record.Stat
                and record.Stat ~= "" then

                statPresent =
                    statPresent + 1

            else

                statMissing =
                    statMissing + 1

                AddExample(
                    missingStatExamples,
                    rootTemplate
                )

            end


            -- =================================================
            -- ROOT TEMPLATE
            -- =================================================

            if record.RootTemplate
                and record.RootTemplate ~= "" then

                rootTemplatePresent =
                    rootTemplatePresent + 1

            else

                rootTemplateMissing =
                    rootTemplateMissing + 1

                AddExample(
                    missingRootTemplateExamples,
                    rootTemplate
                )

            end


            -- =================================================
            -- RARITY
            -- =================================================

            if record.Rarity
                and record.Rarity ~= "" then

                rarityPresent =
                    rarityPresent + 1

            else

                rarityMissing =
                    rarityMissing + 1

                AddExample(
                    missingRarityExamples,
                    rootTemplate
                )

            end

        end

    end


    -- ========================================================
    -- REPORT
    -- ========================================================

    print("")
    print("[DATABASE QUERY] ===============================")
    print("[DATABASE QUERY] LOOT DATA QUALITY")
    print("[DATABASE QUERY] ===============================")


    print(
        "[DATABASE QUERY] Total items: " ..
        tostring(total)
    )


    -- ========================================================
    -- CATEGORY
    -- ========================================================

    print("")
    print("[DATABASE QUERY] Category")

    print(
        "[DATABASE QUERY]   Present: " ..
        tostring(categoryPresent)
    )

    print(
        "[DATABASE QUERY]   Missing: " ..
        tostring(categoryMissing)
    )


    -- ========================================================
    -- STAT
    -- ========================================================

    print("")
    print("[DATABASE QUERY] Stat")

    print(
        "[DATABASE QUERY]   Present: " ..
        tostring(statPresent)
    )

    print(
        "[DATABASE QUERY]   Missing: " ..
        tostring(statMissing)
    )


    -- ========================================================
    -- ROOT TEMPLATE
    -- ========================================================

    print("")
    print("[DATABASE QUERY] RootTemplate")

    print(
        "[DATABASE QUERY]   Present: " ..
        tostring(rootTemplatePresent)
    )

    print(
        "[DATABASE QUERY]   Missing: " ..
        tostring(rootTemplateMissing)
    )


    -- ========================================================
    -- RARITY
    -- ========================================================

    print("")
    print("[DATABASE QUERY] Rarity")

    print(
        "[DATABASE QUERY]   Present: " ..
        tostring(rarityPresent)
    )

    print(
        "[DATABASE QUERY]   Missing: " ..
        tostring(rarityMissing)
    )


    -- ========================================================
    -- EXAMPLES
    -- ========================================================

    local function PrintExamples(
        label,
        list
    )

        if #list == 0 then
            return
        end

        print("")
        print(
            "[DATABASE QUERY] " ..
            label
        )

        for _, value in ipairs(list) do

            print(
                "[DATABASE QUERY]   - " ..
                tostring(value)
            )

        end

    end


    PrintExamples(
        "Missing Category examples:",
        missingCategoryExamples
    )

    PrintExamples(
        "Missing Stat examples:",
        missingStatExamples
    )

    PrintExamples(
        "Missing RootTemplate examples:",
        missingRootTemplateExamples
    )

    PrintExamples(
        "Missing Rarity examples:",
        missingRarityExamples
    )


    print("")
    print("[DATABASE QUERY] ===============================")

end