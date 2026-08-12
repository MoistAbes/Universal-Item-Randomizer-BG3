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
Ext.Require("Database/DatabaseInitializer.lua")


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

    local success =
        ULF_DatabaseInitializer.Initialize()

    if not success
        or not ULF_Database.Ready then

        print(
            "[ULF] ERROR: Database is not ready"
        )

        return
    end

    -- ========================================================
    -- QUICK QUERY TEST
    -- ========================================================

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
        ULF_DatabaseQuery.GetRandomByRarity(
            "Rare"
        )

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

end)