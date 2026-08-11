print("[ULF] ItemScanner.lua LOADED")

-- ============================================================
-- UNIVERSAL LOOT FRAMEWORK
-- ITEM DISCOVERY / CLASSIFICATION v2
--
-- v2 goals:
--
--   1. Discover physical item templates.
--   2. Deduplicate by RootTemplate.
--   3. Collect more useful item information.
--   4. Classify items using multiple signals.
--   5. Produce category statistics.
--   6. Print representative samples.
--
-- IMPORTANT:
-- This version still DOES NOT modify game loot.
-- It only discovers and classifies items.
-- ============================================================


-- local ItemDatabase = {}


-- ============================================================
-- SCAN STATISTICS
-- ============================================================

local ScanStats = {

    StatsTotal = 0,

    StatsWithRootTemplate = 0,

    RootTemplatesResolved = 0,

    PhysicalItems = 0,

    DuplicateTemplates = 0,

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


-- ============================================================
-- CATEGORY SAMPLE STORAGE
--
-- We don't print thousands of items.
-- We only keep a small number of examples per category.
-- ============================================================

local CategorySamples = {

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


local MAX_SAMPLES_PER_CATEGORY = 10


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
--
-- Converts values to strings without allowing a strange
-- object/value to break the scanner.
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
        SafeGet(template, "DisplayName")

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

local function GetNameSignals(statName, displayName, templateName)

    local combined =
        (SafeString(statName) or "")
        .. " "
        .. (SafeString(displayName) or "")
        .. " "
        .. (SafeString(templateName) or "")

    return string.upper(combined)
end


-- ============================================================
-- CLASSIFICATION
--
-- IMPORTANT:
--
-- This is intentionally conservative.
--
-- The classifier produces:
--
--   Category
--   ClassificationReason
--
-- This allows us to inspect mistakes later.
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

        return "Grenade", "grenade/explosive-related name"
    end


    -- ========================================================
    -- CONSUMABLE
    -- ========================================================

    if Contains(text, "POTION")
        or Contains(text, "ELIXIR")
        or Contains(text, "ANTIDOTE")
        or Contains(text, "COATING")
        or Contains(text, "POISON") then

        return "Consumable", "consumable-related name"
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

        return "Book", "book-related name"
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

        return "Material", "material-related name"
    end


    -- ========================================================
    -- ACCESSORY
    --
    -- This is intentionally AFTER weapons/armor/consumables.
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

        return "Accessory", "accessory-related name"
    end


    -- ========================================================
    -- OTHER
    -- ========================================================

    return "Other", "no known classification signal"
end


-- ============================================================
-- ADD SAMPLE
-- ============================================================

local function AddCategorySample(category, record)

    local samples =
        CategorySamples[category]

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
-- BUILD ITEM RECORD
-- ============================================================

local function BuildItemRecord(statName)

    local stat =
        Ext.Stats.Get(statName)

    if not stat then
        return nil, "StatNotFound"
    end


    -- ========================================================
    -- RootTemplate
    -- ========================================================

    local rootTemplate, errorCode =
        SafeGet(stat, "RootTemplate")

    if errorCode then
        return nil, "PropertyError"
    end

    if not rootTemplate
        or rootTemplate == "" then

        return nil, "NoRootTemplate"
    end


    ScanStats.StatsWithRootTemplate =
        ScanStats.StatsWithRootTemplate + 1


    -- ========================================================
    -- Resolve template
    -- ========================================================

    local template =
        Ext.Template.GetRootTemplate(rootTemplate)

    if not template then
        return nil, "TemplateNotFound"
    end


    ScanStats.RootTemplatesResolved =
        ScanStats.RootTemplatesResolved + 1


    -- ========================================================
    -- TemplateType
    -- ========================================================

    local templateType, templateTypeError =
        SafeGet(template, "TemplateType")

    if templateTypeError then
        return nil, "PropertyError"
    end

    if templateType ~= "item" then
        return nil, "WrongTemplateType"
    end


    -- ========================================================
    -- Template information
    -- ========================================================

    local displayName =
        GetDisplayName(template)

    local templateName =
        SafeGet(template, "Name")

    local icon =
        SafeGet(template, "Icon")


    -- ========================================================
    -- Stat information
    -- ========================================================

    local rarity =
        SafeGet(stat, "Rarity")

    local level =
        SafeGet(stat, "Level")


    local weaponGroup =
        SafeGet(stat, "Weapon Group")


    local proficiencyGroup =
        SafeGet(stat, "Proficiency Group")


    -- ========================================================
    -- Classification
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


    -- ========================================================
    -- Record
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
            classificationReason
    }


    return record, nil
end


-- ============================================================
-- SCAN ALL STATS
-- ============================================================

local function ScanItems()

    print("")
    print("[ULF] ========================================")
    print("[ULF] STARTING UNIVERSAL ITEM SCAN v2")
    print("[ULF] ========================================")


    local stats =
        Ext.Stats.GetStats()

    if not stats then

        print(
            "[ULF] ERROR: Ext.Stats.GetStats() returned nil"
        )

        return
    end


    -- ========================================================
    -- SCAN
    -- ========================================================

    for _, statName in ipairs(stats) do

        ScanStats.StatsTotal =
            ScanStats.StatsTotal + 1


        local record, errorCode =
            BuildItemRecord(statName)


        -- ====================================================
        -- PHYSICAL ITEM
        -- ====================================================

        if record then

            ScanStats.PhysicalItems =
                ScanStats.PhysicalItems + 1


            local rootTemplate =
                record.RootTemplate


            -- =================================================
            -- DEDUPLICATION
            -- =================================================

            if ULF_Database.Items[rootTemplate] then

                ScanStats.DuplicateTemplates =
                    ScanStats.DuplicateTemplates + 1

            else

                ULF_Database.Items[rootTemplate] =
                    record


                -- =============================================
                -- CATEGORY COUNT
                -- =============================================

                local category =
                    record.Category


                if ScanStats.Categories[category] ~= nil then

                    ScanStats.Categories[category] =
                        ScanStats.Categories[category] + 1

                end


                -- =============================================
                -- SAMPLE
                -- =============================================

                AddCategorySample(
                    category,
                    record
                )

            end


        -- ====================================================
        -- SKIPPED
        -- ====================================================

        elseif errorCode == "PropertyError" then

            ScanStats.PropertyErrors =
                ScanStats.PropertyErrors + 1


        elseif errorCode == "NoRootTemplate" then

            ScanStats.NoRootTemplate =
                ScanStats.NoRootTemplate + 1


        elseif errorCode == "TemplateNotFound" then

            ScanStats.TemplateNotFound =
                ScanStats.TemplateNotFound + 1


        elseif errorCode == "WrongTemplateType" then

            ScanStats.WrongTemplateType =
                ScanStats.WrongTemplateType + 1

        end
    end


    -- ========================================================
    -- SUMMARY
    -- ========================================================

    print("")
    print("[ULF] ========================================")
    print("[ULF] SCAN FINISHED")
    print("[ULF] ========================================")


    print(
        "[ULF] Stats scanned: " ..
        tostring(ScanStats.StatsTotal)
    )


    print(
        "[ULF] Stats with RootTemplate: " ..
        tostring(ScanStats.StatsWithRootTemplate)
    )


    print(
        "[ULF] RootTemplates resolved: " ..
        tostring(ScanStats.RootTemplatesResolved)
    )


    print(
        "[ULF] Physical item records: " ..
        tostring(ScanStats.PhysicalItems)
    )


    print(
        "[ULF] Unique physical items: " ..
        tostring(
            #(
                (function()

                    local keys = {}

                    for key, _ in pairs(ULF_Database.Items) do
                        table.insert(keys, key)
                    end

                    return keys
                end)()
            )
        )
    )


    -- ========================================================
    -- CATEGORIES
    -- ========================================================

    print("")
    print("[ULF] --- CLASSIFICATION ---")


    print(
        "[ULF] Weapon: " ..
        tostring(ScanStats.Categories.Weapon)
    )


    print(
        "[ULF] Armor: " ..
        tostring(ScanStats.Categories.Armor)
    )


    print(
        "[ULF] Accessory: " ..
        tostring(ScanStats.Categories.Accessory)
    )


    print(
        "[ULF] Consumable: " ..
        tostring(ScanStats.Categories.Consumable)
    )


    print(
        "[ULF] Scroll: " ..
        tostring(ScanStats.Categories.Scroll)
    )


    print(
        "[ULF] Food: " ..
        tostring(ScanStats.Categories.Food)
    )


    print(
        "[ULF] Grenade: " ..
        tostring(ScanStats.Categories.Grenade)
    )


    print(
        "[ULF] Book: " ..
        tostring(ScanStats.Categories.Book)
    )


    print(
        "[ULF] Material: " ..
        tostring(ScanStats.Categories.Material)
    )


    print(
        "[ULF] Other: " ..
        tostring(ScanStats.Categories.Other)
    )


    -- ========================================================
    -- ERRORS
    -- ========================================================

    print("")
    print("[ULF] --- SKIPPED / ERRORS ---")


    print(
        "[ULF] No RootTemplate: " ..
        tostring(ScanStats.NoRootTemplate)
    )


    print(
        "[ULF] Template not found: " ..
        tostring(ScanStats.TemplateNotFound)
    )


    print(
        "[ULF] Wrong TemplateType: " ..
        tostring(ScanStats.WrongTemplateType)
    )


    print(
        "[ULF] Property errors: " ..
        tostring(ScanStats.PropertyErrors)
    )


    print(
        "[ULF] Duplicate RootTemplates: " ..
        tostring(ScanStats.DuplicateTemplates)
    )


    -- ========================================================
    -- CATEGORY SAMPLES
    -- ========================================================

    local categoryOrder = {

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


    for _, category in ipairs(categoryOrder) do

        print("")
        print(
            "[ULF] --- SAMPLE: " ..
            category ..
            " ---"
        )


        local samples =
            CategorySamples[category]


        if not samples
            or #samples == 0 then

            print(
                "[ULF] No samples."
            )

        else

            for _, record in ipairs(samples) do

                print(
                    "[ULF] " ..
                    tostring(record.Stat) ..
                    " -> " ..
                    tostring(record.DisplayName) ..
                    " | " ..
                    tostring(record.Rarity) ..
                    " | Level " ..
                    tostring(record.Level) ..
                    " | Reason: " ..
                    tostring(
                        record.ClassificationReason
                    )
                )

            end
        end
    end


    print("")
    print("[ULF] ========================================")
    print("[ULF] END OF ITEM DISCOVERY REPORT")
    print("[ULF] ========================================")
end


-- ============================================================
-- TEST RECORD
-- ============================================================

local function PrintTestRecord(statName)

    local stat =
        Ext.Stats.Get(statName)


    if not stat then

        print(
            "[ULF] TEST STAT NOT FOUND: " ..
            tostring(statName)
        )

        return
    end


    local rootTemplate =
        SafeGet(stat, "RootTemplate")


    if not rootTemplate
        or rootTemplate == "" then

        print(
            "[ULF] TEST HAS NO ROOT TEMPLATE: " ..
            tostring(statName)
        )

        return
    end


    local record =
        ULF_Database.Items[rootTemplate]


    if not record then

        print(
            "[ULF] TEST RECORD NOT FOUND: " ..
            tostring(statName)
        )

        return
    end


    print("")
    print("[ULF] TEST RECORD")
    print("[ULF] ----------------------------------------")


    print(
        "Stat: " ..
        tostring(record.Stat)
    )


    print(
        "DisplayName: " ..
        tostring(record.DisplayName)
    )


    print(
        "RootTemplate: " ..
        tostring(record.RootTemplate)
    )


    print(
        "TemplateName: " ..
        tostring(record.TemplateName)
    )


    print(
        "TemplateType: " ..
        tostring(record.TemplateType)
    )


    print(
        "Icon: " ..
        tostring(record.Icon)
    )


    print(
        "Rarity: " ..
        tostring(record.Rarity)
    )


    print(
        "Level: " ..
        tostring(record.Level)
    )


    print(
        "WeaponGroup: " ..
        tostring(record.WeaponGroup)
    )


    print(
        "ProficiencyGroup: " ..
        tostring(record.ProficiencyGroup)
    )


    print(
        "Category: " ..
        tostring(record.Category)
    )


    print(
        "ClassificationReason: " ..
        tostring(record.ClassificationReason)
    )


    print("[ULF] ----------------------------------------")
end


-- ============================================================
-- SESSION LOADED
-- ============================================================

Ext.Events.SessionLoaded:Subscribe(function()

    print("[ULF] SESSION LOADED")


    -- ========================================================
    -- RESET DATABASE
    -- ========================================================

    ULF_Database.Items = {}


    -- ========================================================
    -- RESET STATS
    -- ========================================================

    ScanStats = {

        StatsTotal = 0,

        StatsWithRootTemplate = 0,

        RootTemplatesResolved = 0,

        PhysicalItems = 0,

        DuplicateTemplates = 0,

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


    -- ========================================================
    -- RESET SAMPLES
    -- ========================================================

    CategorySamples = {

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


    -- ========================================================
    -- RUN SCANNER
    -- ========================================================

    ScanItems()


    -- ========================================================
    -- KNOWN TEST
    -- ========================================================

    PrintTestRecord("WPN_Battleaxe")

end)