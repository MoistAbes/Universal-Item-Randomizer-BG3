print("[ULF] LootInjector.lua LOADED")


-- ============================================================
-- DEBUG: ENEMY PROFILE
-- ============================================================

local function DebugEnemyProfile(profile)

    print("[ULF][INJECTOR] Enemy Profile:")
    print("  UUID: " ..tostring(profile.EntityUuid))
    print("  Template: " ..tostring(profile.OriginalTemplate))
    print("  Race: " ..tostring(profile.Race))
    print("  Level: " ..tostring(profile.Level))

end


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


-- ============================================================
-- PROCESS ENEMY LOOT
-- ============================================================

local function ProcessEnemyLoot(victim, enemyProfile)

    -- ========================================================
    -- ENEMY ELIGIBILITY
    -- ========================================================

    local canGenerate =
        ULF_LootEligibility.CanGenerate(
            enemyProfile
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
        ULF_LootGenerator.RollDropChance(
            enemyProfile
        )

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
        ULF_LootGenerator.GetDropCount(
            enemyProfile
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
                enemyProfile
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
        -- BUILD ENEMY PROFILE
        -- ====================================================

        local enemyProfile =
            ULF_EnemyProfile.Build(
                entity
            )

        if not enemyProfile then

            print(
                "[ULF][INJECTOR] ERROR: Failed to build enemy profile"
            )

            return
        end


        -- ====================================================
        -- DEBUG PROFILE
        -- ====================================================

        DebugEnemyProfile(
            enemyProfile
        )


        -- ====================================================
        -- PROCESS LOOT
        -- ====================================================

        ProcessEnemyLoot(
            victim,
            enemyProfile
        )

    end
)