ULF_Debug.Print("[ITEM SCANNER] ItemScanner.lua LOADED")

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

        StoryItems = 0,

        PropertyErrors = 0,

        NoRootTemplate = 0,

        TemplateNotFound = 0,

        WrongTemplateType = 0,

        NotItemStats = 0,

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
    -- SAFE NATIVE PROPERTIES
    -- ========================================================

    local modifierList =
        SafeGet(stat, "ModifierList")

    local slot =
        SafeGet(stat, "Slot")

    local shield =
        SafeGet(stat, "Shield")


    -- ========================================================
    -- SHIELD
    -- ========================================================

    if shield == "Yes" then

        return "Armor", "Shield = Yes"

    end


    -- ========================================================
    -- WEAPON
    -- ========================================================

    if modifierList == "Weapon" then

        return "Weapon", "ModifierList = Weapon"

    end


    -- ========================================================
    -- ARMOR
    -- ========================================================

    if modifierList == "Armor" then

        if slot == "Breast"
            or slot == "Helmet"
            or slot == "Gloves"
            or slot == "Boots"
            or slot == "Cloak"
            or slot == "VanityBody"
            or slot == "Underwear"
            or slot == "VanityBoots" then

            return "Armor",
                "ModifierList = Armor, equipment slot"

        end


        if slot == "Ring"
            or slot == "Amulet" then

            return "Accessory",
                "ModifierList = Armor, accessory slot"

        end

        if slot == "MusicalInstrument" then

            return "Accessory",
                "ModifierList = Armor, musical instrument slot"

        end

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
        or Contains(text, "POISON")
        or Contains(text, "OIL") then

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
    -- NAME-BASED ACCESSORY FALLBACK
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

        return nil, "NotItemStat"

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
    -- COMMON ROOT TEMPLATE DATA
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


    local isStoryItem =
        SafeGet(
            template,
            "StoryItem"
        ) == true


    -- ========================================================
    -- STAT-SPECIFIC DATA
    --
    -- Wszystko poniżej może potencjalnie różnić się
    -- pomiędzy statami należącymi do tego samego RootTemplate.
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


    -- ========================================================
    -- NATIVE ITEM FEATURES
    -- ========================================================

    local modifierList =
        SafeGet(
            stat,
            "ModifierList"
        )


    local slot =
        SafeGet(
            stat,
            "Slot"
        )


    local weaponProperties =
        SafeGet(
            stat,
            "Weapon Properties"
        )


    local damageType =
        SafeGet(
            stat,
            "Damage Type"
        )


    local armorType =
        SafeGet(
            stat,
            "ArmorType"
        )


    local armorClass =
        SafeGet(
            stat,
            "ArmorClass"
        )


    local armorClassAbility =
        SafeGet(
            stat,
            "Armor Class Ability"
        )


    local abilityModifierCap =
        SafeGet(
            stat,
            "Ability Modifier Cap"
        )


    local shield =
        SafeGet(
            stat,
            "Shield"
        )


    -- ========================================================
    -- RESULT
    -- ========================================================

    return {

        -- ====================================================
        -- COMMON ROOT TEMPLATE DATA
        -- ====================================================

        RootTemplate = rootTemplate,

        DisplayName = displayName,
        Icon = icon,

        TemplateName = templateName,
        TemplateType = templateType,

        IsStoryItem = isStoryItem,


        -- ====================================================
        -- STAT-SPECIFIC DATA
        -- ====================================================

        Stat = statName,

        Category = category,
        ClassificationReason = classificationReason,

        Level = level,
        Rarity = rarity,

        ModifierList = modifierList,
        Slot = slot,

        WeaponGroup = weaponGroup,
        ProficiencyGroup = proficiencyGroup,

        WeaponProperties = weaponProperties,
        DamageType = damageType,

        ArmorType = armorType,
        ArmorClass = armorClass,
        ArmorClassAbility = armorClassAbility,

        AbilityModifierCap = abilityModifierCap,
        Shield = shield
    }

end


-- ============================================================
-- PRINT SCAN SUMMARY
-- ============================================================

local function PrintScanSummary(
    scanStats,
    itemCount
)

    ULF_Debug.Print("[ITEM SCANNER] SCAN FINISHED -------------------------------------")


    ULF_Debug.Print(
        "[ITEM SCANNER] Stats scanned: " ..
        tostring(scanStats.StatsTotal)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Stats with RootTemplate: " ..
        tostring(scanStats.StatsWithRootTemplate)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] RootTemplates resolved: " ..
        tostring(scanStats.RootTemplatesResolved)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Physical item records: " ..
        tostring(scanStats.PhysicalItems)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Unique physical items: " ..
        tostring(itemCount)
    )

    ULF_Debug.Print(
        "[ITEM SCANNER] Quest items: " ..
        tostring(scanStats.QuestItems)
    )


    -- ========================================================
    -- ERRORS
    -- ========================================================

    ULF_Debug.Print("")
    ULF_Debug.Print("[ITEM SCANNER] --- SKIPPED / ERRORS ---")


    ULF_Debug.Print(
        "[ITEM SCANNER] No RootTemplate: " ..
        tostring(scanStats.NoRootTemplate)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Template not found: " ..
        tostring(scanStats.TemplateNotFound)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Wrong TemplateType: " ..
        tostring(scanStats.WrongTemplateType)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Property errors: " ..
        tostring(scanStats.PropertyErrors)
    )


    ULF_Debug.Print(
        "[ITEM SCANNER] Duplicate RootTemplates: " ..
        tostring(scanStats.DuplicateTemplates)
    )

end

-- ============================================================
-- SCAN ALL STATS
-- ============================================================

local function ScanItems()

    ULF_Debug.Print("")
    ULF_Debug.Print("[ITEM SCANNER] ========================================")
    ULF_Debug.Print("[ITEM SCANNER] STARTING UNIVERSAL ITEM SCAN")
    ULF_Debug.Print("[ITEM SCANNER] ========================================")


    local stats =
        Ext.Stats.GetStats()


    if not stats then

        ULF_Debug.Print(
            "[ITEM SCANNER] ERROR: Ext.Stats.GetStats() returned nil"
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

            if record.IsStoryItem then

                scanStats.StoryItems =
                    scanStats.StoryItems + 1

            end


            scanStats.PhysicalItems =
                scanStats.PhysicalItems + 1


            scanStats.StatsWithRootTemplate =
                scanStats.StatsWithRootTemplate + 1


            scanStats.RootTemplatesResolved =
                scanStats.RootTemplatesResolved + 1


            local rootTemplate =
                record.RootTemplate


            if not items[rootTemplate] then

                items[rootTemplate] =
                    ULF_ItemRecordModel.New({

                        RootTemplate =
                            record.RootTemplate,

                        DisplayName =
                            record.DisplayName,

                        Icon =
                            record.Icon,

                        TemplateName =
                            record.TemplateName,

                        TemplateType =
                            record.TemplateType,

                        IsStoryItem =
                            record.IsStoryItem

                    })

            end

            -- =================================================
            -- STAT RECORD
            -- =================================================

            local statRecord =
                ULF_ItemStatModel.New({

                    Stat =
                        record.Stat,

                    Category =
                        record.Category,

                    ClassificationReason =
                        record.ClassificationReason,

                    Level =
                        record.Level,

                    Rarity =
                        record.Rarity,

                    ModifierList =
                        record.ModifierList,

                    Slot =
                        record.Slot,

                    WeaponGroup =
                        record.WeaponGroup,

                    ProficiencyGroup =
                        record.ProficiencyGroup,

                    WeaponProperties =
                        record.WeaponProperties,

                    DamageType =
                        record.DamageType,

                    ArmorType =
                        record.ArmorType,

                    ArmorClass =
                        record.ArmorClass,

                    ArmorClassAbility =
                        record.ArmorClassAbility,

                    AbilityModifierCap =
                        record.AbilityModifierCap,

                    Shield =
                        record.Shield

                })


            -- =================================================
            -- ADD STAT
            -- =================================================

            table.insert(
                items[rootTemplate].Stats,
                statRecord
            )


            -- =================================================
            -- CATEGORY COUNT
            -- =================================================

            local category =
                record.Category


            if scanStats.Categories[category] ~= nil then

                scanStats.Categories[category] =
                    scanStats.Categories[category] + 1

            end


            -- =================================================
            -- SAMPLE
            -- =================================================

            AddCategorySample(
                category,
                record,
                categorySamples
            )

        -- ====================================================
        -- SKIPPED
        -- ====================================================

        elseif errorCode == "PropertyError" then

            scanStats.PropertyErrors =
                scanStats.PropertyErrors + 1


        elseif errorCode == "NotItemStat" then

            scanStats.NotItemStats =
                scanStats.NotItemStats + 1


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


    ULF_Debug.Print(
        "[ITEM SCANNER] END OF Scan items"
    )

    ULF_Debug.Print("")


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

    ULF_Debug.Print("")
    ULF_Debug.Print("[ITEM SCANNER][TEST] ========================================")
    ULF_Debug.Print("[ITEM SCANNER][TEST] TEST RECORD")
    ULF_Debug.Print("[ITEM SCANNER][TEST] ========================================")
    ULF_Debug.Print("[ITEM SCANNER][TEST] Searching Stat: " .. tostring(statName))

    if not statName or statName == "" then
        ULF_Debug.Print("[ITEM SCANNER][TEST] ERROR: Missing Stat")
        return nil
    end

    local items = ULF_Database.Items
    local found = nil

    for key, item in pairs(items) do

        if type(item) == "table"
            and tostring(item.Stat) == tostring(statName) then

            found = item

            ULF_Debug.Print("")
            ULF_Debug.Print("[ITEM SCANNER][TEST] MATCH FOUND")
            ULF_Debug.Print("[ITEM SCANNER][TEST] Database Key: " .. tostring(key))
            ULF_Debug.Print("[ITEM SCANNER][TEST] ----------------------------------------")

            for field, value in pairs(item) do

                if type(value) == "table" then

                    ULF_Debug.Print(
                        "[ITEM SCANNER][TEST] "
                        .. tostring(field)
                        .. " = <table>"
                    )

                else

                    ULF_Debug.Print(
                        "[ITEM SCANNER][TEST] "
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
        ULF_Debug.Print("[ITEM SCANNER][TEST] NO MATCH FOUND")
    end

    ULF_Debug.Print("[ITEM SCANNER][TEST] ========================================")

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