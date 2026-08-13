ULF_LootConfig = {

    -- ========================================================
    -- SOURCES
    -- ========================================================

    EnemyLootEnabled = true,

    -- Reserved for future version.
    -- Container loot will NOT be implemented in V1.
    ContainerLootEnabled = false,


    -- ========================================================
    -- DROP CHANCE
    -- ========================================================

    -- V1 starts simple.
    -- This will be refined when LootGenerator is implemented.

    BaseDropChance = 0.7,

    -- ========================================================
    -- RARITY
    -- ========================================================

    -- These are intentionally conservative V1 values.
    --
    -- IMPORTANT:
    -- Legendary items are NOT currently allowed to appear
    -- from every enemy.
    --
    -- LootGenerator will later apply level/tier restrictions
    -- before using these weights.

    RarityWeights = {

        Common = 60,

        Uncommon = 25,

        Rare = 10,

        VeryRare = 4,

        Legendary = 1

    },

    -- ============================================================
    -- ITEM CATEGORIES
    -- ============================================================

    AllowedCategories = {
        Weapon = true,
        Armor = true,
        Accessory = true,
        Consumable = true,
        Scroll = true,
        Food = false,

        Book = false,
        Material = false,
        Other = false,
        Grenade = false
    },

    RelativeLevelModifiers = {
        [-5] = -0.30,
        [-4] = -0.25,
        [-3] = -0.20,
        [-2] = -0.15,
        [-1] = -0.05,
        [0]  =  0.00,
        [1]  =  0.05,
        [2]  =  0.10,
        [3]  =  0.15,
        [4]  =  0.20,
        [5]  =  0.25
    },

}


print(
    "[ULF][LOOT] Configuration loaded"
)
