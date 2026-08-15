-- ============================================================
-- Universal Item Randomizer
-- Debug Logger
-- ============================================================

ULF_Debug = {}


-- ============================================================
-- INTERNAL
-- ============================================================

local function IsDebugEnabled()

    return ULF_ModSettings
        and ULF_ModSettings.Debug == true
end


local function FormatMessage(message)

    return "[ULF] " .. tostring(message)
end


-- ============================================================
-- DEBUG
-- ============================================================

function ULF_Debug.Print(message)

    if not IsDebugEnabled() then
        return
    end

    print(
        FormatMessage(message)
    )
end


-- ============================================================
-- WARNING
-- ============================================================

function ULF_Debug.Warn(message)

    print(
        FormatMessage("WARNING: " .. tostring(message))
    )
end


-- ============================================================
-- ERROR
-- ============================================================

function ULF_Debug.Error(message)

    print(
        FormatMessage("ERROR: " .. tostring(message))
    )
end


-- ============================================================
-- STATUS
-- ============================================================

function ULF_Debug.Enabled()

    return IsDebugEnabled()
end


print(
    "[ULF] Debug logger loaded"
)