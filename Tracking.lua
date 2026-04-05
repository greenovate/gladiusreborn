local _, GR = ...

------------------------------------------------------------
-- Announcement System
------------------------------------------------------------
local announceCooldowns = {}

function GR:Announce(msg, announceType, cooldown)
    if not GR.inArena then return end
    local cfg = GR.db and GR.db.announcements
    if not cfg then return end

    -- Check if this type is enabled
    if announceType and cfg[announceType] == false then return end

    -- Cooldown to prevent spam
    cooldown = cooldown or 3
    local key = announceType .. "_" .. (msg or "")
    if announceCooldowns[key] and (GetTime() - announceCooldowns[key]) < cooldown then return end
    announceCooldowns[key] = GetTime()

    local output = cfg.output or "both"
    local cleanMsg = msg:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")

    -- Self: raid warning style on screen
    if output == "self" or output == "both" then
        RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["RAID_WARNING"])
    end

    -- Party chat
    if output == "party" or output == "both" then
        local chatType = IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT"
            or IsInRaid() and "RAID"
            or IsInGroup() and "PARTY"
            or nil
        if chatType then
            SendChatMessage("[GR] " .. cleanMsg, chatType)
        end
    end
end

------------------------------------------------------------
-- Combat Log Handler
------------------------------------------------------------
function GR:OnCombatLog()
    if not GR.inArena then return end

    local timestamp, subevent, hideCaster,
          sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
          destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    local spellId, spellName, spellSchool = select(12, CombatLogGetCurrentEventInfo())

    ----------------------------------------------------------
    -- Trinket Detection
    ----------------------------------------------------------
    if subevent == "SPELL_CAST_SUCCESS" then
        if spellId and GR.TRINKET_SPELLS[spellId] then
            local unit, index = GR:GetArenaUnitFromGUID(sourceGUID)
            if index then
                GR.arenaData[index].trinketUsed = GetTime()
                GR:UpdateTrinket(index)
                if GR.db.announcements.trinket then
                    local name = GR.arenaData[index].name or sourceName or "?"
                    GR:Announce("TRINKET USED: " .. name, "trinket", 4)
                end
                if GR.db.announcements.ccBreaker then
                    local name = GR.arenaData[index].name or sourceName or "?"
                    GR:Announce("CC BREAK: " .. name, "ccBreaker", 4)
                end
            end
        end
    end

    ----------------------------------------------------------
    -- Spec Detection
    ----------------------------------------------------------
    if subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_CAST_START"
        or subevent == "SPELL_AURA_APPLIED" then
        if spellName and sourceGUID then
            local unit, index = GR:GetArenaUnitFromGUID(sourceGUID)
            if index and not GR.arenaData[index].spec then
                local classFile = GR.arenaData[index].classFile
                if classFile and GR.SPEC_SPELLS[classFile] then
                    local spec = GR.SPEC_SPELLS[classFile][spellName]
                    if spec then
                        GR.arenaData[index].spec = spec
                        GR:UpdateFrameUnit(index)
                        -- Announce spec detection
                        local name = GR.arenaData[index].name or "?"
                        GR:Announce("SPEC DETECTED: " .. name .. " - " .. spec .. " (" .. classFile:sub(1,1) .. classFile:sub(2):lower() .. ")", "enemySpec", 30)
                    end
                end
            end
        end
    end

    ----------------------------------------------------------
    -- DR Tracking (GladiusEx-style with spell icons)
    ----------------------------------------------------------
    if subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH"
        or subevent == "SPELL_AURA_REMOVED" then

        local auraType = select(15, CombatLogGetCurrentEventInfo())
        if auraType ~= "DEBUFF" then return end

        local drCat = GR.DR_SPELL_IDS[spellId] or (spellName and GR.DR_SPELL_NAMES[spellName])
        if not drCat then return end

        local unit, index = GR:GetArenaUnitFromGUID(destGUID)
        if not index then return end

        local data = GR.arenaData[index]
        if not data.dr then data.dr = {} end

        if not data.dr[drCat] then
            data.dr[drCat] = {
                diminished = nil,
                spellId = spellId,
                active = false,
                resetTime = 0,
            }
        end

        local dr = data.dr[drCat]
        local applied = (subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH")

        if applied then
            -- CC applied: advance DR
            if dr.active then
                dr.diminished = GR:NextDR(dr.diminished)
            else
                dr.active = true
                dr.diminished = 1
            end
            dr.spellId = spellId
            -- Don't start cooldown timer yet — wait for removal
        else
            -- CC removed: start the 18s reset timer
            if dr.active then
                dr.resetTime = GetTime() + GR.DR_RESET_TIME
            end
        end

        GR:UpdateDRIcons(index)
    end

    ----------------------------------------------------------
    -- Drinking Detection
    ----------------------------------------------------------
    if subevent == "SPELL_AURA_APPLIED" then
        if spellName and GR.DRINK_SPELLS[spellName] then
            local unit, index = GR:GetArenaUnitFromGUID(destGUID)
            if index then
                GR.arenaData[index].drinking = true
                if GR.db.announcements.drinking then
                    local name = GR.arenaData[index].name or destName or "?"
                    GR:Announce("DRINKING: " .. name, "drinking", 5)
                end
            end
        end
    end

    if subevent == "SPELL_AURA_REMOVED" then
        if spellName and GR.DRINK_SPELLS[spellName] then
            local unit, index = GR:GetArenaUnitFromGUID(destGUID)
            if index then
                GR.arenaData[index].drinking = false
            end
        end
    end

    ----------------------------------------------------------
    -- Health update on damage
    ----------------------------------------------------------
    if subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE"
        or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "RANGE_DAMAGE" then
        local unit, index = GR:GetArenaUnitFromGUID(destGUID)
        if index then
            GR:UpdateHealth(index)
        end
    end

    ----------------------------------------------------------
    -- Shadow Sight (Eye) pickup detection
    ----------------------------------------------------------
    if subevent == "SPELL_AURA_APPLIED" and GR.CheckEyePickup then
        GR:CheckEyePickup(spellId, spellName)
    end
end

------------------------------------------------------------
-- DR Icon Management (GladiusEx-style)
------------------------------------------------------------
function GR:UpdateDRIcons(index)
    local f = GR.frames[index]
    if not f then return end
    local data = GR.arenaData[index]
    if not data or not data.dr then return end
    local MAX = 5

    local slot = 1
    local now = GetTime()
    local usedSlots = {}

    for category, drData in pairs(data.dr) do
        if slot > MAX then break end
        if drData.active then
            if drData.resetTime > 0 and now >= drData.resetTime then
                -- Expired — mark inactive but don't wipe during iteration
                drData.active = false
                drData.diminished = nil
            else
                local icon = f.drIcons[slot]
                if icon then
                    -- Spell texture — use GetSpellInfo for TBC compat
                    local _, _, spellTexture = GetSpellInfo(drData.spellId)
                    if spellTexture then
                        icon.texture:SetTexture(spellTexture)
                        icon.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    else
                        icon.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                        icon.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    end

                    -- DR state text + color
                    local state = GR.DR_STATES[drData.diminished]
                    if not state then state = GR.DR_STATES[1] or { text = "?", r = 1, g = 1, b = 1 } end
                    icon.drText:SetText(state.text)
                    icon.drText:SetTextColor(state.r, state.g, state.b)

                    -- DR-colored border
                    icon.colorBorder:SetVertexColor(state.r, state.g, state.b, 1)
                    icon.colorBorder:Show()

                    -- Cooldown spiral
                    if drData.resetTime > 0 and drData.resetTime > now then
                        local startTime = drData.resetTime - GR.DR_RESET_TIME
                        if icon.cooldown.SetCooldown then
                            icon.cooldown:SetCooldown(startTime, GR.DR_RESET_TIME)
                        end
                        icon.cooldown:Show()
                        -- Custom timer text
                        if icon.timerText then
                            local remaining = drData.resetTime - now
                            icon.timerText:SetText(math.floor(remaining))
                            icon.timerText:SetTextColor(1, 1, 1)
                        end
                    else
                        icon.cooldown:Hide()
                        if icon.timerText then icon.timerText:SetText("") end
                    end

                    icon:Show()
                    usedSlots[slot] = true
                    slot = slot + 1
                end
            end
        end
    end

    -- Hide unused slots
    for i = 1, MAX do
        if not usedSlots[i] and f.drIcons[i] then
            f.drIcons[i]:Hide()
        end
    end
end

-- OnUpdate for DR timer expiry
local drUpdateFrame = CreateFrame("Frame")
local drUpdateElapsed = 0
drUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
    drUpdateElapsed = drUpdateElapsed + elapsed
    if drUpdateElapsed < 0.2 then return end
    drUpdateElapsed = 0
    if not GR.inArena and not GR.testMode then return end
    for i = 1, 5 do
        if GR.frames[i] and GR.frames[i]:IsShown() then
            GR:UpdateDRIcons(i)
        end
    end
end)

------------------------------------------------------------
-- Aura Scanning
------------------------------------------------------------
local SCAN_INTERVAL = 0.3
local auraScanElapsed = 0

local auraScanFrame = CreateFrame("Frame")
auraScanFrame:SetScript("OnUpdate", function(self, elapsed)
    auraScanElapsed = auraScanElapsed + elapsed
    if auraScanElapsed < SCAN_INTERVAL then return end
    auraScanElapsed = 0
    if not GR.inArena and not GR.testMode then return end

    for i = 1, 5 do
        local f = GR.frames[i]
        if f and f:IsShown() and not GR.testMode then
            GR:ScanAuras(i)
        end
    end
end)

function GR:ScanAuras(index)
    local f = GR.frames[index]
    if not f or not f.auraIcons then return end
    local unit = f.unitId
    if not UnitExists(unit) then return end

    local MAX_AURAS = 3
    local found = {}

    -- Scan buffs
    for j = 1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
              nameplateShowPersonal, spellId = UnitBuff(unit, j)
        if not name then break end
        if GR.AURA_LIST[spellId] then
            tinsert(found, {
                spellId = spellId,
                icon = icon,
                duration = duration,
                expirationTime = expirationTime,
                priority = GR.AURA_LIST[spellId].priority,
            })
        end
    end

    -- Scan debuffs
    for j = 1, 40 do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable,
              nameplateShowPersonal, spellId = UnitDebuff(unit, j)
        if not name then break end
        if GR.AURA_LIST[spellId] then
            tinsert(found, {
                spellId = spellId,
                icon = icon,
                duration = duration,
                expirationTime = expirationTime,
                priority = GR.AURA_LIST[spellId].priority,
            })
        end
    end

    -- Sort by priority (highest first)
    table.sort(found, function(a, b) return a.priority > b.priority end)

    -- Display top auras
    for j = 1, MAX_AURAS do
        local auraFrame = f.auraIcons[j]
        if auraFrame then
            if found[j] then
                auraFrame.texture:SetTexture(found[j].icon)
                auraFrame.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                if found[j].duration and found[j].duration > 0 then
                    CooldownFrame_Set(auraFrame.cooldown, found[j].expirationTime - found[j].duration, found[j].duration, 1)
                    auraFrame.cooldown:Show()
                else
                    auraFrame.cooldown:Hide()
                end
                auraFrame:Show()
            else
                auraFrame:Hide()
            end
        end
    end
end

------------------------------------------------------------
-- Range Checking
------------------------------------------------------------
local RANGE_UPDATE_INTERVAL = 0.2
local rangeElapsed = 0
local OOR_ALPHA = 0.4

local rangeFrame = CreateFrame("Frame")
rangeFrame:SetScript("OnUpdate", function(self, elapsed)
    rangeElapsed = rangeElapsed + elapsed
    if rangeElapsed < RANGE_UPDATE_INTERVAL then return end
    rangeElapsed = 0
    if not GR.inArena then return end

    for i = 1, 5 do
        local f = GR.frames[i]
        if f and f:IsShown() then
            local unit = f.unitId
            if UnitExists(unit) then
                local inRange = UnitInRange(unit)
                if inRange == false then
                    -- UnitInRange returns false if definitely out of range
                    -- For enemies it may not work — fall back to CheckInteractDistance
                    local canSee = IsSpellInRange(GetSpellInfo(5019), unit) -- Shoot (wand, 30yd)
                    if canSee == nil then
                        -- Can't determine range, assume in range
                        f:SetAlpha(1)
                    elseif canSee == 0 then
                        f:SetAlpha(OOR_ALPHA)
                    else
                        f:SetAlpha(1)
                    end
                else
                    f:SetAlpha(1)
                end
            end
        end
    end
end)

------------------------------------------------------------
-- Alert Glow System
-- Orange = defensives up (don't attack)
-- Green  = no defensives, no trinket (killable)
-- Red    = offensive CDs popped (CC or run)
------------------------------------------------------------

-- Defensive spell IDs to watch
local DEFENSIVE_AURAS = {
    [45438] = true,   -- Ice Block
    [642]   = true,   -- Divine Shield
    [1022]  = true,   -- Blessing of Protection
    [19263] = true,   -- Deterrence
    [31224] = true,   -- Cloak of Shadows
    [871]   = true,   -- Shield Wall
    [33206] = true,   -- Pain Suppression
    [12976] = true,   -- Last Stand
    [18499] = true,   -- Berserker Rage
}

-- Offensive CD spell IDs
local OFFENSIVE_AURAS = {
    [12042] = true,   -- Arcane Power
    [12472] = true,   -- Icy Veins
    [3045]  = true,   -- Rapid Fire
    [34692] = true,   -- The Beast Within
    [31884] = true,   -- Avenging Wrath
    [1719]  = true,   -- Recklessness
    [12292] = true,   -- Death Wish
    [13750] = true,   -- Adrenaline Rush
    [14177] = true,   -- Cold Blood
    [10060] = true,   -- Power Infusion
}

function GR:CreateGlowFrame(f)
    if f.alertGlow then return end

    -- Clickthrough gradient overlay on top of the frame
    f.alertGlow = CreateFrame("Frame", nil, f)
    f.alertGlow:SetAllPoints()
    f.alertGlow:SetFrameLevel(f:GetFrameLevel() + 4)
    f.alertGlow:EnableMouse(false) -- clickthrough

    -- Full frame gradient overlay
    f.alertGlow.overlay = f.alertGlow:CreateTexture(nil, "OVERLAY", nil, 7)
    f.alertGlow.overlay:SetAllPoints()
    f.alertGlow.overlay:SetTexture("Interface\\Buttons\\WHITE8x8")
    f.alertGlow.overlay:SetBlendMode("ADD")

    f.alertGlow:Hide()
end

function GR:SetGlow(f, r, g, b)
    if not f.alertGlow then GR:CreateGlowFrame(f) end
    -- Subtle additive color wash over the whole frame
    f.alertGlow.overlay:SetVertexColor(r, g, b, 0.15)
    f.alertGlow:Show()
end

function GR:ClearGlow(f)
    if f.alertGlow then
        f.alertGlow:Hide()
    end
end

------------------------------------------------------------
-- Raid Warning Alerts
------------------------------------------------------------
local ALERT_COOLDOWN = 4 -- seconds between repeat alerts
local lastAlerts = {} -- [unitIndex] = { type = timestamp }

-- Major offensive CDs that deserve a raid warning
local MAJOR_OFFENSIVES = {
    [12042] = "Arcane Power",
    [34692] = "The Beast Within",
    [31884] = "Avenging Wrath",
    [1719]  = "Recklessness",
    [12292] = "Death Wish",
}

local ALERT_COOLDOWN = 4
local lastAlerts = {}

local function CanAlert(index, alertType)
    local key = index .. "_" .. alertType
    if lastAlerts[key] and (GetTime() - lastAlerts[key]) < ALERT_COOLDOWN then
        return false
    end
    lastAlerts[key] = GetTime()
    return true
end

function GR:UpdateGlow(index)
    local f = GR.frames[index]
    if not f or not f:IsShown() then return end
    local unit = f.unitId
    if not UnitExists(unit) then
        GR:ClearGlow(f)
        return
    end

    local hasDefensive = false
    local hasOffensive = false
    local offensiveName = nil
    local defensiveName = nil

    for j = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, j)
        if not name then break end
        if DEFENSIVE_AURAS[spellId] then
            hasDefensive = true
            defensiveName = defensiveName or name
        end
        if OFFENSIVE_AURAS[spellId] then
            hasOffensive = true
            if MAJOR_OFFENSIVES[spellId] then
                offensiveName = MAJOR_OFFENSIVES[spellId]
            end
        end
    end

    local cfg = GR.db and GR.db.announcements or {}
    local data = GR.arenaData[index]
    local enemyName = data and data.name or UnitName(unit) or "?"
    local hpPct = 0
    local hpMax = UnitHealthMax(unit)
    if hpMax > 0 then
        hpPct = UnitHealth(unit) / hpMax
    end
    local hpPctInt = math.floor(hpPct * 100)

    if hasDefensive then
        GR:SetGlow(f, 1, 0.6, 0)
        if defensiveName and CanAlert(index, "defensive") then
            GR:Announce("ENEMY DEFENSIVE: " .. enemyName .. " (" .. defensiveName .. ")", "defensiveCD", 5)
        end
    elseif hasOffensive then
        GR:SetGlow(f, 1, 0, 0)
        if offensiveName and CanAlert(index, "offensive") then
            GR:Announce("ENEMY OFFENSIVE: " .. enemyName .. " (" .. offensiveName .. ")", "offensiveCD", 4)
        end
    else
        local trinketDown = data and data.trinketUsed > 0
            and (data.trinketUsed + GR.TRINKET_COOLDOWN - GetTime()) > 0
        if trinketDown then
            GR:SetGlow(f, 0, 0.8, 0)
            -- Win condition: low HP + no trinket + no defensives
            local threshold = cfg.enemyLowHPThreshold or 25
            if hpPct > 0 and hpPctInt <= threshold and CanAlert(index, "killable") then
                GR:Announce("KILL TARGET: " .. enemyName .. " (" .. hpPctInt .. "%) NO TRINKET", "killTarget", 4)
            end
        else
            GR:ClearGlow(f)
        end
    end

    -- Enemy low HP announcement (regardless of trinket)
    local enemyThreshold = cfg.enemyLowHPThreshold or 25
    if hpPct > 0 and hpPctInt <= enemyThreshold and not hasDefensive and CanAlert(index, "enemylow") then
        GR:Announce("ENEMY LOW: " .. enemyName .. " (" .. hpPctInt .. "%)", "enemyLowHP", 5)
    end
end

------------------------------------------------------------
-- Teammate Low HP Warning (fires once, resets when above threshold)
------------------------------------------------------------
local teammateWasLow = {} -- [unit] = true when alerted, false/nil when recovered

local function CheckTeammateHP()
    if not GR.inArena then return end
    local cfg = GR.db and GR.db.announcements or {}
    if not cfg.teamLowHP then return end

    local threshold = (cfg.teamLowHPThreshold or 30) / 100
    local units = { "player", "party1", "party2", "party3", "party4" }
    for _, unit in ipairs(units) do
        if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
            local hp = UnitHealth(unit)
            local hpMax = UnitHealthMax(unit)
            if hpMax > 0 then
                local pct = hp / hpMax
                if pct < threshold and pct > 0 then
                    -- Only alert once per drop
                    if not teammateWasLow[unit] then
                        teammateWasLow[unit] = true
                        local name = UnitName(unit) or unit
                        local pctText = math.floor(pct * 100)
                        GR:Announce("TEAM LOW: " .. name .. " (" .. pctText .. "%)", "teamLowHP", 2)
                    end
                else
                    -- Reset when they go back above threshold
                    teammateWasLow[unit] = nil
                end
            end
        end
    end
end

-- Glow + alert update ticker
local glowUpdateFrame = CreateFrame("Frame")
local glowElapsed = 0
glowUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
    glowElapsed = glowElapsed + elapsed
    if glowElapsed < 0.3 then return end
    glowElapsed = 0
    if not GR.inArena and not GR.testMode then return end

    for i = 1, 5 do
        if GR.frames[i] and GR.frames[i]:IsShown() then
            if GR.testMode then
                if i == 1 then
                    GR:SetGlow(GR.frames[i], 1, 0, 0)
                elseif i == 2 then
                    GR:SetGlow(GR.frames[i], 1, 0.6, 0)
                elseif i == 3 then
                    GR:SetGlow(GR.frames[i], 0, 0.8, 0)
                end
            else
                GR:UpdateGlow(i)
            end
        end
    end

    -- Check teammate HP
    if not GR.testMode then
        CheckTeammateHP()
    end
end)
