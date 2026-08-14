print("[ULF] LootGenerator.lua LOADED")

ULF_LootGeneration = {}

local function GetRelativeLevelModifier(levelDifference)

    local modifiers =
        ULF_LootConfig.RelativeLevelModifiers

    if not modifiers then
        return 0
    end

    local roundedDifference =
        math.floor(levelDifference + 0.5)

    if roundedDifference <= -5 then
        return modifiers[-5] or 0
    end

    if roundedDifference >= 5 then
        return modifiers[5] or 0
    end

    return modifiers[roundedDifference] or 0
end

-- ============================================================
-- DETERMINE DROP COUNT
-- ============================================================

function ULF_LootGeneration.GetDropCount(lootContext)

    local level =
        lootContext.Enemy.Class.Level

    -- V1: simple level-based scaling.
    --
    -- This is intentionally conservative.
    -- Rarity and item selection will be handled separately.

    if level <= 2 then
        return 2

    elseif level <= 4 then
        return 3

    elseif level <= 6 then
        return 4

    elseif level <= 8 then
        return 5

    else
        return 6
    end

end

function ULF_LootGeneration.CalculateDropChance(lootContext)

    local baseChance =
        ULF_LootConfig.BaseDropChance

    local levelDifference =
        lootContext.RelativeLevel

    local levelModifier =
        GetRelativeLevelModifier(
            levelDifference
        )

    local finalChance =
        baseChance + levelModifier

    -- Clamp chance to [0, 1]

    finalChance =
        math.max(
            0,
            math.min(
                1,
                finalChance
            )
        )

    print(
        "[ULF][LOOT] Drop chance calculation:" ..
        " base=" ..
        string.format("%.3f", baseChance) ..
        " / relativeLevel=" ..
        string.format("%.1f", levelDifference) ..
        " / levelModifier=" ..
        string.format("%.3f", levelModifier) ..
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

    print(
        "[ULF][LOOT] Drop roll: " ..
        string.format("%.3f", roll) ..
        " / chance: " ..
        string.format("%.3f", chance) ..
        " -> " ..
        tostring(success)
    )

    return success
end


print(
    "[ULF][LOOT] Generator API exported"
)