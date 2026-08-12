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


print(
    "[ULF][LOOT] Generator API exported"
)