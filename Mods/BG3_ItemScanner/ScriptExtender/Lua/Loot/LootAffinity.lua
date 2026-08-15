print("[ULF] LootAffinity.lua LOADED")

ULF_LootAffinity = {}

local DEFAULT_RANDOM_WEIGHT = 100
local ARCHETYPE_WEIGHT = 70
local EQUIPPED_WEIGHT = 30

local function ResolveArchetypeAffinities(archetype)

    local result = {}

    if string.find(archetype, "melee", 1, true) then
        table.insert(result, "Melee")
    end

    if string.find(archetype, "ranged", 1, true) then
        table.insert(result, "Ranged")
    end

    if string.find(archetype, "mage", 1, true)
        or string.find(archetype, "magic", 1, true)
    then
        table.insert(result, "Magic")
    end

    if string.find(archetype, "rogue", 1, true) then
        table.insert(result, "Rogue")
    end

    return result
end

function ULF_LootAffinity.Calculate(
    lootContext
)

    local affinities = {
        Random = DEFAULT_RANDOM_WEIGHT
    }

    if not lootContext
        or not lootContext.Enemy
    then
        return affinities
    end

    local enemyContext =
        lootContext.Enemy


    -- ========================================================
    -- ARCHETYPE
    -- ========================================================

    if enemyContext.Archetype then

        local archetypeAffinities =
            ResolveArchetypeAffinities(
                enemyContext.Archetype
            )

        for _, affinityType in ipairs(
            archetypeAffinities
        ) do

            affinities[affinityType] =
                (affinities[affinityType] or 0) +
                ARCHETYPE_WEIGHT

        end

    end

    -- ========================================================
    -- EQUIPPED ITEMS
    -- ========================================================

    if enemyContext.Items then

        for _, enemyItem in ipairs(
            enemyContext.Items
        ) do

            if enemyItem.Equipped then

                if enemyItem.Slot == "MeleeMainHand" then

                    affinities.Melee =
                        (affinities.Melee or 0) +
                        EQUIPPED_WEIGHT

                elseif enemyItem.Slot == "RangedMainHand" then

                    affinities.Ranged =
                        (affinities.Ranged or 0) +
                        EQUIPPED_WEIGHT

                end

            end

        end

    end

        -- ========================================================
    -- DEBUG
    -- ========================================================

    print("[ULF][AFFINITY] Calculated affinities:")

    for affinityType, weight in pairs(affinities) do

        print(
            "  " ..
            tostring(affinityType) ..
            " | Weight: " ..
            tostring(weight)
        )

    end


    return affinities

end

function ULF_LootAffinity.ResolveAffinity(affinities)

    local totalWeight = 0

    for _, weight in pairs(affinities) do
        totalWeight =
            totalWeight + weight
    end

    print(
        "[ULF][AFFINITY] Total weight: " ..
        tostring(totalWeight)
    )

    if totalWeight <= 0 then
        print(
            "[ULF][AFFINITY] Invalid total weight -> Random"
        )
        return "Random"
    end

    local roll =
        math.random() * totalWeight

    print(
        "[ULF][AFFINITY] Roll: " ..
        tostring(roll)
    )

    local cumulative = 0

    for affinityType, weight in pairs(affinities) do

        cumulative =
            cumulative + weight

        if roll <= cumulative then

            print(
                "[ULF][AFFINITY] Selected: " ..
                tostring(affinityType)
            )

            return affinityType
        end

    end

    print(
        "[ULF][AFFINITY] Roll failed -> Random"
    )

    return "Random"

end

local function Contains(list, value)

    if not list then
        return false
    end

    for _, entry in ipairs(list) do

        if entry == value then
            return true
        end

    end

    return false
end


function ULF_LootAffinity.HasAffinity(
    itemRecord,
    affinity
)

    if not itemRecord
        or not affinity
    then
        return false
    end


    -- ========================================================
    -- MELEE
    -- ========================================================

    if affinity == "Melee" then

        return Contains(
            itemRecord.WeaponProperties,
            "Melee"
        )

    end


    -- ========================================================
    -- RANGED
    -- ========================================================

    if affinity == "Ranged" then

        if itemRecord.Category ~= "Weapon" then
            return false
        end

        return itemRecord.Slot ==
            "Ranged Main Weapon"

    end


    -- ========================================================
    -- MAGIC
    -- ========================================================

    if affinity == "Magic" then

        if Contains(
            itemRecord.WeaponProperties,
            "Magical"
        ) then
            return true
        end

        -- Scrolls are inherently magical loot
        if itemRecord.Category == "Scroll" then
            return true
        end

        return false

    end


    -- ========================================================
    -- DEFENSIVE
    -- ========================================================

    if affinity == "Defensive" then

        return itemRecord.Category == "Armor"

    end


    return false

end


print(
    "[ULF][LOOT] Loot Affinity API exported"
)