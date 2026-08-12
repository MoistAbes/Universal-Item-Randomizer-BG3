print("[ULF] LootSpawner.lua LOADED")

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

        print(
            "[ULF][LOOT] TemplateAddTo failed: " ..
            tostring(result)
        )

        return false
    end

    return true

end

-- ============================================================
-- INTERNAL: RESOLVE ITEM ROOT TEMPLATE
-- ============================================================

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


-- ============================================================
-- SPAWN / ADD ITEM TO ENTITY
-- ============================================================

function ULF_LootSpawner.AddItem(victim, record)

    if not victim then

        print(
            "[ULF][LOOT] ERROR: Victim is nil"
        )

        return false
    end


    if not record then

        print(
            "[ULF][LOOT] ERROR: Item record is nil"
        )

        return false
    end


    local rootTemplate =
        GetItemRootTemplate(record)


    if not rootTemplate then

        print(
            "[ULF][LOOT] ERROR: RootTemplate could not be resolved"
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

        print(
            "[ULF][LOOT] Added: " ..
            tostring(record.Stat) ..
            " -> " ..
            tostring(record.DisplayName)
        )

        return true

    end


    print(
        "[ULF][LOOT] Failed to add item"
    )

    return false

end


print(
    "[ULF][LOOT] Spawner API exported"
)