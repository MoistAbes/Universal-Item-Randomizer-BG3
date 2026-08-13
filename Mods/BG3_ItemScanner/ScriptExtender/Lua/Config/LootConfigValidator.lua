-- ============================================================
-- LOOT CONFIG VALIDATOR
-- ============================================================

ULF_LootConfigValidator = {}


-- ============================================================
-- RARITY ORDER
-- ============================================================

local RARITY_ORDER = {
    "Common",
    "Uncommon",
    "Rare",
    "VeryRare",
    "Legendary"
}


-- ============================================================
-- VALIDATE RARITY WEIGHTS
-- ============================================================

function ULF_LootConfigValidator.ValidateRarityWeights(
    rarityWeights
)

    if type(rarityWeights) ~= "table" then

        print(
            "[ULF][CONFIG] ERROR: RarityWeights must be a table"
        )

        return false
    end


    local total = 0


    for _, rarity in ipairs(RARITY_ORDER) do

        local weight =
            rarityWeights[rarity]


        if weight == nil then

            print(
                "[ULF][CONFIG] ERROR: Missing rarity weight: " ..
                rarity
            )

            return false
        end


        if type(weight) ~= "number"
            or weight % 1 ~= 0 then

            print(
                "[ULF][CONFIG] ERROR: Rarity weight must be an integer: " ..
                rarity
            )

            return false
        end


        if weight < 0
            or weight > 100 then

            print(
                "[ULF][CONFIG] ERROR: Rarity weight out of range: " ..
                rarity
            )

            return false
        end


        total =
            total + weight

    end


    if total ~= 100 then

        print(
            "[ULF][CONFIG] ERROR: Rarity weights must total 100. Total: " ..
            tostring(total)
        )

        return false
    end


    return true

end

function ULF_LootConfigValidator.ValidateBaseDropChance(
    chance
)

    if type(chance) ~= "number" then

        print(
            "[ULF][CONFIG] ERROR: BaseDropChance must be a number"
        )

        return false
    end


    if chance < 0
        or chance > 1 then

        print(
            "[ULF][CONFIG] ERROR: BaseDropChance must be between 0 and 1"
        )

        return false
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


    return true

end