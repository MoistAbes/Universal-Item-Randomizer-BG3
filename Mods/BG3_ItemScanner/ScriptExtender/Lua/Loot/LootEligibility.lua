print("[ULF] LootEligibility.lua LOADED")

ULF_LootEligibility = {}


-- ============================================================
-- CHECK IF ENEMY CAN GENERATE BONUS LOOT
-- ============================================================

function ULF_LootEligibility.CanGenerate(profile)

    if not ULF_LootConfig then
        print(
            "[ULF][LOOT] ERROR: LootConfig not loaded"
        )

        return false
    end


    if not ULF_LootConfig.Enabled then
        return false
    end


    if not ULF_LootConfig.EnemyLootEnabled then
        return false
    end


    if not profile then
        return false
    end


    if not profile.EntityUuid then
        return false
    end


    return true

end


print(
    "[ULF][LOOT] Eligibility API exported"
)
