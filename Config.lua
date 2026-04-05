local _, GR = ...

------------------------------------------------------------
-- Marker names for display
------------------------------------------------------------
local markerNames = {
    [1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t Star",
    [2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t Circle",
    [3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t Diamond",
    [4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t Triangle",
    [5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t Moon",
    [6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t Square",
    [7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t Cross",
    [8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t Skull",
}

------------------------------------------------------------
-- Slash Commands
------------------------------------------------------------
SLASH_GLADIUSREBORN1 = "/gladius"

SlashCmdList["GLADIUSREBORN"] = function(msg)
    msg = strlower(strtrim(msg))

    -- /gladius ui, /gladius config, /gladius options -> open GUI panel
    if msg == "ui" or msg == "config" or msg == "options" or msg == "" then
        GR:ToggleOptionsPanel()
        return
    end

    -- /gladius test2, /gladius test3, etc.
    local testCount = msg:match("^test(%d)$")
    if testCount then
        GR:ShowTest(tonumber(testCount))
        return
    end

    if msg == "test" then
        GR:ShowTest(3)

    elseif msg == "hide" then
        GR:HideTest()

    elseif msg == "lock" then
        GR:SetLocked(true)
        GR:Print("Frames |cff00ff00locked|r.")

    elseif msg == "unlock" then
        GR:SetLocked(false)
        GR:Print("Frames |cffff9900unlocked|r. Drag the header to reposition.")

    elseif msg == "mark" or msg == "automark" then
        GR.db.nameplates.autoMark = not GR.db.nameplates.autoMark
        if GR.db.nameplates.autoMark then
            GR:Print("Auto-marking |cff00ff00ENABLED|r.")
            if GR.inArena then GR:ApplyMarkers() end
        else
            GR:Print("Auto-marking |cffff0000DISABLED|r.")
        end

    elseif msg == "apply" then
        if GR.inArena then
            GR:ApplyMarkers()
            GR:Print("Markers applied.")
        else
            GR:Print("You must be in an arena.")
        end

    elseif msg:match("^assign") then
        local _, unit, marker = strsplit(" ", msg)
        marker = tonumber(marker)
        if unit and marker and marker >= 0 and marker <= 8 then
            unit = strlower(unit)
            if unit == "player" or unit:match("^party[1-4]$") then
                GR.db.nameplates.markAssignments[unit] = marker > 0 and marker or nil
                if marker > 0 then
                    GR:Print(unit .. " -> " .. markerNames[marker])
                else
                    GR:Print(unit .. " marker cleared.")
                end
            else
                GR:Print("Invalid unit. Use: player, party1-4")
            end
        else
            GR:Print("Usage: /gladius assign <unit> <0-8>")
        end

    elseif msg == "trinket" then
        GR.db.announcements.trinket = not GR.db.announcements.trinket
        GR:Print("Trinket announcements: " .. (GR.db.announcements.trinket and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

    elseif msg == "drinking" then
        GR.db.announcements.drinking = not GR.db.announcements.drinking
        GR:Print("Drinking announcements: " .. (GR.db.announcements.drinking and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

    elseif msg == "nameplates" then
        GR.db.nameplates.forceEnemy = not GR.db.nameplates.forceEnemy
        GR:Print("Force enemy nameplates: " .. (GR.db.nameplates.forceEnemy and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

    elseif msg == "status" then
        GR:Print("--- Settings ---")
        GR:Print("Force enemy nameplates: " .. (GR.db.nameplates.forceEnemy and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
        GR:Print("Auto-marking: " .. (GR.db.nameplates.autoMark and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
        GR:Print("Trinket announce: " .. (GR.db.announcements.trinket and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
        GR:Print("Drinking announce: " .. (GR.db.announcements.drinking and "|cff00ff00ON|r" or "|cffff0000OFF|r"))
        GR:Print("Locked: " .. (GR.db.locked and "Yes" or "No"))
        GR:Print("Scale: " .. GR.db.scale)
        if GR.db.nameplates.autoMark then
            GR:Print("Marker assignments:")
            local a = GR.db.nameplates.markAssignments
            if a.player then GR:Print("  You -> " .. (markerNames[a.player] or "None")) end
            for i = 1, 4 do
                local u = "party" .. i
                if a[u] then GR:Print("  " .. u .. " -> " .. (markerNames[a[u]] or "None")) end
            end
        end

    elseif msg:match("^scale") then
        local _, val = strsplit(" ", msg)
        val = tonumber(val)
        if val and val >= 0.5 and val <= 3.0 then
            GR.db.scale = val
            for i = 1, 5 do
                if GR.frames[i] then
                    GR.frames[i]:SetScale(val)
                end
            end
            GR:Print("Scale set to " .. val)
        else
            GR:Print("Usage: /gladius scale <0.5-3.0>")
        end

    else
        GR:Print("|cff33ff99Gladius Reborn|r Commands:")
        GR:Print("  |cff00ff00/gladius ui|r - Show settings")
        GR:Print("  |cff00ff00/gladius test [2-5]|r - Show test frames")
        GR:Print("  |cff00ff00/gladius hide|r - Hide test frames")
        GR:Print("  |cff00ff00/gladius lock|r - Lock frame position")
        GR:Print("  |cff00ff00/gladius unlock|r - Unlock for repositioning")
        GR:Print("  |cff00ff00/gladius scale <0.5-3>|r - Set frame scale")
        GR:Print("  |cff00ff00/gladius mark|r - Toggle auto-marking party")
        GR:Print("  |cff00ff00/gladius assign <unit> <0-8>|r - Set marker")
        GR:Print("  |cff00ff00/gladius apply|r - Apply markers now")
        GR:Print("  |cff00ff00/gladius trinket|r - Toggle trinket announcements")
        GR:Print("  |cff00ff00/gladius drinking|r - Toggle drink announcements")
        GR:Print("  |cff00ff00/gladius nameplates|r - Toggle forced nameplates")
        GR:Print("  |cff00ff00/gladius status|r - Show all settings")
    end
end
