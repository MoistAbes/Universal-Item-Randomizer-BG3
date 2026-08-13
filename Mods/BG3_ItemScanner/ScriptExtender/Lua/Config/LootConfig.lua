ULF_LootConfig = {

    -- Bonus loot is added to vanilla loot.
    -- We do NOT remove or replace vanilla loot in V1.
    PreserveVanillaLoot = true,


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

    BaseDropChance = 0.35,


    -- ========================================================
    -- DROP COUNT
    -- ========================================================

    MinDrops = 1,

    MaxDrops = 5,


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

}


print(
    "[ULF][LOOT] Configuration loaded"
)
