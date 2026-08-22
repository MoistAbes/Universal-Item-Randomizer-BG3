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

    ThreatForGuaranteedDrop = 150,

    -- ========================================================
    -- RARITY
    -- ========================================================

    RarityWeights = {

        Common = 60,

        Uncommon = 25,

        Rare = 10,

        VeryRare = 0.1,

        Legendary = 0.01

    },


    RarityThreatShift = {

        Common = -20,

        Uncommon = -8,

        Rare = 6,

        VeryRare = 0.3,

        Legendary = 0.05

    },


    RarityThreatPressure = {
        { Threshold = 0,   Pressure = 0.00 },
        { Threshold = 50,  Pressure = 0.05 },
        { Threshold = 100, Pressure = 0.15 },
        { Threshold = 150, Pressure = 0.30 },
        { Threshold = 200, Pressure = 0.50 },
        { Threshold = 250, Pressure = 0.70 },
        { Threshold = 300, Pressure = 0.85 },
        { Threshold = 400, Pressure = 1.00 },
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


    -- ========================================================
    -- DROP COUNT
    -- ========================================================

    DropCountByLevel = {
        { MaxLevel = 2, Count = 2 },
        { MaxLevel = 4, Count = 3 },
        { MaxLevel = 6, Count = 4 },
        { MaxLevel = 8, Count = 5 },
        { MaxLevel = math.huge, Count = 6 },
    },

    DropCountThreatThresholds = {
        { Threshold = 100, Bonus = 1 },
        { Threshold = 150, Bonus = 1 },
        { Threshold = 200, Bonus = 1 },
        { Threshold = 250, Bonus = 1 },
    },


    MaxRarityByLevel = {
        { MaxLevel = 2, Rarity = "Uncommon" },
        { MaxLevel = 4, Rarity = "Rare" },
        { MaxLevel = 6, Rarity = "VeryRare" },
        { MaxLevel = math.huge, Rarity = "Legendary" },
    },

    MaxRarityThreatThresholds = {
        { Threshold = 100, Bonus = 1 },
        { Threshold = 150, Bonus = 1 },
        { Threshold = 200, Bonus = 1 },
    },

}


print(
    "[ULF][LOOT] Configuration loaded"
)
