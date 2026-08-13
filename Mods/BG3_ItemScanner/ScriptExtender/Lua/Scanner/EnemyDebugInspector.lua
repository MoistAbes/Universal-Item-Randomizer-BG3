print("[ULF] EnemyDebugInspector.lua LOADED")

ULF_EnemyDebugInspector = {}

-- ============================================================
-- HELPERS
-- ============================================================

local function SafeGetTranslatedString(translatedString)
    if not translatedString then
        return nil
    end

    local ok, result = pcall(function()
        return translatedString:Get()
    end)

    if ok then
        return result
    end

    return nil
end


local function GetItemCategory(slot)
    if not slot then
        return "Other"
    end

    if slot == "MeleeMainHand" then
        return "Weapon"
    end

    if slot == "MeleeOffHand" then
        return "Weapon"
    end

    if slot == "Breast" then
        return "Armor"
    end

    if slot == "Helmet" then
        return "Armor"
    end

    if slot == "Gloves" then
        return "Armor"
    end

    if slot == "Boots" then
        return "Armor"
    end

    if slot == "Ring" then
        return "Ring"
    end

    if slot == "Amulet" then
        return "Amulet"
    end

    return "Other"
end


-- ============================================================
-- MODEL
-- ============================================================

function ULF_EnemyDebugInspector.CreateModel(entity)

    if not entity then
        return nil
    end

    local model = {

        -- ====================================================
        -- IDENTITY
        -- ====================================================

        Identity = {
            UUID = nil,
            Name = nil,
            Title = nil,
            RaceUUID = nil,
            Level = nil,
            WorldLevelName = nil,
        },

        -- ====================================================
        -- CLASSES
        -- ====================================================

        Classes = {},

        -- ====================================================
        -- DATA
        -- ====================================================

        Data = {
            StatsId = nil,
            StepsType = nil,
            Weight = nil,
        },

        -- ====================================================
        -- HEALTH
        -- ====================================================

        Health = {
            HP = nil,
            MaxHP = nil,
            TemporaryHP = nil,
            MaxTemporaryHP = nil,
            Invulnerable = nil,
        },

        -- ====================================================
        -- COMBAT
        -- ====================================================

        Combat = {
            AC = nil,
            BaseAC = nil,

            ProficiencyBonus = nil,
            ArmorType = nil,
            ArmorType2 = nil,
        },

        -- ====================================================
        -- ABILITIES
        -- ====================================================

        Abilities = {
            Values = {},
            Modifiers = {},
        },

        -- ====================================================
        -- ATTACK / SPELL CONFIG
        -- ====================================================

        Attack = {
            RangedAbility = nil,
            UnarmedAbility = nil,
            SpellcastingAbility = nil,
        },

        -- ====================================================
        -- INVENTORY
        -- ====================================================

        Inventory = {
            PrimaryInventory = nil,
            Inventories = {},
            Items = {},

            Summary = {
                Weapons = 0,
                Armor = 0,
                Rings = 0,
                Amulets = 0,
                Other = 0,
            },
        },
    }


    -- ========================================================
    -- IDENTITY
    -- ========================================================

    if entity.Uuid then
        model.Identity.UUID = entity.Uuid.EntityUuid
    end

    if entity.Race then
        model.Identity.RaceUUID = entity.Race.Race
    end

    if entity.Level then
        model.Identity.WorldLevelName = entity.Level.LevelName
    end

    if entity.DisplayName then

        if entity.DisplayName.Name then
            model.Identity.Name =
                SafeGetTranslatedString(
                    entity.DisplayName.Name
                )
        end

        if entity.DisplayName.Title then
            model.Identity.Title =
                SafeGetTranslatedString(
                    entity.DisplayName.Title
                )
        end

    end


    -- ========================================================
    -- CLASSES
    -- ========================================================

    if entity.Classes and entity.Classes.Classes then

        for i, classInfo in ipairs(entity.Classes.Classes) do

            model.Classes[i] = {
                ClassUUID = classInfo.ClassUUID,
                Level = classInfo.Level,
                SubClassUUID = classInfo.SubClassUUID,
            }

        end

    end


    -- ========================================================
    -- DATA
    -- ========================================================

    if entity.Data then

        model.Data.StatsId = entity.Data.StatsId
        model.Data.StepsType = entity.Data.StepsType
        model.Data.Weight = entity.Data.Weight

    end


    -- ========================================================
    -- HEALTH
    -- ========================================================

    if entity.Health then

        model.Health.HP =
            entity.Health.Hp

        model.Health.MaxHP =
            entity.Health.MaxHp

        model.Health.TemporaryHP =
            entity.Health.TemporaryHp

        model.Health.MaxTemporaryHP =
            entity.Health.MaxTemporaryHp

        model.Health.Invulnerable =
            entity.Health.IsInvulnerable

    end


    -- ========================================================
    -- COMBAT
    -- ========================================================
    --
    -- IMPORTANT:
    -- AC intentionally NOT read here yet.
    --
    -- We confirmed:
    --
    -- Stats.ArmorType
    -- Stats.ArmorType2
    -- Stats.ProficiencyBonus
    --
    -- But Stats.AC does NOT exist.
    -- BaseStats.AC does NOT exist.
    --
    -- Resistances.AC exists, but we have not yet confirmed
    -- whether it represents final AC or base AC.
    --
    -- ========================================================

    if entity.Stats then

        model.Combat.ProficiencyBonus =
            entity.Stats.ProficiencyBonus

        model.Combat.ArmorType =
            entity.Stats.ArmorType

        model.Combat.ArmorType2 =
            entity.Stats.ArmorType2

    end


    -- ========================================================
    -- Resistances
    -- ========================================================

    if entity.Resistances then
        model.Combat.AC = entity.Resistances.AC
    end


    -- ========================================================
    -- ABILITIES
    -- ========================================================

    if entity.Stats then

        if entity.Stats.Abilities then

            for i, value in ipairs(entity.Stats.Abilities) do
                model.Abilities.Values[i] = value
            end

        end

        if entity.Stats.AbilityModifiers then

            for i, value in ipairs(entity.Stats.AbilityModifiers) do
                model.Abilities.Modifiers[i] = value
            end

        end

    end


    -- ========================================================
    -- ATTACK / SPELL CONFIG
    -- ========================================================

    if entity.Stats then

        model.Attack.RangedAbility =
            entity.Stats.RangedAttackAbility

        model.Attack.UnarmedAbility =
            entity.Stats.UnarmedAttackAbility

        model.Attack.SpellcastingAbility =
            entity.Stats.SpellCastingAbility

    end


    -- ========================================================
    -- INVENTORY
    -- ========================================================

    if entity.InventoryOwner then

        model.Inventory.PrimaryInventory =
            entity.InventoryOwner.PrimaryInventory

        -- ----------------------------------------------------
        -- INVENTORY HANDLES
        -- ----------------------------------------------------

        if entity.InventoryOwner.Inventories then

            for i, inventory in ipairs(
                entity.InventoryOwner.Inventories
            ) do

                model.Inventory.Inventories[i] =
                    inventory

            end

        end


        -- ----------------------------------------------------
        -- INVENTORY ITEMS
        -- ----------------------------------------------------

        if entity.InventoryOwner.Inventories then

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

                                local itemModel = {

                                    -- --------------------
                                    -- IDENTITY
                                    -- --------------------

                                    UUID = nil,
                                    Name = nil,
                                    Title = nil,

                                    -- --------------------
                                    -- TEMPLATE / DATA
                                    -- --------------------

                                    StatsId = nil,
                                    OriginalTemplate = nil,

                                    StepsType = nil,
                                    Weight = nil,

                                    -- --------------------
                                    -- EQUIPMENT
                                    -- --------------------

                                    Equipment = {
                                        Slot = nil,
                                        EquipmentTypeID = nil,
                                        Category = "Other",
                                    },

                                    -- --------------------
                                    -- VALUE
                                    -- --------------------

                                    Value = {
                                        Value = nil,
                                        Rarity = nil,
                                        Unique = nil,
                                    },

                                    -- --------------------
                                    -- SERVER
                                    -- --------------------

                                    Server = {
                                        ItemType = nil,
                                        Known = nil,
                                        StoryItem = nil,
                                        TreasureGenerated = nil,
                                        UnsoldGenerated = nil,
                                        TreasureLevel = nil,
                                    },
                                }


                                -- ====================================
                                -- ITEM UUID
                                -- ====================================

                                if itemEntity.Uuid then
                                    itemModel.UUID =
                                        itemEntity.Uuid.EntityUuid
                                end


                                -- ====================================
                                -- ITEM DISPLAY NAME
                                -- ====================================

                                if itemEntity.DisplayName then

                                    if itemEntity.DisplayName.Name then
                                        itemModel.Name =
                                            SafeGetTranslatedString(
                                                itemEntity.DisplayName.Name
                                            )
                                    end

                                    if itemEntity.DisplayName.Title then
                                        itemModel.Title =
                                            SafeGetTranslatedString(
                                                itemEntity.DisplayName.Title
                                            )
                                    end

                                end


                                -- ====================================
                                -- ITEM DATA
                                -- ====================================

                                if itemEntity.Data then

                                    itemModel.StatsId =
                                        itemEntity.Data.StatsId

                                    itemModel.StepsType =
                                        itemEntity.Data.StepsType

                                    itemModel.Weight =
                                        itemEntity.Data.Weight

                                end


                                -- ====================================
                                -- ORIGINAL TEMPLATE
                                -- ====================================

                                if itemEntity.OriginalTemplate then

                                    itemModel.OriginalTemplate =
                                        tostring(itemEntity.OriginalTemplate)

                                end


                                -- ====================================
                                -- EQUIPABLE
                                -- ====================================

                                if itemEntity.Equipable then

                                    itemModel.Equipment.Slot =
                                        itemEntity.Equipable.Slot

                                    itemModel.Equipment.EquipmentTypeID =
                                        itemEntity.Equipable.EquipmentTypeID

                                    itemModel.Equipment.Category =
                                        GetItemCategory(
                                            itemEntity.Equipable.Slot
                                        )

                                end


                                -- ====================================
                                -- VALUE
                                -- ====================================

                                if itemEntity.Value then

                                    itemModel.Value.Value =
                                        itemEntity.Value.Value

                                    itemModel.Value.Rarity =
                                        itemEntity.Value.Rarity

                                    itemModel.Value.Unique =
                                        itemEntity.Value.Unique

                                end


                                -- ====================================
                                -- SERVER ITEM
                                -- ====================================

                                if itemEntity.ServerItem then

                                    itemModel.Server.ItemType =
                                        itemEntity.ServerItem.ItemType

                                    itemModel.Server.Known =
                                        itemEntity.ServerItem.Known

                                    itemModel.Server.StoryItem =
                                        itemEntity.ServerItem.StoryItem

                                    itemModel.Server.TreasureGenerated =
                                        itemEntity.ServerItem.TreasureGenerated

                                    itemModel.Server.UnsoldGenerated =
                                        itemEntity.ServerItem.UnsoldGenerated

                                    itemModel.Server.TreasureLevel =
                                        itemEntity.ServerItem.TreasureLevel

                                end


                                -- ====================================
                                -- SUMMARY
                                -- ====================================

                                local category =
                                    itemModel.Equipment.Category

                                if category == "Weapon" then

                                    model.Inventory.Summary.Weapons =
                                        model.Inventory.Summary.Weapons + 1

                                elseif category == "Armor" then

                                    model.Inventory.Summary.Armor =
                                        model.Inventory.Summary.Armor + 1

                                elseif category == "Ring" then

                                    model.Inventory.Summary.Rings =
                                        model.Inventory.Summary.Rings + 1

                                elseif category == "Amulet" then

                                    model.Inventory.Summary.Amulets =
                                        model.Inventory.Summary.Amulets + 1

                                else

                                    model.Inventory.Summary.Other =
                                        model.Inventory.Summary.Other + 1

                                end


                                -- ====================================
                                -- ADD ITEM
                                -- ====================================

                                table.insert(
                                    model.Inventory.Items,
                                    itemModel
                                )

                            end

                        end

                    end

                end

            end

        end

    end


    return model

end


-- ============================================================
-- PRINT MODEL
-- ============================================================

function ULF_EnemyDebugInspector.PrintModel(model)

    if not model then
        return
    end

    print("")
    print(
        "[ULF][ENEMY-RESEARCH] ========================================"
    )

    print(
        "[ULF][ENEMY-RESEARCH] ENEMY INSPECTOR"
    )

    print(
        "[ULF][ENEMY-RESEARCH] ========================================"
    )


    -- ========================================================
    -- IDENTITY
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [IDENTITY]")

    print(
        "  UUID:        " ..
        tostring(model.Identity.UUID or "-")
    )

    print(
        "  Name:        " ..
        tostring(model.Identity.Name or "-")
    )

    print(
        "  Title:       " ..
        tostring(model.Identity.Title or "-")
    )

    print(
        "  Race UUID:   " ..
        tostring(model.Identity.RaceUUID or "-")
    )

    print(
        "  Level:       " ..
        tostring(model.Identity.Level or "-")
    )

    print(
        "  World Level: " ..
        tostring(model.Identity.WorldLevelName or "-")
    )


    -- ========================================================
    -- CLASSES
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [CLASSES]")

    if #model.Classes == 0 then

        print("  None")

    else

        for i, classInfo in ipairs(model.Classes) do

            print("  [" .. i .. "]")

            print(
                "    Class UUID:    " ..
                tostring(classInfo.ClassUUID or "-")
            )

            print(
                "    Class Level:   " ..
                tostring(classInfo.Level or "-")
            )

            print(
                "    Subclass UUID: " ..
                tostring(classInfo.SubClassUUID or "-")
            )

        end

    end


    -- ========================================================
    -- DATA
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [DATA]")

    print(
        "  Stats ID:    " ..
        tostring(model.Data.StatsId or "-")
    )

    print(
        "  Steps Type:  " ..
        tostring(model.Data.StepsType or "-")
    )

    print(
        "  Weight:      " ..
        tostring(model.Data.Weight or "-")
    )


    -- ========================================================
    -- HEALTH
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [HEALTH]")

    print(
        "  HP:           " ..
        tostring(model.Health.HP or 0) ..
        " / " ..
        tostring(model.Health.MaxHP or 0)
    )

    print(
        "  Temporary HP: " ..
        tostring(model.Health.TemporaryHP or 0) ..
        " / " ..
        tostring(model.Health.MaxTemporaryHP or 0)
    )

    print(
        "  Invulnerable: " ..
        tostring(model.Health.Invulnerable)
    )


    -- ========================================================
    -- COMBAT
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [COMBAT]")

    print(
        "  AC:               " ..
        tostring(model.Combat.AC or "-")
    )

    print(
        "  Proficiency:      " ..
        tostring(model.Combat.ProficiencyBonus or "-")
    )

    print(
        "  Armor Type:       " ..
        tostring(model.Combat.ArmorType or "-")
    )

    print(
        "  Armor Type 2:     " ..
        tostring(model.Combat.ArmorType2 or "-")
    )


    -- ========================================================
    -- ABILITIES
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [ABILITIES]")

    if #model.Abilities.Values == 0 then

        print("  None")

    else

        for i, value in ipairs(model.Abilities.Values) do

            print(
                "  [" .. i .. "] Value: " ..
                tostring(value) ..
                " Modifier: " ..
                tostring(
                    model.Abilities.Modifiers[i] or 0
                )
            )

        end

    end


    -- ========================================================
    -- ATTACK / SPELL CONFIG
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [ATTACK / SPELL CONFIG]")

    print(
        "  Ranged Ability:       " ..
        tostring(model.Attack.RangedAbility or "-")
    )

    print(
        "  Unarmed Ability:     " ..
        tostring(model.Attack.UnarmedAbility or "-")
    )

    print(
        "  Spellcasting Ability: " ..
        tostring(model.Attack.SpellcastingAbility or "-")
    )


    -- ========================================================
    -- INVENTORY
    -- ========================================================

    print("")
    print("[ULF][ENEMY-RESEARCH] [INVENTORY]")

    print(
        "  Inventories: " ..
        tostring(#model.Inventory.Inventories)
    )

    print(
        "  Items:       " ..
        tostring(#model.Inventory.Items)
    )

    print("")
    print("  [SUMMARY]")

    print(
        "    Weapons: " ..
        tostring(model.Inventory.Summary.Weapons)
    )

    print(
        "    Armor:   " ..
        tostring(model.Inventory.Summary.Armor)
    )

    print(
        "    Rings:   " ..
        tostring(model.Inventory.Summary.Rings)
    )

    print(
        "    Amulets: " ..
        tostring(model.Inventory.Summary.Amulets)
    )

    print(
        "    Other:   " ..
        tostring(model.Inventory.Summary.Other)
    )


    -- ========================================================
    -- INVENTORY ITEMS
    -- ========================================================

    if #model.Inventory.Items > 0 then

        print("")
        print("  [ITEMS]")

        for i, item in ipairs(model.Inventory.Items) do

            print(
                "  [" .. i .. "] " ..
                tostring(item.Name or "-")
            )

            print(
                "      UUID:        " ..
                tostring(item.UUID or "-")
            )

            print(
                "      StatsId:     " ..
                tostring(item.StatsId or "-")
            )

            print(
                "      Category:    " ..
                tostring(
                    item.Equipment.Category or "-"
                )
            )

            print(
                "      Slot:        " ..
                tostring(
                    item.Equipment.Slot or "-"
                )
            )

            print(
                "      EquipmentID: " ..
                tostring(
                    item.Equipment.EquipmentTypeID or "-"
                )
            )

            print(
                "      Value:       " ..
                tostring(
                    item.Value.Value or "-"
                )
            )

            print(
                "      Rarity:      " ..
                tostring(
                    item.Value.Rarity or "-"
                )
            )

            print(
                "      Unique:      " ..
                tostring(
                    item.Value.Unique
                )
            )

            print(
                "      Weight:      " ..
                tostring(item.Weight or "-")
            )

            print(
                "      ItemType:    " ..
                tostring(
                    item.Server.ItemType or "-"
                )
            )

            print(
                "      StoryItem:   " ..
                tostring(
                    item.Server.StoryItem
                )
            )

            print(
                "      TreasureGen: " ..
                tostring(
                    item.Server.TreasureGenerated
                )
            )

            print(
                "      UnsoldGen:   " ..
                tostring(
                    item.Server.UnsoldGenerated
                )
            )

        end

    end


    -- ========================================================
    -- END
    -- ========================================================

    print("")
    print(
        "[ULF][ENEMY-RESEARCH] ========================================"
    )

    print(
        "[ULF][ENEMY-RESEARCH] END INSPECTOR"
    )

    print(
        "[ULF][ENEMY-RESEARCH] ========================================"
    )

end


-- ============================================================
-- INSPECT ENEMY ENTITY
-- ============================================================

function ULF_EnemyDebugInspector.Inspect(entity)

    if not entity then
        print(
            "[ULF][ENEMY-RESEARCH] Inspect called with nil entity"
        )
        return nil
    end

    local model =
        ULF_EnemyDebugInspector.CreateModel(entity)

    ULF_EnemyDebugInspector.PrintModel(model)

    return model

end


print(
    "[ULF][ENEMY-RESEARCH] Inspector API exported"
)