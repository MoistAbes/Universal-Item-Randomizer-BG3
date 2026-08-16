ULF_LootTier = {}


-- ============================================================
-- RARITY ORDER
-- ============================================================

local RARITY_ORDER = ULF_LootDefinitions.Rarities


-- ============================================================
-- GET RARITY INDEX
-- ============================================================

local function GetRarityIndex(rarity)

    for index, value in ipairs(RARITY_ORDER) do

        if value == rarity then
            return index
        end

    end

    return nil

end


-- ============================================================
-- GET BASE MAX RARITY BY LEVEL
-- ============================================================

local function GetBaseMaxRarity(level)

    local thresholds =
        ULF_LootConfig.MaxRarityByLevel

    if not thresholds then
        return "Common"
    end


    for _, entry in ipairs(thresholds) do

        if level <= entry.MaxLevel then
            return entry.Rarity
        end

    end


    return "Common"

end


-- ============================================================
-- CALCULATE THREAT RARITY BONUS
-- ============================================================

local function CalculateThreatRarityBonus(threatScore)

    local thresholds =
        ULF_LootConfig.MaxRarityThreatThresholds

    if not thresholds then
        return 0
    end


    local bonus = 0


    for _, entry in ipairs(thresholds) do

        if threatScore >= entry.Threshold then

            bonus =
                bonus +
                entry.Bonus

        end

    end


    return bonus

end


-- ============================================================
-- GET MAXIMUM RARITY AVAILABLE TO ENEMY
-- ============================================================

function ULF_LootTier.GetMaxRarity(lootContext)

    if not lootContext
        or not lootContext.Enemy
        or not lootContext.Enemy.Class
    then
        return nil
    end


    local level =
        lootContext.Enemy.Class.Level or 0


    local threatScore =
        lootContext.EnemyThreatScore or 0


    -- ========================================================
    -- BASE RARITY
    -- ========================================================

    local baseRarity =
        GetBaseMaxRarity(level)


    local baseIndex =
        GetRarityIndex(baseRarity)


    if not baseIndex then

        ULF_Debug.Error(
            "[LOOT TIER] Invalid base rarity: " ..
            tostring(baseRarity)
        )

        return nil

    end


    -- ========================================================
    -- THREAT BONUS
    -- ========================================================

    local threatBonus =
        CalculateThreatRarityBonus(
            threatScore
        )


    -- ========================================================
    -- FINAL RARITY
    -- ========================================================

    local finalIndex =
        baseIndex +
        threatBonus


    -- Never exceed Legendary.

    if finalIndex > #RARITY_ORDER then
        finalIndex = #RARITY_ORDER
    end


    local finalRarity =
        RARITY_ORDER[finalIndex]


 -- ========================================================
    -- DEBUG
    -- ========================================================

    ULF_Debug.Print(
        "[LOOT TIER] Level=" ..
        tostring(level) ..
        " | Base=" ..
        tostring(baseRarity) ..
        " | Threat=" ..
        string.format("%.2f", threatScore) ..
        " | Bonus=+" ..
        tostring(threatBonus) ..
        " | Max=" ..
        tostring(finalRarity)
    )


    return finalRarity

end