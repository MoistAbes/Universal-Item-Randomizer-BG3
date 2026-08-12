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


    if not ULF_DatabaseQuery then

        print(
            "[ULF][LOOT] ERROR: DatabaseQuery is not loaded"
        )

        return nil
    end


    local item =
        ULF_DatabaseQuery.GetRandomByRarity(rarity)


    if not item then

        print(
            "[ULF][LOOT] No item found for rarity: " ..
            tostring(rarity)
        )

        return nil
    end


    return item

end


print(
    "[ULF][LOOT] Item Resolver API exported"
)