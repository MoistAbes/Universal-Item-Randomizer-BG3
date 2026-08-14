ULF_LootEligibility = {}


-- ============================================================
-- CHECK IF ENEMY CAN GENERATE BONUS LOOT for example summons should not, party members, other examples
-- ============================================================

function ULF_LootEligibility.CanGenerate(lootContext)

    -- Gameplay / entity eligibility only.

    return true

end


print(
    "[ULF][LOOT] Eligibility API exported"
)
