print("[ItemScanner] BootstrapServer.lua LOADED")


-- ============================================================
-- LOAD MODULES
-- ============================================================

-- CONFIG
Ext.Require("Config/ModSettings.lua")
Ext.Require("Config/LootConfig.lua")
Ext.Require("Loot/LootDefinitions.lua")


-- ============================================================
-- CONFIG VALIDATION
-- ============================================================

Ext.Require("Config/LootConfigValidator.lua")

if not ULF_LootConfigValidator.Validate() then

    print(
        "[ULF] ERROR: Loot configuration is invalid"
    )

    return
end

-- CONTEXT
Ext.Require("Context/EnemyContext.lua")
Ext.Require("Context/PartyContext.lua")
Ext.Require("Context/LootContext.lua")

-- LOOT - BASIC
Ext.Require("Loot/LootEligibility.lua")
Ext.Require("Loot/LootItemEligibility.lua")

Ext.Require("Loot/LootGeneration.lua")
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
Ext.Require("Scanner/EnemyDebugInspector.lua")


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

end)