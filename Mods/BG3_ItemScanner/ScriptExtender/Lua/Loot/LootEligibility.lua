ULF_LootEligibility = {}


-- ============================================================
-- CHECK IF ENEMY CAN GENERATE BONUS LOOT
-- ============================================================

function ULF_LootEligibility.CanGenerate(profile)

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
