ULF_LootItemResolver = {}

-- ============================================================
-- RESOLVE RANDOM ITEM BY RARITY AND AFFINITY
-- ============================================================

function ULF_LootItemResolver.Resolve(
    affinity,
    rarity
)

    if not rarity then

        ULF_Debug.Error(
            "[LOOT ITEM RESOLVER] Rarity is missing"
        )

        return nil
    end


    local candidates =
        ULF_DatabaseQuery.GetByRarity(
            rarity
        )

    if not candidates
        or #candidates == 0
    then
        return nil
    end


    local eligible = {}

    for _, candidate in ipairs(candidates) do

        if ULF_LootItemEligibility.IsEligible(
            candidate.Record,
            candidate.Stat
        ) then

            table.insert(
                eligible,
                candidate
            )

        end

    end


    if #eligible == 0 then
        return nil
    end


    -- ========================================================
    -- FILTER BY AFFINITY
    -- ========================================================

    local affinityEligible = {}

    for _, candidate in ipairs(eligible) do

        if affinity == "Random"
            or ULF_LootAffinity.HasAffinity(
                candidate.Stat,
                affinity
            )
        then

            table.insert(
                affinityEligible,
                candidate
            )

        end

    end


    if #affinityEligible == 0 then

        ULF_Debug.Print(
            "[LOOT ITEM] No candidates for affinity=" ..
            tostring(affinity)
        )

        return nil

    end


    -- ========================================================
    -- RANDOM ITEM
    -- ========================================================

    ULF_Debug.Print(
        "[LOOT ITEM] Candidates=" ..
        tostring(#affinityEligible)
    )


    local selected =
        affinityEligible[
            math.random(#affinityEligible)
        ]


    ULF_Debug.Print(
        "[LOOT ITEM] Selected=" ..
        tostring(selected.Stat.Stat)
    )


    return selected

end