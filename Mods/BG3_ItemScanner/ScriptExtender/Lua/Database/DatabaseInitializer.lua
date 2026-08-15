ULF_DatabaseInitializer = {}

function ULF_DatabaseInitializer.Initialize()

    ULF_Database.Ready = false

    ULF_Debug.Print("Initializing item database")

    -- ========================================================
    -- TRY LOAD CACHE
    -- ========================================================

    local cachedDatabase =
        ULF_DatabaseCache.Load()

    if cachedDatabase then

        ULF_Debug.Print("Loading item database from cache")

        ULF_Database.Meta =
            cachedDatabase.Meta or {}

        ULF_Database.Items =
            cachedDatabase.Items or {}

        ULF_Database.Indexes =
            ULF_DatabaseIndex.Build(
                ULF_Database
            )

        ULF_Debug.Print(
            " Database loaded from cache: " ..
            tostring(
                ULF_Database.Meta.ItemCount
            ) ..
            " items"
        )

        ULF_Database.Ready = true

        return true
    end

    -- ========================================================
    -- NO CACHE
    -- ========================================================

    ULF_Debug.Print(
        " Database cache not available"
    )

    ULF_Debug.Print(
        " Starting full item scan..."
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

        ULF_Debug.Error(
            " Item scan returned nil"
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

        ULF_Debug.Print(
            " Item database cached successfully"
        )

    else

        ULF_Debug.Warn(
            " Failed to cache item database"
        )

    end

    ULF_Database.Ready = true

    return true
end

return ULF_DatabaseInitializer