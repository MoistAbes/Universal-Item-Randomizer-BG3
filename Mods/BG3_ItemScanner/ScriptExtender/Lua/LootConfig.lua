print("[ULF] LootConfig.lua LOADED")

ULF_LootConfig = {

    -- ========================================================
    -- SYSTEM
    -- ========================================================

    Enabled = true,

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

    BaseDropChance = 0.20,


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


    -- ========================================================
    -- DEBUG
    -- ========================================================

    Debug = true

}


print(
    "[ULF][LOOT] Configuration loaded"
)
