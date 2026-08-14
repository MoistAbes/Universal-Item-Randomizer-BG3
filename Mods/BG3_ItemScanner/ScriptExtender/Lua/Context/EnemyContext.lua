print("[ULF] EnemyContext.lua LOADED")

ULF_EnemyContext = {}

-- ============================================================
-- BUILD ENEMY PROFILE
-- ============================================================

function ULF_EnemyContext.Build(entity)

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
                            local slot = nil

                            -- ====================================
                            -- ITEM TYPE / SLOT
                            -- ====================================

                            if itemEntity.Weapon then

                                itemType = "Weapon"

                                if itemEntity.Equipable then
                                    slot =
                                        itemEntity.Equipable.Slot
                                end

                            elseif itemEntity.Equipable
                                and itemEntity.Equipable.Slot == "Ring"
                            then

                                itemType = "Ring"
                                slot = "Ring"

                            elseif itemEntity.Equipable
                                and itemEntity.Equipable.Slot == "Amulet"
                            then

                                itemType = "Amulet"
                                slot = "Amulet"

                            elseif itemEntity.Armor then

                                if itemEntity.Armor.Shield then
                                    itemType = "Shield"
                                else
                                    itemType = "Armor"
                                end

                                if itemEntity.Equipable then
                                    slot =
                                        itemEntity.Equipable.Slot
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
                                        Slot = slot,
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

        Items = items

    }

end

-- ============================================================
-- DEBUG PRINT
-- ============================================================

function ULF_EnemyContext.DebugPrint(enemyContext)

    if not enemyContext then
        print("[ULF][ENEMY-PROFILE] ERROR: enemyContext is nil")
        return
    end

    print("[ULF][ENEMY-CONTEXT] ========================================")
    print("[ULF][ENEMY-CONTEXT] ENEMY CONTEXT")
    print("[ULF][ENEMY-CONTEXT] ========================================")

    -- ========================================================
    -- IDENTITY
    -- ========================================================

    print("[ULF][ENEMY-CONTEXT] [IDENTITY]")

    print(
        "  Entity UUID:  " ..
        tostring(enemyContext.EntityUuid)
    )

    -- ========================================================
    -- CLASS
    -- ========================================================

    print("[ULF][ENEMY-CONTEXT] [CLASS]")

    local classLevel = nil

    if enemyContext.Class then
        classLevel = enemyContext.Class.Level
    end

    print(
        "  Class Level:   " ..
        tostring(classLevel or "-")
    )

    -- ========================================================
    -- ARCHETYPE
    -- ========================================================

    print("[ULF][ENEMY-CONTEXT] [ARCHETYPE]")

    print(
        "  Archetype:     " ..
        tostring(enemyContext.Archetype or "-")
    )

    -- ========================================================
    -- ITEMS
    -- ========================================================

    print("[ULF][ENEMY-CONTEXT] [ITEMS]")

    local itemCount = 0

    if enemyContext.Items then
        itemCount = #enemyContext.Items
    end

    print(
        "  Items:         " ..
        tostring(itemCount)
    )

    if itemCount > 0 then

        for i, item in ipairs(enemyContext.Items) do

              print(
                "  [" .. tostring(i) .. "] " ..
                "Type: " .. tostring(item.Type) ..
                " | Slot: " .. tostring(item.Slot or "-") ..
                " | Equipped: " .. tostring(item.Equipped) ..
                " | Rarity: " .. tostring(item.Rarity)
            )

        end

    end

    print("[ULF][ENEMY-CONTEXT] ========================================")
    print("[ULF][ENEMY-CONTEXT] END CONTEXT")
    print("[ULF][ENEMY-CONTEXT] ========================================")

end
