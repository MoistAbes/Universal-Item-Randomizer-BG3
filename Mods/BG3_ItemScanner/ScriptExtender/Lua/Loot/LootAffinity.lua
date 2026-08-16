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

    local debugParts = {}

    for affinityType, weight in pairs(affinities) do

        table.insert(
            debugParts,
            tostring(affinityType) ..
            "=" ..
            tostring(weight)
        )

    end

    ULF_Debug.Print(
        "[LOOT AFFINITY] Weights: " ..
        table.concat(
            debugParts,
            " | "
        )
    )


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


    if totalWeight <= 0 then

        ULF_Debug.Error(
            "[LOOT AFFINITY] Invalid total weight -> Random"
        )

        return "Random"

    end


    local roll =
        math.random() * totalWeight

    local cumulative = 0


    for affinityType, weight in pairs(affinities) do

        cumulative =
            cumulative + weight

        if roll <= cumulative then

            ULF_Debug.Print(
                "[LOOT AFFINITY] Selected=" ..
                tostring(affinityType)
            )

            return affinityType

        end

    end


    ULF_Debug.Error(
        "[LOOT AFFINITY] Roll failed -> Random"
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