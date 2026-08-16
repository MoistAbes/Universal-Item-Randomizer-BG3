ULF_LootGeneration = {}

-- ============================================================
-- DETERMINE DROP COUNT
-- ============================================================

local function GetBaseDropCount(level)

    for _, entry in ipairs(
        ULF_LootConfig.DropCountByLevel
    ) do

        if level <= entry.MaxLevel then
            return entry.Count
        end

    end

    return 0

end


local function GetThreatDropBonus(threatScore)

    local bonus = 0

    for _, entry in ipairs(
        ULF_LootConfig.DropCountThreatThresholds
    ) do

        if threatScore >= entry.Threshold then

            bonus =
                bonus +
                entry.Bonus

        end

    end

    return bonus

end


function ULF_LootGeneration.GetDropCount(lootContext)

    if not lootContext
        or not lootContext.Enemy
    then
        return 0
    end


    local level =
        lootContext.Enemy.Class.Level or 0


    local threatScore =
        lootContext.EnemyThreatScore or 0


    local baseCount =
        GetBaseDropCount(level)


    local threatBonus =
        GetThreatDropBonus(threatScore)


    local finalCount =
        baseCount +
        threatBonus


    ULF_Debug.Print(
        "[LOOT] Drop count calculation:" ..
        " level=" ..
        tostring(level) ..
        " / base=" ..
        tostring(baseCount) ..
        " / threat=" ..
        string.format("%.2f", threatScore) ..
        " / threatBonus=" ..
        tostring(threatBonus) ..
        " / final=" ..
        tostring(finalCount)
    )


    return finalCount

end

function ULF_LootGeneration.CalculateDropChance(lootContext)

    local baseChance =
        ULF_LootConfig.BaseDropChance

    local threatScore =
        lootContext.EnemyThreatScore or 0

    local threatForGuaranteedDrop =
        ULF_LootConfig.ThreatForGuaranteedDrop

    local threatModifier = 0

    if threatForGuaranteedDrop
        and threatForGuaranteedDrop > 0
    then

        local threatRatio =
            threatScore /
            threatForGuaranteedDrop

        threatModifier =
            threatRatio *
            (
                1 -
                baseChance
            )

    end

    local finalChance =
        baseChance +
        threatModifier

    finalChance =
        math.max(
            0,
            math.min(
                1,
                finalChance
            )
        )

    ULF_Debug.Print(
        "[LOOT] Drop chance calculation:" ..
        " base=" ..
        string.format("%.3f", baseChance) ..
        " / threatScore=" ..
        string.format("%.3f", threatScore) ..
        " / threatModifier=" ..
        string.format("%.3f", threatModifier) ..
        " / final=" ..
        string.format("%.3f", finalChance)
    )

    return finalChance

end

function ULF_LootGeneration.ShouldGenerate(lootContext)

    local chance =
        ULF_LootGeneration.CalculateDropChance(lootContext)

    local roll =
        math.random()

    local success =
        roll <= chance

    ULF_Debug.Print(
        "[LOOT] Drop roll: " ..
        string.format("%.3f", roll) ..
        " / chance: " ..
        string.format("%.3f", chance) ..
        " -> " ..
        tostring(success)
    )

    return success
end