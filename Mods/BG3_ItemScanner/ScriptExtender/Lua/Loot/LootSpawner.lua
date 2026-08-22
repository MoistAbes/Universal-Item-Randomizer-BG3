ULF_LootSpawner = {}

-- ============================================================
-- INTERNAL: ADD ITEM TO ENTITY
-- ============================================================

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

        ULF_Debug.Print(
            "[LOOT SPAWNER] TemplateAddTo failed: " ..
            tostring(result)
        )

        return false
    end

    return true

end

-- ============================================================
-- INTERNAL: RESOLVE ITEM ROOT TEMPLATE
-- ============================================================

local function GetItemRootTemplate(queryResult)

    if not queryResult then
        return nil
    end

    if not queryResult.Record then
        return nil
    end

    local rootTemplate =
        queryResult.Record.RootTemplate

    if not rootTemplate
        or rootTemplate == "" then

        return nil
    end

    return rootTemplate

end


-- ============================================================
-- SPAWN / ADD ITEM TO ENTITY
-- ============================================================

function ULF_LootSpawner.AddItem(
    victim,
    queryResult
)

    if not victim then

        ULF_Debug.Error(
            "[LOOT SPAWNER] Victim is nil"
        )

        return false
    end


    if not queryResult then

        ULF_Debug.Error(
            "[LOOT SPAWNER] Query result is nil"
        )

        return false
    end


    local rootTemplate =
        GetItemRootTemplate(
            queryResult
        )


    if not rootTemplate then

        ULF_Debug.Error(
            "[LOOT SPAWNER] RootTemplate could not be resolved: " ..
            tostring(
                queryResult.Stat
                    and queryResult.Stat.Stat
            )
        )

        return false
    end


    local success =
        AddItemToEntity(
            victim,
            rootTemplate,
            1
        )


    if success then

        ULF_Debug.Print(
            "[LOOT SPAWNER] Added: " ..
            tostring(
                queryResult.Stat
                    and queryResult.Stat.Stat
            ) ..
            " -> " ..
            tostring(
                queryResult.Record
                    and queryResult.Record.DisplayName
            )
        )

        return true

    end


    ULF_Debug.Error(
        "[LOOT SPAWNER] Failed to add item: " ..
        tostring(
            queryResult.Stat
                and queryResult.Stat.Stat
        )
    )

    return false

end