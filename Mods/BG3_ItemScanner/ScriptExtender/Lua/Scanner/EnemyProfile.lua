print("[ULF] EnemyProfile.lua LOADED")

ULF_EnemyProfile = {}

-- ============================================================
-- BUILD ENEMY PROFILE
-- ============================================================

function ULF_EnemyProfile.Build(entity)

    if not entity then
        print("[ULF][ENEMY] ERROR: Entity is nil")
        return nil
    end


    -- ========================================================
    -- UUID
    -- ========================================================

    local uuidComponent =
        entity:GetAllComponents().Uuid

    local entityUuid = nil

    if uuidComponent then
        entityUuid =
            uuidComponent.EntityUuid
    end


    -- ========================================================
    -- ORIGINAL TEMPLATE
    -- ========================================================

    local templateComponent =
        entity:GetAllComponents().OriginalTemplate

    local originalTemplate = nil

    if templateComponent then
        originalTemplate =
            templateComponent.OriginalTemplate
    end


    -- ========================================================
    -- RACE
    -- ========================================================

    local raceComponent =
        entity:GetAllComponents().Race

    local race = nil

    if raceComponent then
        race =
            raceComponent.Race
    end


    -- ========================================================
    -- LEVEL
    -- ========================================================

    local levelComponent =
        entity:GetAllComponents().EocLevel

    local level = nil

    if levelComponent then
        level =
            levelComponent.Level
    end


    -- ========================================================
    -- PROFILE
    -- ========================================================

    return {

        EntityUuid = entityUuid,

        OriginalTemplate = originalTemplate,

        Race = race,

        Level = level

    }

end


-- ============================================================
-- TEST API
-- ============================================================

function ULF_EnemyProfile.Test()

    return "ENEMY_PROFILE_OK"

end


print(
    "[ULF][ENEMY] API exported: " ..
    tostring(type(ULF_EnemyProfile))
)


-- ============================================================
-- RESEARCH NOTES
-- ============================================================
--
-- Current research status:
--
-- CONFIRMED:
--
-- EntityUuid
--   -> Uuid.EntityUuid
--
-- OriginalTemplate
--   -> OriginalTemplate.OriginalTemplate
--
-- Race
--   -> Race.Race
--
-- Level
--   -> EocLevel.Level
--
-- Inventory:
--   -> InventoryOwner.Inventories
--   -> Main inventory can be empty
--   -> Equipment inventory can be empty
--   -> Therefore Inventory contents are NOT currently treated
--      as the source of enemy loot rules.
--
-- LootComponent:
--   -> Flags / InventoryType were tested
--   -> Imp / Mephit = 3 / 8
--   -> Goblin / Refugee / DrainVictim = 1 / 33
--   -> Therefore these values are NOT sufficient to identify
--      a generic "enemy" category.
--
-- Classes:
--   -> Component exists
--   -> Some NPCs return empty/default class UUIDs
--   -> Not currently used by EnemyProfile.
--
-- FUTURE RESEARCH:
--
-- EnemyProfile can be expanded later with:
--   - Classes
--   - Faction
--   - Tags
--   - Archetype
--   - Loot-related data
--   - Other combat/reward information
--
-- IMPORTANT:
-- Keep this profile intentionally small.
-- Add new fields only when research confirms that they are
-- useful for the loot system.
--
-- Design goal:
-- Simple now -> easy to expand later.
-- Keep responsibilities separated and avoid premature indexes
-- or complex enemy classification systems.
--
-- ============================================================