print("[ULF] LootInjector.lua LOADED")

local function GetRandomItems(count)

    local results = {}

    if not ULF_Database
        or not ULF_Database.Items then

        print(
            "[ULF][INJECTOR] ERROR: Database unavailable"
        )

        return results
    end

    local candidates = {}

    for rootTemplate, record in pairs(ULF_Database.Items) do

        if record
            and record.Stat
            and record.DisplayName
            and record.RootTemplate then

            table.insert(
                candidates,
                record
            )

        end
    end

    print(
        "[ULF][INJECTOR] Database candidates: " ..
        tostring(#candidates)
    )

    for i = 1, count do

        if #candidates == 0 then
            break
        end

        local index =
            math.random(1, #candidates)

        local selected =
            table.remove(candidates, index)

        table.insert(
            results,
            selected
        )

    end

    return results
end

local function GetItemRootTemplate(record)

    if not record then
        return nil
    end

    if not record.RootTemplate
        or record.RootTemplate == "" then

        return nil
    end

    return record.RootTemplate
end

local function AddItemToEntity(victim, rootTemplate, amount)

    if not victim then
        return false
    end

    if not rootTemplate then
        return false
    end

    local success, result =
        pcall(function()

            return Osi.TemplateAddTo(
                rootTemplate,
                victim,
                amount
            )

        end)

    if not success then

        print(
            "[ULF][INJECTOR] TemplateAddTo failed: " ..
            tostring(result)
        )

        return false
    end

    return true
end

local function InjectLoot(victim, count)

    if not victim then

        print(
            "[ULF][INJECTOR] ERROR: victim is nil"
        )

        return
    end

    print("")
    print("[ULF][INJECTOR] ========================================")
    print("[ULF][INJECTOR] LOOT INJECTION")
    print("[ULF][INJECTOR] ========================================")

    print(
        "[ULF][INJECTOR] Victim: " ..
        tostring(victim)
    )

    local items =
        GetRandomItems(count)

    print(
        "[ULF][INJECTOR] Selected items: " ..
        tostring(#items)
    )

    local added = 0

    for _, record in ipairs(items) do

        local rootTemplate =
            GetItemRootTemplate(record)

        if rootTemplate then

            local success =
                AddItemToEntity(
                    victim,
                    rootTemplate,
                    1
                )

            if success then

                added = added + 1

                print(
                    "[ULF][INJECTOR] Added: " ..
                    tostring(record.Stat) ..
                    " -> " ..
                    tostring(record.DisplayName)
                )

            end

        end

    end

    print(
        "[ULF][INJECTOR] Successfully added: " ..
        tostring(added)
    )

    print(
        "[ULF][INJECTOR] ========================================"
    )
end

Ext.Osiris.RegisterListener(
    "Died",
    1,
    "after",
    function(victim)

        print(
            "[ULF][INJECTOR] Died event: " ..
            tostring(victim)
        )

        local entity =
            Ext.Entity.Get(victim)

        if not entity then
            print(
                "[ULF][INJECTOR] ERROR: Victim entity not found"
            )

            return
        end

        local enemyProfile =
            ULF_EnemyProfile.Build(entity)

        if not enemyProfile then
            print(
                "[ULF][INJECTOR] ERROR: Failed to build enemy profile"
            )

            return
        end

        -- Temporary research output

        print(
            "[ULF][INJECTOR] Enemy Profile:"
        )

        print(
            "  UUID: " ..
            tostring(enemyProfile.EntityUuid)
        )

        print(
            "  Template: " ..
            tostring(enemyProfile.OriginalTemplate)
        )

        print(
            "  Race: " ..
            tostring(enemyProfile.Race)
        )

        print(
            "  Level: " ..
            tostring(enemyProfile.Level)
        )

        -- Check if source can drop loot 

        local canGenerate =
        ULF_LootEligibility.CanGenerate(enemyProfile)

        print(
            "[ULF][LOOT] Eligibility: " ..
            tostring(canGenerate)
        )

        local dropCount =
        ULF_LootGenerator.GetDropCount(enemyProfile)

        print(
            "[ULF][LOOT] Drop count: " ..
            tostring(dropCount)
        )

        local maxRarity =
        ULF_LootTier.GetMaxRarity(enemyProfile)

        print(
            "[ULF][LOOT] Max rarity: " ..
            tostring(maxRarity)
        )

        local resolvedRarity =
        ULF_LootRarityResolver.Resolve(maxRarity)

        print(
            "[ULF][LOOT] Resolved rarity: " ..
            tostring(resolvedRarity)
        )

        local itemRecord =
        ULF_LootItemResolver.Resolve(resolvedRarity)

        if itemRecord then

            print(
                "[ULF][LOOT] Item resolved successfully"
            )

            print(
                "[ULF][LOOT] Item UUID: " ..
                tostring(itemRecord.RootTemplate)
            )

            local success =
                ULF_LootSpawner.AddItem(
                    victim,
                    itemRecord
                )

            print(
                "[ULF][LOOT] Spawn result: " ..
                tostring(success)
            )

            else

                print(
                    "[ULF][LOOT] Item resolution failed"
                )

            end

        -- Loot logic will come here later.

        -- InjectLoot(victim, 5)

    end
)