ULF_PartyContext = {}

local function IsSummon(character)

    local entity =
        Ext.Entity.Get(character)

    if not entity then
        return false
    end

    for _, componentName in ipairs(
        entity:GetAllComponentNames()
    ) do

        if componentName ==
            "eoc::summon::IsSummonComponent"
        then
            return true
        end

    end

    return false
end

-- ============================================================
-- GET PARTY MEMBERS
-- ============================================================

function ULF_PartyContext.GetMembers()

    local members = {}

    if not Osi
        or not Osi.DB_PartyMembers
    then
        ULF_Debug.Error("[PARTY CONTEXT] DB_PartyMembers is unavailable")
        return members
    end

    local rows = Osi.DB_PartyMembers:Get(nil)

    if not rows then
        ULF_Debug.Error("[PARTY CONTEXT] No party members found")
        return members
    end

    for _, row in pairs(rows) do

        local character = row and row[1]

        if character
            and not IsSummon(character)
        then

            local level = nil
            local entity = Ext.Entity.Get(character)

            if entity
                and entity.Classes
                and entity.Classes.Classes
            then

                for _, classInfo in ipairs(entity.Classes.Classes) do

                    if classInfo then
                        level = classInfo.Level
                        break
                    end

                end

            end

            table.insert(
                members,
                {
                    Character = character,
                    Level = level
                }
            )

        end

end

    return members
end

-- ============================================================
-- BUILD PARTY LEVEL DATA
-- ============================================================

function ULF_PartyContext.Build()

    local members =
        ULF_PartyContext.GetMembers()

    local totalLevel = 0
    local validMembers = 0
    local highestLevel = nil
    local lowestLevel = nil

    for _, member in ipairs(members) do

        if member.Level ~= nil then

            totalLevel =
                totalLevel + member.Level

            validMembers =
                validMembers + 1

            if not highestLevel
                or member.Level > highestLevel
            then
                highestLevel = member.Level
            end

            if not lowestLevel
                or member.Level < lowestLevel
            then
                lowestLevel = member.Level
            end

        end

    end


    -- ========================================================
    -- VALIDATE PARTY CONTEXT
    -- ========================================================

    if validMembers <= 0 then

        ULF_Debug.Error(
            "[PARTY CONTEXT] ERROR: No valid party members"
        )

        return nil

    end


    local averageLevel =
        totalLevel / validMembers


    return {
        Members = members,
        MemberCount = validMembers,
        AverageLevel = averageLevel,
        HighestLevel = highestLevel,
        LowestLevel = lowestLevel
    }

end

-- ============================================================
-- DEBUG PRINT
-- ============================================================

function ULF_PartyContext.DebugPrint(data)

    if not data then
        ULF_Debug.Error("[PARTY CONTEXT] Party data is nil")
        return
    end

    ULF_Debug.Print("[PARTY CONTEXT] -------------------------------------")

    ULF_Debug.Print("[PARTY CONTEXT] [SUMMARY]")
    ULF_Debug.Print("  Members:       " .. tostring(data.MemberCount))
    ULF_Debug.Print("  Average Level: " .. tostring(data.AverageLevel or "-"))
    ULF_Debug.Print("  Highest Level: " .. tostring(data.HighestLevel or "-"))
    ULF_Debug.Print("  Lowest Level:  " .. tostring(data.LowestLevel or "-"))

    print("[PARTY CONTEXT] [MEMBERS]")

    if data.Members then

        for i, member in ipairs(data.Members) do

            ULF_Debug.Print(
                "  [" .. tostring(i) .. "] " ..
                "Character: " .. tostring(member.Character) ..
                " | Level: " .. tostring(member.Level or "-")
            )

        end

    end

    ULF_Debug.Print("[PARTY CONTEXT] END PARTY CONTEXT")
    ULF_Debug.Print("")

end