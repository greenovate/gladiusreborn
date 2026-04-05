local _, GR = ...
------------------------------------------------------------
-- Options Panel — ElvUI-quality design
------------------------------------------------------------
local PANEL_W, PANEL_H = 880, 560
local SIDEBAR_W = 145
local GOLD = {1, 0.82, 0}
local WHITE = {1, 1, 1}
local GRAY = {0.6, 0.6, 0.6}
local LGRAY = {0.4, 0.4, 0.4}
local GREEN = {0.2, 1, 0.2}
local RED = {1, 0.2, 0.2}
local BG = {0.06, 0.06, 0.06, 0.92}
local BORDER = {0.15, 0.15, 0.15, 1}
local WBG = {0.1, 0.1, 0.1, 1}
local ROW = 22
local GAP = 10
local PAD = 8
local COL1 = 0
local COL2 -- set dynamically based on content width
local CONTENT_W -- set dynamically
local ddN = 0

local optFrame, cFrames, sBtns, activeCat = nil, {}, {}, nil

-- ElvUI-style 1px border backdrop
local function Skin(f, bg, bd)
    if not f.SetBackdrop then return end
    f:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8x8", edgeFile="Interface\\Buttons\\WHITE8x8", edgeSize=1})
    f:SetBackdropColor((bg or BG)[1], (bg or BG)[2], (bg or BG)[3], (bg or BG)[4] or 1)
    f:SetBackdropBorderColor((bd or BORDER)[1], (bd or BORDER)[2], (bd or BORDER)[3], (bd or BORDER)[4] or 1)
end

------------------------------------------------------------
-- Widgets
------------------------------------------------------------

-- Bordered inline group (ElvUI-style section container)
-- Returns the inner frame to place widgets in, and the bottom y
local function W_Group(p, title, y, height)
    height = height or 100

    -- Title above the group
    local label = p:CreateFontString(nil, "OVERLAY")
    label:SetPoint("TOPLEFT", 0, y)
    label:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    label:SetText(title)
    label:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    -- Bordered container
    local grp = CreateFrame("Frame", nil, p, BackdropTemplateMixin and "BackdropTemplate" or nil)
    grp:SetPoint("TOPLEFT", 0, y - 14)
    grp:SetPoint("RIGHT", p, "RIGHT")
    grp:SetHeight(height)
    Skin(grp, {0.04, 0.04, 0.04, 0.6}, {0.2, 0.2, 0.2, 0.6})

    -- Inner frame for content (padded inside the group)
    local inner = CreateFrame("Frame", nil, grp)
    inner:SetPoint("TOPLEFT", PAD, -PAD + 2)
    inner:SetPoint("BOTTOMRIGHT", -PAD, PAD)

    return inner, y - 14 - height - 4
end

local function W_Header(p, text, y)
    local h = p:CreateFontString(nil, "OVERLAY")
    h:SetPoint("TOPLEFT", 0, y); h:SetPoint("RIGHT", p, "RIGHT")
    h:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    h:SetText(text); h:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    h:SetJustifyH("LEFT")
    local l = p:CreateTexture(nil, "ARTWORK")
    l:SetHeight(1); l:SetPoint("TOPLEFT", h, "BOTTOMLEFT", 0, -1)
    l:SetPoint("RIGHT", p, "RIGHT"); l:SetColorTexture(0.2, 0.2, 0.2, 0.8)
    return y - 18
end

local function W_Info(p, text, y)
    local t = p:CreateFontString(nil, "OVERLAY")
    t:SetPoint("TOPLEFT", 0, y); t:SetWidth(CONTENT_W or 600)
    t:SetJustifyH("LEFT"); t:SetFont(STANDARD_TEXT_FONT, 9, "")
    t:SetText(text); t:SetTextColor(GRAY[1], GRAY[2], GRAY[3])
    return y - 13
end

local function W_Check(p, text, x, y, get, set, tip)
    local f = CreateFrame("Button", nil, p)
    f:SetSize((CONTENT_W or 600)/2 - 6, 18)
    f:SetPoint("TOPLEFT", x, y)

    local bx = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate" or nil)
    bx:SetSize(14, 14); bx:SetPoint("LEFT", 0, 0); Skin(bx, WBG, BORDER)

    local ck = bx:CreateTexture(nil, "OVERLAY")
    ck:SetSize(10, 10); ck:SetPoint("CENTER")
    ck:SetTexture("Interface\\Buttons\\WHITE8x8")

    local lb = f:CreateFontString(nil, "OVERLAY")
    lb:SetPoint("LEFT", bx, "RIGHT", 4, 0)
    lb:SetFont(STANDARD_TEXT_FONT, 10, ""); lb:SetText(text); lb:SetTextColor(1,1,1)

    local function R()
        if get() then ck:SetVertexColor(GREEN[1],GREEN[2],GREEN[3],1)
        else ck:SetVertexColor(RED[1],RED[2],RED[3],0.4) end
    end
    R()

    f:SetScript("OnClick", function() set(not get()); R() end)
    f:SetScript("OnEnter", function(s)
        bx:SetBackdropBorderColor(GOLD[1],GOLD[2],GOLD[3])
        if tip then GameTooltip:SetOwner(s,"ANCHOR_RIGHT"); GameTooltip:SetText(text,1,1,1); GameTooltip:AddLine(tip,nil,nil,nil,true); GameTooltip:Show() end
    end)
    f:SetScript("OnLeave", function() bx:SetBackdropBorderColor(BORDER[1],BORDER[2],BORDER[3]); GameTooltip:Hide() end)
    return f
end

-- Two checkboxes on same row
local function W_Check2(p, t1, g1, s1, t2, g2, s2, y, tip1, tip2)
    W_Check(p, t1, COL1, y, g1, s1, tip1)
    if t2 then W_Check(p, t2, COL2 or ((CONTENT_W or 600)/2), y, g2, s2, tip2) end
    return y - ROW
end

local function W_Slider(p, text, x, y, lo, hi, step, get, set, fmt)
    fmt = fmt or "%.1f"
    local w = (CONTENT_W or 600)/2 - 10

    local lb = p:CreateFontString(nil, "OVERLAY")
    lb:SetPoint("TOPLEFT", x, y); lb:SetFont(STANDARD_TEXT_FONT, 10, ""); lb:SetText(text); lb:SetTextColor(1,1,1)

    local vt = p:CreateFontString(nil, "OVERLAY")
    vt:SetPoint("LEFT", lb, "RIGHT", 4, 0); vt:SetFont(STANDARD_TEXT_FONT, 10, "")
    vt:SetTextColor(GOLD[1],GOLD[2],GOLD[3])

    local s = CreateFrame("Slider", nil, p)
    s:SetSize(w, 12); s:SetPoint("TOPLEFT", x, y-13)
    s:SetMinMaxValues(lo, hi); s:SetValueStep(step); s:SetObeyStepOnDrag(true)
    s:SetOrientation("HORIZONTAL"); s:EnableMouse(true)

    local tr = CreateFrame("Frame", nil, s, BackdropTemplateMixin and "BackdropTemplate" or nil)
    tr:SetPoint("LEFT"); tr:SetPoint("RIGHT"); tr:SetHeight(5); Skin(tr, WBG, BORDER)

    local th = s:CreateTexture(nil, "OVERLAY")
    th:SetSize(8, 14); th:SetTexture("Interface\\Buttons\\WHITE8x8")
    th:SetVertexColor(GOLD[1],GOLD[2],GOLD[3],0.8)
    s:SetThumbTexture(th)

    s:SetValue(get()); vt:SetText(format(fmt, get()))
    s:SetScript("OnValueChanged", function(_, v)
        v = math.floor(v/step+0.5)*step; vt:SetText(format(fmt, v)); set(v)
    end)
    s:SetScript("OnEnter", function() th:SetVertexColor(1,1,1,1) end)
    s:SetScript("OnLeave", function() th:SetVertexColor(GOLD[1],GOLD[2],GOLD[3],0.8) end)
    return y - 30
end

-- Two sliders side by side
local function W_Slider2(p, t1, lo1, hi1, st1, g1, s1, f1, t2, lo2, hi2, st2, g2, s2, f2, y)
    W_Slider(p, t1, COL1, y, lo1, hi1, st1, g1, s1, f1)
    if t2 then W_Slider(p, t2, COL2 or ((CONTENT_W or 600)/2), y, lo2, hi2, st2, g2, s2, f2) end
    return y - 30
end

local function W_Drop(p, text, x, y, items, get, set)
    ddN = ddN + 1; local w = (CONTENT_W or 600)/2 - 10

    local lb = p:CreateFontString(nil, "OVERLAY")
    lb:SetPoint("TOPLEFT", x, y); lb:SetFont(STANDARD_TEXT_FONT, 10, ""); lb:SetText(text); lb:SetTextColor(1,1,1)

    local btn = CreateFrame("Button", "GRD"..ddN, p, BackdropTemplateMixin and "BackdropTemplate" or nil)
    btn:SetSize(w, 18); btn:SetPoint("TOPLEFT", x, y-12)
    Skin(btn, WBG, BORDER)

    local bt = btn:CreateFontString(nil, "OVERLAY")
    bt:SetPoint("LEFT", 5, 0); bt:SetPoint("RIGHT", -16, 0)
    bt:SetFont(STANDARD_TEXT_FONT, 9, ""); bt:SetJustifyH("LEFT")
    bt:SetText(items[get()] or ""); bt:SetTextColor(1,1,1)

    local ar = btn:CreateTexture(nil, "OVERLAY")
    ar:SetSize(8,8); ar:SetPoint("RIGHT", -4, 0)
    ar:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")

    local keys = {}
    for k in pairs(items) do keys[#keys+1] = k end
    table.sort(keys, function(a,b)
        if type(a)=="number" and type(b)=="number" then return a<b end
        return tostring(a)<tostring(b)
    end)

    local menu = CreateFrame("Frame", nil, btn)
    menu:SetSize(w, #keys*17+4); menu:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, 0)
    menu:SetFrameStrata("FULLSCREEN_DIALOG"); menu:SetFrameLevel(btn:GetFrameLevel()+20); menu:Hide()

    local mbg = CreateFrame("Frame", nil, menu, BackdropTemplateMixin and "BackdropTemplate" or nil)
    mbg:SetAllPoints(); Skin(mbg, BG, BORDER)

    for i, key in ipairs(keys) do
        local it = CreateFrame("Button", nil, menu)
        it:SetSize(w-4, 17); it:SetPoint("TOPLEFT", 2, -(i-1)*17-2)
        local hl = it:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints(); hl:SetTexture("Interface\\Buttons\\WHITE8x8"); hl:SetVertexColor(GOLD[1],GOLD[2],GOLD[3],0.1)
        local t = it:CreateFontString(nil, "OVERLAY")
        t:SetPoint("LEFT", 5, 0); t:SetFont(STANDARD_TEXT_FONT, 9, ""); t:SetText(items[key]); t:SetTextColor(1,1,1)
        it:SetScript("OnClick", function() set(key); bt:SetText(items[key]); menu:Hide() end)
    end

    btn:SetScript("OnClick", function() if menu:IsShown() then menu:Hide() else bt:SetText(items[get()] or ""); menu:Show() end end)
    btn:SetScript("OnEnter", function() btn:SetBackdropBorderColor(GOLD[1],GOLD[2],GOLD[3]) end)
    btn:SetScript("OnLeave", function()
        btn:SetBackdropBorderColor(BORDER[1],BORDER[2],BORDER[3])
    end)

    -- Close menu when clicking anywhere else
    menu:SetScript("OnShow", function()
        menu:SetPropagateKeyboardInput(false)
    end)
    local cl = CreateFrame("Frame")
    local clElapsed = 0
    cl:SetScript("OnUpdate", function(self, elapsed)
        if not menu:IsShown() then return end
        clElapsed = clElapsed + elapsed
        if clElapsed < 0.1 then return end
        clElapsed = 0
        if not menu:IsMouseOver() and not btn:IsMouseOver() then
            menu:Hide()
        end
    end)
    return y - 34
end

-- Two dropdowns side by side
local function W_Drop2(p, t1, it1, g1, s1, t2, it2, g2, s2, y)
    W_Drop(p, t1, COL1, y, it1, g1, s1)
    if t2 then W_Drop(p, t2, COL2 or ((CONTENT_W or 600)/2), y, it2, g2, s2) end
    return y - 34
end

local function W_Btn(p, text, x, y, w, fn)
    local b = CreateFrame("Button", nil, p, BackdropTemplateMixin and "BackdropTemplate" or nil)
    b:SetSize(w or 110, 20); b:SetPoint("TOPLEFT", x, y)
    Skin(b, WBG, BORDER)
    local t = b:CreateFontString(nil, "OVERLAY")
    t:SetPoint("CENTER"); t:SetFont(STANDARD_TEXT_FONT, 9, ""); t:SetText(text); t:SetTextColor(1,1,1)
    b:SetScript("OnClick", fn)
    b:SetScript("OnEnter", function() b:SetBackdropBorderColor(GOLD[1],GOLD[2],GOLD[3]) end)
    b:SetScript("OnLeave", function() b:SetBackdropBorderColor(BORDER[1],BORDER[2],BORDER[3]) end)
    b.label = t; return b, y - 24
end

------------------------------------------------------------
-- Common dropdown data
------------------------------------------------------------
local FLAGS = {["OUTLINE"]="Outline",["THICKOUTLINE"]="Thick",[""]="None"}
local POS = {["LEFT"]="Left",["CENTER"]="Center",["RIGHT"]="Right"}
local CDSTYLE = {["spiral"]="Spiral+Text",["spiralonly"]="Spiral",["text"]="Text",["none"]="None"}
local DRCD = {["spiral"]="Spiral",["both"]="Spiral+Text",["text"]="Text",["none"]="None"}

-- Shorthand for appearance get/set
local function ag(k) return function() return GR.db.appearance[k] end end
local function as(k) return function(v) GR.db.appearance[k]=v; GR:RebuildAllFrames() end end

------------------------------------------------------------
-- PAGE: General
------------------------------------------------------------
local function PGeneral(p)
    local y = -PAD
    y = W_Header(p, "General", y)
    y = W_Check2(p, "Lock Frames",
        function() return GR.db.locked end, function(v) GR.db.locked=v; GR:SetLocked(v) end,
        nil, nil, nil, y)

    y = W_Slider(p, "Frame Scale", COL1, y, 0.5, 3, 0.05,
        function() return GR.db.scale end,
        function(v) GR.db.scale=v; for i=1,5 do if GR.frames[i] then GR.frames[i]:SetScale(v) end end end)

    y = y - GAP; y = W_Header(p, "Testing", y)
    local tb, lb
    tb, y = W_Btn(p, "Show Test", COL1, y, 100, function()
        if GR.testMode then GR:HideTest(); tb.label:SetText("Show Test")
        else GR:ShowTest(3); tb.label:SetText("Hide Test") end
    end)
    lb, _ = W_Btn(p, "Lock", 108, y+24, 100, function()
        local l = not GR.db.locked; GR:SetLocked(l); lb.label:SetText(l and "Unlock" or "Lock")
    end)

    y = y - GAP; y = W_Header(p, "Profiles", y)
    y = W_Info(p, "5 profile slots + character default (auto-loads on login).", y)

    for slot = 1, 5 do
        local sl
        local sv, _ = W_Btn(p, "Save "..slot, COL1, y, 60, function() GR:SaveProfile(slot); sl:SetText("|cff00ff00Saved|r") end)
        W_Btn(p, "Load", 66, y, 50, function() GR:LoadProfile(slot) end)
        W_Btn(p, "X", 120, y, 20, function() GR:DeleteProfile(slot); sl:SetText("|cff666666-|r") end)
        sl = p:CreateFontString(nil, "OVERLAY"); sl:SetPoint("TOPLEFT", 148, y+1)
        sl:SetFont(STANDARD_TEXT_FONT, 9, ""); sl:SetText(GR:HasProfile(slot) and "|cff00ff00Saved|r" or "|cff666666-|r")
        y = y - 22
    end
    W_Btn(p, "Save as Character Default", COL1, y, 180, function() GR:SaveCharDefault() end)
end

------------------------------------------------------------
-- PAGE: Appearance
------------------------------------------------------------
local function PAppearance(p)
    local y = -PAD
    local g, gy

    -- Test button at top
    local testBtn2
    testBtn2, y = W_Btn(p, "Show Test", 0, y, 100, function()
        if GR.testMode then GR:HideTest(); testBtn2.label:SetText("Show Test")
        else GR:ShowTest(3); testBtn2.label:SetText("Hide Test") end
    end)

    -- THEMES GROUP
    g, y = W_Group(p, "Themes", y, 60)
    local presets = {"default","elvui","minimal","shadow","gothic","neon","blizzard"}
    local col = 0
    for _, k in ipairs(presets) do
        local pr = GR.PRESETS[k]
        if pr then W_Btn(g, pr.name, col*90, -2, 85, function() GR:ApplyPreset(k) end); col=col+1
            if col>=4 then col=0 end end
    end

    -- FRAME LAYOUT GROUP
    g, y = W_Group(p, "Frame Layout", y, 136)
    local iy = -2
    iy = W_Slider2(g, "Width", 120,400,5, ag("barWidth"), as("barWidth"), "%.0f",
                      "HP Height", 16,60,1, ag("hpBarHeight"), as("hpBarHeight"), "%.0f", iy)
    iy = W_Slider2(g, "Cast Height", 6,30,1, ag("castBarHeight"), as("castBarHeight"), "%.0f",
                      "Power Height", 2,16,1, ag("powerBarHeight"), as("powerBarHeight"), "%.0f", iy)
    iy = W_Slider2(g, "Spacing", 0,20,1, ag("spacing"), as("spacing"), "%.0f",
                      "Border Size", 0,20,1, ag("borderSize"), as("borderSize"), "%.0f", iy)
    iy = W_Slider(g, "BG Opacity", COL1, iy, 0,1,0.05,
        function() return GR.db.appearance.bgColor[4] or GR.db.appearance.bgAlpha end,
        function(v) GR.db.appearance.bgColor[4]=v; GR.db.appearance.bgAlpha=v; GR:RebuildAllFrames() end)

    -- TEXTURE & OPTIONS GROUP
    g, y = W_Group(p, "Texture & Display", y, 64)
    iy = -2
    iy = W_Drop(g, "Bar Texture", COL1, iy, GR.BAR_TEXTURES, ag("barTexture"), as("barTexture"))
    W_Check(g, "Class-Colored Bars", COL1, iy, ag("classColorBars"), as("classColorBars"))
    W_Check(g, "Show Class Icon", COL2 or 300, iy,
        function() return GR.db.appearance.showClassIcon~=false end,
        function(v) GR.db.appearance.showClassIcon=v; GR:RebuildAllFrames() end)

    -- NAME & HP TEXT GROUP
    g, y = W_Group(p, "Name & HP Text", y, 185)
    iy = -2
    iy = W_Drop2(g, "Name Font", GR.FONT_LIST, ag("nameFont"), as("nameFont"),
                    "HP Font", GR.FONT_LIST, ag("hpFont"), as("hpFont"), iy)
    iy = W_Slider2(g, "Name Size", 7,20,1, ag("nameFontSize"), as("nameFontSize"), "%.0f",
                      "HP Size", 7,20,1, ag("hpFontSize"), as("hpFontSize"), "%.0f", iy)
    iy = W_Drop2(g, "Name Outline", FLAGS, ag("nameFontFlags"), as("nameFontFlags"),
                    "HP Position", POS, function() return GR.db.appearance.hpPosition or "RIGHT" end, as("hpPosition"), iy)
    iy = W_Check2(g, "Font Shadow", ag("nameFontShadow"), as("nameFontShadow"),
                     "Class-Colored Names", function() return GR.db.appearance.nameColorByClass~=false end,
                     function(v) GR.db.appearance.nameColorByClass=v; GR:RebuildAllFrames() end, iy)
    iy = W_Drop2(g, "Name Position", POS, function() return GR.db.appearance.namePosition or "LEFT" end, as("namePosition"),
                    "Spec Position", {["ICON"]="On Icon",["NAME"]="After Name"},
                    function() return GR.db.appearance.specPosition or "ICON" end, as("specPosition"), iy)
    W_Check(g, "Show Spec", COL1, iy,
        function() return GR.db.appearance.nameShowSpec~=false end,
        function(v) GR.db.appearance.nameShowSpec=v; GR:RebuildAllFrames() end)

    -- CAST BAR GROUP
    g, y = W_Group(p, "Cast Bar", y, 72)
    iy = -2
    iy = W_Drop2(g, "Cast Font", GR.FONT_LIST, ag("castFont"), as("castFont"),
                    "Cast Outline", FLAGS, ag("castFontFlags"), as("castFontFlags"), iy)
    W_Slider(g, "Cast Size", COL1, iy, 6,18,1, ag("castFontSize"), as("castFontSize"), "%.0f")

    -- TRINKET & DR GROUP
    g, y = W_Group(p, "Trinket & DR Icons", y, 160)
    iy = -2
    iy = W_Slider2(g, "Trinket Size", 14,50,1, function() return GR.db.appearance.trinketSize or 26 end, as("trinketSize"), "%.0f",
                      "DR Icon Size", 12,40,1, function() return GR.db.appearance.drIconSize or 22 end, as("drIconSize"), "%.0f", iy)
    iy = W_Drop2(g, "Trinket CD", CDSTYLE, function() return GR.db.appearance.trinketCDStyle or "spiral" end, as("trinketCDStyle"),
                    "DR CD Style", DRCD, function() return GR.db.appearance.drCDStyle or "spiral" end, as("drCDStyle"), iy)
    iy = W_Slider2(g, "Trinket Text", 6,24,1, function() return GR.db.appearance.trinketCDTextSize or 12 end, as("trinketCDTextSize"), "%.0f",
                      "DR Label", 5,14,1, ag("drFontSize"), as("drFontSize"), "%.0f", iy)
    W_Slider2(g, "DR CD Text", 6,20,1, function() return GR.db.appearance.drCDTextSize or 10 end, as("drCDTextSize"), "%.0f",
                 "DR Opacity", 0,1,0.05, function() return GR.db.appearance.drCDTextOpacity or 1 end, as("drCDTextOpacity"), nil, iy)
end

------------------------------------------------------------
-- PAGE: Click Actions
------------------------------------------------------------
local function PClicks(p)
    local y = -PAD
    y = W_Header(p, "Click Actions", y)
    y = W_Info(p, "Configure modifier+click bindings. Quick Presets show macros for your class.", y)

    local actItems = {["target"]="Target",["focus"]="Focus",["spell"]="Spell",["macro"]="Macro",["none"]="None"}
    local modL = {[""]="",["shift-"]="Shift+",["ctrl-"]="Ctrl+",["alt-"]="Alt+"}
    local btnL = {"Left","Right"}

    local _, pc = UnitClass("player")
    local preItems = {["_none"]="-- Presets --"}
    local preLookup = {}
    if GR.CLICK_PRESETS then
        for i, pr in ipairs(GR.CLICK_PRESETS) do
            if not pr.classFilter or pr.classFilter==pc then
                local k="p"..i; preItems[k]=pr.name; preLookup[k]=pr
            end
        end
    end

    local actions = GR.db.clicks and GR.db.clicks.actions
    if not actions then return end

    for _, cfg in ipairs(actions) do
        y = W_Header(p, (modL[cfg.modifier] or "")..(btnL[cfg.button] or "?").." Click", y)
        y = W_Drop2(p, "Action", actItems,
            function() return cfg.action or "none" end,
            function(v) cfg.action=v; for i=1,5 do if GR.frames[i] then GR:ApplyClickActions(GR.frames[i]) end end end,
            "Preset", preItems,
            function() return "_none" end,
            function(v) if v and v~="_none" and preLookup[v] then
                local pr=preLookup[v]
                if pr.action=="spell" then cfg.action="spell"; cfg.spell=pr.spell
                elseif pr.action=="macro" then cfg.action="macro"; cfg.spell=pr.macro end
                for i=1,5 do if GR.frames[i] then GR:ApplyClickActions(GR.frames[i]) end end
            end end, y)
    end
end

------------------------------------------------------------
-- PAGE: Macro Toolkit
------------------------------------------------------------
local function PMacros(p)
    local y = -PAD
    y = W_Header(p, "Arena Macro Toolkit", y)
    y = W_Info(p, "Browse proven arena macros by class. Import creates a character-specific macro.", y)

    local _, pc = UnitClass("player")
    local sel = pc or "ROGUE"
    local cKeys = {"ROGUE","MAGE","WARLOCK","PRIEST","DRUID","PALADIN","WARRIOR","HUNTER","SHAMAN"}
    local cNames = {}
    for _, k in ipairs(cKeys) do cNames[k] = k:sub(1,1)..k:sub(2):lower() end

    local list = CreateFrame("Frame", nil, p)
    list:SetPoint("TOPLEFT", 0, y-40); list:SetSize(CONTENT_W or 600, 2000)

    local function Build()
        for _, c in ipairs({list:GetChildren()}) do c:Hide(); c:SetParent(nil) end
        local macros = GR.MACRO_CATALOG and GR.MACRO_CATALOG[sel]
        if not macros then return end
        local my = 0
        for _, m in ipairs(macros) do
            local card = CreateFrame("Frame", nil, list, BackdropTemplateMixin and "BackdropTemplate" or nil)
            card:SetSize((CONTENT_W or 600)-10, 50); card:SetPoint("TOPLEFT", 0, my)
            Skin(card, {0.08,0.08,0.08,0.9}, BORDER)

            local nm = card:CreateFontString(nil, "OVERLAY")
            nm:SetPoint("TOPLEFT", 6, -5); nm:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
            nm:SetText("|cff33ff99"..m.name.."|r")

            local ds = card:CreateFontString(nil, "OVERLAY")
            ds:SetPoint("TOPLEFT", nm, "BOTTOMLEFT", 0, -2); ds:SetWidth((CONTENT_W or 600)-100)
            ds:SetJustifyH("LEFT"); ds:SetFont(STANDARD_TEXT_FONT, 8, ""); ds:SetText(m.desc); ds:SetTextColor(GRAY[1],GRAY[2],GRAY[3])

            local ib, _ = W_Btn(card, "Import", -76, -15, 65, function()
                local mn = "GR: "..m.name
                local ex = GetMacroIndexByName(mn)
                if ex and ex>0 then EditMacro(ex, mn, m.icon or "INV_Misc_QuestionMark", m.body)
                else local _,nc = GetNumMacros()
                    if nc<18 then CreateMacro(mn, m.icon or "INV_Misc_QuestionMark", m.body, true)
                    else GR:Print("|cffff0000Macro slots full!|r") end
                end
                GR:Print("Imported: "..m.name)
            end)
            ib:ClearAllPoints(); ib:SetPoint("RIGHT", card, "RIGHT", -6, 0)

            my = my - 56
        end
    end

    y = W_Drop(p, "Class", COL1, y, cNames,
        function() return sel end, function(v) sel=v; Build() end)
    Build()
end

------------------------------------------------------------
-- PAGE: Nameplates
------------------------------------------------------------
local function PNameplates(p)
    local y = -PAD
    y = W_Header(p, "Nameplates", y)
    y = W_Check2(p, "Force Enemy Nameplates",
        function() return GR.db.nameplates.forceEnemy end, function(v) GR.db.nameplates.forceEnemy=v end,
        "Auto-Marking",
        function() return GR.db.nameplates.autoMark end, function(v) GR.db.nameplates.autoMark=v end, y)

    y = y-GAP; y = W_Header(p, "Marker Assignments", y)
    local mI = {[0]="None",[1]="Star",[2]="Circle",[3]="Diamond",[4]="Triangle",[5]="Moon",[6]="Square",[7]="Cross",[8]="Skull"}
    local units = {{"player","You"},{"party1","Party 1"},{"party2","Party 2"},{"party3","Party 3"},{"party4","Party 4"}}

    for i = 1, #units, 2 do
        local u1 = units[i]
        local u2 = units[i+1]
        if u2 then
            y = W_Drop2(p, u1[2], mI,
                function() return GR.db.nameplates.markAssignments[u1[1]] or 0 end,
                function(v) v=tonumber(v); GR.db.nameplates.markAssignments[u1[1]]=v>0 and v or nil end,
                u2[2], mI,
                function() return GR.db.nameplates.markAssignments[u2[1]] or 0 end,
                function(v) v=tonumber(v); GR.db.nameplates.markAssignments[u2[1]]=v>0 and v or nil end, y)
        else
            y = W_Drop(p, u1[2], COL1, y, mI,
                function() return GR.db.nameplates.markAssignments[u1[1]] or 0 end,
                function(v) v=tonumber(v); GR.db.nameplates.markAssignments[u1[1]]=v>0 and v or nil end)
        end
    end
end

------------------------------------------------------------
-- PAGE: Tracking
------------------------------------------------------------
local function PTracking(p)
    local y = -PAD
    y = W_Header(p, "Tracking", y)
    y = W_Info(p, "All tracking is automatic. Visual settings are in Appearance.", y)
    y = y-GAP
    y = W_Header(p, "Trinket", y)
    y = W_Info(p, "PvP trinket + WotF tracked via combat log. 2-minute cooldown spiral.", y)
    y = y-GAP
    y = W_Header(p, "Diminishing Returns", y)
    y = W_Info(p, "Spell icons outside the frame with cooldown spirals. Green=Full, Orange=Half, Red=Immune.", y)
    y = y-GAP
    y = W_Header(p, "Spec Detection", y)
    y = W_Info(p, "Detected from abilities + mana pool analysis. Works pre-gates.", y)
    y = y-GAP
    y = W_Header(p, "Auras", y)
    y = W_Info(p, "Key buffs/debuffs shown below trinket icon with cooldown spirals.", y)
    y = y-GAP
    y = W_Header(p, "Alerts", y)
    y = W_Info(p, "Frame glow: Orange=defensives, Red=offensive CDs, Green=killable (no trinket).", y)
end

------------------------------------------------------------
-- PAGE: Announcements
------------------------------------------------------------
local function PAnnounce(p)
    local y = -PAD
    y = W_Header(p, "Announcements", y)

    local outI = {["both"]="Self + Party",["self"]="Self Only",["party"]="Party Only",["none"]="Disabled"}
    y = W_Drop(p, "Output", COL1, y, outI,
        function() return GR.db.announcements.output or "both" end,
        function(v) GR.db.announcements.output=v end)

    y = y-GAP; y = W_Header(p, "Enemy Callouts", y)
    y = W_Check2(p, "Trinket Used",
        function() return GR.db.announcements.trinket end, function(v) GR.db.announcements.trinket=v end,
        "CC Breaker",
        function() return GR.db.announcements.ccBreaker end, function(v) GR.db.announcements.ccBreaker=v end, y)
    y = W_Check2(p, "Drinking",
        function() return GR.db.announcements.drinking end, function(v) GR.db.announcements.drinking=v end,
        "Spec Detected",
        function() return GR.db.announcements.enemySpec end, function(v) GR.db.announcements.enemySpec=v end, y)
    y = W_Check2(p, "Offensive CDs",
        function() return GR.db.announcements.offensiveCD end, function(v) GR.db.announcements.offensiveCD=v end,
        "Defensive CDs",
        function() return GR.db.announcements.defensiveCD end, function(v) GR.db.announcements.defensiveCD=v end, y)

    y = y-GAP; y = W_Header(p, "Win Conditions", y)
    y = W_Check2(p, "Enemy Low HP",
        function() return GR.db.announcements.enemyLowHP end, function(v) GR.db.announcements.enemyLowHP=v end,
        "Kill Target (low+no trinket)",
        function() return GR.db.announcements.killTarget end, function(v) GR.db.announcements.killTarget=v end, y)
    y = W_Slider2(p, "Enemy Threshold %", 10,50,5,
        function() return GR.db.announcements.enemyLowHPThreshold or 25 end,
        function(v) GR.db.announcements.enemyLowHPThreshold=v end, "%.0f%%",
        "Team Threshold %", 15,50,5,
        function() return GR.db.announcements.teamLowHPThreshold or 30 end,
        function(v) GR.db.announcements.teamLowHPThreshold=v end, "%.0f%%", y)

    y = y-GAP; y = W_Header(p, "Team Callouts", y)
    y = W_Check2(p, "Teammate Low HP",
        function() return GR.db.announcements.teamLowHP end, function(v) GR.db.announcements.teamLowHP=v end,
        nil, nil, nil, y)

    y = y-GAP; y = W_Header(p, "Arena Utilities", y)
    y = W_Check2(p, "Shadow Sight Timer",
        function() return GR.db.announcements.eyeTracker~=false end, function(v) GR.db.announcements.eyeTracker=v end,
        "Prep Checklist",
        function() return GR.db.announcements.prepChecklist~=false end, function(v) GR.db.announcements.prepChecklist=v end, y)
    y = W_Check2(p, "Queue Pop Alert",
        function() return GR.db.announcements.queueAlert~=false end, function(v) GR.db.announcements.queueAlert=v end,
        nil, nil, nil, y)
end

------------------------------------------------------------
-- PAGE: About
------------------------------------------------------------
local function PAbout(p)
    local y = -PAD
    y = W_Header(p, "Gladius Reborn", y)
    local lines = {
        {"Version: 1.0.0", GOLD}, {"Author: evildz on nightslayer", GOLD}, {"", WHITE},
        {"Arena unit frames for TBC Classic Anniversary (2.5.5).", GRAY}, {"", WHITE},
        {"Features:", WHITE},
        {"  Arena frames - HP, Mana, Cast bars, DR, Auras", GRAY},
        {"  Click actions with combo macro presets per class", GRAY},
        {"  Trinket + DR tracking with spell icons & spirals", GRAY},
        {"  Smart alerts: offensive/defensive CDs, kill windows", GRAY},
        {"  Announcement system (self/party/both)", GRAY},
        {"  Arena macro toolkit with one-click import", GRAY},
        {"  Shadow Sight timer + prep checklist + queue alerts", GRAY},
        {"  Forced enemy nameplates + auto markers", GRAY},
        {"  Themes, profiles, per-character defaults", GRAY}, {"", WHITE},
        {"Special Thanks:", GOLD}, {"", WHITE},
        {"Gladius by Proditor (Resike)", WHITE},
        {"The original arena frames addon.", GRAY}, {"", WHITE},
        {"GladiusEx by slaren & vendethiel", WHITE},
        {"Pushed arena frames forward with modular design, DR", GRAY},
        {"tracking, and features the community relied on.", GRAY}, {"", WHITE},
        {"This addon exists because of their work.", GRAY},
        {"Thank you for everything you gave the PvP community.", GRAY},
    }
    for _, l in ipairs(lines) do
        local t = p:CreateFontString(nil, "OVERLAY")
        t:SetPoint("TOPLEFT", 0, y); t:SetWidth(CONTENT_W or 600); t:SetJustifyH("LEFT")
        t:SetFont(STANDARD_TEXT_FONT, 10, ""); t:SetText(l[1]); t:SetTextColor(l[2][1],l[2][2],l[2][3])
        y = y - 14
    end
end

------------------------------------------------------------
-- Categories
------------------------------------------------------------
local cats = {
    {name="General",       fn=PGeneral},
    {name="Appearance",    fn=PAppearance},
    {name="Click Actions", fn=PClicks},
    {name="Macro Toolkit", fn=PMacros},
    {name="Nameplates",    fn=PNameplates},
    {name="Tracking",      fn=PTracking},
    {name="Announcements", fn=PAnnounce},
    {name="About",         fn=PAbout},
}

local function ShowCat(i)
    if activeCat==i then return end; activeCat=i
    for _, c in pairs(cFrames) do c:Hide() end
    for _, b in pairs(sBtns) do
        b.bg:SetBackdropBorderColor(0,0,0,0); b.text:SetTextColor(GRAY[1],GRAY[2],GRAY[3])
    end
    if cFrames[i] then cFrames[i]:Show() end
    if sBtns[i] then
        sBtns[i].bg:SetBackdropBorderColor(GOLD[1],GOLD[2],GOLD[3],0.4)
        sBtns[i].text:SetTextColor(GOLD[1],GOLD[2],GOLD[3])
    end
end

------------------------------------------------------------
-- Build Panel
------------------------------------------------------------
local function Build()
    if optFrame then return optFrame end

    CONTENT_W = PANEL_W - SIDEBAR_W - 40
    COL2 = math.floor(CONTENT_W / 2)

    local f = CreateFrame("Frame", "GladiusReborn_Options", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    f:SetSize(PANEL_W, PANEL_H); f:SetPoint("CENTER")
    f:SetMovable(true); f:EnableMouse(true); f:SetClampedToScreen(true)
    f:SetFrameStrata("DIALOG"); f:SetToplevel(true)
    f:SetResizable(true)
    if f.SetResizeBounds then f:SetResizeBounds(700, 450) else f:SetMinResize(700, 450) end
    Skin(f, BG, BORDER); f:Hide()

    -- Resize grip
    local grip = CreateFrame("Button", nil, f)
    grip:SetSize(16, 16); grip:SetPoint("BOTTOMRIGHT", -2, 2)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetScript("OnMouseDown", function() f:StartSizing("BOTTOMRIGHT") end)
    grip:SetScript("OnMouseUp", function() f:StopMovingOrSizing() end)

    -- Title bar
    local tb = CreateFrame("Frame", nil, f)
    tb:SetHeight(26); tb:SetPoint("TOPLEFT"); tb:SetPoint("TOPRIGHT")
    tb:EnableMouse(true); tb:RegisterForDrag("LeftButton")
    tb:SetScript("OnDragStart", function() f:StartMoving() end)
    tb:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)

    local tl = tb:CreateFontString(nil, "OVERLAY")
    tl:SetPoint("LEFT", 10, -13); tl:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    tl:SetText("|cff33ff99Gladius Reborn|r |cff666666v1.0.0|r")

    -- Close
    local cl = CreateFrame("Button", nil, f)
    cl:SetSize(18,18); cl:SetPoint("TOPRIGHT", -5, -4)
    cl:SetFrameLevel(f:GetFrameLevel()+20); cl:EnableMouse(true); cl:RegisterForClicks("AnyUp")
    local clBG = CreateFrame("Frame", nil, cl, BackdropTemplateMixin and "BackdropTemplate" or nil)
    clBG:SetAllPoints(); Skin(clBG, WBG, BORDER)
    local clT = cl:CreateFontString(nil, "OVERLAY")
    clT:SetPoint("CENTER"); clT:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE"); clT:SetText("x"); clT:SetTextColor(RED[1],RED[2],RED[3])
    cl:SetScript("OnClick", function() f:Hide() end)
    cl:SetScript("OnEnter", function() clBG:SetBackdropBorderColor(RED[1],RED[2],RED[3]) end)
    cl:SetScript("OnLeave", function() clBG:SetBackdropBorderColor(BORDER[1],BORDER[2],BORDER[3]) end)

    -- Sidebar
    local sb = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate" or nil)
    sb:SetWidth(SIDEBAR_W); sb:SetPoint("TOPLEFT", 3, -28); sb:SetPoint("BOTTOMLEFT", 3, 3)
    Skin(sb, {0.04,0.04,0.04,0.95}, BORDER)

    for i, cat in ipairs(cats) do
        local b = CreateFrame("Button", nil, sb)
        b:SetSize(SIDEBAR_W-6, 22); b:SetPoint("TOPLEFT", 3, -3-(i-1)*24)
        b.bg = CreateFrame("Frame", nil, b, BackdropTemplateMixin and "BackdropTemplate" or nil)
        b.bg:SetAllPoints(); Skin(b.bg, {0,0,0,0}, {0,0,0,0})
        local hl = b:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints(); hl:SetTexture("Interface\\Buttons\\WHITE8x8"); hl:SetVertexColor(GOLD[1],GOLD[2],GOLD[3],0.06)
        b.text = b:CreateFontString(nil, "OVERLAY")
        b.text:SetPoint("LEFT", 6, 0); b.text:SetFont(STANDARD_TEXT_FONT, 10, "")
        b.text:SetText(cat.name); b.text:SetTextColor(GRAY[1],GRAY[2],GRAY[3])
        b:SetScript("OnClick", function() ShowCat(i) end)
        sBtns[i] = b
    end

    -- Divider
    local dv = f:CreateTexture(nil, "ARTWORK")
    dv:SetWidth(1); dv:SetPoint("TOPLEFT", sb, "TOPRIGHT", 1, 0); dv:SetPoint("BOTTOMLEFT", sb, "BOTTOMRIGHT", 1, 0)
    dv:SetColorTexture(BORDER[1],BORDER[2],BORDER[3],1)

    -- Content
    for i, cat in ipairs(cats) do
        local wrap = CreateFrame("Frame", nil, f)
        wrap:SetPoint("TOPLEFT", SIDEBAR_W+10, -32); wrap:SetPoint("BOTTOMRIGHT", -6, 6); wrap:Hide()

        local scroll = CreateFrame("ScrollFrame", "GRS"..i, wrap, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT"); scroll:SetPoint("BOTTOMRIGHT", -20, 0)
        local bar = scroll.ScrollBar or _G["GRS"..i.."ScrollBar"]
        if bar then bar:ClearAllPoints()
            bar:SetPoint("TOPRIGHT", wrap, "TOPRIGHT", 0, -16)
            bar:SetPoint("BOTTOMRIGHT", wrap, "BOTTOMRIGHT", 0, 16) end

        local child = CreateFrame("Frame", nil, scroll)
        child:SetWidth(CONTENT_W); child:SetHeight(3000)
        scroll:SetScrollChild(child)
        cat.fn(child)
        cFrames[i] = wrap
    end

    tinsert(UISpecialFrames, "GladiusReborn_Options")
    optFrame = f; return f
end

------------------------------------------------------------
-- API
------------------------------------------------------------
function GR:ShowOptionsPanel() Build():Show(); ShowCat(1) end
function GR:ToggleOptionsPanel()
    local p = Build()
    if p:IsShown() then p:Hide() else p:Show(); ShowCat(activeCat or 1) end
end

local bp = CreateFrame("Frame", "GR_BlizzOpt")
bp.name = "Gladius Reborn"
local bpt = bp:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
bpt:SetPoint("TOPLEFT", 16, -16); bpt:SetText("|cff33ff99Gladius Reborn|r")
local bpb = CreateFrame("Button", nil, bp, "UIPanelButtonTemplate")
bpb:SetSize(200, 24); bpb:SetPoint("TOPLEFT", bpt, "BOTTOMLEFT", 0, -10)
bpb:SetText("Open Options"); bpb:SetScript("OnClick", function() GR:ShowOptionsPanel() end)
if InterfaceOptions_AddCategory then InterfaceOptions_AddCategory(bp) end
