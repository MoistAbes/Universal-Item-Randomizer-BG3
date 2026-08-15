print("[ULF] LootAffinity.lua LOADED")

ULF_LootAffinity = {}

local DEFAULT_RANDOM_WEIGHT = 100
local PROFICIENCY_WEIGHT = 70


-- ============================================================
-- CALCULATE AFFINITIES
-- ============================================================

function ULF_LootAffinity.Calculate(
    enemyContext
)

    local affinities = {
        Random = DEFAULT_RANDOM_WEIGHT
    }

    -- ========================================================
    -- PROFICIENCY AFFINITIES
    -- ========================================================

    if enemyContext.ProficiencyGroup then

        for _, proficiency in ipairs(
            enemyContext.ProficiencyGroup
        ) do

            affinities[proficiency] =
                (affinities[proficiency] or 0) +
                PROFICIENCY_WEIGHT

        end

    end

    -- ========================================================
    -- DEBUG
    -- ========================================================

    print("[ULF][AFFINITY] Calculated affinities:")

    for affinityType, weight in pairs(affinities) do

        print(
            "  " ..
            tostring(affinityType) ..
            " | Weight: " ..
            tostring(weight)
        )

    end

    return affinities

end


-- ============================================================
-- RESOLVE FINAL AFFINITY
-- ============================================================

function ULF_LootAffinity.ResolveAffinity(affinities)

    local totalWeight = 0

    for _, weight in pairs(affinities) do

        totalWeight =
            totalWeight + weight

    end

    print(
        "[ULF][AFFINITY] Total weight: " ..
        tostring(totalWeight)
    )

    if totalWeight <= 0 then

        print(
            "[ULF][AFFINITY] Invalid total weight -> Random"
        )

        return "Random"

    end

    local roll =
        math.random() * totalWeight

    print(
        "[ULF][AFFINITY] Roll: " ..
        tostring(roll)
    )

    local cumulative = 0

    for affinityType, weight in pairs(affinities) do

        cumulative =
            cumulative + weight

        if roll <= cumulative then

            print(
                "[ULF][AFFINITY] Selected: " ..
                tostring(affinityType)
            )

            return affinityType

        end

    end

    print(
        "[ULF][AFFINITY] Roll failed -> Random"
    )

    return "Random"

end


-- ============================================================
-- UTILITY
-- ============================================================

local function Contains(
    list,
    value
)

    if not list then
        return false
    end

    for _, entry in ipairs(list) do

        if entry == value then
            return true
        end

    end

    return false

end


-- ============================================================
-- ITEM AFFINITY MATCHING
-- ============================================================

function ULF_LootAffinity.HasAffinity(
    itemRecord,
    affinity
)

    if not itemRecord
        or not affinity
    then
        return false
    end

    return Contains(
        itemRecord.ProficiencyGroup,
        affinity
    )

end


print(
    "[ULF][LOOT] Loot Affinity API exported"
)