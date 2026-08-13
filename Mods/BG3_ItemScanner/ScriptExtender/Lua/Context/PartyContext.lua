print("[ULF] PartyContext.lua LOADED")

ULF_PartyContext = {}

-- ============================================================
-- GET PARTY MEMBERS
-- ============================================================

function ULF_PartyContext.GetMembers()

    local members = {}

    if not Osi
        or not Osi.DB_PartyMembers
    then
        print("[ULF][PARTY] ERROR: DB_PartyMembers is unavailable")
        return members
    end

    local rows = Osi.DB_PartyMembers:Get(nil)

    if not rows then
        print("[ULF][PARTY] No party members found")
        return members
    end

    for _, row in pairs(rows) do

        local character = row and row[1]

        if character then

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

function ULF_PartyContext.GetData()

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

    local averageLevel = nil

    if validMembers > 0 then
        averageLevel =
            totalLevel / validMembers
    end

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
        print("[ULF][PARTY] ERROR: Party data is nil")
        return
    end

    print("[ULF][PARTY] ========================================")
    print("[ULF][PARTY] PARTY CONTEXT")
    print("[ULF][PARTY] ========================================")

    print("[ULF][PARTY] [SUMMARY]")
    print("  Members:       " .. tostring(data.MemberCount))
    print("  Average Level: " .. tostring(data.AverageLevel or "-"))
    print("  Highest Level: " .. tostring(data.HighestLevel or "-"))
    print("  Lowest Level:  " .. tostring(data.LowestLevel or "-"))

    print("[ULF][PARTY] [MEMBERS]")

    if data.Members then

        for i, member in ipairs(data.Members) do

            print(
                "  [" .. tostring(i) .. "] " ..
                "Character: " .. tostring(member.Character) ..
                " | Level: " .. tostring(member.Level or "-")
            )

        end

    end

    print("[ULF][PARTY] ========================================")
    print("[ULF][PARTY] END PARTY CONTEXT")
    print("[ULF][PARTY] ========================================")

end