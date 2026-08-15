print("[ULF] EnemyThreatCalculator.lua LOADED")

ULF_EnemyThreatCalculator = {}

-- ============================================================
-- CONFIGURATION
-- ============================================================
--
-- V1 intentionally uses simple, transparent numbers.
--
-- IMPORTANT:
-- ThreatScore is NOT capped at 100.
--
-- Every component is calculated independently and then
-- multiplied by its weight.
--
-- This makes future balancing easy.
-- ============================================================

local CONFIG = ULF_EnemyThreatConfig


-- ============================================================
-- HELPERS
-- ============================================================

local function SafeNumber(value)

    if type(value) == "number" then
        return value
    end

    return 0

end


-- ============================================================
-- LEVEL
-- ============================================================

local function CalculateLevelThreat(enemyContext)

    if not enemyContext
        or not enemyContext.Class
    then
        return 0
    end


    local level =
        SafeNumber(enemyContext.Class.Level)


    if level <= 0 then
        return 0
    end


    return level * CONFIG.LevelWeight

end


-- ============================================================
-- HEALTH
-- ============================================================

local function CalculateHealthThreat(enemyContext)

    if not enemyContext
        or not enemyContext.Health
    then
        return 0
    end


    local maxHP =
        SafeNumber(enemyContext.Health.MaxHP)

    local maxTemporaryHP =
        SafeNumber(enemyContext.Health.MaxTemporaryHP)


    local effectiveHP =
        maxHP +
        (
            maxTemporaryHP *
            CONFIG.TemporaryHPFactor
        )


    return effectiveHP *
        CONFIG.HealthWeight

end


-- ============================================================
-- ARMOR CLASS
-- ============================================================

local function CalculateACThreat(enemyContext)

    if not enemyContext
        or not enemyContext.Combat
    then
        return 0
    end


    local ac =
        SafeNumber(enemyContext.Combat.AC)


    if ac <= 0 then
        return 0
    end


    return ac * CONFIG.ACWeight

end


-- ============================================================
-- ABILITIES
-- ============================================================
--
-- Uses both:
--
-- 1. Raw ability values
-- 2. Ability modifiers
--
-- But modifiers are intentionally much more important.
--
-- We use the AVERAGE rather than SUM of all ability scores.
-- This prevents enemies with many populated values from
-- receiving excessive threat.
-- ============================================================

local function CalculateAbilityThreat(enemyContext)

    if not enemyContext
        or not enemyContext.Abilities
    then
        return 0
    end


    local values =
        enemyContext.Abilities.Values or {}

    local modifiers =
        enemyContext.Abilities.Modifiers or {}


    local valueTotal = 0
    local valueCount = 0

    for _, value in pairs(values) do

        value =
            SafeNumber(value)

        if value > 0 then

            valueTotal =
                valueTotal + value

            valueCount =
                valueCount + 1

        end

    end


    local modifierTotal = 0
    local modifierCount = 0

    for _, modifier in pairs(modifiers) do

        modifier =
            SafeNumber(modifier)

        modifierTotal =
            modifierTotal + modifier

        modifierCount =
            modifierCount + 1

    end


    local averageValue = 0
    local averageModifier = 0


    if valueCount > 0 then

        averageValue =
            valueTotal / valueCount

    end


    if modifierCount > 0 then

        averageModifier =
            modifierTotal / modifierCount

    end


    local score =
        (
            averageValue *
            CONFIG.AbilityValueFactor
        )
        +
        (
            averageModifier *
            CONFIG.AbilityModifierFactor
        )


    return score *
        CONFIG.AbilityWeight

end


-- ============================================================
-- PROFICIENCY
-- ============================================================

local function CalculateProficiencyThreat(enemyContext)

    if not enemyContext
        or not enemyContext.ProficiencyGroup
    then
        return 0
    end


    local count =
        #enemyContext.ProficiencyGroup


    return
        count *
        CONFIG.ProficiencyPerGroup *
        CONFIG.ProficiencyWeight

end


-- ============================================================
-- EQUIPMENT
-- ============================================================

local function CalculateEquipmentThreat(enemyContext)

    if not enemyContext
        or not enemyContext.Items
    then
        return 0
    end


    local score = 0


    for _, item in ipairs(enemyContext.Items) do

        if item
            and item.Equipped
        then

            local rarity =
                SafeNumber(item.Rarity)


            local rarityMultiplier =
                CONFIG.RarityMultiplier[rarity]


            if not rarityMultiplier then

                rarityMultiplier = 1.0

            end


            score =
                score
                +
                (
                    CONFIG.EquippedItemBaseValue
                    *
                    rarityMultiplier
                )

        end

    end


    return
        score *
        CONFIG.EquipmentWeight

end


-- ============================================================
-- CALCULATE
-- ============================================================

function ULF_EnemyThreatCalculator.Calculate(
    enemyContext
)

    if not enemyContext then

        ULF_Debug.Error(
            "[THREAT] enemyContext is nil"
        )

        return nil

    end


    local levelScore =
        CalculateLevelThreat(
            enemyContext
        )


    local healthScore =
        CalculateHealthThreat(
            enemyContext
        )


    local acScore =
        CalculateACThreat(
            enemyContext
        )


    local abilityScore =
        CalculateAbilityThreat(
            enemyContext
        )


    local proficiencyScore =
        CalculateProficiencyThreat(
            enemyContext
        )


    local equipmentScore =
        CalculateEquipmentThreat(
            enemyContext
        )


    local total =
        levelScore
        + healthScore
        + acScore
        + abilityScore
        + proficiencyScore
        + equipmentScore


    return {

        Score = total,

        Components = {

            Level = levelScore,

            Health = healthScore,

            AC = acScore,

            Abilities = abilityScore,

            Proficiency = proficiencyScore,

            Equipment = equipmentScore,

        },

    }

end


-- ============================================================
-- DEBUG PRINT
-- ============================================================

function ULF_EnemyThreatCalculator.DebugPrint(
    result
)

    if not result then

        ULF_Debug.Print(
            "[THREAT] Result is nil"
        )

        return

    end


    ULF_Debug.Print(
        "[THREAT] ========================================"
    )


    ULF_Debug.Print(
        "[THREAT] Total Score: " ..
        tostring(result.Score)
    )


    if result.Components then

        ULF_Debug.Print(
            "[THREAT] Components:"
        )

        ULF_Debug.Print(
            "  Level:        " ..
            tostring(result.Components.Level)
        )

        ULF_Debug.Print(
            "  Health:       " ..
            tostring(result.Components.Health)
        )

        ULF_Debug.Print(
            "  AC:           " ..
            tostring(result.Components.AC)
        )

        ULF_Debug.Print(
            "  Abilities:    " ..
            tostring(result.Components.Abilities)
        )

        ULF_Debug.Print(
            "  Proficiency:  " ..
            tostring(result.Components.Proficiency)
        )

        ULF_Debug.Print(
            "  Equipment:    " ..
            tostring(result.Components.Equipment)
        )

    end


    ULF_Debug.Print(
        "[THREAT] ========================================"
    )

end