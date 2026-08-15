ULF_LootRarityResolver = {}

-- ============================================================
-- RARITY ORDER
-- ============================================================

local RARITY_ORDER =
    ULF_LootDefinitions.Rarities

-- ============================================================
-- RESOLVE RANDOM RARITY
-- ============================================================

function ULF_LootRarityResolver.Resolve(maxRarity)

    if not maxRarity then
        return nil
    end


    local maxIndex = nil

    for index, rarity in ipairs(RARITY_ORDER) do

        if rarity == maxRarity then
            maxIndex = index
            break
        end

    end


    if not maxIndex then
        return nil
    end


    local totalWeight = 0

    for index = 1, maxIndex do

        local rarity =
            RARITY_ORDER[index]

        local weight =
            ULF_LootConfig.RarityWeights[rarity]

        totalWeight =
            totalWeight + weight

    end


    if totalWeight <= 0 then
        return nil
    end


    local roll =
        math.random() * totalWeight

    local accumulated = 0

    for index = 1, maxIndex do

        local rarity =
            RARITY_ORDER[index]

        local weight =
            ULF_LootConfig.RarityWeights[rarity]

        accumulated =
            accumulated + weight


        if roll <= accumulated then
            return rarity
        end

    end

    return nil

end