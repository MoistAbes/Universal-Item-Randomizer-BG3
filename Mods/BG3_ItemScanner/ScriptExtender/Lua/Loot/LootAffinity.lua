print("[ULF] LootAffinity.lua LOADED")

ULF_LootAffinity = {}

-- ============================================================
-- DEFAULT AFFINITY
-- ============================================================

local DEFAULT_AFFINITY = 1


-- ============================================================
-- CALCULATE AFFINITY
-- ============================================================

function ULF_LootAffinity.Calculate(
    lootContext,
    itemRecord
)

    if not itemRecord then
        return DEFAULT_AFFINITY
    end

    local affinity =
        DEFAULT_AFFINITY


    -- ========================================================
    -- ENEMY CONTEXT
    -- ========================================================

    local enemyContext =
        lootContext
        and lootContext.Enemy

    if not enemyContext then
        return affinity
    end


    -- ========================================================
    -- ARCHETYPE
    -- ========================================================

    local archetype =
        enemyContext.Archetype

    if archetype == "melee"
        and itemRecord.Category == "Weapon"
    then

        affinity = affinity + 2

    elseif archetype == "ranged"
        and itemRecord.Category == "Weapon"
    then

        affinity = affinity + 2

    end


    -- ========================================================
    -- EQUIPPED ITEMS
    -- ========================================================

    if enemyContext.Items then

        for _, enemyItem in ipairs(
            enemyContext.Items
        ) do

            if enemyItem.Equipped
                and enemyItem.Type
                    == itemRecord.Category
            then

                affinity = affinity + 1

            end

        end

    end


    return affinity

end


print(
    "[ULF][LOOT] Loot Affinity API exported"
)