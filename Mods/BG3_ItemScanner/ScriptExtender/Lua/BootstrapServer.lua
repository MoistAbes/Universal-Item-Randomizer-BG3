print("[ItemScanner] BootstrapServer.lua LOADED")


-- ============================================================
-- LOAD MODULES
-- ============================================================

Ext.Require("LootConfig.lua")
Ext.Require("LootEligibility.lua")
Ext.Require("LootGenerator.lua")
Ext.Require("LootTier.lua")
Ext.Require("LootRarityResolver.lua")
Ext.Require("ULF_Database.lua")
Ext.Require("DatabaseCache.lua")
Ext.Require("DatabaseIndex.lua")
Ext.Require("DatabaseQuery.lua")
Ext.Require("LootItemResolver.lua")
Ext.Require("LootSpawner.lua")
Ext.Require("EnemyProfile.lua")
Ext.Require("ItemScanner.lua")
Ext.Require("LootInjector.lua")


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

    ULF_ItemScanner.Scan()


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