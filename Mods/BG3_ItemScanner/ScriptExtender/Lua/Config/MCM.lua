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
        ULF_Debug.Error("[MCM] MCM API not available")
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

    -- --------------------------------------------------------
    -- LOG
    -- --------------------------------------------------------

    ULF_Debug.Print("[MCM] Settings applied")


    ULF_Debug.Print(
        "[MCM] Enabled = "
        .. tostring(ULF_ModSettings.Enabled)
    )

    ULF_Debug.Print(
        "[MCM] Debug = "
        .. tostring(ULF_ModSettings.Debug)
    )

    ULF_Debug.Print(
        "[MCM] BaseDropChance = "
        .. tostring(ULF_LootConfig.BaseDropChance)
    )

    ULF_Debug.Print(
        "[MCM] RarityWeights = "
        .. tostring(ULF_LootConfig.RarityWeights.Common)
        .. "/"
        .. tostring(ULF_LootConfig.RarityWeights.Uncommon)
        .. "/"
        .. tostring(ULF_LootConfig.RarityWeights.Rare)
        .. "/"
        .. tostring(ULF_LootConfig.RarityWeights.VeryRare)
        .. "/"
        .. tostring(ULF_LootConfig.RarityWeights.Legendary)
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

    ULF_Debug.Print(
        "[MCM] Setting saved: "
        .. tostring(payload.settingId)
        .. " = "
        .. tostring(payload.value)
    )


    -- --------------------------------------------------------
    -- MOD SETTINGS
    -- --------------------------------------------------------

    if payload.settingId == "Enabled" then

        ULF_ModSettings.Enabled = payload.value

        ULF_Debug.Print(
            "[MCM] Runtime Enabled = "
            .. tostring(ULF_ModSettings.Enabled)
        )

        return
    end


    if payload.settingId == "Debug" then

        ULF_ModSettings.Debug = payload.value

        ULF_Debug.Print(
            "[MCM] Runtime Debug = "
            .. tostring(ULF_ModSettings.Debug)
        )

        return
    end


    -- --------------------------------------------------------
    -- LOOT CONFIG
    -- --------------------------------------------------------

    if payload.settingId == "BaseDropChance" then

        ULF_LootConfig.BaseDropChance = payload.value

        ULF_Debug.Print(
            "[MCM] Runtime BaseDropChance = "
            .. tostring(ULF_LootConfig.BaseDropChance)
        )

        return
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

    ULF_Debug.Print(
        "[ULF][MCM] MCM_Setting_Saved listener registered"
    )

else

    ULF_Debug.Print(
        "[ULF][MCM] WARNING: MCM event API not available"
    )

end


ULF_Debug.Print(
    "[ULF][MCM] MCM integration loaded"
)