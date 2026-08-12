print("[ULF] LootTier.lua LOADED")

ULF_LootTier = {}


-- ============================================================
-- GET MAXIMUM RARITY AVAILABLE TO ENEMY
-- ============================================================

function ULF_LootTier.GetMaxRarity(profile)

    if not profile then
        return "Common"
    end

    local level =
        tonumber(profile.Level) or 1


    if level <= 2 then
        return "Uncommon"

    elseif level <= 4 then
        return "Rare"

    elseif level <= 6 then
        return "VeryRare"

    else
        return "Legendary"
    end

end


print(
    "[ULF][LOOT] Tier API exported"
)