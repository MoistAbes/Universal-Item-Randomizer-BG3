print(" LootInjector.lua LOADED")

-- ============================================================
-- DEBUG: LOOT ITEM
-- ============================================================

local function DebugLootItem(record)
    ULF_Debug.Print("[LOOT INJECTOR] Dropped Item Category=" .. tostring(record.Category) .. " | Type=" .. tostring(record.Type) .. " | Stat=" .. tostring(record.Stat) .. " | DisplayName=" .. tostring(record.DisplayName))
end

local function generateLoot(
    lootContext,
    victim,
    dropCount
)

    local affinities =
        ULF_LootAffinity.Calculate(
            lootContext.Enemy
        )


    -- ========================================================
    -- GENERATE EACH DROP
    -- ========================================================

    for i = 1, dropCount do

        ULF_Debug.Print(
            "[LOOT] Drop " ..
            tostring(i) ..
            "/" ..
            tostring(dropCount)
        )


        -- ====================================================
        -- MAX RARITY
        -- ====================================================

        local maxRarity =
            ULF_LootTier.GetMaxRarity(
                lootContext
            )

        if not maxRarity then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Failed to resolve max rarity"
            )

            return
        end

        -- ====================================================
        -- RESOLVE RARITY
        -- ====================================================

        local resolvedRarity =
            ULF_LootRarityResolver.Resolve(
                lootContext,
                maxRarity
            )

        if not resolvedRarity then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Failed to resolve rarity"
            )

            return
        end


        -- ====================================================
        -- RESOLVE AFFINITY
        -- ====================================================

        local resolvedAffinity =
            ULF_LootAffinity.ResolveAffinity(
                affinities
            )


        -- ====================================================
        -- RESOLVE ITEM
        -- ====================================================

        local itemRecord =
            ULF_LootItemResolver.Resolve(
                resolvedAffinity,
                resolvedRarity
            )

        if not itemRecord then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Item resolution failed"
            )

            return
        end


        -- ====================================================
        -- SPAWN ITEM
        -- ====================================================

        local success =
            ULF_LootSpawner.AddItem(
                victim,
                itemRecord
            )

        if not success then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Failed to spawn item"
            )

            return
        end

    end

end

local function buildLootContext(entity)

    -- ====================================================
    -- BUILD ENEMY CONTEXT
    -- ====================================================

    local enemyContext =
        ULF_EnemyContext.Build(
            entity
        )

    if not enemyContext then

        ULF_Debug.Error(
            "[LOOT INJECTOR] Failed to build enemy context"
        )

        return
    end

    -- ULF_EnemyContext.DebugPrint(enemyContext)

    -- ====================================================
    -- CALCULATE ENEMY THREAT
    -- ====================================================

    local enemyThreat = ULF_EnemyThreatCalculator.Calculate(enemyContext);

     if not enemyThreat then

        ULF_Debug.Error(
            "[LOOT INJECTOR] Failed to calculate enemyThreat"
        )

        return
    end

    ULF_EnemyThreatCalculator.DebugPrint(enemyThreat);

    -- ====================================================
    -- Build Player context
    -- ====================================================

    local partyContext =
        ULF_PartyContext.Build()

    if not partyContext then

        ULF_Debug.Error(
            "[LOOT INJECTOR] Failed to build party context"
        )

        return
    end

    -- ====================================================
    -- Build LOOT context
    -- ====================================================

    local lootContext = ULF_LootContext.Build(enemyContext, partyContext, enemyThreat.Score)

    return lootContext

end


-- ============================================================
-- PROCESS ENEMY LOOT
-- ============================================================

local function ProcessEnemyLoot(victim, lootContext)

    if not lootContext then
        ULF_Debug.Error(
            "[LOOT INJECTOR] Missing loot context"
        )
        return
    end

    -- ========================================================
    -- ENEMY ELIGIBILITY
    -- ========================================================

    local canGenerate =
        ULF_LootEligibility.CanGenerate(
            lootContext
        )

    ULF_Debug.Print(
        "[LOOT INJECTOR] Eligibility (Can this enemy drop item): " ..
        tostring(canGenerate)
    )

    if not canGenerate then
        return
    end

    -- ========================================================
    -- DROP CHANCE
    -- ========================================================

    local shouldDrop =
        ULF_LootGeneration.ShouldGenerate(lootContext)

    if not shouldDrop then
        return
    end

    -- ========================================================
    -- DROP COUNT
    -- ========================================================

    local dropCount =
        ULF_LootGeneration.GetDropCount(
            lootContext
        )

    ULF_Debug.Print(
        "[LOOT INJECTOR] Drop count: " ..
        tostring(dropCount)
    )

    if not dropCount
        or dropCount <= 0 then

        return
    end

    generateLoot(lootContext, victim, dropCount);

end


-- ============================================================
-- OSIRIS: DIED
-- ============================================================

Ext.Osiris.RegisterListener("Died",1,"after", function(victim)

        if not ULF_ModSettings.Enabled then
            return
        end

        ULF_Debug.Print(
            "[LOOT INJECTOR] Died event: " ..
            tostring(victim)
        )

        if not ULF_Database.Ready then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Database is not ready"
            )

            return
        end

        -- ====================================================
        -- GET ENTITY
        -- ====================================================

        local entity =
            Ext.Entity.Get(victim)

        if not entity then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Victim entity not found"
            )

            return
        end

        -- ====================================================
        -- ENEMY RESEARCH
        -- ====================================================
        -- ULF_EnemyDebugInspector.Inspect(entity)

        local lootContext = buildLootContext(entity)

        if not lootContext then

            ULF_Debug.Error(
                "[LOOT INJECTOR] Failed to build loot context"
            )

            return
        end

        -- ====================================================
        -- PROCESS LOOT
        -- ====================================================

        ProcessEnemyLoot(
            victim,
            lootContext
        )

    end
)