print("[ULF] EnemyProfile.lua LOADED")

ULF_EnemyProfile = {}

-- ============================================================
-- BUILD ENEMY PROFILE
-- ============================================================

function ULF_EnemyProfile.Build(entity)

    if not entity then
        print("[ULF][ENEMY] ERROR: Entity is nil")
        return nil
    end

    -- Cache all components once.
    local components = entity:GetAllComponents()


    -- ========================================================
    -- UUID
    -- ========================================================

    local entityUuid = nil

    if components.Uuid then
        entityUuid =
            components.Uuid.EntityUuid
    end

    -- ========================================================
    -- AI ARCHETYPE
    -- ========================================================

    local archetype = nil

    if entity.ServerAiArchetype then

        archetype =
            entity.ServerAiArchetype.BaseArchetype

    end


    -- ========================================================
    -- CLASS LEVEL
    -- ========================================================

    local classLevel = nil

    if entity.Classes and entity.Classes.Classes then

        for _, classInfo in ipairs(entity.Classes.Classes) do

            if classInfo then

                classLevel =
                    classInfo.Level

                break

            end

        end

    end


-- ========================================================
-- ITEMS
-- ========================================================

    local items = {}

    if entity.InventoryOwner
        and entity.InventoryOwner.Inventories
    then

        for _, inventoryHandle in ipairs(
            entity.InventoryOwner.Inventories
        ) do

            local inventoryEntity =
                Ext.Entity.Get(inventoryHandle)

            if inventoryEntity
                and inventoryEntity.InventoryContainer
                and inventoryEntity.InventoryContainer.Items
            then

                for _, slotData in pairs(
                    inventoryEntity.InventoryContainer.Items
                ) do

                    if slotData and slotData.Item then

                        local itemEntity =
                            Ext.Entity.Get(slotData.Item)

                        if itemEntity then

                            local itemType = nil
                            local equipped = false
                            local rarity = 0


                            -- ====================================
                            -- ITEM TYPE
                            -- ====================================

                            if itemEntity.Weapon then

                                itemType = "Weapon"

                            elseif itemEntity.Equipable
                                and itemEntity.Equipable.Slot == "Ring"
                            then

                                itemType = "Ring"

                            elseif itemEntity.Equipable
                                and itemEntity.Equipable.Slot == "Amulet"
                            then

                                itemType = "Amulet"

                            elseif itemEntity.Armor then

                                if itemEntity.Armor.Shield then
                                    itemType = "Shield"
                                else
                                    itemType = "Armor"
                                end

                            end


                            -- ====================================
                            -- EQUIPPED
                            -- ====================================

                            if itemEntity.Wielding
                                and itemEntity.Wielding.Owner
                            then

                                equipped =
                                    itemEntity.Wielding.Owner == entity

                            end

                            -- ====================================
                            -- RARITY
                            -- ====================================

                            if itemEntity.Value
                                and itemEntity.Value.Rarity ~= nil
                            then

                                rarity =
                                    itemEntity.Value.Rarity

                            end


                            -- ====================================
                            -- ADD ONLY SUPPORTED TYPES
                            -- ====================================

                            if itemType then

                                table.insert(
                                    items,
                                    {
                                        Type = itemType,
                                        Equipped = equipped,
                                        Rarity = rarity
                                    }
                                )

                            end

                        end

                    end

                end

            end

        end

    end


    -- ========================================================
    -- PROFILE
    -- ========================================================

    return {

        EntityUuid = entityUuid,

        Class = {
            Level = classLevel
        },

        Archetype = archetype,

        ClassLevel = classLevel,

        Items = items

    }

end

-- ============================================================
-- DEBUG PRINT
-- ============================================================

function ULF_EnemyProfile.DebugPrint(profile)

    if not profile then
        print("[ULF][ENEMY-PROFILE] ERROR: Profile is nil")
        return
    end

    print("[ULF][ENEMY-PROFILE] ========================================")
    print("[ULF][ENEMY-PROFILE] ENEMY PROFILE")
    print("[ULF][ENEMY-PROFILE] ========================================")

    -- ========================================================
    -- IDENTITY
    -- ========================================================

    print("[ULF][ENEMY-PROFILE] [IDENTITY]")

    print(
        "  Entity UUID:  " ..
        tostring(profile.EntityUuid)
    )

    -- ========================================================
    -- CLASS
    -- ========================================================

    print("[ULF][ENEMY-PROFILE] [CLASS]")

    local classLevel = nil

    if profile.Class then
        classLevel = profile.Class.Level
    end

    print(
        "  Class Level:   " ..
        tostring(classLevel or "-")
    )

    -- ========================================================
    -- ARCHETYPE
    -- ========================================================

    print("[ULF][ENEMY-PROFILE] [ARCHETYPE]")

    print(
        "  Archetype:     " ..
        tostring(profile.Archetype or "-")
    )

    -- ========================================================
    -- ITEMS
    -- ========================================================

    print("[ULF][ENEMY-PROFILE] [ITEMS]")

    local itemCount = 0

    if profile.Items then
        itemCount = #profile.Items
    end

    print(
        "  Items:         " ..
        tostring(itemCount)
    )

    if itemCount > 0 then

        for i, item in ipairs(profile.Items) do

            print(
                "  [" .. tostring(i) .. "] " ..
                "Type: " ..
                tostring(item.Type) ..
                " | Equipped: " ..
                tostring(item.Equipped) ..
                " | Rarity: " ..
                tostring(item.Rarity)
            )

        end

    end

    print("[ULF][ENEMY-PROFILE] ========================================")
    print("[ULF][ENEMY-PROFILE] END PROFILE")
    print("[ULF][ENEMY-PROFILE] ========================================")

end
