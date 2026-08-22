ULF_ItemStatModel = {}

function ULF_ItemStatModel.New(data)

    return {
        Stat = data.Stat,

        Category = data.Category,
        ClassificationReason = data.ClassificationReason,

        Level = data.Level,
        Rarity = data.Rarity,

        ModifierList = data.ModifierList,
        Slot = data.Slot,

        WeaponGroup = data.WeaponGroup,
        ProficiencyGroup = data.ProficiencyGroup,

        WeaponProperties = data.WeaponProperties,
        DamageType = data.DamageType,

        ArmorType = data.ArmorType,
        ArmorClass = data.ArmorClass,
        ArmorClassAbility = data.ArmorClassAbility,

        AbilityModifierCap = data.AbilityModifierCap,
        Shield = data.Shield
    }

end