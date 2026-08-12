ULF_DatabaseInitializer = {}

function ULF_DatabaseInitializer.Initialize()

    print("[ULF] Initializing item database")

    -- ========================================================
    -- TRY LOAD CACHE
    -- ========================================================

    local cachedDatabase =
        ULF_DatabaseCache.Load()

    if cachedDatabase then

        print("[ULF] Loading item database from cache")

        ULF_Database.Meta =
            cachedDatabase.Meta or {}

        ULF_Database.Items =
            cachedDatabase.Items or {}

        ULF_Database.Indexes =
            ULF_DatabaseIndex.Build(
                ULF_Database
            )

        print(
            "[ULF] Database loaded from cache: " ..
            tostring(
                ULF_Database.Meta.ItemCount
            ) ..
            " items"
        )

        return true
    end

    -- ========================================================
    -- NO CACHE
    -- ========================================================

    print(
        "[ULF] Database cache not available"
    )

    print(
        "[ULF] Starting full item scan..."
    )

    -- ========================================================
    -- RESET DATABASE
    -- ========================================================

    ULF_Database.Meta = {

        CacheVersion = 2,

        SchemaVersion = 1,

        ItemCount = 0
    }

    ULF_Database.Items = {}

    ULF_Database.Indexes = {}

    -- ========================================================
    -- FULL SCAN
    -- ========================================================

    local scanResult =
        ULF_ItemScanner.Scan()

    if not scanResult then

        print(
            "[ULF] ERROR: Item scan returned nil"
        )

        return false
    end

    ULF_Database.Items =
        scanResult.Items or {}

    ULF_Database.Meta.ItemCount =
        scanResult.ItemCount or 0

    -- ========================================================
    -- BUILD INDEXES
    -- ========================================================

    ULF_Database.Indexes =
        ULF_DatabaseIndex.Build(
            ULF_Database
        )

    -- ========================================================
    -- SAVE CACHE
    -- ========================================================

    local saved =
        ULF_DatabaseCache.Save(
            ULF_Database
        )

    if saved then

        print(
            "[ULF] Item database cached successfully"
        )

    else

        print(
            "[ULF] WARNING: Failed to cache item database"
        )

    end

    return true
end

return ULF_DatabaseInitializer