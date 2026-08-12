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


function ULF_DatabaseQuery.GetByRarity(rarity)

    local index =
        ULF_Database.Indexes.Rarity

    if not index then
        return {}
    end

    local itemIds =
        index[rarity]

    if not itemIds then
        return {}
    end

    local results = {}

    for _, itemId in ipairs(itemIds) do

        local record =
            ULF_Database.Items[itemId]

        if record then
            table.insert(results, record)
        end

    end

    return results
end

-- ============================================================
-- DEBUG: SCAN ITEM CATEGORIES
-- ============================================================

function ULF_DatabaseQuery.ScanCategories()

    local categories = {}

    if not ULF_Database
        or not ULF_Database.Items then

        print(
            "[ULF][QUERY] ERROR: Database is unavailable"
        )

        return
    end


    for _, record in pairs(ULF_Database.Items) do

        local category =
            record.Category

        if category then

            categories[category] =
                (categories[category] or 0) + 1

        end

    end


    print("")
    print("[ULF][QUERY] ===============================")
    print("[ULF][QUERY] ITEM CATEGORIES")
    print("[ULF][QUERY] ===============================")


    local count = 0
    local total = 0

    for category, amount in pairs(categories) do

        count = count + 1
        total = total + amount

        print(
            "[ULF][QUERY] " ..
            tostring(category) ..
            " -> " ..
            tostring(amount)
        )

    end


    print(
        "[ULF][QUERY] Unique categories: " ..
        tostring(count)
    )

    print(
        "[ULF][QUERY] Categorized items: " ..
        tostring(total)
    )

    print(
        "[ULF][QUERY] Total database items: " ..
        tostring(#ULF_Database.Items)
    )

    print("[ULF][QUERY] ===============================")

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


    if not ULF_Database
        or not ULF_Database.Items then

        print(
            "[ULF][QUERY] ERROR: Database is unavailable"
        )

        return
    end


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
    print("[ULF][QUERY] ===============================")
    print("[ULF][QUERY] OTHER STAT RESEARCH")
    print("[ULF][QUERY] ===============================")


    print(
        "[ULF][QUERY] WPN-like: " ..
        tostring(otherStats.WPN)
    )

    print(
        "[ULF][QUERY] ALCH-like: " ..
        tostring(otherStats.ALCH)
    )

    print(
        "[ULF][QUERY] OBJ-like: " ..
        tostring(otherStats.OBJ)
    )

    print(
        "[ULF][QUERY] UNI-like: " ..
        tostring(otherStats.UNI)
    )

    print(
        "[ULF][QUERY] Other: " ..
        tostring(otherStats.Other)
    )


    print("")
    print("[ULF][QUERY] PREFIX BREAKDOWN")
    print("[ULF][QUERY] ===============================")


    local count = 0

    for prefix, amount in pairs(prefixes) do

        count = count + 1

        print(
            "[ULF][QUERY] " ..
            tostring(prefix) ..
            " -> " ..
            tostring(amount)
        )

    end


    print(
        "[ULF][QUERY] Unique prefixes: " ..
        tostring(count)
    )

    print("[ULF][QUERY] ===============================")

end

-- ============================================================
-- LOOT ELIGIBILITY SIGNAL SCAN
-- ============================================================

function ULF_DatabaseQuery.ScanLootEligibilitySignals()

    if not ULF_Database
        or not ULF_Database.Items then

        print(
            "[ULF][QUERY] ERROR: Database is unavailable"
        )

        return
    end


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


    local MAX_EXAMPLES =
        5


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
        "[ULF][QUERY] ==============================="
    )

    print(
        "[ULF][QUERY] LOOT ELIGIBILITY SIGNAL SUMMARY"
    )

    print(
        "[ULF][QUERY] ==============================="
    )

    print(
        "[ULF][QUERY] Items scanned: " ..
        tostring(scanned)
    )

    print(
        "[ULF][QUERY] Items matched: " ..
        tostring(matched)
    )


    -- ========================================================
    -- SIGNAL SUMMARY
    -- ========================================================

    for signal, count in pairs(counts) do

        print(
            "[ULF][QUERY] " ..
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
                "[ULF][QUERY] --------------------------------"
            )

            print(
                "[ULF][QUERY] SIGNAL: " ..
                tostring(signal)
            )


            for _, item in ipairs(items) do

                print(
                    "[ULF][QUERY] RootTemplate: " ..
                    tostring(item.RootTemplate)
                )

                print(
                    "[ULF][QUERY] Category: " ..
                    tostring(item.Category)
                )

                print(
                    "[ULF][QUERY] Rarity: " ..
                    tostring(item.Rarity)
                )

                print(
                    "[ULF][QUERY] Stat: " ..
                    tostring(item.Stat)
                )

                print(
                    "[ULF][QUERY] DisplayName: " ..
                    tostring(item.DisplayName)
                )

                print(
                    "[ULF][QUERY] Source: " ..
                    tostring(item.Source)
                )

                print(
                    "[ULF][QUERY] ~"
                )

            end

        end

    end


    print(
        "[ULF][QUERY] ==============================="
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
            "[ULF][RESEARCH] "
            .. property
            .. " = <"
            .. tostring(errorCode)
            .. ">"
        )
        return
    end

    if value == nil then
        print(
            "[ULF][RESEARCH] "
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
            "[ULF][RESEARCH] "
            .. property
            .. " = "
            .. text
        )
    else
        print(
            "[ULF][RESEARCH] "
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
    print("[ULF][RESEARCH] ========================================")
    print("[ULF][RESEARCH] ITEM: " .. tostring(statName))
    print("[ULF][RESEARCH] ========================================")

    local stat = Ext.Stats.Get(statName)

    if not stat then
        print("[ULF][RESEARCH] STAT NOT FOUND")
        return
    end

    print("")
    print("[ULF][RESEARCH] --- STAT ---")

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
        print("[ULF][RESEARCH] NO ROOT TEMPLATE")
        return
    end

    local template = Ext.Template.GetRootTemplate(rootTemplate)

    if not template then
        print("[ULF][RESEARCH] TEMPLATE NOT FOUND")
        return
    end

    print("")
    print("[ULF][RESEARCH] --- TEMPLATE ---")

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
    print("[ULF][RESEARCH] --- TAGS ---")
    if template.Tags then
        print("[ULF][RESEARCH] Tag container structure:")
        for key, value in pairs(template.Tags) do
            print("[ULF][RESEARCH] " .. tostring(key) .. " => " .. type(value))
            
            -- Jeśli to tablica/kontener, iteruj po nim
            if type(value) == "table" then
                for tagName in pairs(value) do
                    print("[ULF][RESEARCH]   └─ " .. tostring(tagName))
                end
            end
        end
    else
        print("[ULF][RESEARCH] Tags: <nil>")
    end

    print("")
    print("[ULF][RESEARCH] ========================================")
    print("[ULF][RESEARCH] END")
    print("[ULF][RESEARCH] ========================================")
end

-- ============================================================
-- SUSPICIOUS LOOT ITEMS
-- ============================================================

function ULF_DatabaseQuery.FindSuspiciousLootItems()

    if not ULF_Database
        or not ULF_Database.Items then

        print(
            "[ULF][QUERY] ERROR: Database is unavailable"
        )

        return
    end


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
        "[ULF][QUERY] ==============================="
    )

    print(
        "[ULF][QUERY] SUSPICIOUS LOOT ITEMS"
    )

    print(
        "[ULF][QUERY] ==============================="
    )

    print(
        "[ULF][QUERY] Scanned loot-category items: " ..
        tostring(scanned)
    )

    print(
        "[ULF][QUERY] Suspicious matches: " ..
        tostring(suspicious)
    )


    for _, item in ipairs(results) do

        print(
            "[ULF][QUERY] --------------------------------"
        )

        print(
            "[ULF][QUERY] RootTemplate: " ..
            tostring(item.RootTemplate)
        )

        print(
            "[ULF][QUERY] Category: " ..
            tostring(item.Category)
        )

        print(
            "[ULF][QUERY] Rarity: " ..
            tostring(item.Rarity)
        )

        print(
            "[ULF][QUERY] Stat: " ..
            tostring(item.Stat)
        )

        print(
            "[ULF][QUERY] DisplayName: " ..
            tostring(item.DisplayName)
        )

        print(
            "[ULF][QUERY] Type: " ..
            tostring(item.Type)
        )


        if item.StatMatch then

            print(
                "[ULF][QUERY] Stat match: " ..
                tostring(item.StatMatch)
            )

        end


        if item.NameMatch then

            print(
                "[ULF][QUERY] Name match: " ..
                tostring(item.NameMatch)
            )

        end

    end


    print(
        "[ULF][QUERY] ==============================="
    )


    return results
end


-- ============================================================
-- DEBUG: SCAN LOOT DATA QUALITY
-- ============================================================

function ULF_DatabaseQuery.ScanLootDataQuality()

    if not ULF_Database
        or not ULF_Database.Items then

        print(
            "[ULF][QUERY] ERROR: Database is unavailable"
        )

        return
    end


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
    print("[ULF][QUERY] ===============================")
    print("[ULF][QUERY] LOOT DATA QUALITY")
    print("[ULF][QUERY] ===============================")


    print(
        "[ULF][QUERY] Total items: " ..
        tostring(total)
    )


    -- ========================================================
    -- CATEGORY
    -- ========================================================

    print("")
    print("[ULF][QUERY] Category")

    print(
        "[ULF][QUERY]   Present: " ..
        tostring(categoryPresent)
    )

    print(
        "[ULF][QUERY]   Missing: " ..
        tostring(categoryMissing)
    )


    -- ========================================================
    -- STAT
    -- ========================================================

    print("")
    print("[ULF][QUERY] Stat")

    print(
        "[ULF][QUERY]   Present: " ..
        tostring(statPresent)
    )

    print(
        "[ULF][QUERY]   Missing: " ..
        tostring(statMissing)
    )


    -- ========================================================
    -- ROOT TEMPLATE
    -- ========================================================

    print("")
    print("[ULF][QUERY] RootTemplate")

    print(
        "[ULF][QUERY]   Present: " ..
        tostring(rootTemplatePresent)
    )

    print(
        "[ULF][QUERY]   Missing: " ..
        tostring(rootTemplateMissing)
    )


    -- ========================================================
    -- RARITY
    -- ========================================================

    print("")
    print("[ULF][QUERY] Rarity")

    print(
        "[ULF][QUERY]   Present: " ..
        tostring(rarityPresent)
    )

    print(
        "[ULF][QUERY]   Missing: " ..
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
            "[ULF][QUERY] " ..
            label
        )

        for _, value in ipairs(list) do

            print(
                "[ULF][QUERY]   - " ..
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
    print("[ULF][QUERY] ===============================")

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