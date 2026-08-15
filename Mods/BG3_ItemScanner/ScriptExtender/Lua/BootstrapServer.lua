print("[ItemScanner] BootstrapServer.lua LOADED")


-- ============================================================
-- LOAD MODULES
-- ============================================================

-- CONFIG
Ext.Require("Config/ModSettings.lua")
Ext.Require("Config/LootConfig.lua")

-- DEBUG
Ext.Require("Debug/ULF_Debug.lua")

Ext.Require("Loot/LootDefinitions.lua")
Ext.Require("Config/MCM.lua")

-- ============================================================
-- CONFIG VALIDATION
-- ============================================================

Ext.Require("Config/LootConfigValidator.lua")

if not ULF_LootConfigValidator.Validate() then

    ULF_Debug.Error(
        "[BOOTSTRAP SERVER] Loot configuration is invalid"
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
Ext.Require("Scanner/ItemDebugInspector.lua")

-- LOOT - RESOLUTION / SPAWNING
Ext.Require("Loot/LootAffinity.lua")
Ext.Require("Loot/LootItemResolver.lua")
Ext.Require("Loot/LootSpawner.lua")


-- LOOT - INJECTION
Ext.Require("Loot/LootInjector.lua")


-- ============================================================
-- SESSION LOADED
-- ============================================================

Ext.Events.SessionLoaded:Subscribe(function()

    ULF_Debug.Print("[BOOTSTRAP SERVER] SESSION LOADED")

    local success =
        ULF_DatabaseInitializer.Initialize()

    if not success
        or not ULF_Database.Ready then

        ULF_Debug.Error(
            "[BOOTSTRAP SERVER] Database is not ready"
        )

        return
    end

end)