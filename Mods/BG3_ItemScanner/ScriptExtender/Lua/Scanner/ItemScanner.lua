print("[ULF] ItemScanner.lua LOADED")

-- ============================================================
-- ITEM SCANNER
--
-- Responsible for:
--   - discovering stats
--   - resolving RootTemplates
--   - reading item properties
--   - classifying items
--   - building item records
--
-- NOT responsible for:
--   - cache
--   - database initialization
--   - indexes
--   - loot injection
--   - SessionLoaded
-- ============================================================


-- ============================================================
-- CONSTANTS
-- ============================================================

local MAX_SAMPLES_PER_CATEGORY = 10

local CATEGORY_ORDER = {

    "Weapon",
    "Armor",
    "Accessory",
    "Consumable",
    "Scroll",
    "Food",
    "Grenade",
    "Book",
    "Material",
    "Other"

}


-- ============================================================
-- CREATE SCAN STATISTICS
-- ============================================================

local function CreateScanStats()

    return {

        StatsTotal = 0,

        StatsWithRootTemplate = 0,

        RootTemplatesResolved = 0,

        PhysicalItems = 0,

        DuplicateTemplates = 0,

        QuestItems = 0,

        PropertyErrors = 0,

        NoRootTemplate = 0,

        TemplateNotFound = 0,

        WrongTemplateType = 0,

        Categories = {

            Weapon = 0,
            Armor = 0,
            Accessory = 0,
            Consumable = 0,
            Scroll = 0,
            Food = 0,
            Grenade = 0,
            Book = 0,
            Material = 0,
            Other = 0

        }

    }

end


-- ============================================================
-- CREATE CATEGORY SAMPLES
-- ============================================================

local function CreateCategorySamples()

    return {

        Weapon = {},
        Armor = {},
        Accessory = {},
        Consumable = {},
        Scroll = {},
        Food = {},
        Grenade = {},
        Book = {},
        Material = {},
        Other = {}

    }

end


-- ============================================================
-- SAFE PROPERTY ACCESS
-- ============================================================

local function SafeGet(object, property)

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


-- ============================================================
-- SAFE STRING
-- ============================================================

local function SafeString(value)

    if value == nil then

        return nil

    end


    local ok, result = pcall(function()

        return tostring(value)

    end)


    if ok then

        return result

    end


    return nil

end


-- ============================================================
-- DISPLAY NAME
-- ============================================================

local function GetDisplayName(template)

    if not template then

        return nil

    end


    local displayName, errorCode =
        SafeGet(
            template,
            "DisplayName"
        )


    if errorCode then

        return nil

    end


    if not displayName then

        return nil

    end


    local ok, result = pcall(function()

        return displayName:Get()

    end)


    if ok then

        return result

    end


    return nil

end


-- ============================================================
-- STRING HELPERS
-- ============================================================

local function Contains(text, value)

    if not text or not value then

        return false

    end


    return string.find(
        string.upper(text),
        string.upper(value),
        1,
        true
    ) ~= nil

end


local function StartsWith(text, value)

    if not text or not value then

        return false

    end


    return string.find(
        string.upper(text),
        "^" .. string.upper(value)
    ) ~= nil

end


-- ============================================================
-- NAME / STAT SIGNALS
-- ============================================================

local function GetNameSignals(
    statName,
    displayName,
    templateName
)

    local combined =

        (SafeString(statName) or "")
        .. " "
        .. (SafeString(displayName) or "")
        .. " "
        .. (SafeString(templateName) or "")


    return string.upper(combined)

end


-- ============================================================
-- ITEM CLASSIFICATION
-- ============================================================

local function ClassifyItem(
    statName,
    displayName,
    templateName,
    stat,
    template
)

    local text =

        GetNameSignals(
            statName,
            displayName,
            templateName
        )


    -- ========================================================
    -- WEAPON
    -- ========================================================

    if StartsWith(statName, "WPN_")
        or StartsWith(templateName, "WPN_") then

        return "Weapon", "WPN prefix"

    end


    -- ========================================================
    -- ARMOR
    -- ========================================================

    if StartsWith(statName, "ARM_")
        or StartsWith(templateName, "ARM_") then

        return "Armor", "ARM prefix"

    end


    -- ========================================================
    -- FOOD
    -- ========================================================

    if Contains(text, "FOOD")
        or Contains(text, "FRUIT")
        or Contains(text, "MEAT")
        or Contains(text, "CHEESE")
        or Contains(text, "BREAD")
        or Contains(text, "SAUSAGE")
        or Contains(text, "APPLE")
        or Contains(text, "ORANGE")
        or Contains(text, "POTATO")
        or Contains(text, "MUSHROOM") then

        return "Food", "food-related name"

    end


    -- ========================================================
    -- SCROLL
    -- ========================================================

    if Contains(text, "SCROLL") then

        return "Scroll", "scroll-related name"

    end


    -- ========================================================
    -- GRENADE
    -- ========================================================

    if Contains(text, "GRENADE")
        or Contains(text, "BOMB")
        or Contains(text, "ALCHEMICAL FIRE")
        or Contains(text, "SMOKEPOWDER")
        or Contains(text, "SPORE") then

        return "Grenade",
            "grenade/explosive-related name"

    end


    -- ========================================================
    -- CONSUMABLE
    -- ========================================================

    if Contains(text, "POTION")
        or Contains(text, "ELIXIR")
        or Contains(text, "ANTIDOTE")
        or Contains(text, "COATING")
        or Contains(text, "POISON") then

        return "Consumable",
            "consumable-related name"

    end


    -- ========================================================
    -- BOOK
    -- ========================================================

    if Contains(text, "BOOK")
        or Contains(text, "TOME")
        or Contains(text, "JOURNAL")
        or Contains(text, "DIARY")
        or Contains(text, "MANUSCRIPT")
        or Contains(text, "GRIMOIRE")
        or Contains(text, "CODEX") then

        return "Book",
            "book-related name"

    end


    -- ========================================================
    -- MATERIAL
    -- ========================================================

    if Contains(text, "ORE")
        or Contains(text, "INGOT")
        or Contains(text, "CRAFT")
        or Contains(text, "MATERIAL")
        or Contains(text, "GEM")
        or Contains(text, "CRYSTAL")
        or Contains(text, "DYE") then

        return "Material",
            "material-related name"

    end


    -- ========================================================
    -- ACCESSORY
    -- ========================================================

    if Contains(text, "RING")
        or Contains(text, "AMULET")
        or Contains(text, "PENDANT")
        or Contains(text, "NECKLACE")
        or Contains(text, "CIRCLET")
        or Contains(text, "HELMET")
        or Contains(text, "CROWN")
        or Contains(text, "MASK")
        or Contains(text, "GLOVES")
        or Contains(text, "BOOTS")
        or Contains(text, "CLOAK")
        or Contains(text, "CAPE")
        or Contains(text, "BELT") then

        return "Accessory",
            "accessory-related name"

    end


    -- ========================================================
    -- OTHER
    -- ========================================================

    return "Other",
        "no known classification signal"

end


-- ============================================================
-- ADD CATEGORY SAMPLE
-- ============================================================

local function AddCategorySample(
    category,
    record,
    categorySamples
)

    local samples =
        categorySamples[category]


    if not samples then

        return

    end


    if #samples >= MAX_SAMPLES_PER_CATEGORY then

        return

    end


    table.insert(
        samples,
        record
    )

end


-- ============================================================
-- SCAN ONE ITEM / BUILD ITEM RECORD
-- ============================================================
--
-- This is the actual single-item scanner.
--
-- Input:
--     statName
--
-- Returns:
--     record, nil
--
-- or:
--     nil, errorCode
--
-- ============================================================

local function BuildItemRecord(statName)

    local stat =
        Ext.Stats.Get(statName)


    if not stat then

        return nil, "StatNotFound"

    end


    -- ========================================================
    -- ROOT TEMPLATE
    -- ========================================================

    local rootTemplate, errorCode =
        SafeGet(
            stat,
            "RootTemplate"
        )


    if errorCode then

        return nil, "PropertyError"

    end


    if not rootTemplate
        or rootTemplate == "" then

        return nil, "NoRootTemplate"

    end


    -- ========================================================
    -- RESOLVE TEMPLATE
    -- ========================================================

    local template =
        Ext.Template.GetRootTemplate(
            rootTemplate
        )


    if not template then

        return nil, "TemplateNotFound"

    end


    -- ========================================================
    -- TEMPLATE TYPE
    -- ========================================================

    local templateType,
          templateTypeError =

        SafeGet(
            template,
            "TemplateType"
        )


    if templateTypeError then

        return nil, "PropertyError"

    end


    if templateType ~= "item" then

        return nil, "WrongTemplateType"

    end


    -- ========================================================
    -- TEMPLATE INFORMATION
    -- ========================================================

    local displayName =
        GetDisplayName(
            template
        )


    local templateName =
        SafeGet(
            template,
            "Name"
        )


    local icon =
        SafeGet(
            template,
            "Icon"
        )


    -- ========================================================
    -- STAT INFORMATION
    -- ========================================================

    local rarity =
        SafeGet(
            stat,
            "Rarity"
        )


    local level =
        SafeGet(
            stat,
            "Level"
        )


    local weaponGroup =
        SafeGet(
            stat,
            "Weapon Group"
        )


    local proficiencyGroup =
        SafeGet(
            stat,
            "Proficiency Group"
        )


    -- ========================================================
    -- CLASSIFICATION
    -- ========================================================

    local category,
          classificationReason =

        ClassifyItem(
            statName,
            displayName,
            templateName,
            stat,
            template
        )

    local IsQuestItem =
        StartsWith(statName, "QUEST_")
        or
        StartsWith(templateName, "QUEST_")

    -- ========================================================
    -- RECORD
    -- ========================================================

    local record = {

        Stat = statName,

        RootTemplate = rootTemplate,

        TemplateName = templateName,

        TemplateType = templateType,

        DisplayName = displayName,

        Icon = icon,

        Rarity = rarity,

        Level = level,

        WeaponGroup = weaponGroup,

        ProficiencyGroup = proficiencyGroup,

        Category = category,

        ClassificationReason =
            classificationReason,

        IsQuestItem = IsQuestItem

    }


    return record, nil

end


-- ============================================================
-- PRINT SCAN SUMMARY
-- ============================================================

local function PrintScanSummary(
    scanStats,
    itemCount
)

    print("")
    print("[ULF] ========================================")
    print("[ULF] SCAN FINISHED")
    print("[ULF] ========================================")


    print(
        "[ULF] Stats scanned: " ..
        tostring(scanStats.StatsTotal)
    )


    print(
        "[ULF] Stats with RootTemplate: " ..
        tostring(scanStats.StatsWithRootTemplate)
    )


    print(
        "[ULF] RootTemplates resolved: " ..
        tostring(scanStats.RootTemplatesResolved)
    )


    print(
        "[ULF] Physical item records: " ..
        tostring(scanStats.PhysicalItems)
    )


    print(
        "[ULF] Unique physical items: " ..
        tostring(itemCount)
    )

    print(
        "[ULF] Quest items: " ..
        tostring(scanStats.QuestItems)
    )


    -- ========================================================
    -- ERRORS
    -- ========================================================

    print("")
    print("[ULF] --- SKIPPED / ERRORS ---")


    print(
        "[ULF] No RootTemplate: " ..
        tostring(scanStats.NoRootTemplate)
    )


    print(
        "[ULF] Template not found: " ..
        tostring(scanStats.TemplateNotFound)
    )


    print(
        "[ULF] Wrong TemplateType: " ..
        tostring(scanStats.WrongTemplateType)
    )


    print(
        "[ULF] Property errors: " ..
        tostring(scanStats.PropertyErrors)
    )


    print(
        "[ULF] Duplicate RootTemplates: " ..
        tostring(scanStats.DuplicateTemplates)
    )

end

-- ============================================================
-- SCAN ALL STATS
-- ============================================================

local function ScanItems()

    print("")
    print("[ULF] ========================================")
    print("[ULF] STARTING UNIVERSAL ITEM SCAN")
    print("[ULF] ========================================")


    local stats =
        Ext.Stats.GetStats()


    if not stats then

        print(
            "[ULF] ERROR: Ext.Stats.GetStats() returned nil"
        )

        return nil

    end


    local scanStats =
        CreateScanStats()


    local categorySamples =
        CreateCategorySamples()


    local items = {}


    -- ========================================================
    -- SCAN
    -- ========================================================

    for _, statName in ipairs(stats) do

        scanStats.StatsTotal =
            scanStats.StatsTotal + 1


        local record, errorCode =
            BuildItemRecord(
                statName
            )


        -- ====================================================
        -- PHYSICAL ITEM
        -- ====================================================

        if record then

            if record.IsQuestItem then
                scanStats.QuestItems =
                    scanStats.QuestItems + 1
            end

            scanStats.PhysicalItems =
                scanStats.PhysicalItems + 1


            scanStats.StatsWithRootTemplate =
                scanStats.StatsWithRootTemplate + 1


            scanStats.RootTemplatesResolved =
                scanStats.RootTemplatesResolved + 1


            local rootTemplate =
                record.RootTemplate


            -- =================================================
            -- DEDUPLICATION
            -- =================================================

            if items[rootTemplate] then

                scanStats.DuplicateTemplates =
                    scanStats.DuplicateTemplates + 1

            else

                items[rootTemplate] =
                    record


                -- =============================================
                -- CATEGORY COUNT
                -- =============================================

                local category =
                    record.Category


                if scanStats.Categories[category] ~= nil then

                    scanStats.Categories[category] =
                        scanStats.Categories[category] + 1

                end


                -- =============================================
                -- SAMPLE
                -- =============================================

                AddCategorySample(
                    category,
                    record,
                    categorySamples
                )

            end


        -- ====================================================
        -- SKIPPED
        -- ====================================================

        elseif errorCode == "PropertyError" then

            scanStats.PropertyErrors =
                scanStats.PropertyErrors + 1


        elseif errorCode == "NoRootTemplate" then

            scanStats.NoRootTemplate =
                scanStats.NoRootTemplate + 1


        elseif errorCode == "TemplateNotFound" then

            scanStats.TemplateNotFound =
                scanStats.TemplateNotFound + 1


        elseif errorCode == "WrongTemplateType" then

            scanStats.WrongTemplateType =
                scanStats.WrongTemplateType + 1

        end

    end


    -- ========================================================
    -- ITEM COUNT
    -- ========================================================

    local itemCount = 0


    for _ in pairs(items) do

        itemCount = itemCount + 1

    end


    -- ========================================================
    -- REPORT
    -- ========================================================

    PrintScanSummary(
        scanStats,
        itemCount
    )


    print("")
    print("[ULF] ========================================")
    print("[ULF] END OF Scan items")
    print("[ULF] ========================================")


    -- ========================================================
    -- RETURN RESULT
    -- ========================================================

    return {

        Items = items,

        ItemCount = itemCount,

        Stats = scanStats,

        Samples = categorySamples

    }

end


-- ============================================================
-- TEST RECORD
-- ============================================================

function PrintTestRecord(statName)

    print("")
    print("[ULF][TEST] ========================================")
    print("[ULF][TEST] TEST RECORD")
    print("[ULF][TEST] ========================================")
    print("[ULF][TEST] Searching Stat: " .. tostring(statName))

    if not statName or statName == "" then
        print("[ULF][TEST] ERROR: Missing Stat")
        return nil
    end

    local items = ULF_Database.Items
    local found = nil

    for key, item in pairs(items) do

        if type(item) == "table"
            and tostring(item.Stat) == tostring(statName) then

            found = item

            print("")
            print("[ULF][TEST] MATCH FOUND")
            print("[ULF][TEST] Database Key: " .. tostring(key))
            print("[ULF][TEST] ----------------------------------------")

            for field, value in pairs(item) do

                if type(value) == "table" then

                    print(
                        "[ULF][TEST] "
                        .. tostring(field)
                        .. " = <table>"
                    )

                else

                    print(
                        "[ULF][TEST] "
                        .. tostring(field)
                        .. " = "
                        .. tostring(value)
                    )

                end
            end

            break
        end
    end

    if not found then
        print("[ULF][TEST] NO MATCH FOUND")
    end

    print("[ULF][TEST] ========================================")

    return found
end


-- ============================================================
-- PUBLIC API
-- ============================================================

ULF_ItemScanner = {

    Scan = ScanItems,

    -- Scan exactly one Stat and build its item record.
    ScanItem = BuildItemRecord,

    PrintTestRecord = PrintTestRecord

}