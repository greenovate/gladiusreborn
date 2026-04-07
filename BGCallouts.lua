local _, GR = ...

------------------------------------------------------------
-- BG Callout Quick Action Bar
-- Auto-detects BG, shows clickable callout buttons
------------------------------------------------------------

local bgBar = nil
local bgBarButtons = {}
local bgBarHeaders = {}
local currentBG = nil

------------------------------------------------------------
-- BG Callout Data
------------------------------------------------------------
local BG_CALLOUTS = {
    -- Arathi Basin: 5 nodes x 3 actions + 3 strategy = grid layout
    ["Arathi Basin"] = {
        cols = 5, -- nodes as columns
        nodes = {
            { name = "BS", color = {1, 0.6, 0.2}, calls = {
                { label = "INC",  msg = "INC BLACKSMITH" },
                { label = "HELP", msg = "NEED HELP BLACKSMITH" },
                { label = "SAFE", msg = "BLACKSMITH SAFE" },
            }},
            { name = "LM", color = {0.3, 0.9, 0.3}, calls = {
                { label = "INC",  msg = "INC LUMBER MILL" },
                { label = "HELP", msg = "NEED HELP LUMBER MILL" },
                { label = "SAFE", msg = "LUMBER MILL SAFE" },
            }},
            { name = "FARM", color = {1, 1, 0.3}, calls = {
                { label = "INC",  msg = "INC FARM" },
                { label = "HELP", msg = "NEED HELP FARM" },
                { label = "SAFE", msg = "FARM SAFE" },
            }},
            { name = "MINE", color = {0.4, 0.6, 1}, calls = {
                { label = "INC",  msg = "INC MINE" },
                { label = "HELP", msg = "NEED HELP MINE" },
                { label = "SAFE", msg = "MINE SAFE" },
            }},
            { name = "ST", color = {0.8, 0.4, 1}, calls = {
                { label = "INC",  msg = "INC STABLES" },
                { label = "HELP", msg = "NEED HELP STABLES" },
                { label = "SAFE", msg = "STABLES SAFE" },
            }},
        },
        strategy = {
            { label = "HOLD 3",  msg = "HOLD 3 BASES - DEFEND DONT PUSH", color = {1, 0.82, 0} },
            { label = "NO DEF",  msg = "NO ONE IS DEFENDING - GET BACK",  color = {1, 0, 0} },
            { label = "ALL IN",  msg = "ALL IN - PUSH TOGETHER",          color = {1, 0.82, 0} },
        },
    },
    -- Eye of the Storm: 4 nodes + flag + strategy
    ["Eye of the Storm"] = {
        cols = 4,
        nodes = {
            { name = "MT", color = {0.3, 0.5, 1}, calls = {
                { label = "INC",  msg = "INC MAGE TOWER" },
                { label = "HELP", msg = "NEED HELP MAGE TOWER" },
                { label = "SAFE", msg = "MAGE TOWER SAFE" },
            }},
            { name = "DR", color = {0.7, 0.3, 1}, calls = {
                { label = "INC",  msg = "INC DRAENEI RUINS" },
                { label = "HELP", msg = "NEED HELP DRAENEI RUINS" },
                { label = "SAFE", msg = "DRAENEI RUINS SAFE" },
            }},
            { name = "BET", color = {1, 0.3, 0.3}, calls = {
                { label = "INC",  msg = "INC BLOOD ELF TOWER" },
                { label = "HELP", msg = "NEED HELP BLOOD ELF TOWER" },
                { label = "SAFE", msg = "BLOOD ELF TOWER SAFE" },
            }},
            { name = "FRR", color = {0.3, 1, 0.3}, calls = {
                { label = "INC",  msg = "INC FEL REAVER RUINS" },
                { label = "HELP", msg = "NEED HELP FEL REAVER" },
                { label = "SAFE", msg = "FEL REAVER SAFE" },
            }},
        },
        strategy = {
            { label = "FLAG MID",  msg = "FLAG IS AT MID",               color = {1, 0.82, 0} },
            { label = "GET FLAG",  msg = "GET THE FLAG",                  color = {1, 0.82, 0} },
            { label = "CAP FLAG",  msg = "CAPPING FLAG",                  color = {1, 0.82, 0} },
            { label = "HAVE FLAG", msg = "I HAVE THE FLAG",               color = {1, 0.82, 0} },
            { label = "HOLD 3",    msg = "HOLD 3 TOWERS - DEFEND DONT PUSH", color = {1, 0.82, 0} },
            { label = "NO DEF",    msg = "NO ONE IS DEFENDING - GET BACK",    color = {1, 0, 0} },
            { label = "ALL MID",   msg = "ALL MID FOR FLAG",                  color = {1, 0.82, 0} },
        },
    },
    -- Warsong Gulch
    ["Warsong Gulch"] = {
        { label = "EFC TUN",    msg = "EFC COMING OUT TUNNEL" },
        { label = "EFC RAMP",   msg = "EFC ON RAMP" },
        { label = "EFC ROOF",   msg = "EFC ON ROOF" },
        { label = "EFC GY",     msg = "EFC AT GRAVEYARD" },
        { label = "EFC MID",    msg = "EFC MIDFIELD" },
        { label = "EFC BASE",   msg = "EFC IN BASE" },
        { label = "HELP FC",    msg = "HELP FC - NEED PEEL" },
        { label = "FC LOW",     msg = "OUR FC IS LOW - HELP" },
        { label = "INC BASE",   msg = "INC OUR BASE" },
        { label = "GET FLAG",   msg = "GET THEIR FLAG" },
        { label = "SAFE",       msg = "FLAG ROOM CLEAR" },
        { label = "RETURN",     msg = "RETURN FLAG NOW",                 color = {1, 0.82, 0} },
        { label = "HAVE FLAG",  msg = "I HAVE THE FLAG",                 color = {1, 0.82, 0} },
    },
    -- Alterac Valley
    ["Alterac Valley"] = {
        { label = "INC SHGY",   msg = "INC STONEHEARTH GY" },
        { label = "INC IBGY",   msg = "INC ICEBLOOD GY" },
        { label = "INC TOWER",  msg = "INC TOWER - NEED HELP" },
        { label = "RUSH DREK",  msg = "RUSH DREK - GO GO GO" },
        { label = "RUSH VAN",   msg = "RUSH VANN - GO GO GO" },
        { label = "DEF BRIDGE", msg = "DEFEND BRIDGE" },
        { label = "RECAP",      msg = "RECAP NOW" },
        { label = "SAFE",       msg = "NODE SAFE" },
    },
}

-- Fallback generic callouts
local GENERIC_CALLOUTS = {
    { label = "INC",       msg = "INCOMING" },
    { label = "HELP",      msg = "NEED HELP" },
    { label = "SAFE",      msg = "ALL CLEAR" },
    { label = "FALL BACK", msg = "FALL BACK - REGROUP" },
    { label = "PUSH",      msg = "PUSH NOW" },
    { label = "OOM",       msg = "HEALER OOM" },
}

------------------------------------------------------------
-- Send to BG chat (per-button cooldown)
------------------------------------------------------------
local CALLOUT_COOLDOWN = 5
local buttonCooldowns = {} -- [button] = expireTime

local function SendBGMessage(msg, btn)
    local now = GetTime()
    if btn and buttonCooldowns[btn] and now < buttonCooldowns[btn] then
        return false
    end

    if btn then
        buttonCooldowns[btn] = now + CALLOUT_COOLDOWN
    end

    local chatType = "SAY"
    if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
        chatType = "INSTANCE_CHAT"
    elseif IsInRaid() then
        chatType = "RAID"
    elseif IsInGroup() then
        chatType = "PARTY"
    end
    local formatted = "[GladiusReborn] " .. msg:sub(1,1) .. msg:sub(2):lower()
    SendChatMessage(formatted, chatType)
    return true
end

------------------------------------------------------------
-- Create BG Bar
------------------------------------------------------------
local BUTTON_W = 78
local BUTTON_H = 22
local BUTTONS_PER_ROW = 6
local BAR_PAD = 4

function GR:CreateBGBar()
    if bgBar then return end

    bgBar = CreateFrame("Frame", "GladiusReborn_BGBar", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    bgBar:SetMovable(true)
    bgBar:EnableMouse(true)
    bgBar:SetClampedToScreen(true)
    bgBar:RegisterForDrag("LeftButton")
    bgBar:SetScript("OnDragStart", function(self) self:StartMoving() end)
    bgBar:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relPoint, x, y = self:GetPoint()
        if GR.db then
            GR.db.bgBarPosition = { point = point, relPoint = relPoint, x = x, y = y }
        end
    end)
    -- Restore saved position
    if GR.db and GR.db.bgBarPosition then
        local p = GR.db.bgBarPosition
        bgBar:ClearAllPoints()
        bgBar:SetPoint(p.point or "TOP", UIParent, p.relPoint or "TOP", p.x or 0, p.y or -40)
    else
        bgBar:SetPoint("TOP", UIParent, "TOP", 0, -40)
    end
    bgBar:SetFrameStrata("MEDIUM")

    if bgBar.SetBackdrop then
        bgBar:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
            edgeFile = "Interface\\Buttons\\WHITE8x8",
            edgeSize = 1,
        })
        bgBar:SetBackdropColor(0.06, 0.06, 0.06, 0.9)
        bgBar:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)
    end

    -- Title
    bgBar.title = bgBar:CreateFontString(nil, "OVERLAY")
    bgBar.title:SetPoint("TOPLEFT", BAR_PAD, -BAR_PAD)
    bgBar.title:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    bgBar.title:SetTextColor(1, 0.82, 0)

    -- Close button
    local cls = CreateFrame("Button", nil, bgBar)
    cls:SetSize(14, 14); cls:SetPoint("TOPRIGHT", -2, -2)
    local clsT = cls:CreateFontString(nil, "OVERLAY")
    clsT:SetPoint("CENTER"); clsT:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE"); clsT:SetText("x"); clsT:SetTextColor(1, 0.3, 0.3)
    cls:SetScript("OnClick", function() bgBar:Hide() end)

    -- Scoreboard toggle button (always visible in title bar)
    local scoreBtn = CreateFrame("Button", nil, bgBar, BackdropTemplateMixin and "BackdropTemplate" or nil)
    scoreBtn:SetSize(50, 14); scoreBtn:SetPoint("TOPRIGHT", -20, -2)
    if scoreBtn.SetBackdrop then
        scoreBtn:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8", edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=1})
        scoreBtn:SetBackdropColor(0.15, 0.15, 0.15, 1)
        scoreBtn:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
    end
    local scoreTxt = scoreBtn:CreateFontString(nil, "OVERLAY")
    scoreTxt:SetPoint("CENTER"); scoreTxt:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE"); scoreTxt:SetText("Score"); scoreTxt:SetTextColor(0.3, 0.8, 1)
    scoreBtn:SetScript("OnClick", function() GR:ToggleScoreboard() end)
    scoreBtn:SetScript("OnEnter", function() scoreBtn:SetBackdropBorderColor(1, 0.82, 0) end)
    scoreBtn:SetScript("OnLeave", function() scoreBtn:SetBackdropBorderColor(0.3, 0.3, 0.3) end)

    bgBar:Hide()
end

------------------------------------------------------------
-- Populate buttons for a specific BG
------------------------------------------------------------
function GR:PopulateBGBar(bgData, bgName)
    if not bgBar then GR:CreateBGBar() end

    for _, btn in ipairs(bgBarButtons) do btn:Hide(); btn:SetParent(nil) end
    wipe(bgBarButtons)
    for _, h in ipairs(bgBarHeaders) do h:Hide() end
    wipe(bgBarHeaders)
    bgBar.title:SetText(bgName or "Battleground")

    -- Helper: create a callout button
    local function MakeButton(parent, callout, color, x, y)
        local c = callout.color or color or {1, 1, 1}
        local btn = CreateFrame("Button", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
        btn:SetSize(BUTTON_W, BUTTON_H)
        btn:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        if btn.SetBackdrop then
            btn:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8", edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=1})
            btn:SetBackdropColor(0.12, 0.12, 0.12, 1)
            btn:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
        end
        local t = btn:CreateFontString(nil, "OVERLAY")
        t:SetPoint("CENTER"); t:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
        t:SetText(callout.label); t:SetTextColor(c[1], c[2], c[3])
        local accent = btn:CreateTexture(nil, "OVERLAY")
        accent:SetWidth(2); accent:SetPoint("TOPLEFT"); accent:SetPoint("BOTTOMLEFT")
        accent:SetColorTexture(c[1], c[2], c[3], 0.8)
        local cdBar = btn:CreateTexture(nil, "ARTWORK", nil, 1)
        cdBar:SetPoint("TOPLEFT"); cdBar:SetPoint("BOTTOMLEFT"); cdBar:SetWidth(0)
        cdBar:SetColorTexture(0.3, 0.3, 0.3, 0.5); cdBar:Hide()
        btn:SetScript("OnClick", function()
            local sent = SendBGMessage(callout.msg, btn)
            if sent then
                btn:SetBackdropColor(0.2, 0.8, 0.2, 0.6)
                C_Timer.After(0.3, function() if btn.SetBackdropColor then btn:SetBackdropColor(0.12, 0.12, 0.12, 1) end end)
                cdBar:SetWidth(BUTTON_W); cdBar:Show()
                local st = GetTime()
                btn:SetScript("OnUpdate", function(self)
                    local r = CALLOUT_COOLDOWN - (GetTime() - st)
                    if r <= 0 then cdBar:Hide(); cdBar:SetWidth(0); self:SetScript("OnUpdate", nil); return end
                    cdBar:SetWidth(BUTTON_W * (r / CALLOUT_COOLDOWN))
                end)
            end
        end)
        btn:SetScript("OnEnter", function() btn:SetBackdropBorderColor(1, 0.82, 0, 1)
            GameTooltip:SetOwner(btn, "ANCHOR_TOP"); GameTooltip:SetText(callout.msg, 1, 1, 1); GameTooltip:Show() end)
        btn:SetScript("OnLeave", function() btn:SetBackdropBorderColor(0.2, 0.2, 0.2, 1); GameTooltip:Hide() end)
        tinsert(bgBarButtons, btn)
        return btn
    end

    -- Check if this is the new columnar format (has .nodes)
    if bgData.nodes then
        local numCols = #bgData.nodes
        local maxRows = 0
        for _, node in ipairs(bgData.nodes) do
            if #node.calls > maxRows then maxRows = #node.calls end
        end

        local colW = BUTTON_W + 1
        local titleH = 14
        local headerH = 12
        local strategyRows = bgData.strategy and math.ceil(#bgData.strategy / numCols) or 0

        local barW = numCols * colW + BAR_PAD * 2
        local barH = titleH + BAR_PAD + headerH + maxRows * (BUTTON_H + 1) + strategyRows * (BUTTON_H + 1) + BAR_PAD + 4
        bgBar:SetWidth(barW)
        bgBar:SetHeight(barH)

        -- Node columns with header labels
        for col, node in ipairs(bgData.nodes) do
            local cx = BAR_PAD + (col - 1) * colW

            -- Node header label
            local header = bgBar:CreateFontString(nil, "OVERLAY")
            header:SetPoint("TOP", bgBar, "TOPLEFT", cx + BUTTON_W / 2, -(titleH + BAR_PAD))
            header:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
            header:SetText(node.name)
            header:SetTextColor(node.color[1], node.color[2], node.color[3])
            header:SetJustifyH("CENTER")
            tinsert(bgBarHeaders, header)

            -- Callout buttons stacked vertically
            for row, call in ipairs(node.calls) do
                local by = -(titleH + BAR_PAD + headerH + (row - 1) * (BUTTON_H + 1))
                MakeButton(bgBar, call, node.color, cx, by)
            end
        end

        -- Strategy row at bottom
        if bgData.strategy then
            local stratY = -(titleH + BAR_PAD + headerH + maxRows * (BUTTON_H + 1) + 2)
            for i, strat in ipairs(bgData.strategy) do
                local col = (i - 1) % numCols
                local row = math.floor((i - 1) / numCols)
                MakeButton(bgBar, strat, strat.color, BAR_PAD + col * colW, stratY - row * (BUTTON_H + 1))
            end
        end
    else
        -- Flat format (WSG, AV, generic) — horizontal rows
        local numButtons = #bgData
        local cols = math.min(numButtons, BUTTONS_PER_ROW)
        local rows = math.ceil(numButtons / BUTTONS_PER_ROW)
        bgBar:SetSize(cols * (BUTTON_W + 2) + BAR_PAD * 2, rows * (BUTTON_H + 2) + 20 + BAR_PAD * 2)

        for i, callout in ipairs(bgData) do
            local row = math.floor((i - 1) / BUTTONS_PER_ROW)
            local col = (i - 1) % BUTTONS_PER_ROW
            MakeButton(bgBar, callout, callout.color, BAR_PAD + col * (BUTTON_W + 2), -(18 + BAR_PAD + row * (BUTTON_H + 2)))
        end
    end

    bgBar:Show()
end

------------------------------------------------------------
-- Detect BG and show bar
------------------------------------------------------------
function GR:DetectAndShowBGBar()
    local cfg = GR.db and GR.db.announcements
    if cfg and cfg.bgCallouts == false then return end

    local _, instanceType = IsInInstance()
    if instanceType ~= "pvp" then
        if bgBar then bgBar:Hide() end
        currentBG = nil
        return
    end

    -- Get BG name
    local zoneName = GetRealZoneText() or GetZoneText() or ""

    -- Match against our callout data
    local callouts = nil
    local matchedName = nil
    for bgName, data in pairs(BG_CALLOUTS) do
        if zoneName:find(bgName) then
            callouts = data
            matchedName = bgName
            break
        end
    end

    -- Fallback to generic
    if not callouts then
        callouts = GENERIC_CALLOUTS
        matchedName = zoneName ~= "" and zoneName or "Battleground"
    end

    if currentBG ~= matchedName then
        currentBG = matchedName
        GR:PopulateBGBar(callouts, matchedName)
    end
end

------------------------------------------------------------
-- Events: detect BG entry/exit
------------------------------------------------------------
local bgEventFrame = CreateFrame("Frame")
bgEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
bgEventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
bgEventFrame:SetScript("OnEvent", function(self, event)
    C_Timer.After(1, function()
        GR:DetectAndShowBGBar()
    end)
end)

------------------------------------------------------------
-- Toggle Preview (for options panel)
------------------------------------------------------------
function GR:ToggleBGPreview()
    if bgBar and bgBar:IsShown() then
        bgBar:Hide()
        return
    end
    GR:PopulateBGBar(BG_CALLOUTS["Arathi Basin"], "Preview: Arathi Basin")
end

------------------------------------------------------------
-- BG Scoreboard Fix
-- Makes the scoreboard not block the spirit release button
-- Also adds a toggle keybind/button to open scoreboard anytime
------------------------------------------------------------
local scoreboardFixed = false

function GR:FixBGScoreboard()
    if scoreboardFixed then return end
    scoreboardFixed = true

    -- Instead of fixing the scoreboard, make ALL release popups always top
    -- This works regardless of what frame is covering them
    local enforcer = CreateFrame("Frame")
    local enfElapsed = 0
    enforcer:SetScript("OnUpdate", function(self, elapsed)
        enfElapsed = enfElapsed + elapsed
        if enfElapsed < 0.3 then return end
        enfElapsed = 0

        local _, instanceType = IsInInstance()
        if instanceType ~= "pvp" and instanceType ~= "arena" then return end

        -- Force release popup to highest strata
        for i = 1, 4 do
            local dialog = _G["StaticPopup" .. i]
            if dialog and dialog:IsShown() then
                local which = dialog.which
                if which == "DEATH" or which == "CONFIRM_BATTLEFIELD_ENTRY"
                    or which == "RESURRECT" or which == "RESURRECT_NO_TIMER"
                    or which == "SKINNED" or which == "AREA_SPIRIT_HEAL" then
                    dialog:SetFrameStrata("FULLSCREEN_DIALOG")
                    dialog:SetFrameLevel(999)
                    dialog:Raise()
                end
            end
        end
    end)
end

-- Toggle scoreboard
function GR:ToggleScoreboard()
    -- Try to toggle the BG scoreboard
    if ToggleWorldStateScoreFrame then
        ToggleWorldStateScoreFrame()
    end
end

-- Auto-fix on BG entry
local sbFixFrame = CreateFrame("Frame")
sbFixFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
sbFixFrame:SetScript("OnEvent", function()
    C_Timer.After(2, function()
        local _, instanceType = IsInInstance()
        if instanceType == "pvp" then
            GR:FixBGScoreboard()
        end
    end)
end)
