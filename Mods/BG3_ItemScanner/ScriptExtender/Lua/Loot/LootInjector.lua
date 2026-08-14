print("[ULF] LootInjector.lua LOADED")

-- ============================================================
-- DEBUG: LOOT ITEM
-- ============================================================

local function DebugLootItem(record)

    print(
        "[ULF][LOOT] Item Category: " ..
        tostring(record.Category)
    )

    print(
        "[ULF][LOOT] Item Type: " ..
        tostring(record.Type)
    )

    print(
        "[ULF][LOOT] Item Stat: " ..
        tostring(record.Stat)
    )

    print(
        "[ULF][LOOT] Item DisplayName: " ..
        tostring(record.DisplayName)
    )

end

local function generateLoot(lootContext, victim, dropCount)

        -- ========================================================
    -- GENERATE EACH DROP
    -- ========================================================

    for i = 1, dropCount do

        print(
            "[ULF][LOOT] Generating drop " ..
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

        print(
            "[ULF][LOOT] Max rarity: " ..
            tostring(maxRarity)
        )

        if not maxRarity then

            print(
                "[ULF][LOOT] Failed to resolve max rarity"
            )

            return
        end

        -- ====================================================
        -- RESOLVE RARITY
        -- ====================================================

        local resolvedRarity =
            ULF_LootRarityResolver.Resolve(
                maxRarity
            )

        print(
            "[ULF][LOOT] Resolved rarity: " ..
            tostring(resolvedRarity)
        )

        if not resolvedRarity then

            print(
                "[ULF][LOOT] Failed to resolve rarity"
            )

            return
        end

        -- ====================================================
        -- RESOLVE ITEM
        -- ====================================================

        local itemRecord =
            ULF_LootItemResolver.Resolve(
                lootContext,
                resolvedRarity
            )

        if not itemRecord then

            print(
                "[ULF][LOOT] Item resolution failed"
            )

        else

            print(
                "[ULF][LOOT] Item resolved successfully"
            )

            print(
                "[ULF][LOOT] Item UUID: " ..
                tostring(itemRecord.RootTemplate)
            )


            -- ================================================
            -- SPAWN ITEM
            -- ================================================

            local success =
                ULF_LootSpawner.AddItem(
                    victim,
                    itemRecord
                )

            print(
                "[ULF][LOOT] Spawn result: " ..
                tostring(success)
            )


            -- ================================================
            -- DEBUG ITEM
            -- ================================================

            DebugLootItem(
                itemRecord
            )

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

        print(
            "[ULF][INJECTOR] ERROR: Failed to build enemy context"
        )

        return
    end

    -- ====================================================
    -- Build Player context
    -- ====================================================

    ULF_EnemyContext.DebugPrint(enemyContext)

    local partyContext =
        ULF_PartyContext.Build()

    if not partyContext then

        print(
            "[ULF][INJECTOR] ERROR: Failed to build party context"
        )

        return
    end

    -- ====================================================
    -- Build LOOT context
    -- ====================================================

    local lootContext = ULF_LootContext.Build(enemyContext, partyContext)

    return lootContext

end


-- ============================================================
-- PROCESS ENEMY LOOT
-- ============================================================

local function ProcessEnemyLoot(victim, lootContext)

    if not lootContext then
        print(
            "[ULF][LOOT] Missing loot context"
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

    print(
        "[ULF][LOOT] Eligibility: " ..
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

        print(
            "[ULF][LOOT] Drop chance failed"
        )

        return
    end


    -- ========================================================
    -- DROP COUNT
    -- ========================================================

    local dropCount =
        ULF_LootGeneration.GetDropCount(
            lootContext
        )

    print(
        "[ULF][LOOT] Drop count: " ..
        tostring(dropCount)
    )

    if not dropCount
        or dropCount <= 0 then

        print(
            "[ULF][LOOT] Drop count is zero"
        )

        return
    end

    generateLoot(lootContext, victim, dropCount);

end


-- ============================================================
-- OSIRIS: DIED
-- ============================================================

Ext.Osiris.RegisterListener(
    "Died",
    1,
    "after",
    function(victim)

        if not ULF_ModSettings.Enabled then
            return
        end

        print(
            "[ULF][INJECTOR] Died event: " ..
            tostring(victim)
        )

        if not ULF_Database.Ready then

            print(
                "[ULF][INJECTOR] Database is not ready"
            )

            return
        end

        -- ====================================================
        -- GET ENTITY
        -- ====================================================

        local entity =
            Ext.Entity.Get(victim)

        if not entity then

            print(
                "[ULF][INJECTOR] ERROR: Victim entity not found"
            )

            return
        end

        -- ====================================================
        -- ENEMY RESEARCH
        -- ====================================================
        ULF_EnemyDebugInspector.Inspect(entity)

        local lootContext = buildLootContext(entity)

        if not lootContext then

            print(
                "[ULF][INJECTOR] Failed to build loot context"
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