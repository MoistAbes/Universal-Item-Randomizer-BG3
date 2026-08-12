print("[ItemScanner] BootstrapServer.lua LOADED")


-- ============================================================
-- LOAD MODULES
-- ============================================================

-- CONFIG
Ext.Require("Config/LootConfig.lua")


-- LOOT - BASIC
Ext.Require("Loot/LootEligibility.lua")
Ext.Require("Loot/LootItemEligibility.lua")

Ext.Require("Loot/LootGenerator.lua")
Ext.Require("Loot/LootTier.lua")
Ext.Require("Loot/LootRarityResolver.lua")


-- DATABASE
Ext.Require("Database/ULF_Database.lua")
Ext.Require("Database/DatabaseCache.lua")
Ext.Require("Database/DatabaseIndex.lua")
Ext.Require("Database/DatabaseQuery.lua")


-- SCANNER
Ext.Require("Scanner/ItemScanner.lua")
Ext.Require("Scanner/EnemyProfile.lua")


-- LOOT - RESOLUTION / SPAWNING
Ext.Require("Loot/LootItemResolver.lua")
Ext.Require("Loot/LootSpawner.lua")


-- LOOT - INJECTION
Ext.Require("Loot/LootInjector.lua")


-- ============================================================
-- SESSION LOADED
-- ============================================================

Ext.Events.SessionLoaded:Subscribe(function()

    print("[ULF] SESSION LOADED")


    -- ========================================================
    -- TRY LOAD CACHE
    -- ========================================================

    local cachedDatabase =
        ULF_DatabaseCache.Load()


    if cachedDatabase then

        print("[ULF] Loading item database from cache")


        ULF_Database.Meta =
            cachedDatabase.Meta or {}


        ULF_Database.Items =
            cachedDatabase.Items or {}


        -- ====================================================
        -- BUILD INDEXES FROM CACHE
        -- ====================================================

        ULF_Database.Indexes =
            ULF_DatabaseIndex.Build(
                ULF_Database
            )


        -- ====================================================
        -- QUICK QUERY TEST
        -- ====================================================

        local testItem =
            ULF_DatabaseQuery.GetRandomByCategory(
                "Weapon"
            )


        if testItem then

            print(
                "[ULF][QUERY TEST] Weapon: " ..
                tostring(testItem.Stat) ..
                " -> " ..
                tostring(testItem.DisplayName)
            )

        else

            print(
                "[ULF][QUERY TEST] FAILED"
            )

        end


        local rarityTest =
        ULF_DatabaseQuery.GetRandomByRarity("Rare")

        if rarityTest then
            print(
                "[ULF][QUERY TEST] Rare: " ..
                tostring(rarityTest.Stat) ..
                " -> " ..
                tostring(rarityTest.DisplayName) ..
                " | " ..
                tostring(rarityTest.Rarity)
            )
        end


        -- debug  print all item caregories
        -- ULF_DatabaseQuery.ScanCategories()
        -- -- debug
        -- ULF_DatabaseQuery.ScanOtherStatPrefixes()
        -- -- debug
        -- ULF_DatabaseQuery.ScanLootDataQuality()
        --   -- debug
        -- ULF_DatabaseQuery.ScanLootEligibilitySignals()
        -- -- debug
        -- ULF_DatabaseQuery.FindSuspiciousLootItems()
    
        -- ULF_DatabaseQuery.ResearchItem("OBJ_CrownController_Ketheric")
        -- ULF_DatabaseQuery.ResearchItem("WPN_Flail_Rusty")
        -- ULF_DatabaseQuery.ResearchItem("OBJ_BloodPotion_Human")
        -- ULF_DatabaseQuery.ResearchItem("OBJ_ArrowOfFiendSlaying")
        -- ULF_DatabaseQuery.ResearchItem("OBJ_Scroll_GlyphOfWarding")
        -- ULF_DatabaseQuery.ResearchItem("OBJ_Dye_BlackBlue")
        -- ULF_DatabaseQuery.ResearchItem("OBJ_WoodenPatchwork")

        -- ====================================================
        -- CACHE LOADED
        -- ====================================================

        print(
            "[ULF] Database loaded from cache: " ..
            tostring(
                ULF_Database.Meta.ItemCount
            ) ..
            " items"
        )


        return
    end


    -- ========================================================
    -- NO CACHE
    -- ========================================================

    print(
        "[ULF] Database cache not available"
    )

    print(
        "[ULF] Starting full item scan..."
    )


    -- ========================================================
    -- RESET DATABASE
    -- ========================================================

    ULF_Database.Meta = {

        CacheVersion = 2,

        SchemaVersion = 1,

        ItemCount = 0
    }


    ULF_Database.Items = {}


    ULF_Database.Indexes = {}


    -- ========================================================
    -- FULL SCAN
    -- ========================================================

    local scanResult =
    ULF_ItemScanner.Scan()

    if not scanResult then

        print(
            "[ULF] ERROR: Item scan returned nil"
        )

        return
    end


    ULF_Database.Items =
        scanResult.Items or {}


    ULF_Database.Meta.ItemCount =
        scanResult.ItemCount or 0


    -- ========================================================
    -- BUILD INDEXES
    -- ========================================================

    ULF_Database.Indexes =
        ULF_DatabaseIndex.Build(
            ULF_Database
        )


    -- ========================================================
    -- SAVE CACHE
    -- ========================================================

    local saved =
        ULF_DatabaseCache.Save(
            ULF_Database
        )


    if saved then

        print(
            "[ULF] Item database cached successfully"
        )

    else

        print(
            "[ULF] WARNING: Failed to cache item database"
        )

    end


    -- ========================================================
    -- TEST
    -- ========================================================

    ULF_ItemScanner.PrintTestRecord(
        "WPN_Battleaxe"
    )

end)