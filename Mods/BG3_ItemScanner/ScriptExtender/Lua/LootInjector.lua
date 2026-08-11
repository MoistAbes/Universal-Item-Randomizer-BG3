print("[ULF] LootInjector.lua LOADED")

local function GetRandomTestItems(count)
    local results = {}

    if not ULF_Database then
        print("[ULF][INJECTOR] ERROR: ULF_Database does not exist")
        return results
    end

    if not ULF_Database.Items then
        print("[ULF][INJECTOR] ERROR: ULF_Database.Items does not exist")
        return results
    end

    local candidates = {}

    for rootTemplate, record in pairs(ULF_Database.Items) do
        if record
            and record.RootTemplate
            and record.DisplayName
        then
            table.insert(candidates, {
                RootTemplate = rootTemplate,
                Record = record
            })
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

        local index = math.random(1, #candidates)
        local selected = table.remove(candidates, index)

        table.insert(results, selected)
    end

    return results
end

local function InjectTestLoot(victim)

    print("")
    print("[ULF][INJECTOR] ========================================")
    print("[ULF][INJECTOR] TEST LOOT INJECTION")
    print("[ULF][INJECTOR] ========================================")

    if not victim then
        print("[ULF][INJECTOR] ERROR: victim is nil")
        return
    end

    print(
        "[ULF][INJECTOR] Victim: " ..
        tostring(victim)
    )

    print(
        "[ULF][INJECTOR] ULF_Database type: " ..
        tostring(type(ULF_Database))
    )

    print(
        "[ULF][INJECTOR] ULF_Database.Items type: " ..
        tostring(type(ULF_Database.Items))
    )


    -- ========================================================
    -- GET KNOWN TEST ITEM
    -- ========================================================

    local stat = Ext.Stats.Get("WPN_Battleaxe")

    if not stat then

        print(
            "[ULF][INJECTOR] ERROR: WPN_Battleaxe stat not found"
        )

        return
    end


    local rootTemplate

    local ok, value = pcall(function()
        return stat.RootTemplate
    end)


    if not ok then

        print(
            "[ULF][INJECTOR] ERROR: Could not read RootTemplate"
        )

        return
    end


    rootTemplate = value


    if not rootTemplate
        or rootTemplate == "" then

        print(
            "[ULF][INJECTOR] ERROR: WPN_Battleaxe has no RootTemplate"
        )

        return
    end


    print(
        "[ULF][INJECTOR] Test item: WPN_Battleaxe"
    )

    print(
        "[ULF][INJECTOR] RootTemplate: " ..
        tostring(rootTemplate)
    )


    -- ========================================================
    -- ADD ITEM
    -- ========================================================

    print(
        "[ULF][INJECTOR] Calling Osi.TemplateAddTo..."
    )


    local success, result = pcall(function()

        return Osi.TemplateAddTo(
            rootTemplate,
            victim,
            1
        )

    end)


    if not success then

        print(
            "[ULF][INJECTOR] ERROR: TemplateAddTo failed"
        )

        print(
            "[ULF][INJECTOR] " ..
            tostring(result)
        )

        print(
            "[ULF][INJECTOR] ========================================"
        )

        return
    end


    print(
        "[ULF][INJECTOR] TemplateAddTo succeeded"
    )

    print(
        "[ULF][INJECTOR] Result: " ..
        tostring(result)
    )

    print(
        "[ULF][INJECTOR] Added 1x Battleaxe to victim"
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

        InjectTestLoot(victim)
    end
)