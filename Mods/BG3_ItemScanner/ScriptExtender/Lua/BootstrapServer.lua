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
Ext.Require("Scanner/ItemDebugInspector.lua")

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

    -- ULF_ItemDebugInspector.InspectStat("MAG_Weapon44")
    -- ULF_ItemDebugInspector.InspectStat("ARM_Leather_Body")
    -- ULF_ItemDebugInspector.InspectStat("Cl_LightSharran_Shirt_A")
    -- ULF_ItemDebugInspector.InspectStat("MAG_Bhaalist_Paralyzing_Dagger")
    --     ULF_ItemDebugInspector.InspectStat("ARM_Shield_GuardianOfFaith_Neutral")
    --     ULF_ItemDebugInspector.InspectStat("GAB_YurgirKnife")
    --             ULF_ItemDebugInspector.InspectStat("HAG_HagsRing")
    --                             ULF_ItemDebugInspector.InspectStat("WYR_MonkAmulet_Amulet_NoGhost")
    --                                                             ULF_ItemDebugInspector.InspectStat("OBJ_Potion_Of_Psychic_Resistance")
    ULF_ItemDebugInspector.InspectStat("Mace_HeavensRage_Stats")
    ULF_ItemDebugInspector.InspectStat("WPN_HeavyCrossbow_Rusty")
        ULF_ItemDebugInspector.InspectStat("FATE_StoneKing_DwarfPlate")






end)