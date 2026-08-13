ULF_LootTier = {}


-- ============================================================
-- GET MAXIMUM RARITY AVAILABLE TO ENEMY
-- ============================================================

function ULF_LootTier.GetMaxRarity(profile)

    if not profile then
        return nil
    end

    local level =
        tonumber(profile.Level)

    if not level then
        return nil
    end

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