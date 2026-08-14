print("[ULF] ItemDebugInspector.lua LOADED")

ULF_ItemDebugInspector = {}

local function SafeGet(object, property)
    if not object then
        return nil
    end

    local ok, value = pcall(function()
        return object[property]
    end)

    if ok then
        return value
    end

    return nil
end


local function PrintValue(name, value)

    if value == nil then
        print(
            "[ULF][ITEM-RESEARCH] "
            .. name
            .. " = <nil>"
        )
        return
    end

    print(
        "[ULF][ITEM-RESEARCH] "
        .. name
        .. " = "
        .. tostring(value)
    )

end


local function PrintTable(name, value)

    if value == nil then
        print(
            "[ULF][ITEM-RESEARCH] "
            .. name
            .. " = <nil>"
        )
        return
    end

    print(
        "[ULF][ITEM-RESEARCH] "
        .. name
        .. " = "
        .. tostring(value)
    )

    if type(value) == "table" then

        for i, v in pairs(value) do
            print(
                "[ULF][ITEM-RESEARCH] "
                .. name
                .. "["
                .. tostring(i)
                .. "] = "
                .. tostring(v)
            )
        end

    end

end


function ULF_ItemDebugInspector.InspectStat(statName)

    print("")
    print("================================================")
    print("[ULF][ITEM-RESEARCH] " .. tostring(statName))
    print("================================================")

    local stat = Ext.Stats.Get(statName)

    if not stat then
        print("[ULF][ITEM-RESEARCH] Stat NOT FOUND")
        return
    end

    print("[ULF][ITEM-RESEARCH] Stat found")


    -- ========================================================
    -- IDENTITY
    -- ========================================================

    print("")
    print("[ULF][ITEM-RESEARCH] IDENTITY")

    PrintValue(
        "Name",
        SafeGet(stat, "Name")
    )

    PrintValue(
        "ModifierList",
        SafeGet(stat, "ModifierList")
    )

    PrintValue(
        "RootTemplate",
        SafeGet(stat, "RootTemplate")
    )

    PrintValue(
        "ModId",
        SafeGet(stat, "ModId")
    )

    PrintValue(
        "OriginalModId",
        SafeGet(stat, "OriginalModId")
    )


    -- ========================================================
    -- GENERAL
    -- ========================================================

    print("")
    print("[ULF][ITEM-RESEARCH] GENERAL")

    PrintValue(
        "Level",
        SafeGet(stat, "Level")
    )

    PrintValue(
        "Rarity",
        SafeGet(stat, "Rarity")
    )

    PrintValue(
        "Weight",
        SafeGet(stat, "Weight")
    )

    PrintValue(
        "Unique",
        SafeGet(stat, "Unique")
    )

    PrintValue(
        "ValueOverride",
        SafeGet(stat, "ValueOverride")
    )

    PrintValue(
        "InventoryTab",
        SafeGet(stat, "InventoryTab")
    )

    PrintValue(
        "ItemColor",
        SafeGet(stat, "ItemColor")
    )

    PrintValue(
        "NeedsIdentification",
        SafeGet(stat, "NeedsIdentification")
    )


    -- ========================================================
    -- WEAPON
    -- ========================================================

    print("")
    print("[ULF][ITEM-RESEARCH] WEAPON")

    PrintValue(
        "Weapon Group",
        SafeGet(stat, "Weapon Group")
    )

    PrintTable(
        "Proficiency Group",
        SafeGet(stat, "Proficiency Group")
    )

    PrintTable(
        "Weapon Properties",
        SafeGet(stat, "Weapon Properties")
    )

    PrintValue(
        "WeaponRange",
        SafeGet(stat, "WeaponRange")
    )

    PrintValue(
        "Slot",
        SafeGet(stat, "Slot")
    )

    PrintValue(
        "Damage",
        SafeGet(stat, "Damage")
    )

    PrintValue(
        "Damage Type",
        SafeGet(stat, "Damage Type")
    )


    -- ========================================================
    -- ARMOR
    -- ========================================================

    print("")
    print("[ULF][ITEM-RESEARCH] ARMOR")

    PrintValue(
        "ArmorType",
        SafeGet(stat, "ArmorType")
    )

    PrintValue(
        "ArmorClass",
        SafeGet(stat, "ArmorClass")
    )

    PrintValue(
        "Armor Class Ability",
        SafeGet(stat, "Armor Class Ability")
    )

    PrintValue(
        "Ability Modifier Cap",
        SafeGet(stat, "Ability Modifier Cap")
    )

    PrintValue(
        "Shield",
        SafeGet(stat, "Shield")
    )

    PrintValue(
        "Slot",
        SafeGet(stat, "Slot")
    )


    -- ========================================================
    -- EFFECTS
    -- ========================================================

    print("")
    print("[ULF][ITEM-RESEARCH] EFFECTS")

    PrintValue(
        "DefaultBoosts",
        SafeGet(stat, "DefaultBoosts")
    )

    PrintValue(
        "Boosts",
        SafeGet(stat, "Boosts")
    )

    PrintValue(
        "BoostsOnEquipMainHand",
        SafeGet(stat, "BoostsOnEquipMainHand")
    )

    PrintValue(
        "BoostsOnEquipOffHand",
        SafeGet(stat, "BoostsOnEquipOffHand")
    )

    PrintValue(
        "PassivesOnEquip",
        SafeGet(stat, "PassivesOnEquip")
    )

    PrintValue(
        "PassivesMainHand",
        SafeGet(stat, "PassivesMainHand")
    )

    PrintValue(
        "PassivesOffHand",
        SafeGet(stat, "PassivesOffHand")
    )

    PrintValue(
        "Spells",
        SafeGet(stat, "Spells")
    )

    PrintValue(
        "StatusOnEquip",
        SafeGet(stat, "StatusOnEquip")
    )

    PrintValue(
        "StatusInInventory",
        SafeGet(stat, "StatusInInventory")
    )


    -- ========================================================
    -- OTHER
    -- ========================================================

    print("")
    print("[ULF][ITEM-RESEARCH] OTHER")

    PrintValue(
        "Tags",
        SafeGet(stat, "Tags")
    )

    PrintTable(
        "Requirements",
        SafeGet(stat, "Requirements")
    )

    PrintTable(
        "Flags",
        SafeGet(stat, "Flags")
    )

    PrintValue(
        "ComboCategories",
        SafeGet(stat, "ComboCategories")
    )

    PrintValue(
        "ComboProperties",
        SafeGet(stat, "ComboProperties")
    )


    -- ========================================================
    -- ROOT TEMPLATE
    -- ========================================================

    local rootTemplate =
        SafeGet(stat, "RootTemplate")

    if rootTemplate then

        print("")
        print("[ULF][ITEM-RESEARCH] ROOT TEMPLATE")

        print(
            "[ULF][ITEM-RESEARCH] UUID = "
            .. tostring(rootTemplate)
        )

        local template =
            Ext.Template.GetRootTemplate(rootTemplate)

        if template then

            print(
                "[ULF][ITEM-RESEARCH] Template found"
            )

            PrintValue(
                "TEMPLATE.Name",
                SafeGet(template, "Name")
            )

            PrintValue(
                "TEMPLATE.DisplayName",
                SafeGet(template, "DisplayName")
            )

            PrintValue(
                "TEMPLATE.Icon",
                SafeGet(template, "Icon")
            )

            PrintValue(
                "TEMPLATE.TemplateType",
                SafeGet(template, "TemplateType")
            )

        else

            print(
                "[ULF][ITEM-RESEARCH] Template NOT FOUND"
            )

        end

    end


    print("================================================")
    print("[ULF][ITEM-RESEARCH] END")
    print("================================================")
    print("")

end