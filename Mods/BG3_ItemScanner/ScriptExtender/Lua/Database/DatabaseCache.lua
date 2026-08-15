ULF_DatabaseCache = {}

ULF_DatabaseCache.VERSION = 1
ULF_DatabaseCache.FILE_NAME = "ULF_ItemDatabase.json"

-- ============================================================
-- SAVE
-- ============================================================

function ULF_DatabaseCache.Save(database)

    ULF_Debug.Print("[CACHE] Saving database...")

    if not database then
        ULF_Debug.Error("[CACHE] database is nil")
        return false
    end

    local payload = {
        Version = ULF_DatabaseCache.VERSION,

        Meta = database.Meta,

        Items = database.Items
    }

    local ok, json = pcall(function()
        return Ext.Json.Stringify(payload)
    end)

    if not ok then
        ULF_Debug.Error("[CACHE] JSON serialization failed")
        ULF_Debug.Print("[CACHE] " .. tostring(json))
        return false
    end

    local saveOk, saveResult = pcall(function()

        return Ext.IO.SaveFile(
            ULF_DatabaseCache.FILE_NAME,
            json
        )

    end)

    if not saveOk then
        ULF_Debug.Error("[CACHE] SaveFile failed")
        ULF_Debug.Print("[CACHE] " .. tostring(saveResult))
        return false
    end

    ULF_Debug.Print("[CACHE] Database saved successfully")

    return true
end


-- ============================================================
-- LOAD
-- ============================================================

function ULF_DatabaseCache.Load()

    ULF_Debug.Print("[CACHE] Loading database...")

    local ok, content = pcall(function()

        return Ext.IO.LoadFile(
            ULF_DatabaseCache.FILE_NAME
        )

    end)

    if not ok then

        ULF_Debug.Error("[CACHE] LoadFile failed")
        ULF_Debug.Error("[CACHE] " .. tostring(content))

        return nil
    end

    if not content then

        ULF_Debug.Error("[CACHE] No cache file found")

        return nil
    end


    local jsonOk, data = pcall(function()

        return Ext.Json.Parse(content)

    end)

    if not jsonOk then

        ULF_Debug.Error("[CACHE] JSON parsing failed")
        ULF_Debug.Error("[CACHE] " .. tostring(data))

        return nil
    end

    if not data then

        ULF_Debug.Error("[CACHE] Parsed cache is nil")

        return nil
    end


    -- ========================================================
    -- VERSION
    -- ========================================================

    if data.Version ~= ULF_DatabaseCache.VERSION then

        ULF_Debug.Error(
            "[CACHE] Version mismatch: " ..
            tostring(data.Version) ..
            " != " ..
            tostring(ULF_DatabaseCache.VERSION)
        )

        return nil
    end


    if not data.Items then

        ULF_Debug.Error(
            "[CACHE] Cache contains no Items"
        )

        return nil
    end


    ULF_Debug.Print(
        "[CACHE] Database loaded successfully"
    )


    return {
        Meta = data.Meta or {},

        Items = data.Items
    }
end