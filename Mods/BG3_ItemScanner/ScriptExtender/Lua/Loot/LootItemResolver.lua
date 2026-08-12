print("[ULF] LootItemResolver.lua LOADED")

ULF_LootItemResolver = {}


-- ============================================================
-- RESOLVE RANDOM ITEM BY RARITY
-- ============================================================

function ULF_LootItemResolver.Resolve(rarity)

    if not rarity then

        print(
            "[ULF][LOOT] ERROR: Rarity is missing"
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
            table.insert(eligible, record)
        end

    end

    if #eligible == 0 then
        return nil
    end

    return eligible[
        math.random(#eligible)
    ]

end


print(
    "[ULF][LOOT] Item Resolver API exported"
)