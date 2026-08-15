ULF_LootTier = {}


-- ============================================================
-- NOTE:
-- This currently uses enemy level only.
-- We do not yet have a reliable way to determine enemy power
-- or boss status.
--
-- Once EnemyPower / boss classification is available,
-- this logic can be expanded to use LootContext.
-- ============================================================

-- ============================================================
-- GET MAXIMUM RARITY AVAILABLE TO ENEMY
-- ============================================================

function ULF_LootTier.GetMaxRarity(lootContext)

    local level = lootContext.Enemy.Class.Level

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