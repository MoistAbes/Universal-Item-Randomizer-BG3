ULF_LootTier = {}


-- ============================================================
-- GET MAXIMUM RARITY AVAILABLE TO ENEMY
-- ============================================================

function ULF_LootTier.GetMaxRarity(profile)

    -- if we will find out how to corretly determine if enemy is strong or is a boss then we can change it for now lets leave it like this

    if not profile then
        return nil
    end

    local level =
        tonumber(profile.ClassLevel)

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