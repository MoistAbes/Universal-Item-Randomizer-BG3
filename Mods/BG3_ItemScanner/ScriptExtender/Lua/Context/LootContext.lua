ULF_LootContext = {}

-- ============================================================
-- BUILD LOOT CONTEXT
-- ============================================================

function ULF_LootContext.Build(
    enemyContext,
    partyContext,
    enemyThreatScore
)

    if not enemyContext then
        return nil
    end

    if not partyContext then
        return nil
    end

    local relativeLevel =
        enemyContext.Class.Level -
        partyContext.AverageLevel

    return {
        Enemy = enemyContext,
        Party = partyContext,

        RelativeLevel = relativeLevel,

        EnemyThreatScore = enemyThreatScore
    }

end