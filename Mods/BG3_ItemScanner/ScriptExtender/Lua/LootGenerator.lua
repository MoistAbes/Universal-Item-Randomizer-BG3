print("[ULF] LootGenerator.lua LOADED")

ULF_LootGenerator = {}


-- ============================================================
-- DETERMINE DROP COUNT
-- ============================================================

function ULF_LootGenerator.GetDropCount(profile)

    if not profile then
        return 0
    end

    local level =
        tonumber(profile.Level) or 1


    -- V1: simple level-based scaling.
    --
    -- This is intentionally conservative.
    -- Rarity and item selection will be handled separately.

    if level <= 2 then
        return 1

    elseif level <= 4 then
        return 2

    elseif level <= 6 then
        return 3

    elseif level <= 8 then
        return 4

    else
        return 5
    end

end

function ULF_LootGenerator.RollDropChance(profile)

    if not profile then
        return false
    end

    local chance =
        tonumber(ULF_LootConfig.BaseDropChance)

    if not chance then
        return false
    end

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