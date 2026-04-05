local _, GR = ...

------------------------------------------------------------
-- Arena Utilities: Eye Tracker + Prep Checklist
------------------------------------------------------------

------------------------------------------------------------
-- Eye of the Storm Tracker (Shadow Sight orbs)
-- Small movable frame showing time until orbs spawn
------------------------------------------------------------
local EYE_SPAWN_TIME = 90 -- Shadow Sight spawns 90s into arena
local EYE_RESPAWN = 90    -- Respawns every 90s after pickup

local eyeFrame = nil
local eyeActive = false
local eyeNextSpawn = 0

function GR:CreateEyeTracker()
    if eyeFrame then return end

    eyeFrame = CreateFrame("Frame", "GladiusReborn_EyeTracker", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    eyeFrame:SetSize(140, 32)
    eyeFrame:SetPoint("TOP", UIParent, "TOP", 0, -120)
    eyeFrame:SetMovable(true)
    eyeFrame:EnableMouse(true)
    eyeFrame:SetClampedToScreen(true)
    eyeFrame:RegisterForDrag("LeftButton")
    eyeFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    eyeFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    if eyeFrame.SetBackdrop then
        eyeFrame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        eyeFrame:SetBackdropColor(0.05, 0.05, 0.05, 0.85)
        eyeFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    end

    -- Eye icon
    eyeFrame.icon = eyeFrame:CreateTexture(nil, "ARTWORK")
    eyeFrame.icon:SetSize(20, 20)
    eyeFrame.icon:SetPoint("LEFT", eyeFrame, "LEFT", 6, 0)
    eyeFrame.icon:SetTexture("Interface\\Icons\\Spell_Shadow_EvilEye")
    eyeFrame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    -- Timer text
    eyeFrame.text = eyeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    eyeFrame.text:SetPoint("LEFT", eyeFrame.icon, "RIGHT", 6, 0)
    eyeFrame.text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    eyeFrame.text:SetText("Eye: --")
    eyeFrame.text:SetTextColor(0.7, 0.5, 1)

    -- Status bar
    eyeFrame.bar = CreateFrame("StatusBar", nil, eyeFrame)
    eyeFrame.bar:SetPoint("BOTTOMLEFT", eyeFrame, "BOTTOMLEFT", 4, 3)
    eyeFrame.bar:SetPoint("BOTTOMRIGHT", eyeFrame, "BOTTOMRIGHT", -4, 3)
    eyeFrame.bar:SetHeight(3)
    eyeFrame.bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    eyeFrame.bar:SetStatusBarColor(0.6, 0.3, 1)
    eyeFrame.bar:SetMinMaxValues(0, EYE_SPAWN_TIME)
    eyeFrame.bar:SetValue(0)

    eyeFrame:SetScript("OnUpdate", function(self, elapsed)
        if not eyeActive then return end
        local remaining = eyeNextSpawn - GetTime()
        if remaining <= 0 then
            self.text:SetText("EYE UP!")
            self.text:SetTextColor(0, 1, 0)
            self.bar:SetValue(EYE_SPAWN_TIME)
        else
            local mins = math.floor(remaining / 60)
            local secs = math.floor(remaining % 60)
            self.text:SetText(format("Eye: %d:%02d", mins, secs))
            self.text:SetTextColor(0.7, 0.5, 1)
            self.bar:SetValue(EYE_SPAWN_TIME - remaining)

            -- Alert at 10s
            if remaining <= 10 and remaining > 9.5 then
                GR:Announce("EYE SPAWNING IN 10s", "offensive", 15)
            end
        end
    end)

    eyeFrame:Hide()
end

function GR:StartEyeTracker()
    local cfg = GR.db and GR.db.announcements
    if cfg and cfg.eyeTracker == false then return end
    if not eyeFrame then GR:CreateEyeTracker() end
    -- Don't start countdown yet — wait for gates open
    eyeActive = false
    eyeNextSpawn = 0
    eyeFrame.text:SetText("Eye: waiting...")
    eyeFrame.text:SetTextColor(0.5, 0.5, 0.5)
    eyeFrame.bar:SetValue(0)
    eyeFrame:Show()
end

-- Called when gates actually open (first opponent seen)
function GR:OnArenaGatesOpen()
    if eyeFrame and eyeFrame:IsShown() then
        eyeActive = true
        eyeNextSpawn = GetTime() + EYE_SPAWN_TIME
    end
    -- Hide prep checklist
    GR:HidePrepChecklist()
end

function GR:StopEyeTracker()
    eyeActive = false
    if eyeFrame then eyeFrame:Hide() end
end

-- Detect Shadow Sight pickup from combat log
function GR:CheckEyePickup(spellId, spellName)
    if spellName == "Shadow Sight" or spellId == 34709 then
        -- Eye was picked up, start respawn timer
        eyeNextSpawn = GetTime() + EYE_RESPAWN
        if eyeFrame then
            eyeFrame.text:SetText("Eye respawning...")
            eyeFrame.text:SetTextColor(1, 0.5, 0)
        end
    end
end

------------------------------------------------------------
-- Arena Prep Checklist
-- Shows countdown bars reminding you what to do before gates
------------------------------------------------------------
local prepFrame = nil
local prepItems = {}
local gatesOpenTime = 0
local PREP_DURATION = 60 -- 60s prep phase

-- Class-specific checks
local CLASS_CHECKS = {
    ALL = {
        {
            name = "PvP Trinket",
            check = function()
                -- Check trinket slot (13 and 14)
                local t1 = GetInventoryItemLink("player", 13)
                local t2 = GetInventoryItemLink("player", 14)
                local hasPvP = false
                if t1 and t1:find("Medallion") then hasPvP = true end
                if t2 and t2:find("Medallion") then hasPvP = true end
                -- Also check by item equip slot
                for slot = 13, 14 do
                    local id = GetInventoryItemID("player", slot)
                    if id then
                        -- Common TBC PvP trinket item IDs
                        local pvpTrinkets = {
                            [29593]=true,[29594]=true,[29595]=true,[29596]=true,
                            [29597]=true,[29598]=true,[30348]=true,[30349]=true,
                            [30350]=true,[30351]=true,[30352]=true,[30353]=true,
                            [32774]=true,
                        }
                        if pvpTrinkets[id] then hasPvP = true end
                    end
                end
                return hasPvP
            end,
            color = {1, 0.2, 0.2},
        },
    },
    ROGUE = {
        {
            name = "Main Hand Poison",
            check = function()
                local hasEnchant = GetWeaponEnchantInfo()
                return hasEnchant
            end,
            color = {0.2, 0.8, 0.2},
        },
        {
            name = "Off Hand Poison",
            check = function()
                local _, _, _, _, hasOffhand = GetWeaponEnchantInfo()
                return hasOffhand
            end,
            color = {0.2, 0.8, 0.2},
        },
    },
    SHAMAN = {
        {
            name = "Weapon Enchant",
            check = function()
                local hasEnchant = GetWeaponEnchantInfo()
                return hasEnchant
            end,
            color = {0.3, 0.5, 1},
        },
    },
    MAGE = {
        {
            name = "Food/Water",
            check = function()
                -- Check for food/water in bags
                for bag = 0, 4 do
                    for slot = 1, GetContainerNumSlots(bag) do
                        local link = GetContainerItemLink(bag, slot)
                        if link then
                            local name = GetItemInfo(link)
                            if name and (name:find("Conjured") or name:find("Water") or name:find("Manna")) then
                                return true
                            end
                        end
                    end
                end
                return false
            end,
            color = {0.3, 0.7, 1},
        },
    },
    WARLOCK = {
        {
            name = "Healthstone",
            check = function()
                for bag = 0, 4 do
                    for slot = 1, GetContainerNumSlots(bag) do
                        local link = GetContainerItemLink(bag, slot)
                        if link then
                            local name = GetItemInfo(link)
                            if name and name:find("Healthstone") then
                                return true
                            end
                        end
                    end
                end
                return false
            end,
            color = {0.5, 0.2, 0.8},
        },
    },
}

function GR:CreatePrepChecklist()
    if prepFrame then return end

    prepFrame = CreateFrame("Frame", "GladiusReborn_PrepChecklist", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    prepFrame:SetSize(220, 20)
    prepFrame:SetPoint("TOP", UIParent, "TOP", 0, -200)
    prepFrame:SetMovable(true)
    prepFrame:EnableMouse(true)
    prepFrame:SetClampedToScreen(true)
    prepFrame:RegisterForDrag("LeftButton")
    prepFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    prepFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

    if prepFrame.SetBackdrop then
        prepFrame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        prepFrame:SetBackdropColor(0.04, 0.04, 0.04, 0.9)
        prepFrame:SetBackdropBorderColor(0.25, 0.25, 0.25, 0.8)
    end

    -- Title
    prepFrame.title = prepFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    prepFrame.title:SetPoint("TOP", prepFrame, "TOP", 0, -6)
    prepFrame.title:SetText("|cff33ff99Arena Prep|r")
    prepFrame.title:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")

    prepFrame:Hide()
end

function GR:ShowPrepChecklist()
    local cfg = GR.db and GR.db.announcements
    if cfg and cfg.prepChecklist == false then return end
    if not prepFrame then GR:CreatePrepChecklist() end

    local _, playerClass = UnitClass("player")
    local checks = {}

    -- Add universal checks
    if CLASS_CHECKS.ALL then
        for _, c in ipairs(CLASS_CHECKS.ALL) do
            tinsert(checks, c)
        end
    end

    -- Add class-specific checks
    if CLASS_CHECKS[playerClass] then
        for _, c in ipairs(CLASS_CHECKS[playerClass]) do
            tinsert(checks, c)
        end
    end

    -- Clear old items
    for _, item in ipairs(prepItems) do
        item.frame:Hide()
    end
    wipe(prepItems)

    -- Build checklist items
    local y = -22
    for i, check in ipairs(checks) do
        local item = {}

        item.frame = CreateFrame("Frame", nil, prepFrame)
        item.frame:SetSize(200, 22)
        item.frame:SetPoint("TOPLEFT", prepFrame, "TOPLEFT", 10, y)

        -- Status icon
        item.status = item.frame:CreateTexture(nil, "OVERLAY")
        item.status:SetSize(14, 14)
        item.status:SetPoint("LEFT", item.frame, "LEFT", 0, 0)

        -- Label
        item.label = item.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        item.label:SetPoint("LEFT", item.status, "RIGHT", 4, 0)
        item.label:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")

        -- Countdown bar
        item.bar = CreateFrame("StatusBar", nil, item.frame)
        item.bar:SetPoint("LEFT", item.label, "RIGHT", 6, 0)
        item.bar:SetPoint("RIGHT", item.frame, "RIGHT", 0, 0)
        item.bar:SetHeight(8)
        item.bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
        item.bar:SetMinMaxValues(0, PREP_DURATION)
        item.bar:SetValue(PREP_DURATION)

        item.check = check
        item.frame:Show()

        tinsert(prepItems, item)
        y = y - 24
    end

    -- Resize frame to fit
    prepFrame:SetHeight(math.abs(y) + 10)

    gatesOpenTime = GetTime() + PREP_DURATION

    -- Update ticker — keeps running even when hidden to catch new issues
    if not prepFrame.ticker then
        prepFrame.ticker = CreateFrame("Frame")
        local tickElapsed = 0
        prepFrame.ticker:SetScript("OnUpdate", function(self, elapsed)
            if not GR.inArena or GR._gatesOpened then
                prepFrame:Hide()
                return
            end
            tickElapsed = tickElapsed + elapsed
            if tickElapsed < 0.5 then return end
            tickElapsed = 0

            local remaining = gatesOpenTime - GetTime()
            if remaining <= 0 then
                GR:HidePrepChecklist()
                return
            end

            local anyFailing = false
            for _, item in ipairs(prepItems) do
                local passed = item.check.check()
                if passed then
                    item.frame:Hide()
                else
                    anyFailing = true
                    item.status:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
                    item.label:SetText("|cffff3333" .. item.check.name .. "|r")
                    item.bar:Show()
                    local c = item.check.color or {1, 0.5, 0}
                    item.bar:SetStatusBarColor(c[1], c[2], c[3])
                    item.bar:SetValue(remaining)
                    item.frame:Show()
                end
            end

            if anyFailing then
                prepFrame:Show()
            else
                prepFrame:Hide()
            end
        end)
    end
    prepFrame.ticker:Show()

    -- Only show if something is actually missing
    local anyMissing = false
    for _, item in ipairs(prepItems) do
        if not item.check.check() then
            anyMissing = true
            break
        end
    end

    if anyMissing then
        prepFrame:Show()
    end
end

function GR:HidePrepChecklist()
    if prepFrame then
        prepFrame:Hide()
    end
end

------------------------------------------------------------
-- Queue Pop Alert System
------------------------------------------------------------
local queueFrame = nil
local queueActive = false
local queueExpireTime = 0
local QUEUE_ACCEPT_TIME = 90 -- seconds to accept

function GR:CreateQueueFrame()
    if queueFrame then return end

    queueFrame = CreateFrame("Frame", "GladiusReborn_QueueAlert", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    queueFrame:SetSize(260, 50)
    queueFrame:SetPoint("TOP", UIParent, "TOP", 0, -60)
    queueFrame:SetMovable(true)
    queueFrame:EnableMouse(true)
    queueFrame:SetClampedToScreen(true)
    queueFrame:RegisterForDrag("LeftButton")
    queueFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    queueFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    queueFrame:SetFrameStrata("FULLSCREEN_DIALOG")

    if queueFrame.SetBackdrop then
        queueFrame:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 10,
            insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        queueFrame:SetBackdropColor(0.1, 0, 0, 0.95)
        queueFrame:SetBackdropBorderColor(0.8, 0.2, 0.2, 1)
    end

    -- Title
    queueFrame.title = queueFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    queueFrame.title:SetPoint("TOP", queueFrame, "TOP", 0, -8)
    queueFrame.title:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    queueFrame.title:SetText("|cffff3333ARENA QUEUE POP!|r")

    -- Timer text
    queueFrame.timer = queueFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    queueFrame.timer:SetPoint("CENTER", queueFrame, "CENTER", 0, -4)
    queueFrame.timer:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
    queueFrame.timer:SetTextColor(1, 1, 0)

    -- Countdown bar
    queueFrame.bar = CreateFrame("StatusBar", nil, queueFrame)
    queueFrame.bar:SetPoint("BOTTOMLEFT", queueFrame, "BOTTOMLEFT", 6, 5)
    queueFrame.bar:SetPoint("BOTTOMRIGHT", queueFrame, "BOTTOMRIGHT", -6, 5)
    queueFrame.bar:SetHeight(4)
    queueFrame.bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8x8")
    queueFrame.bar:SetStatusBarColor(1, 0.3, 0.3)
    queueFrame.bar:SetMinMaxValues(0, QUEUE_ACCEPT_TIME)

    -- Flash animation
    queueFrame.flash = queueFrame:CreateAnimationGroup()
    local fadeOut = queueFrame.flash:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0.4)
    fadeOut:SetDuration(0.5)
    fadeOut:SetOrder(1)
    local fadeIn = queueFrame.flash:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0.4)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.5)
    fadeIn:SetOrder(2)
    queueFrame.flash:SetLooping("REPEAT")

    queueFrame:SetScript("OnUpdate", function(self, elapsed)
        if not queueActive then return end
        local remaining = queueExpireTime - GetTime()
        if remaining <= 0 then
            self.timer:SetText("EXPIRED")
            self.timer:SetTextColor(1, 0, 0)
            self.bar:SetValue(0)
            queueActive = false
            C_Timer.After(3, function()
                if queueFrame then queueFrame:Hide() end
            end)
            return
        end

        self.timer:SetText(format("%d", math.ceil(remaining)))
        self.bar:SetValue(remaining)

        -- Color changes as time runs out
        if remaining < 15 then
            self.timer:SetTextColor(1, 0, 0)
            self.bar:SetStatusBarColor(1, 0, 0)
        elseif remaining < 30 then
            self.timer:SetTextColor(1, 0.5, 0)
            self.bar:SetStatusBarColor(1, 0.5, 0)
        else
            self.timer:SetTextColor(1, 1, 0)
            self.bar:SetStatusBarColor(1, 0.3, 0.3)
        end
    end)

    queueFrame:Hide()
end

function GR:OnQueuePop()
    local cfg = GR.db and GR.db.announcements
    if cfg and cfg.queueAlert == false then return end

    if not queueFrame then GR:CreateQueueFrame() end

    queueActive = true
    queueExpireTime = GetTime() + QUEUE_ACCEPT_TIME
    queueFrame:Show()
    queueFrame.flash:Play()

    -- Play sound even when game is minimized
    PlaySound(8959, "Master") -- PVPENTERQUEUE sound
    -- Use Master channel so it plays when minimized

    -- Flash the taskbar
    FlashClientIcon()
end

function GR:OnQueueAcceptOrDecline()
    queueActive = false
    if queueFrame then
        queueFrame.flash:Stop()
        queueFrame:Hide()
    end
end

-- Register queue events
local queueEventFrame = CreateFrame("Frame")
queueEventFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
queueEventFrame:RegisterEvent("BATTLEFIELD_MGR_QUEUE_REQUEST_RESPONSE")
queueEventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "UPDATE_BATTLEFIELD_STATUS" then
        for i = 1, GetMaxBattlefieldID() do
            local status, mapName, teamSize, registeredMatch, suspendedQueue, queueType, gameId, role, asGroup, shortDescription, longDescription = GetBattlefieldStatus(i)
            if status == "confirm" then
                -- Queue popped!
                if not queueActive then
                    GR:OnQueuePop()
                end
                return
            end
        end
        -- If we get here and queue was active, it was accepted or declined
        if queueActive then
            GR:OnQueueAcceptOrDecline()
        end
    end
end)
