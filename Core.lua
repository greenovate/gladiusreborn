local addonName, GR = ...
GR.addonName = addonName

------------------------------------------------------------
-- Defaults
------------------------------------------------------------
local defaults = {
    locked = false,
    scale = 1.0,
    position = { point = "RIGHT", relPoint = "RIGHT", x = -100, y = 0 },
    nameplates = {
        forceEnemy = true,
        autoMark = false,
        markAssignments = {
            player = 1,
            party1 = 2,
            party2 = 3,
            party3 = 4,
            party4 = 5,
        },
    },
    announcements = {
        -- Output: "none", "self", "party", "both"
        output = "both",
        -- Individual toggles
        trinket = true,
        drinking = true,
        enemySpec = true,
        enemyLowHP = true,
        enemyLowHPThreshold = 25,
        teamLowHP = true,
        teamLowHPThreshold = 30,
        offensiveCD = true,
        defensiveCD = true,
        killTarget = true,
        ccBreaker = true,
        eyeTracker = true,
        prepChecklist = true,
        queueAlert = true,
    },
    appearance = {
        preset = "default",
        barWidth = 220,
        barHeight = 42,
        castBarHeight = 14,
        spacing = 2,
        barTexture = "Interface\\TargetingFrame\\UI-StatusBar",
        bgAlpha = 0.7,
        borderSize = 10,
        borderColor = { 0.3, 0.3, 0.3, 0.8 },
        bgColor = { 0, 0, 0, 0.7 },
        nameFont = "Fonts\\FRIZQT__.TTF",
        nameFontSize = 11,
        nameFontFlags = "OUTLINE",
        nameFontShadow = false,
        nameFontShadowColor = { 0, 0, 0, 1 },
        nameFontShadowOffset = { 1, -1 },
        nameFontColor = { 1, 1, 1, 1 },
        nameColorByClass = true,
        nameShowSpec = true,
        namePosition = "LEFT",
        hpFont = "Fonts\\FRIZQT__.TTF",
        hpFontSize = 10,
        hpFontFlags = "OUTLINE",
        hpFontColor = { 1, 1, 1, 1 },
        hpPosition = "RIGHT",
        castFont = "Fonts\\FRIZQT__.TTF",
        castFontSize = 9,
        castFontFlags = "OUTLINE",
        castFontColor = { 1, 1, 1, 1 },
        castTimerColor = { 1, 1, 1, 1 },
        specPosition = "ICON",
        drFontSize = 8,
        drTimerFontSize = 7,
        classColorBars = true,
        showClassIcon = true,
        castBarColor = { 1, 0.7, 0 },
        channelBarColor = { 0, 0.7, 1 },
        powerBarHeight = 6,
        hpBarHeight = 28,
        trinketSize = 26,
        trinketCDStyle = "spiral",
        trinketCDTextSize = 12,
        trinketCDTextOpacity = 1.0,
        drIconSize = 22,
        drCDStyle = "spiral",
        drCDTextSize = 10,
        drCDTextOpacity = 1.0,
    },
    clicks = {
        -- button1 = left click, button2 = right click
        -- modifiers: "", "shift-", "ctrl-", "alt-"
        -- actions: "target", "focus", "spell", "macro", "none"
        actions = {
            { button = 1, modifier = "",      action = "target", spell = "" },
            { button = 2, modifier = "",      action = "focus",  spell = "" },
            { button = 1, modifier = "shift-", action = "focus",  spell = "" },
            { button = 1, modifier = "ctrl-",  action = "none",   spell = "" },
            { button = 1, modifier = "alt-",   action = "none",   spell = "" },
            { button = 2, modifier = "shift-", action = "none",   spell = "" },
            { button = 2, modifier = "ctrl-",  action = "none",   spell = "" },
            { button = 2, modifier = "alt-",   action = "none",   spell = "" },
        },
    },
}

------------------------------------------------------------
-- Available Fonts (TBC client + ElvUI)
------------------------------------------------------------
GR.FONT_LIST = {
    ["Fonts\\FRIZQT__.TTF"]    = "Friz Quadrata (Default)",
    ["Fonts\\ARIALN.TTF"]      = "Arial Narrow",
    ["Fonts\\MORPHEUS.TTF"]    = "Morpheus",
    ["Fonts\\skurri.TTF"]      = "Skurri",
    ["Fonts\\FRIENDS.TTF"]     = "Friends",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Fonts\\Expressway.ttf"] = "Expressway",
}

------------------------------------------------------------
-- Profile System
------------------------------------------------------------
function GR:SaveProfile(slot)
    if not GR.db then return end
    if not GladiusRebornDB.profiles then GladiusRebornDB.profiles = {} end
    local profile = {}
    -- Deep copy appearance and clicks
    for _, key in ipairs({"appearance", "clicks", "announcements", "nameplates"}) do
        if GR.db[key] then
            profile[key] = GR:DeepCopy(GR.db[key])
        end
    end
    profile.scale = GR.db.scale
    profile.locked = GR.db.locked
    GladiusRebornDB.profiles[slot] = profile
    GR:Print("Profile " .. slot .. " saved.")
end

function GR:LoadProfile(slot)
    if not GladiusRebornDB.profiles or not GladiusRebornDB.profiles[slot] then
        GR:Print("Profile " .. slot .. " is empty.")
        return
    end
    local profile = GladiusRebornDB.profiles[slot]
    for _, key in ipairs({"appearance", "clicks", "announcements", "nameplates"}) do
        if profile[key] then
            GR.db[key] = GR:DeepCopy(profile[key])
        end
    end
    if profile.scale then GR.db.scale = profile.scale end
    if profile.locked ~= nil then GR.db.locked = profile.locked end
    GR:RebuildAllFrames()
    GR:Print("Profile " .. slot .. " loaded.")
end

function GR:DeleteProfile(slot)
    if GladiusRebornDB.profiles then
        GladiusRebornDB.profiles[slot] = nil
        GR:Print("Profile " .. slot .. " deleted.")
    end
end

function GR:HasProfile(slot)
    return GladiusRebornDB.profiles and GladiusRebornDB.profiles[slot] ~= nil
end

function GR:DeepCopy(src)
    if type(src) ~= "table" then return src end
    local copy = {}
    for k, v in pairs(src) do
        copy[k] = GR:DeepCopy(v)
    end
    return copy
end

-- Character-specific default profile
function GR:SaveCharDefault()
    if not GladiusRebornCharDB then GladiusRebornCharDB = {} end
    GladiusRebornCharDB.default = {}
    for _, key in ipairs({"appearance", "clicks", "announcements", "nameplates"}) do
        if GR.db[key] then
            GladiusRebornCharDB.default[key] = GR:DeepCopy(GR.db[key])
        end
    end
    GladiusRebornCharDB.default.scale = GR.db.scale
    GR:Print("Character default saved.")
end

function GR:LoadCharDefault()
    if not GladiusRebornCharDB or not GladiusRebornCharDB.default then return false end
    local profile = GladiusRebornCharDB.default
    for _, key in ipairs({"appearance", "clicks", "announcements", "nameplates"}) do
        if profile[key] then
            GR.db[key] = GR:DeepCopy(profile[key])
        end
    end
    if profile.scale then GR.db.scale = profile.scale end
    return true
end
-- State
------------------------------------------------------------
GR.inArena = false
GR.frames = {}
GR.arenaData = {}
GR.testMode = false

------------------------------------------------------------
-- Utility
------------------------------------------------------------
function GR:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99Gladius Reborn:|r " .. msg)
end

function GR:IsInArena()
    local _, instanceType = IsInInstance()
    if instanceType == "arena" then return true end
    -- Fallback: check if we're in a battleground arena via IsActiveBattlefieldArena
    if IsActiveBattlefieldArena and IsActiveBattlefieldArena() then return true end
    return false
end

function GR:GetArenaUnitFromGUID(guid)
    for i = 1, 5 do
        local unit = "arena" .. i
        if UnitGUID(unit) == guid then
            return unit, i
        end
    end
    return nil, nil
end

local function DeepCopy(src)
    local copy = {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function GR:ResetArenaData()
    for i = 1, 5 do
        GR.arenaData[i] = {
            seen = false,
            name = "",
            class = nil,
            classFile = nil,
            spec = nil,
            trinketUsed = 0,
            drinking = false,
            dr = {},
        }
    end
end

------------------------------------------------------------
-- Database Init
------------------------------------------------------------
function GR:InitDB()
    if not GladiusRebornDB then
        GladiusRebornDB = {}
    end
    for k, v in pairs(defaults) do
        if GladiusRebornDB[k] == nil then
            if type(v) == "table" then
                GladiusRebornDB[k] = DeepCopy(v)
            else
                GladiusRebornDB[k] = v
            end
        elseif type(v) == "table" then
            for k2, v2 in pairs(v) do
                if GladiusRebornDB[k][k2] == nil then
                    if type(v2) == "table" then
                        GladiusRebornDB[k][k2] = DeepCopy(v2)
                    else
                        GladiusRebornDB[k][k2] = v2
                    end
                end
            end
        end
    end
    GR.db = GladiusRebornDB
    -- Load character-specific defaults if they exist
    GR:LoadCharDefault()
end

------------------------------------------------------------
-- Arena Enter / Leave
------------------------------------------------------------
function GR:EnterArena()
    if GR.inArena then return end
    GR.inArena = true
    GR._gatesOpened = false
    GR:ResetArenaData()
    GR:Print("Arena detected. Frames active.")
    if GR.StartNameplateEnforcement then
        GR:StartNameplateEnforcement()
    end

    -- Show prep checklist (hides automatically when gates open)
    if GR.ShowPrepChecklist then
        GR:ShowPrepChecklist()
    end

    -- Start Shadow Sight tracker
    if GR.StartEyeTracker then
        GR:StartEyeTracker()
    end

    -- Show placeholder frames immediately
    GR:ShowPlaceholders()

    -- Start scanning for opponents
    GR:ScanArenaOpponents()
    if not GR._arenaScanTimer then
        GR._arenaScanTimer = C_Timer.NewTicker(0.5, function()
            if not GR.inArena then
                if GR._arenaScanTimer then
                    GR._arenaScanTimer:Cancel()
                    GR._arenaScanTimer = nil
                end
                return
            end
            GR:ScanArenaOpponents()
        end)
    end
end

function GR:ShowPlaceholders()
    -- Guess arena size from group size
    local groupSize = GetNumGroupMembers()
    local arenaSize = 3 -- default
    if groupSize <= 2 then
        arenaSize = 2
    elseif groupSize <= 3 then
        arenaSize = 3
    else
        arenaSize = 5
    end

    for i = 1, arenaSize do
        local f = GR.frames[i]
        if f then
            f:SetAlpha(0.5)
            f.nameText:SetText("|cff888888Arena " .. i .. " - Waiting...|r")
            f.nameText:SetTextColor(0.5, 0.5, 0.5)
            f.healthBar:SetMinMaxValues(0, 1)
            f.healthBar:SetValue(1)
            f.healthBar:SetStatusBarColor(0.3, 0.3, 0.3)
            f.healthText:SetText("")
            f.classIcon:Hide()
            f.specText:Hide()
            f.castBar:Hide()
            f.trinket.icon:SetDesaturated(false)
            f.trinket.cooldown:Clear()
            if f.trinket.timerText then f.trinket.timerText:SetText("") end
            f:Show()
        end
    end

    -- Hide extras
    for i = arenaSize + 1, 5 do
        if GR.frames[i] then GR.frames[i]:Hide() end
    end
end

function GR:ScanArenaOpponents()
    for i = 1, 5 do
        local unit = "arena" .. i
        local data = GR.arenaData[i]
        local f = GR.frames[i]

        -- Try to get class even before "seen" (prep phase detection)
        local _, classFile = UnitClass(unit)
        if classFile and not data.classFile then
            data.classFile = classFile
            data.name = UnitName(unit) or ("Arena " .. i)

            -- Show class info on placeholder frame
            if f and GR.CLASS_TCOORDS[classFile] then
                f.classIcon:SetTexCoord(unpack(GR.CLASS_TCOORDS[classFile]))
                local a = GR.db and GR.db.appearance or {}
                if a.showClassIcon ~= false then
                    f.classIcon:Show()
                end

                -- Class-colored name
                local color = RAID_CLASS_COLORS[classFile]
                if color then
                    f.nameText:SetTextColor(color.r, color.g, color.b)
                    if a.classColorBars ~= false then
                        f.healthBar:SetStatusBarColor(color.r, color.g, color.b)
                    end
                end

                f.nameText:SetText(data.name .. " (" .. classFile:sub(1,1) .. classFile:sub(2):lower() .. ")")
                f:SetAlpha(0.7) -- partially visible = detected but not seen
                f:Show()

                GR:Announce("SPEC DETECTED: " .. data.name .. " - " .. classFile:sub(1,1) .. classFile:sub(2):lower(), "enemySpec", 30)

                -- Mana-based spec guessing (GladiusEx technique)
                GR:GuessSpecFromPower(i, unit, classFile)
            end
        end

        -- Full detection when unit is actually visible
        if UnitExists(unit) then
            if not data.seen then
                data.seen = true
                GR:UpdateFrameUnit(i)
                GR:ShowFrame(i)
                -- Try spec guess again with full data
                if not data.spec and data.classFile then
                    GR:GuessSpecFromPower(i, unit, data.classFile)
                    GR:GuessSpecFromAuras(i, unit)
                end
            else
                GR:UpdateHealth(i)
                GR:UpdatePower(i)
            end
        end
    end
end

------------------------------------------------------------
-- Spec Guessing (pre-combat, GladiusEx technique)
------------------------------------------------------------
-- TBC mana pools are distinct enough to guess some specs
-- High mana = caster/healer spec, low mana = melee/feral
local MANA_SPEC_THRESHOLD = 4000

function GR:GuessSpecFromPower(index, unit, classFile)
    local data = GR.arenaData[index]
    if data.spec then return end -- already detected

    local mana = UnitPowerMax(unit, 0) -- 0 = mana
    if not mana or mana == 0 then return end

    local guessedSpec = nil

    if classFile == "PALADIN" then
        if mana > MANA_SPEC_THRESHOLD then
            guessedSpec = "Holy"
        else
            guessedSpec = "Retribution"
        end
    elseif classFile == "DRUID" then
        if mana < MANA_SPEC_THRESHOLD then
            guessedSpec = "Feral"
        end
        -- Can't distinguish Balance vs Resto from mana alone
    elseif classFile == "SHAMAN" then
        if mana < MANA_SPEC_THRESHOLD then
            guessedSpec = "Enhancement"
        end
    end

    if guessedSpec then
        data.spec = guessedSpec
        GR:UpdateFrameUnit(index)
        local name = data.name or "?"
        GR:Announce("SPEC DETECTED: " .. name .. " - " .. guessedSpec .. " (" .. classFile:sub(1,1) .. classFile:sub(2):lower() .. ")", "enemySpec", 30)
    end
end

function GR:GuessSpecFromAuras(index, unit)
    local data = GR.arenaData[index]
    if data.spec then return end
    local classFile = data.classFile
    if not classFile then return end

    -- Scan buffs for spec-defining auras
    for j = 1, 40 do
        local name = UnitBuff(unit, j)
        if not name then break end

        -- Check against our spec spell list
        if GR.SPEC_SPELLS[classFile] and GR.SPEC_SPELLS[classFile][name] then
            data.spec = GR.SPEC_SPELLS[classFile][name]
            GR:UpdateFrameUnit(index)
            local playerName = data.name or "?"
            GR:Announce("SPEC DETECTED: " .. playerName .. " - " .. data.spec .. " (" .. classFile:sub(1,1) .. classFile:sub(2):lower() .. ")", "enemySpec", 30)
            return
        end
    end
end

function GR:LeaveArena()
    if not GR.inArena then return end
    GR.inArena = false
    if GR._arenaScanTimer then
        GR._arenaScanTimer:Cancel()
        GR._arenaScanTimer = nil
    end
    GR:HideAllFrames()
    if GR.StopNameplateEnforcement then
        GR:StopNameplateEnforcement()
    end
    if GR.StopEyeTracker then
        GR:StopEyeTracker()
    end
    if GR.HidePrepChecklist then
        GR:HidePrepChecklist()
    end
end

function GR:CheckZone()
    if GR:IsInArena() then
        GR:EnterArena()
    else
        if GR.inArena then
            GR:LeaveArena()
        end
    end
end

------------------------------------------------------------
-- Main Event Frame
------------------------------------------------------------
local eventFrame = CreateFrame("Frame", "GladiusReborn_EventFrame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("ARENA_OPPONENT_UPDATE")
eventFrame:RegisterEvent("UNIT_HEALTH")
eventFrame:RegisterEvent("UNIT_POWER_UPDATE")
eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
eventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
eventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
eventFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("CVAR_UPDATE")
eventFrame:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
eventFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == addonName then
            GR:InitDB()
            GR:CreateAllFrames()
            GR:ResetArenaData()
            GR:Print("Loaded. Type |cff00ff00/gladius ui|r for options.")
            self:UnregisterEvent("ADDON_LOADED")
        end

    elseif event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        GR:CheckZone()

    elseif event == "ARENA_OPPONENT_UPDATE" then
        local unit, reason = ...
        GR:OnArenaOpponentUpdate(unit, reason)

    elseif event == "UNIT_HEALTH" then
        local unit = ...
        GR:OnUnitHealth(unit)

    elseif event == "UNIT_POWER_UPDATE" then
        local unit = ...
        GR:OnUnitPower(unit)

    elseif event == "UNIT_SPELLCAST_START" then
        local unit = ...
        GR:OnCastStart(unit)

    elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED"
        or event == "UNIT_SPELLCAST_INTERRUPTED" then
        local unit = ...
        GR:OnCastStop(unit)

    elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
        local unit = ...
        GR:OnChannelStart(unit)

    elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
        local unit = ...
        if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
            GR:OnChannelStop(unit)
        else
            GR:OnChannelStart(unit)
        end

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        GR:OnCombatLog()

    elseif event == "GROUP_ROSTER_UPDATE" then
        if GR.inArena and GR.db.nameplates.autoMark then
            C_Timer.After(0.5, function() GR:ApplyMarkers() end)
        end

    elseif event == "CVAR_UPDATE" then
        if GR.OnCVarUpdate then
            GR:OnCVarUpdate(...)
        end

    elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" then
        GR:CheckZone()
        if GR.inArena then
            GR:ScanArenaOpponents()
        end

    elseif event == "UPDATE_BATTLEFIELD_STATUS" then
        -- Fires when entering/leaving any PvP instance
        C_Timer.After(0.5, function()
            GR:CheckZone()
        end)
    end
end)
