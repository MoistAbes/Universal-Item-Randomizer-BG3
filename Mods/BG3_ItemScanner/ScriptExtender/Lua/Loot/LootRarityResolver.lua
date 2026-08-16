ULF_LootRarityResolver = {}

-- ============================================================
-- RARITY ORDER
-- ============================================================

local RARITY_ORDER =
    ULF_LootDefinitions.Rarities


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
-- CALCULATE THREAT PRESSURE
-- ============================================================

local function CalculateThreatPressure(threatScore)

    local thresholds =
        ULF_LootConfig.RarityThreatPressure

    if not thresholds
        or #thresholds == 0
    then
        return 0
    end


    threatScore =
        threatScore or 0


    -- Below first threshold.

    if threatScore <= thresholds[1].Threshold then
        return thresholds[1].Pressure
    end


    -- Find surrounding thresholds
    -- and interpolate between them.

    for index = 1, #thresholds - 1 do

        local current =
            thresholds[index]

        local next =
            thresholds[index + 1]


        if threatScore <= next.Threshold then

            local range =
                next.Threshold -
                current.Threshold

            local progress =
                (threatScore - current.Threshold) /
                range

            return
                current.Pressure +
                (
                    (next.Pressure - current.Pressure) *
                    progress
                )

        end

    end


    -- Above final threshold.

    return thresholds[#thresholds].Pressure

end


-- ============================================================
-- GET FINAL RARITY WEIGHT
-- ============================================================

local function GetFinalWeight(
    rarity,
    pressure
)

    local baseWeight =
        ULF_LootConfig.RarityWeights[rarity]

    local shift =
        ULF_LootConfig.RarityThreatShift[rarity]


    if baseWeight == nil then
        return 0
    end

    if shift == nil then
        shift = 0
    end


    local finalWeight =
        baseWeight +
        (
            shift *
            pressure
        )


    -- Never allow negative weights.

    if finalWeight < 0 then
        finalWeight = 0
    end


    return finalWeight

end


-- ============================================================
-- RESOLVE RANDOM RARITY
-- ============================================================

function ULF_LootRarityResolver.Resolve(
    lootContext,
    maxRarity
)

    if not lootContext then
        return nil
    end

    if not maxRarity then
        return nil
    end


    -- ========================================================
    -- MAX RARITY INDEX
    -- ========================================================

    local maxIndex =
        GetRarityIndex(maxRarity)


    if not maxIndex then
        return nil
    end


    -- ========================================================
    -- THREAT PRESSURE
    -- ========================================================

    local threatScore =
        lootContext.EnemyThreatScore or 0

    local pressure =
        CalculateThreatPressure(
            threatScore
        )


    -- ========================================================
    -- CALCULATE TOTAL WEIGHT
    -- ========================================================

    local totalWeight = 0

    local weights = {}


    for index = 1, maxIndex do

        local rarity =
            RARITY_ORDER[index]

        local weight =
            GetFinalWeight(
                rarity,
                pressure
            )


        weights[rarity] =
            weight

        totalWeight =
            totalWeight +
            weight

    end


    if totalWeight <= 0 then
        return nil
    end


    -- ========================================================
    -- DEBUG
    -- ========================================================

    local debugParts = {}


    for index = 1, maxIndex do

        local rarity =
            RARITY_ORDER[index]

        local weight =
            weights[rarity]

        local chance =
            weight /
            totalWeight *
            100


        table.insert(
            debugParts,
            rarity ..
            "=" ..
            string.format(
                "%.1f%%",
                chance
            )
        )

    end


    ULF_Debug.Print(
        "[LOOT RARITY] Threat=" ..
        string.format(
            "%.2f",
            threatScore
        ) ..
        " / Pressure=" ..
        string.format(
            "%.2f",
            pressure
        ) ..
        " / Max=" ..
        tostring(maxRarity) ..
        " | " ..
        table.concat(
            debugParts,
            " "
        )
    )


    -- ========================================================
    -- RANDOM ROLL
    -- ========================================================

    local roll =
        math.random() *
        totalWeight

    local accumulated = 0


    for index = 1, maxIndex do

        local rarity =
            RARITY_ORDER[index]

        local weight =
            weights[rarity]


        accumulated =
            accumulated +
            weight


        if roll <= accumulated then

            ULF_Debug.Print(
                "[LOOT RARITY] Result=" ..
                tostring(rarity)
            )

            return rarity

        end

    end


    return nil

end