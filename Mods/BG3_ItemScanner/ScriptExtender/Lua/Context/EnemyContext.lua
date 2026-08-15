ULF_EnemyContext = {}

-- ============================================================
-- BUILD ENEMY PROFILE
-- ============================================================

function ULF_EnemyContext.Build(entity)

    if not entity then
        ULF_Debug.Error("[ENEMY CONTEXT] Entity is nil")
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
    -- PROFICIENCY
    -- ========================================================

    local proficiencyGroups = {}

    if entity.ServerBaseProficiency
        and entity.ServerBaseProficiency.ProficiencyGroup
    then

        for _, proficiency in ipairs(
            entity.ServerBaseProficiency.ProficiencyGroup
        ) do

            table.insert(
                proficiencyGroups,
                proficiency
            )

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

        ProficiencyGroup = proficiencyGroups,

        Items = items

    }

end

-- ============================================================
-- DEBUG PRINT
-- ============================================================

function ULF_EnemyContext.DebugPrint(enemyContext)

    if not enemyContext then
        ULF_Debug.Print("[ENEMY CONTEXT] enemyContext is nil")
        return
    end

    ULF_Debug.Print("[ENEMY CONTEXT] ------------------------------------------------")

    -- ========================================================
    -- IDENTITY
    -- ========================================================

    ULF_Debug.Print("[ENEMY-CONTEXT] [IDENTITY]")

    print(
        "  Entity UUID:  " ..
        tostring(enemyContext.EntityUuid)
    )

    -- ========================================================
    -- CLASS
    -- ========================================================

    ULF_Debug.Print("[ENEMY-CONTEXT] [CLASS]")

    local classLevel = nil

    if enemyContext.Class then
        classLevel = enemyContext.Class.Level
    end

    ULF_Debug.Print(
        "  Class Level:   " ..
        tostring(classLevel or "-")
    )

    -- ========================================================
    -- ARCHETYPE
    -- ========================================================

    ULF_Debug.Print("[ENEMY-CONTEXT] [ARCHETYPE]")

    ULF_Debug.Print(
        "  Archetype:     " ..
        tostring(enemyContext.Archetype or "-")
    )

    -- ========================================================
    -- PROFICIENCY
    -- ========================================================

    ULF_Debug.Print("[ENEMY-CONTEXT] [PROFICIENCY]")

    if enemyContext.ProficiencyGroup
        and #enemyContext.ProficiencyGroup > 0
    then

        for _, proficiency in ipairs(
            enemyContext.ProficiencyGroup
        ) do

            ULF_Debug.Print(
                "  " .. tostring(proficiency)
            )

        end

    else

        ULF_Debug.Print("  - ")

    end

    -- ========================================================
    -- ITEMS
    -- ========================================================

    ULF_Debug.Print("[ENEMY-CONTEXT] [ITEMS]")

    local itemCount = 0

    if enemyContext.Items then
        itemCount = #enemyContext.Items
    end

    ULF_Debug.Print(
        "  Items:         " ..
        tostring(itemCount)
    )

    if itemCount > 0 then

        for i, item in ipairs(enemyContext.Items) do

              ULF_Debug.Print(
                "  [" .. tostring(i) .. "] " ..
                "Type: " .. tostring(item.Type) ..
                " | Slot: " .. tostring(item.Slot or "-") ..
                " | Equipped: " .. tostring(item.Equipped) ..
                " | Rarity: " .. tostring(item.Rarity)
            )

        end

    end

    ULF_Debug.Print("[ULF][ENEMY-CONTEXT] END CONTEXT ---------------------------")
    ULF_Debug.Print("")

end
