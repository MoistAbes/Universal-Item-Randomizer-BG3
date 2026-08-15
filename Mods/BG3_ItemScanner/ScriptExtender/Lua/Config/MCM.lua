-- ============================================================
-- Universal Item Randomizer
-- MCM Integration
-- ============================================================

ULF_MCM = {}


-- ============================================================
-- APPLY CURRENT MCM VALUES
-- ============================================================

function ULF_MCM.ApplySettings()

    if not MCM then
        print("[ULF][MCM] MCM API not available")
        return false
    end


    -- --------------------------------------------------------
    -- MOD SETTINGS
    -- --------------------------------------------------------

    local enabled = MCM.Get("Enabled")

    if enabled ~= nil then
        ULF_ModSettings.Enabled = enabled
    end


    local debug = MCM.Get("Debug")

    if debug ~= nil then
        ULF_ModSettings.Debug = debug
    end


    -- --------------------------------------------------------
    -- LOOT CONFIG
    -- --------------------------------------------------------

    local baseDropChance = MCM.Get("BaseDropChance")

    if baseDropChance ~= nil then
        ULF_LootConfig.BaseDropChance = baseDropChance
    end


    print(
        "[ULF][MCM] Settings applied"
    )

    print(
        "[ULF][MCM] Enabled = "
        .. tostring(ULF_ModSettings.Enabled)
    )

    print(
        "[ULF][MCM] Debug = "
        .. tostring(ULF_ModSettings.Debug)
    )

    print(
        "[ULF][MCM] BaseDropChance = "
        .. tostring(ULF_LootConfig.BaseDropChance)
    )

    return true
end


-- ============================================================
-- MCM SETTING CHANGED
-- ============================================================

function ULF_MCM.OnSettingSaved(payload)

    if not payload then
        return
    end

    if payload.modUUID ~= ModuleUUID then
        return
    end

    if not payload.settingId then
        return
    end


    print(
        "[ULF][MCM] Setting saved: "
        .. tostring(payload.settingId)
        .. " = "
        .. tostring(payload.value)
    )


    if payload.settingId == "Enabled" then

        ULF_ModSettings.Enabled = payload.value

    elseif payload.settingId == "Debug" then

        ULF_ModSettings.Debug = payload.value

    elseif payload.settingId == "BaseDropChance" then

        ULF_LootConfig.BaseDropChance = payload.value

    end

end


-- ============================================================
-- INITIALIZATION
-- ============================================================

if Ext.ModEvents
    and Ext.ModEvents.BG3MCM
    and Ext.ModEvents.BG3MCM["MCM_Setting_Saved"] then

    Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(
        ULF_MCM.OnSettingSaved
    )

    print(
        "[ULF][MCM] MCM_Setting_Saved listener registered"
    )

else

    print(
        "[ULF][MCM] WARNING: MCM event API not available"
    )

end

function ULF_MCM.Refresh()
    print("[ULF][MCM] Enabled from MCM = " .. tostring(MCM.Get("Enabled")))
end

Ext.ModEvents.BG3MCM["MCM_Setting_Saved"]:Subscribe(function(payload)

    print(
        "[ULF][MCM] EVENT:"
        .. " modUUID=" .. tostring(payload.modUUID)
        .. " settingId=" .. tostring(payload.settingId)
        .. " value=" .. tostring(payload.value)
    )

end)


print(
    "[ULF][MCM] MCM integration loaded"
)