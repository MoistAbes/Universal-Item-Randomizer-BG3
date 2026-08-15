ULF_EnemyContext = {}

-- ============================================================
-- BUILD ENEMY CONTEXT
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

    if entity.Classes
        and entity.Classes.Classes
    then

        for _, classInfo in ipairs(
            entity.Classes.Classes
        ) do

            if classInfo then

                classLevel =
                    classInfo.Level

                break

            end

        end

    end


    -- ========================================================
    -- HEALTH
    -- ========================================================

    local health = {
        HP = nil,
        MaxHP = nil
    }

    if entity.Health then

        health.HP =
            entity.Health.Hp

        health.MaxHP =
            entity.Health.MaxHp

    end


    -- ========================================================
    -- COMBAT
    -- ========================================================

    local combat = {
        AC = nil,
        ProficiencyBonus = nil,
        ArmorType = nil,
        ArmorType2 = nil
    }

    if entity.Stats then

        combat.ProficiencyBonus =
            entity.Stats.ProficiencyBonus

        combat.ArmorType =
            entity.Stats.ArmorType

        combat.ArmorType2 =
            entity.Stats.ArmorType2

    end

    -- AC is currently exposed through Resistances.
    if entity.Resistances then

        combat.AC =
            entity.Resistances.AC

    end


    -- ========================================================
    -- ABILITIES
    -- ========================================================

    local abilities = {
        Values = {},
        Modifiers = {}
    }

    if entity.Stats then

        if entity.Stats.Abilities then

            for i, value in ipairs(
                entity.Stats.Abilities
            ) do

                abilities.Values[i] =
                    value

            end

        end

        if entity.Stats.AbilityModifiers then

            for i, value in ipairs(
                entity.Stats.AbilityModifiers
            ) do

                abilities.Modifiers[i] =
                    value

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

                    if slotData
                        and slotData.Item
                    then

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

        -- ====================================================
        -- IDENTITY
        -- ====================================================

        EntityUuid = entityUuid,


        -- ====================================================
        -- CLASS
        -- ====================================================

        Class = {
            Level = classLevel
        },


        -- ====================================================
        -- HEALTH
        -- ====================================================

        Health = health,


        -- ====================================================
        -- COMBAT
        -- ====================================================

        Combat = combat,


        -- ====================================================
        -- ABILITIES
        -- ====================================================

        Abilities = abilities,


        -- ====================================================
        -- AI
        -- ====================================================

        Archetype = archetype,


        -- ====================================================
        -- PROFICIENCY
        -- ====================================================

        ProficiencyGroup = proficiencyGroups,


        -- ====================================================
        -- ITEMS
        -- ====================================================

        Items = items

    }

end


-- ============================================================
-- DEBUG PRINT
-- ============================================================

function ULF_EnemyContext.DebugPrint(enemyContext)

    if not enemyContext then

        ULF_Debug.Print(
            "[ENEMY CONTEXT] enemyContext is nil"
        )

        return

    end


    ULF_Debug.Print(
        "[ENEMY CONTEXT] ------------------------------------------------"
    )


    -- ========================================================
    -- IDENTITY
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [IDENTITY]"
    )

    ULF_Debug.Print(
        "  Entity UUID:  " ..
        tostring(enemyContext.EntityUuid)
    )


    -- ========================================================
    -- CLASS
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [CLASS]"
    )

    local classLevel = nil

    if enemyContext.Class then
        classLevel =
            enemyContext.Class.Level
    end

    ULF_Debug.Print(
        "  Class Level:   " ..
        tostring(classLevel or "-")
    )


    -- ========================================================
    -- HEALTH
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [HEALTH]"
    )

    local hp = nil
    local maxHp = nil

    if enemyContext.Health then

        hp =
            enemyContext.Health.HP

        maxHp =
            enemyContext.Health.MaxHP

    end

    ULF_Debug.Print(
        "  HP:            " ..
        tostring(hp or "-")
    )

    ULF_Debug.Print(
        "  Max HP:        " ..
        tostring(maxHp or "-")
    )


    -- ========================================================
    -- COMBAT
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [COMBAT]"
    )

    local ac = nil
    local proficiencyBonus = nil
    local armorType = nil
    local armorType2 = nil

    if enemyContext.Combat then

        ac =
            enemyContext.Combat.AC

        proficiencyBonus =
            enemyContext.Combat.ProficiencyBonus

        armorType =
            enemyContext.Combat.ArmorType

        armorType2 =
            enemyContext.Combat.ArmorType2

    end

    ULF_Debug.Print(
        "  AC:             " ..
        tostring(ac or "-")
    )

    ULF_Debug.Print(
        "  Proficiency:    " ..
        tostring(proficiencyBonus or "-")
    )

    ULF_Debug.Print(
        "  Armor Type:     " ..
        tostring(armorType or "-")
    )

    ULF_Debug.Print(
        "  Armor Type 2:   " ..
        tostring(armorType2 or "-")
    )


    -- ========================================================
    -- ABILITIES
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [ABILITIES]"
    )

    if enemyContext.Abilities then

        local values =
            enemyContext.Abilities.Values

        local modifiers =
            enemyContext.Abilities.Modifiers

        if values
            and #values > 0
        then

            ULF_Debug.Print(
                "  Values:"
            )

            for i, value in ipairs(values) do

                ULF_Debug.Print(
                    "    [" ..
                    tostring(i) ..
                    "] " ..
                    tostring(value)
                )

            end

        else

            ULF_Debug.Print(
                "  Values:        -"
            )

        end


        if modifiers
            and #modifiers > 0
        then

            ULF_Debug.Print(
                "  Modifiers:"
            )

            for i, value in ipairs(modifiers) do

                ULF_Debug.Print(
                    "    [" ..
                    tostring(i) ..
                    "] " ..
                    tostring(value)
                )

            end

        else

            ULF_Debug.Print(
                "  Modifiers:     -"
            )

        end

    else

        ULF_Debug.Print(
            "  -"
        )

    end


    -- ========================================================
    -- ARCHETYPE
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [ARCHETYPE]"
    )

    ULF_Debug.Print(
        "  Archetype:     " ..
        tostring(enemyContext.Archetype or "-")
    )


    -- ========================================================
    -- PROFICIENCY
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [PROFICIENCY]"
    )

    if enemyContext.ProficiencyGroup
        and #enemyContext.ProficiencyGroup > 0
    then

        for _, proficiency in ipairs(
            enemyContext.ProficiencyGroup
        ) do

            ULF_Debug.Print(
                "  " ..
                tostring(proficiency)
            )

        end

    else

        ULF_Debug.Print(
            "  -"
        )

    end


    -- ========================================================
    -- ITEMS
    -- ========================================================

    ULF_Debug.Print(
        "[ENEMY-CONTEXT] [ITEMS]"
    )

    local itemCount = 0

    if enemyContext.Items then

        itemCount =
            #enemyContext.Items

    end

    ULF_Debug.Print(
        "  Items:         " ..
        tostring(itemCount)
    )


    if itemCount > 0 then

        for i, item in ipairs(
            enemyContext.Items
        ) do

            ULF_Debug.Print(
                "  [" ..
                tostring(i) ..
                "] " ..
                "Type: " ..
                tostring(item.Type) ..
                " | Slot: " ..
                tostring(item.Slot or "-") ..
                " | Equipped: " ..
                tostring(item.Equipped) ..
                " | Rarity: " ..
                tostring(item.Rarity)
            )

        end

    end


    -- ========================================================
    -- END
    -- ========================================================

    ULF_Debug.Print(
        "[ULF][ENEMY-CONTEXT] END CONTEXT ---------------------------"
    )

    ULF_Debug.Print("")

end