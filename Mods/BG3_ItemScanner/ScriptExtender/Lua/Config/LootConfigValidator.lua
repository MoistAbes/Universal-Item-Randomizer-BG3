-- ============================================================
-- LOOT CONFIG VALIDATOR
-- ============================================================

ULF_LootConfigValidator = {}

local CATEGORY_ORDER =
    ULF_LootDefinitions.Categories

-- ============================================================
-- RARITY ORDER
-- ============================================================

local RARITY_ORDER =
    ULF_LootDefinitions.Rarities

-- ============================================================
-- VALIDATE RARITY WEIGHTS
-- ============================================================

function ULF_LootConfigValidator.ValidateRarityWeights(
    rarityWeights
)

    if type(rarityWeights) ~= "table" then
        ULF_Debug.Error("[CONFIG] ERROR: RarityWeights must be a table")
        return false
    end


    local total = 0


    for _, rarity in ipairs(RARITY_ORDER) do

        local weight =
            rarityWeights[rarity]


        if weight == nil then
            ULF_Debug.Error("[CONFIG] Missing rarity weight: " + rarity)
            return false
        end


        if type(weight) ~= "number"
            or weight % 1 ~= 0 then

            ULF_Debug.Error("[CONFIG] Rarity weight must be an integert: " + rarity)
            return false
        end


        if weight < 0
            or weight > 100 then

            ULF_Debug.Error("[CONFIG] Rarity weight out of range: " + rarity)
            return false
        end


        total =
            total + weight

    end


    if total ~= 100 then
        ULF_Debug.Error("[CONFIG] Rarity weights must total 100. Total: " + tostring(total))
        return false
    end

    return true

end

function ULF_LootConfigValidator.ValidateBaseDropChance(chance)

    if type(chance) ~= "number" then
        ULF_Debug.Error("[CONFIG] BaseDropChance must be a number")
        return false
    end


    if chance < 0
        or chance > 1 then

        ULF_Debug.Error("[CONFIG] BaseDropChance must be between 0 and 1")
        return false
    end

    return true

end

function ULF_LootConfigValidator.ValidateAllowedCategories(allowedCategories)

    if type(allowedCategories) ~= "table" then

        ULF_Debug.Error("[CONFIG] AllowedCategories must be a table")
        return false
    end


    for _, category in ipairs(CATEGORY_ORDER) do

        local enabled =
            allowedCategories[category]


        if enabled == nil then

            ULF_Debug.Error("[CONFIG] Missing category: " + category)
            return false
        end


        if type(enabled) ~= "boolean" then

            ULF_Debug.Error("[CONFIG] Category value must be boolean: " + category)
            return false
        end

    end


    for category, _ in pairs(allowedCategories) do

        local known = false

        for _, knownCategory in ipairs(CATEGORY_ORDER) do

            if category == knownCategory then

                known = true
                break

            end

        end

        if not known then

            ULF_Debug.Error("[CONFIG] Unknown category: " + tostring(category))
            return false
        end

    end


    return true

end

-- ============================================================
-- VALIDATE CONFIGURATION
-- ============================================================

function ULF_LootConfigValidator.Validate()

    if not ULF_LootConfigValidator.ValidateRarityWeights(
        ULF_LootConfig.RarityWeights
    ) then

        return false
    end

    if not ULF_LootConfigValidator.ValidateBaseDropChance(
        ULF_LootConfig.BaseDropChance
    ) then

        return false
    end

    if not ULF_LootConfigValidator.ValidateAllowedCategories(
        ULF_LootConfig.AllowedCategories
    ) then

        return false
    end


    return true

end