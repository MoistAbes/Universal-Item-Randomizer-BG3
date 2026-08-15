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
        ULF_DatabaseQuery.GetByRarity(rarity)

    if not candidates or #candidates == 0 then
        return nil
    end

    local eligible = {}

    for _, record in ipairs(candidates) do

        if ULF_LootItemEligibility.IsEligible(record) then
            table.insert(
                eligible,
                record
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

    for _, record in ipairs(eligible) do

        if affinity == "Random"
            or ULF_LootAffinity.HasAffinity(
                record,
                affinity
            )
        then

            table.insert(
                affinityEligible,
                record
            )

        end

    end


    if #affinityEligible == 0 then

        ULF_Debug.Print(
            "[LOOT ITEM RESOLVER] No items found for affinity: " ..
            tostring(affinity)
        )

        return nil

    end


    -- ========================================================
    -- RANDOM ITEM
    -- ========================================================

    ULF_Debug.Print(
        "[AFFINITY] Matching items: " ..
        tostring(#affinityEligible)
    )

    return affinityEligible[
        math.random(#affinityEligible)
    ]

end