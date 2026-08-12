print("[ULF] DatabaseCache.lua LOADED")

ULF_DatabaseCache = {}

ULF_DatabaseCache.VERSION = 1
ULF_DatabaseCache.FILE_NAME = "ULF_ItemDatabase.json"

-- ============================================================
-- SAVE
-- ============================================================

function ULF_DatabaseCache.Save(database)

    print("[ULF][CACHE] Saving database...")

    if not database then
        print("[ULF][CACHE] ERROR: database is nil")
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
        print("[ULF][CACHE] ERROR: JSON serialization failed")
        print("[ULF][CACHE] " .. tostring(json))
        return false
    end

    local saveOk, saveResult = pcall(function()

        return Ext.IO.SaveFile(
            ULF_DatabaseCache.FILE_NAME,
            json
        )

    end)

    if not saveOk then
        print("[ULF][CACHE] ERROR: SaveFile failed")
        print("[ULF][CACHE] " .. tostring(saveResult))
        return false
    end

    print("[ULF][CACHE] Database saved successfully")

    return true
end


-- ============================================================
-- LOAD
-- ============================================================

function ULF_DatabaseCache.Load()

    print("[ULF][CACHE] Loading database...")

    local ok, content = pcall(function()

        return Ext.IO.LoadFile(
            ULF_DatabaseCache.FILE_NAME
        )

    end)

    if not ok then

        print("[ULF][CACHE] ERROR: LoadFile failed")
        print("[ULF][CACHE] " .. tostring(content))

        return nil
    end

    if not content then

        print("[ULF][CACHE] No cache file found")

        return nil
    end


    local jsonOk, data = pcall(function()

        return Ext.Json.Parse(content)

    end)

    if not jsonOk then

        print("[ULF][CACHE] ERROR: JSON parsing failed")
        print("[ULF][CACHE] " .. tostring(data))

        return nil
    end

    if not data then

        print("[ULF][CACHE] ERROR: Parsed cache is nil")

        return nil
    end


    -- ========================================================
    -- VERSION
    -- ========================================================

    if data.Version ~= ULF_DatabaseCache.VERSION then

        print(
            "[ULF][CACHE] Version mismatch: " ..
            tostring(data.Version) ..
            " != " ..
            tostring(ULF_DatabaseCache.VERSION)
        )

        return nil
    end


    if not data.Items then

        print(
            "[ULF][CACHE] ERROR: Cache contains no Items"
        )

        return nil
    end


    print(
        "[ULF][CACHE] Database loaded successfully"
    )


    return {
        Meta = data.Meta or {},

        Items = data.Items
    }
end