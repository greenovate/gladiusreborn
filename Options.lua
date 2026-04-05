local _, GR = ...

------------------------------------------------------------
-- Options Panel
------------------------------------------------------------
local PANEL_WIDTH = 860
local PANEL_HEIGHT = 580
local SIDEBAR_WIDTH = 170
local CONTENT_LEFT = SIDEBAR_WIDTH + 12
local ROW_HEIGHT = 24
local SECTION_GAP = 16

local optionsFrame = nil
local contentFrames = {}
local sidebarButtons = {}
local activeCategory = nil

------------------------------------------------------------
-- Backdrop Helper
------------------------------------------------------------
local function ApplyBackdrop(frame, bgColor, borderColor)
    if frame.SetBackdrop then
        frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 },
        })
        if bgColor then frame:SetBackdropColor(unpack(bgColor)) end
        if borderColor then frame:SetBackdropBorderColor(unpack(borderColor)) end
    end
end

------------------------------------------------------------
-- Widget Builders
------------------------------------------------------------
local function CreateSectionHeader(parent, text, yOffset)
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
    header:SetText(text)
    header:SetTextColor(1, 0.82, 0)
    return header, yOffset - 26
end

local function CreateSubHeader(parent, text, yOffset)
    local header = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
    header:SetText(text)
    header:SetTextColor(0.8, 0.8, 0.8)

    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -2)
    line:SetPoint("RIGHT", parent, "RIGHT", -10, 0)
    line:SetColorTexture(0.4, 0.4, 0.4, 0.6)

    return header, yOffset - 22
end

local function CreateCheckbox(parent, text, yOffset, getValue, setValue, tooltip)
    local cb = CreateFrame("Button", nil, parent)
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
    cb:SetSize(220, 20)

    -- Custom checkbox box
    cb.box = cb:CreateTexture(nil, "ARTWORK")
    cb.box:SetPoint("LEFT", cb, "LEFT", 0, 0)
    cb.box:SetSize(16, 16)
    cb.box:SetColorTexture(0.15, 0.15, 0.15, 1)

    cb.border = cb:CreateTexture(nil, "OVERLAY")
    cb.border:SetPoint("CENTER", cb.box, "CENTER")
    cb.border:SetSize(18, 18)
    cb.border:SetColorTexture(0.4, 0.4, 0.4, 1)
    cb.border:SetDrawLayer("ARTWORK", -1)

    -- Swap draw layers so border is behind
    cb.box:SetDrawLayer("ARTWORK", 1)

    cb.check = cb:CreateTexture(nil, "OVERLAY")
    cb.check:SetPoint("CENTER", cb.box, "CENTER")
    cb.check:SetSize(14, 14)
    cb.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")

    cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    cb.text:SetPoint("LEFT", cb.box, "RIGHT", 6, 0)
    cb.text:SetText(text)

    local checked = getValue() and true or false
    cb.check:SetShown(checked)

    cb:SetScript("OnClick", function(self)
        checked = not checked
        self.check:SetShown(checked)
        setValue(checked)
    end)

    cb:SetScript("OnEnter", function(self)
        self.box:SetColorTexture(0.25, 0.25, 0.25, 1)
        if tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, 1, 1, 1)
            GameTooltip:AddLine(tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end
    end)
    cb:SetScript("OnLeave", function(self)
        self.box:SetColorTexture(0.15, 0.15, 0.15, 1)
        GameTooltip:Hide()
    end)

    cb.Refresh = function()
        checked = getValue() and true or false
        cb.check:SetShown(checked)
    end
    return cb, yOffset - ROW_HEIGHT - 2
end

local function CreateSlider(parent, text, yOffset, minVal, maxVal, step, getValue, setValue, tooltip, fmt)
    fmt = fmt or "%.2f"

    local container = CreateFrame("Frame", nil, parent)
    container:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    container:SetSize(300, 46)

    local label = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    label:SetText(text)

    -- Custom slider
    local slider = CreateFrame("Slider", nil, container)
    slider:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -16)
    slider:SetSize(220, 16)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    slider:EnableMouse(true)

    -- Track background
    local track = slider:CreateTexture(nil, "BACKGROUND")
    track:SetPoint("LEFT", slider, "LEFT", 0, 0)
    track:SetPoint("RIGHT", slider, "RIGHT", 0, 0)
    track:SetHeight(8)
    track:SetColorTexture(0.12, 0.12, 0.12, 1)

    -- Track border
    local trackBorderTop = slider:CreateTexture(nil, "ARTWORK", nil, -1)
    trackBorderTop:SetPoint("BOTTOMLEFT", track, "TOPLEFT")
    trackBorderTop:SetPoint("BOTTOMRIGHT", track, "TOPRIGHT")
    trackBorderTop:SetHeight(1)
    trackBorderTop:SetColorTexture(0.3, 0.3, 0.3, 1)

    local trackBorderBot = slider:CreateTexture(nil, "ARTWORK", nil, -1)
    trackBorderBot:SetPoint("TOPLEFT", track, "BOTTOMLEFT")
    trackBorderBot:SetPoint("TOPRIGHT", track, "BOTTOMRIGHT")
    trackBorderBot:SetHeight(1)
    trackBorderBot:SetColorTexture(0.3, 0.3, 0.3, 1)

    local trackBorderL = slider:CreateTexture(nil, "ARTWORK", nil, -1)
    trackBorderL:SetPoint("TOPRIGHT", track, "TOPLEFT")
    trackBorderL:SetPoint("BOTTOMRIGHT", track, "BOTTOMLEFT")
    trackBorderL:SetWidth(1)
    trackBorderL:SetColorTexture(0.3, 0.3, 0.3, 1)

    local trackBorderR = slider:CreateTexture(nil, "ARTWORK", nil, -1)
    trackBorderR:SetPoint("TOPLEFT", track, "TOPRIGHT")
    trackBorderR:SetPoint("BOTTOMLEFT", track, "BOTTOMRIGHT")
    trackBorderR:SetWidth(1)
    trackBorderR:SetColorTexture(0.3, 0.3, 0.3, 1)

    -- Thumb
    local thumb = slider:CreateTexture(nil, "OVERLAY")
    thumb:SetSize(14, 20)
    thumb:SetColorTexture(0.7, 0.7, 0.7, 1)
    slider:SetThumbTexture(thumb)
    slider:SetOrientation("HORIZONTAL")

    -- Min/Max labels
    local minLabel = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    minLabel:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 0, -2)
    minLabel:SetText(minVal)
    minLabel:SetTextColor(0.5, 0.5, 0.5)

    local maxLabel = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    maxLabel:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 0, -2)
    maxLabel:SetText(maxVal)
    maxLabel:SetTextColor(0.5, 0.5, 0.5)

    -- Value display
    local valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valueText:SetPoint("TOP", slider, "BOTTOM", 0, -2)
    valueText:SetTextColor(1, 0.82, 0)

    slider:SetValue(getValue())
    valueText:SetText(format(fmt, getValue()))

    slider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value / step + 0.5) * step
        valueText:SetText(format(fmt, value))
        setValue(value)
    end)

    if tooltip then
        slider:SetScript("OnEnter", function(self)
            thumb:SetColorTexture(0.8, 0.8, 0.8, 1)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, 1, 1, 1)
            GameTooltip:AddLine(tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        slider:SetScript("OnLeave", function(self)
            thumb:SetColorTexture(0.6, 0.6, 0.6, 1)
            GameTooltip:Hide()
        end)
    end

    slider.Refresh = function()
        slider:SetValue(getValue())
        valueText:SetText(format(fmt, getValue()))
    end

    return slider, yOffset - 50
end

local ddCounter = 0
local function CreateDropdown(parent, text, yOffset, items, getValue, setValue, tooltip)
    ddCounter = ddCounter + 1

    local container = CreateFrame("Frame", nil, parent)
    container:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    container:SetSize(260, 44)

    local label = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    label:SetText(text)

    -- Build ordered items list
    local orderedKeys = {}
    for k, _ in pairs(items) do
        orderedKeys[#orderedKeys + 1] = k
    end
    table.sort(orderedKeys, function(a, b)
        if type(a) == "number" and type(b) == "number" then return a < b end
        return tostring(a) < tostring(b)
    end)

    -- Main button
    local btn = CreateFrame("Button", "GR_CDD_" .. ddCounter, container)
    btn:SetPoint("TOPLEFT", container, "TOPLEFT", 0, -16)
    btn:SetSize(220, 22)

    local btnBg = btn:CreateTexture(nil, "BACKGROUND")
    btnBg:SetAllPoints()
    btnBg:SetColorTexture(0.12, 0.12, 0.12, 1)

    local btnBorder = CreateFrame("Frame", nil, btn, BackdropTemplateMixin and "BackdropTemplate" or nil)
    btnBorder:SetAllPoints()
    if btnBorder.SetBackdrop then
        btnBorder:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        btnBorder:SetBackdropBorderColor(0.35, 0.35, 0.35, 1)
    end

    local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    btnText:SetPoint("LEFT", btn, "LEFT", 8, 0)
    btnText:SetPoint("RIGHT", btn, "RIGHT", -20, 0)
    btnText:SetJustifyH("LEFT")
    btnText:SetText(items[getValue()] or "")

    local arrow = btn:CreateTexture(nil, "OVERLAY")
    arrow:SetSize(12, 12)
    arrow:SetPoint("RIGHT", btn, "RIGHT", -6, 0)
    arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")

    -- Dropdown menu frame
    local menu = CreateFrame("Frame", nil, btn)
    menu:SetPoint("TOPLEFT", btn, "BOTTOMLEFT", 0, -1)
    menu:SetSize(220, 10)
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:SetFrameLevel(btn:GetFrameLevel() + 10)
    menu:Hide()

    local menuBg = menu:CreateTexture(nil, "BACKGROUND")
    menuBg:SetAllPoints()
    menuBg:SetColorTexture(0.1, 0.1, 0.1, 0.95)

    local menuBorder = CreateFrame("Frame", nil, menu, BackdropTemplateMixin and "BackdropTemplate" or nil)
    menuBorder:SetAllPoints()
    if menuBorder.SetBackdrop then
        menuBorder:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 },
        })
        menuBorder:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    end

    -- Build menu items
    local menuButtons = {}
    for i, key in ipairs(orderedKeys) do
        local itemBtn = CreateFrame("Button", nil, menu)
        itemBtn:SetSize(216, 18)
        if i == 1 then
            itemBtn:SetPoint("TOPLEFT", menu, "TOPLEFT", 2, -2)
        else
            itemBtn:SetPoint("TOPLEFT", menuButtons[i - 1], "BOTTOMLEFT", 0, 0)
        end

        local itemHL = itemBtn:CreateTexture(nil, "HIGHLIGHT")
        itemHL:SetAllPoints()
        itemHL:SetColorTexture(0.2, 0.5, 0.8, 0.4)

        local itemText = itemBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        itemText:SetPoint("LEFT", itemBtn, "LEFT", 6, 0)
        itemText:SetText(items[key])

        itemBtn:SetScript("OnClick", function()
            setValue(key)
            btnText:SetText(items[key])
            menu:Hide()
        end)

        menuButtons[i] = itemBtn
    end

    menu:SetHeight(#orderedKeys * 18 + 4)

    btn:SetScript("OnClick", function()
        if menu:IsShown() then
            menu:Hide()
        else
            menu:Show()
        end
    end)

    -- Close menu when clicking elsewhere
    menu:SetScript("OnShow", function(self)
        self:SetPropagateKeyboardInput(false)
    end)

    local closeChecker = CreateFrame("Frame")
    closeChecker:SetScript("OnUpdate", function()
        if menu:IsShown() and not menu:IsMouseOver() and not btn:IsMouseOver() then
            if IsMouseButtonDown("LeftButton") then
                menu:Hide()
            end
        end
    end)

    btn:SetScript("OnEnter", function() btnBg:SetColorTexture(0.18, 0.18, 0.18, 1) end)
    btn:SetScript("OnLeave", function() btnBg:SetColorTexture(0.12, 0.12, 0.12, 1) end)

    container.Refresh = function()
        btnText:SetText(items[getValue()] or "")
    end

    return container, yOffset - 48
end

local function CreateButton(parent, text, yOffset, width, onClick, tooltip)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    btn:SetSize(width or 140, 22)
    btn:SetText(text)
    btn:SetScript("OnClick", onClick)

    if tooltip then
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, 1, 1, 1)
            GameTooltip:AddLine(tooltip, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end

    return btn, yOffset - 30
end

local function CreateInfoText(parent, text, yOffset, height)
    local t = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    t:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, yOffset)
    t:SetWidth(500)
    t:SetJustifyH("LEFT")
    t:SetText(text)
    t:SetTextColor(0.7, 0.7, 0.7)
    return t, yOffset - (height or 20)
end

------------------------------------------------------------
-- Page: General
------------------------------------------------------------
local function BuildGeneralPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "General Settings", y)
    y = y - 4

    CreateCheckbox(parent, "Lock Frames", y,
        function() return GR.db.locked end,
        function(v) GR.db.locked = v; GR:SetLocked(v) end,
        "Lock frame positions.")
    y = y - ROW_HEIGHT - 2

    _, y = CreateSlider(parent, "Frame Scale", y, 0.5, 3.0, 0.05,
        function() return GR.db.scale end,
        function(v)
            GR.db.scale = v
            for i = 1, 5 do
                if GR.frames[i] then GR.frames[i]:SetScale(v) end
            end
        end,
        "Scale of the arena frames.")

    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Testing & Position", y)
    y = y - 6

    local testBtn
    testBtn, _ = CreateButton(parent, GR.testMode and "Hide Test" or "Show Test", y, 120, function()
        if GR.testMode then
            GR:HideTest()
            testBtn:SetText("Show Test")
        else
            GR:ShowTest(3)
            testBtn:SetText("Hide Test")
        end
    end, "Toggle test arena frames.")
    y = y - 4

    local lockBtn
    lockBtn, _ = CreateButton(parent, GR.db.locked and "Unlock" or "Lock", y, 120, function()
        local newLocked = not GR.db.locked
        GR:SetLocked(newLocked)
        lockBtn:SetText(newLocked and "Unlock" or "Lock")
    end, "Toggle frame lock/unlock for repositioning.")
    lockBtn:ClearAllPoints()
    lockBtn:SetPoint("LEFT", testBtn, "RIGHT", 6, 0)
    y = y - 30

    -- Profiles
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Profiles", y)
    y = y - 6

    CreateInfoText(parent, "Save up to 5 profiles. Use character default to auto-load settings for this character.", y, 20)
    y = y - 24

    for slot = 1, 5 do
        local slotLabel

        local saveBtn
        saveBtn, _ = CreateButton(parent, "Save " .. slot, y, 80, function()
            GR:SaveProfile(slot)
            slotLabel:SetText("|cff00ff00Saved|r")
        end, "Save current settings to profile " .. slot)

        local loadBtn
        loadBtn, _ = CreateButton(parent, "Load " .. slot, y, 80, function()
            GR:LoadProfile(slot)
        end, "Load profile " .. slot)
        loadBtn:ClearAllPoints()
        loadBtn:SetPoint("LEFT", saveBtn, "RIGHT", 4, 0)

        local delBtn
        delBtn, _ = CreateButton(parent, "X", y, 24, function()
            GR:DeleteProfile(slot)
            slotLabel:SetText("|cff666666Empty|r")
        end, "Delete profile " .. slot)
        delBtn:ClearAllPoints()
        delBtn:SetPoint("LEFT", loadBtn, "RIGHT", 4, 0)

        slotLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        slotLabel:SetPoint("LEFT", delBtn, "RIGHT", 8, 0)
        local hasProfile = GR:HasProfile(slot)
        slotLabel:SetText(hasProfile and "|cff00ff00Saved|r" or "|cff666666Empty|r")

        y = y - 28
    end

    y = y - 10
    _, y = CreateSubHeader(parent, "Character Default", y)
    y = y - 6

    CreateButton(parent, "Save as Character Default", y, 220, function()
        GR:SaveCharDefault()
    end, "Save current settings as the default for this character. Loads automatically on login.")
    y = y - 30

    CreateInfoText(parent, "Character default auto-loads when you log in on this character.", y, 16)
end

------------------------------------------------------------
-- Page: Appearance
------------------------------------------------------------
local function BuildAppearancePage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Appearance", y)
    y = y - 4

    -- Test & Lock controls at the top
    local testBtn2
    testBtn2, _ = CreateButton(parent, GR.testMode and "Hide Test" or "Show Test", y, 120, function()
        if GR.testMode then
            GR:HideTest()
            testBtn2:SetText("Show Test")
        else
            GR:ShowTest(3)
            testBtn2:SetText("Hide Test")
        end
    end, "Toggle test frames to preview appearance changes live.")
    y = y - 4

    local lockBtn2
    lockBtn2, _ = CreateButton(parent, GR.db.locked and "Unlock" or "Lock", y, 120, function()
        local newLocked = not GR.db.locked
        GR:SetLocked(newLocked)
        lockBtn2:SetText(newLocked and "Unlock" or "Lock")
    end, "Toggle frame lock/unlock for repositioning.")
    lockBtn2:ClearAllPoints()
    lockBtn2:SetPoint("LEFT", testBtn2, "RIGHT", 6, 0)
    y = y - 30

    y = y - 4

    -- Presets section
    _, y = CreateSubHeader(parent, "Themes", y)
    y = y - 6

    CreateInfoText(parent, "Pick a theme to change fonts, textures, borders, shadows, and colors. Customize further below.", y, 16)
    y = y - 20

    local presetBtns = {}
    local presetOrder = { "default", "elvui", "minimal", "shadow", "gothic", "neon", "blizzard" }
    local buttonsPerRow = 4
    for i, key in ipairs(presetOrder) do
        local preset = GR.PRESETS[key]
        local btn
        btn, _ = CreateButton(parent, preset.name, y, 120, function()
            GR:ApplyPreset(key)
            GR:Print("Theme applied: " .. preset.name)
        end, "Apply the " .. preset.name .. " theme.")
        if i > 1 then
            btn:ClearAllPoints()
            local row = math.ceil(i / buttonsPerRow)
            local col = ((i - 1) % buttonsPerRow)
            if col == 0 then
                -- New row
                local firstInPrevRow = presetBtns[(row - 2) * buttonsPerRow + 1]
                btn:SetPoint("TOPLEFT", firstInPrevRow, "BOTTOMLEFT", 0, -4)
            else
                btn:SetPoint("LEFT", presetBtns[i - 1], "RIGHT", 6, 0)
            end
        end
        presetBtns[i] = btn
    end
    local numRows = math.ceil(#presetOrder / buttonsPerRow)
    y = y - (numRows * 30 + 10)

    -- Frame Dimensions
    _, y = CreateSubHeader(parent, "Frame Dimensions", y)
    y = y - 6

    _, y = CreateSlider(parent, "Bar Width", y, 120, 400, 5,
        function() return GR.db.appearance.barWidth end,
        function(v) GR.db.appearance.barWidth = v; GR:RebuildAllFrames() end,
        "Width of the arena frames.", "%.0f")

    _, y = CreateSlider(parent, "Health Bar Height", y, 16, 60, 1,
        function() return GR.db.appearance.hpBarHeight or 28 end,
        function(v) GR.db.appearance.hpBarHeight = v; GR:RebuildAllFrames() end,
        "Height of the health bar. Frame auto-sizes to fit.", "%.0f")

    _, y = CreateSlider(parent, "Cast Bar Height", y, 6, 30, 1,
        function() return GR.db.appearance.castBarHeight end,
        function(v) GR.db.appearance.castBarHeight = v; GR:RebuildAllFrames() end,
        "Height of the cast bar.", "%.0f")

    _, y = CreateSlider(parent, "Power Bar Height", y, 2, 16, 1,
        function() return GR.db.appearance.powerBarHeight end,
        function(v) GR.db.appearance.powerBarHeight = v; GR:RebuildAllFrames() end,
        "Height of the mana/rage/energy bar.", "%.0f")

    _, y = CreateSlider(parent, "Frame Spacing", y, 0, 20, 1,
        function() return GR.db.appearance.spacing end,
        function(v) GR.db.appearance.spacing = v; GR:RebuildAllFrames() end,
        "Gap between arena frames.", "%.0f")

    -- Bar Textures
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Bar Textures", y)
    y = y - 6

    _, y = CreateDropdown(parent, "Health Bar Texture", y, GR.BAR_TEXTURES,
        function() return GR.db.appearance.barTexture end,
        function(v) GR.db.appearance.barTexture = v; GR:RebuildAllFrames() end,
        "Texture for health bars.")

    -- Background & Border
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Background & Border", y)
    y = y - 6

    _, y = CreateSlider(parent, "Background Opacity", y, 0, 1, 0.05,
        function() return GR.db.appearance.bgColor[4] or GR.db.appearance.bgAlpha end,
        function(v)
            GR.db.appearance.bgColor[4] = v
            GR.db.appearance.bgAlpha = v
            GR:RebuildAllFrames()
        end,
        "Opacity of the frame background.")

    _, y = CreateSlider(parent, "Border Size", y, 0, 20, 1,
        function() return GR.db.appearance.borderSize end,
        function(v) GR.db.appearance.borderSize = v; GR:RebuildAllFrames() end,
        "Size of the frame border.", "%.0f")

    -- Health Bar
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Health Bar", y)
    y = y - 6

    CreateCheckbox(parent, "Class-Colored Health Bars", y,
        function() return GR.db.appearance.classColorBars end,
        function(v) GR.db.appearance.classColorBars = v; GR:RebuildAllFrames() end,
        "Color health bars by class. When off, bars are green.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Show Class Icon", y,
        function() return GR.db.appearance.showClassIcon ~= false end,
        function(v) GR.db.appearance.showClassIcon = v; GR:RebuildAllFrames() end,
        "Show the class icon on the left. Hiding it gives the health bar more width.")
    y = y - ROW_HEIGHT - 2

    -- Name & Text
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Name Text", y)
    y = y - 6

    _, y = CreateDropdown(parent, "Name Font", y, GR.FONT_LIST,
        function() return GR.db.appearance.nameFont or "Fonts\\FRIZQT__.TTF" end,
        function(v) GR.db.appearance.nameFont = v; GR:RebuildAllFrames() end,
        "Font for player names.")

    _, y = CreateSlider(parent, "Name Font Size", y, 7, 20, 1,
        function() return GR.db.appearance.nameFontSize end,
        function(v) GR.db.appearance.nameFontSize = v; GR:RebuildAllFrames() end,
        "Size of the player name text.", "%.0f")

    local fontFlagItems = {
        ["OUTLINE"] = "Outline",
        ["THICKOUTLINE"] = "Thick Outline",
        ["MONOCHROME"] = "Monochrome",
        [""] = "None (shadow only)",
    }
    _, y = CreateDropdown(parent, "Name Font Outline", y, fontFlagItems,
        function() return GR.db.appearance.nameFontFlags end,
        function(v) GR.db.appearance.nameFontFlags = v; GR:RebuildAllFrames() end,
        "Outline style for name text.")

    CreateCheckbox(parent, "Font Shadow", y,
        function() return GR.db.appearance.nameFontShadow end,
        function(v) GR.db.appearance.nameFontShadow = v; GR:RebuildAllFrames() end,
        "Enable drop shadow on name and HP text.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Class-Colored Names", y,
        function() return GR.db.appearance.nameColorByClass ~= false end,
        function(v) GR.db.appearance.nameColorByClass = v; GR:RebuildAllFrames() end,
        "Color player names by class. When off, names are white.")
    y = y - ROW_HEIGHT - 2

    local positionItems = {
        ["LEFT"] = "Left",
        ["CENTER"] = "Center",
        ["RIGHT"] = "Right",
    }
    _, y = CreateDropdown(parent, "Name Position", y, positionItems,
        function() return GR.db.appearance.namePosition or "LEFT" end,
        function(v) GR.db.appearance.namePosition = v; GR:RebuildAllFrames() end,
        "Where to show the player name on the health bar.")

    -- Spec display
    CreateCheckbox(parent, "Show Spec", y,
        function() return GR.db.appearance.nameShowSpec ~= false end,
        function(v) GR.db.appearance.nameShowSpec = v; GR:RebuildAllFrames() end,
        "Show enemy specialization.")
    y = y - ROW_HEIGHT - 2

    local specPosItems = {
        ["ICON"] = "On Class Icon",
        ["NAME"] = "After Name",
    }
    _, y = CreateDropdown(parent, "Spec Position", y, specPosItems,
        function() return GR.db.appearance.specPosition or "ICON" end,
        function(v) GR.db.appearance.specPosition = v; GR:RebuildAllFrames() end,
        "Where to show the detected spec.")

    -- HP Text
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "HP Text", y)
    y = y - 6

    _, y = CreateDropdown(parent, "HP Font", y, GR.FONT_LIST,
        function() return GR.db.appearance.hpFont or "Fonts\\FRIZQT__.TTF" end,
        function(v) GR.db.appearance.hpFont = v; GR:RebuildAllFrames() end,
        "Font for HP percentage text.")

    _, y = CreateSlider(parent, "HP Font Size", y, 7, 20, 1,
        function() return GR.db.appearance.hpFontSize end,
        function(v) GR.db.appearance.hpFontSize = v; GR:RebuildAllFrames() end,
        "Size of the health percentage text.", "%.0f")

    _, y = CreateDropdown(parent, "HP Position", y, positionItems,
        function() return GR.db.appearance.hpPosition or "RIGHT" end,
        function(v) GR.db.appearance.hpPosition = v; GR:RebuildAllFrames() end,
        "Where to show the HP percentage on the bar.")

    -- Cast Bar
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Cast Bar Text", y)
    y = y - 6

    _, y = CreateDropdown(parent, "Cast Bar Font", y, GR.FONT_LIST,
        function() return GR.db.appearance.castFont or "Fonts\\FRIZQT__.TTF" end,
        function(v) GR.db.appearance.castFont = v; GR:RebuildAllFrames() end,
        "Font for cast bar text.")

    _, y = CreateSlider(parent, "Cast Bar Font Size", y, 6, 18, 1,
        function() return GR.db.appearance.castFontSize end,
        function(v) GR.db.appearance.castFontSize = v; GR:RebuildAllFrames() end,
        "Size of the cast bar text.", "%.0f")

    _, y = CreateDropdown(parent, "Cast Bar Font Outline", y, fontFlagItems,
        function() return GR.db.appearance.castFontFlags end,
        function(v) GR.db.appearance.castFontFlags = v; GR:RebuildAllFrames() end,
        "Outline style for cast bar text.")

    -- DR & Trinket (outside frame)
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Trinket & DR Icons (outside frame)", y)
    y = y - 6

    -- Trinket
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Trinket Icon", y)
    y = y - 6

    _, y = CreateSlider(parent, "Trinket Icon Size", y, 14, 50, 1,
        function() return GR.db.appearance.trinketSize or 26 end,
        function(v) GR.db.appearance.trinketSize = v; GR:RebuildAllFrames() end,
        "Size of the trinket icon.", "%.0f")

    local cdStyleItems = {
        ["spiral"]     = "Spiral + Text",
        ["spiralonly"] = "Spiral Only",
        ["text"]       = "Text Only",
        ["none"]       = "None",
    }
    _, y = CreateDropdown(parent, "Trinket CD Style", y, cdStyleItems,
        function() return GR.db.appearance.trinketCDStyle or "spiral" end,
        function(v) GR.db.appearance.trinketCDStyle = v; GR:RebuildAllFrames() end,
        "How to display the trinket cooldown.")

    _, y = CreateSlider(parent, "Trinket CD Text Size", y, 6, 24, 1,
        function() return GR.db.appearance.trinketCDTextSize or 12 end,
        function(v) GR.db.appearance.trinketCDTextSize = v; GR:RebuildAllFrames() end,
        "Size of the trinket cooldown number.", "%.0f")

    _, y = CreateSlider(parent, "Trinket CD Text Opacity", y, 0, 1, 0.05,
        function() return GR.db.appearance.trinketCDTextOpacity or 1.0 end,
        function(v) GR.db.appearance.trinketCDTextOpacity = v; GR:RebuildAllFrames() end,
        "Opacity of the trinket cooldown number.")

    -- DR Icons
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "DR Icons", y)
    y = y - 6

    _, y = CreateSlider(parent, "DR Icon Size", y, 12, 40, 1,
        function() return GR.db.appearance.drIconSize or 22 end,
        function(v) GR.db.appearance.drIconSize = v; GR:RebuildAllFrames() end,
        "Size of the DR icons.", "%.0f")

    local drCDItems = {
        ["spiral"] = "Spiral Only",
        ["both"]   = "Spiral + Text",
        ["text"]   = "Text Only",
        ["none"]   = "None",
    }
    _, y = CreateDropdown(parent, "DR CD Style", y, drCDItems,
        function() return GR.db.appearance.drCDStyle or "spiral" end,
        function(v) GR.db.appearance.drCDStyle = v; GR:RebuildAllFrames() end,
        "How to display the DR cooldown reset timer.")

    _, y = CreateSlider(parent, "DR Label Size", y, 5, 14, 1,
        function() return GR.db.appearance.drFontSize end,
        function(v) GR.db.appearance.drFontSize = v; GR:RebuildAllFrames() end,
        "Size of the DR state text (1/2, 1/4, 0).", "%.0f")

    _, y = CreateSlider(parent, "DR CD Text Size", y, 6, 20, 1,
        function() return GR.db.appearance.drCDTextSize or 10 end,
        function(v) GR.db.appearance.drCDTextSize = v; GR:RebuildAllFrames() end,
        "Size of the DR cooldown countdown number.", "%.0f")

    _, y = CreateSlider(parent, "DR Text Opacity", y, 0, 1, 0.05,
        function() return GR.db.appearance.drCDTextOpacity or 1.0 end,
        function(v) GR.db.appearance.drCDTextOpacity = v; GR:RebuildAllFrames() end,
        "Opacity of DR text overlays.")
end

------------------------------------------------------------
-- Page: Nameplates
------------------------------------------------------------
local function BuildNameplatesPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Nameplate Settings", y)
    y = y - 4

    CreateCheckbox(parent, "Force Enemy Nameplates in Arena", y,
        function() return GR.db.nameplates.forceEnemy end,
        function(v) GR.db.nameplates.forceEnemy = v end,
        "Force enemy nameplates ON in arena. Cannot be toggled off by keybinds.")
    y = y - ROW_HEIGHT - 2

    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Auto-Marking", y)
    y = y - 6

    CreateCheckbox(parent, "Enable Auto-Marking", y,
        function() return GR.db.nameplates.autoMark end,
        function(v) GR.db.nameplates.autoMark = v end,
        "Auto-place raid markers on party in arena.")
    y = y - ROW_HEIGHT - 2

    local markerItems = {
        [0] = "None", [1] = "Star", [2] = "Circle", [3] = "Diamond",
        [4] = "Triangle", [5] = "Moon", [6] = "Square", [7] = "Cross", [8] = "Skull",
    }

    local units = {
        { key = "player", label = "You" },
        { key = "party1", label = "Party 1" },
        { key = "party2", label = "Party 2" },
        { key = "party3", label = "Party 3" },
        { key = "party4", label = "Party 4" },
    }

    for _, u in ipairs(units) do
        CreateDropdown(parent, u.label .. " Marker", y, markerItems,
            function() return GR.db.nameplates.markAssignments[u.key] or 0 end,
            function(v)
                v = tonumber(v)
                GR.db.nameplates.markAssignments[u.key] = (v > 0) and v or nil
            end)
        y = y - 48
    end

    y = y - 10
    CreateButton(parent, "Apply Markers Now", y, 200, function()
        if GR.inArena then
            GR:ApplyMarkers()
            GR:Print("Markers applied.")
        else
            GR:Print("You must be in an arena.")
        end
    end)
end

------------------------------------------------------------
-- Page: Tracking
------------------------------------------------------------
local function BuildTrackingPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Tracking", y)
    y = y - 4

    _, y = CreateSubHeader(parent, "Trinket Tracking", y)
    y = y - 6
    _, y = CreateInfoText(parent,
        "Trinket usage is tracked automatically. When an enemy uses their PvP trinket or WotF, a 2-minute cooldown spiral appears on their arena frame.",
        y, 36)

    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Diminishing Returns", y)
    y = y - 6
    _, y = CreateInfoText(parent,
        "DR tracking is always active. Color-coded icons show:\n\n|cff00ff00Green|r = Full (1st)\n|cffffff00Yellow|r = Half (2nd)\n|cffff0000Red / IM|r = Quarter or Immune (3rd+)\n\nDRs reset after 15 seconds. Live countdown timers show remaining time.",
        y, 90)

    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Spec Detection", y)
    y = y - 6
    _, y = CreateInfoText(parent,
        "Enemy specs are detected from signature abilities in the combat log (e.g. Mortal Strike = Arms). Once identified, the spec shows on the arena frame for the rest of the match.",
        y, 40)
end

------------------------------------------------------------
-- Page: Announcements
------------------------------------------------------------
local function BuildAnnouncementsPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Announcements", y)
    y = y - 4

    _, y = CreateInfoText(parent, "Control what gets announced and where. Announcements fire during arena matches.", y, 20)
    y = y - 8

    -- Output mode
    _, y = CreateSubHeader(parent, "Output", y)
    y = y - 6

    local outputItems = {
        ["both"]  = "Self + Party Chat",
        ["self"]  = "Self Only (on-screen)",
        ["party"] = "Party Chat Only",
        ["none"]  = "Disabled",
    }
    _, y = CreateDropdown(parent, "Announcement Output", y, outputItems,
        function() return GR.db.announcements.output or "both" end,
        function(v) GR.db.announcements.output = v end,
        "Where to send announcements. Self = raid warning on screen. Party = party/raid chat.")

    -- Enemy callouts
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Enemy Callouts", y)
    y = y - 6

    CreateCheckbox(parent, "Trinket Used", y,
        function() return GR.db.announcements.trinket end,
        function(v) GR.db.announcements.trinket = v end,
        "Announce when an enemy uses PvP trinket or WotF.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "CC Breaker", y,
        function() return GR.db.announcements.ccBreaker end,
        function(v) GR.db.announcements.ccBreaker = v end,
        "Announce when an enemy breaks CC with trinket.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Enemy Drinking", y,
        function() return GR.db.announcements.drinking end,
        function(v) GR.db.announcements.drinking = v end,
        "Announce when an enemy starts drinking.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Spec Detected", y,
        function() return GR.db.announcements.enemySpec end,
        function(v) GR.db.announcements.enemySpec = v end,
        "Announce when an enemy spec is identified.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Offensive CDs", y,
        function() return GR.db.announcements.offensiveCD end,
        function(v) GR.db.announcements.offensiveCD = v end,
        "Announce major offensive cooldowns (Recklessness, Arcane Power, etc).")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Defensive CDs", y,
        function() return GR.db.announcements.defensiveCD end,
        function(v) GR.db.announcements.defensiveCD = v end,
        "Announce defensive cooldowns (Bubble, Block, Cloak, etc).")
    y = y - ROW_HEIGHT - 2

    -- Win conditions
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Win Conditions", y)
    y = y - 6

    CreateCheckbox(parent, "Enemy Low HP", y,
        function() return GR.db.announcements.enemyLowHP end,
        function(v) GR.db.announcements.enemyLowHP = v end,
        "Announce when an enemy is low health.")
    y = y - ROW_HEIGHT - 2

    _, y = CreateSlider(parent, "Enemy Low HP Threshold (%)", y, 10, 50, 5,
        function() return GR.db.announcements.enemyLowHPThreshold or 25 end,
        function(v) GR.db.announcements.enemyLowHPThreshold = v end,
        "HP percentage to trigger enemy low HP callout.", "%.0f%%")

    CreateCheckbox(parent, "Kill Target (no trinket + low)", y,
        function() return GR.db.announcements.killTarget end,
        function(v) GR.db.announcements.killTarget = v end,
        "Big callout when enemy is low, has no trinket, and no defensives. THE kill window.")
    y = y - ROW_HEIGHT - 2

    -- Team callouts
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Team Callouts", y)
    y = y - 6

    CreateCheckbox(parent, "Teammate Low HP", y,
        function() return GR.db.announcements.teamLowHP end,
        function(v) GR.db.announcements.teamLowHP = v end,
        "Announce when a teammate drops low. Peel callouts.")
    y = y - ROW_HEIGHT - 2

    _, y = CreateSlider(parent, "Team Low HP Threshold (%)", y, 15, 50, 5,
        function() return GR.db.announcements.teamLowHPThreshold or 30 end,
        function(v) GR.db.announcements.teamLowHPThreshold = v end,
        "HP percentage to trigger teammate low HP callout.", "%.0f%%")

    -- Arena Utilities
    y = y - SECTION_GAP
    _, y = CreateSubHeader(parent, "Arena Utilities", y)
    y = y - 6

    CreateCheckbox(parent, "Shadow Sight Timer", y,
        function() return GR.db.announcements.eyeTracker ~= false end,
        function(v) GR.db.announcements.eyeTracker = v end,
        "Show Shadow Sight orb spawn timer during arena.")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Arena Prep Checklist", y,
        function() return GR.db.announcements.prepChecklist ~= false end,
        function(v) GR.db.announcements.prepChecklist = v end,
        "Show missing items checklist in arena prep room (trinket, poisons, etc).")
    y = y - ROW_HEIGHT - 2

    CreateCheckbox(parent, "Queue Pop Alert", y,
        function() return GR.db.announcements.queueAlert ~= false end,
        function(v) GR.db.announcements.queueAlert = v end,
        "Show countdown timer and flash taskbar when arena queue pops.")
    y = y - ROW_HEIGHT - 2
end

------------------------------------------------------------
-- Page: Click Actions
------------------------------------------------------------
local function BuildClickActionsPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Click Actions", y)
    y = y - 4

    _, y = CreateInfoText(parent,
        "Configure what happens when you click on arena frames. Actions apply out of combat on next reload.",
        y, 24)
    y = y - 8

    local actionItems = {
        ["target"] = "Target",
        ["focus"]  = "Focus",
        ["spell"]  = "Cast Spell",
        ["macro"]  = "Run Macro",
        ["none"]   = "None",
    }

    -- Advanced arena macro presets — filtered to player class
    local _, playerClass = UnitClass("player")
    local presetItems = { ["_none"] = "-- Quick Presets --" }
    local presetLookup = {}
    if GR.CLICK_PRESETS then
        for idx, p in ipairs(GR.CLICK_PRESETS) do
            -- Only show presets for the player's class (or classless ones)
            if not p.classFilter or p.classFilter == playerClass then
                local key = "preset_" .. idx
                presetItems[key] = p.name
                presetLookup[key] = p
            end
        end
    end

    local modifierLabels = {
        [""]       = "No Modifier",
        ["shift-"] = "Shift",
        ["ctrl-"]  = "Ctrl",
        ["alt-"]   = "Alt",
    }

    local buttonLabels = { "Left Click", "Right Click" }

    local actions = GR.db.clicks and GR.db.clicks.actions
    if not actions then return end

    for idx, cfg in ipairs(actions) do
        local label = (modifierLabels[cfg.modifier] or "?") .. " + " .. (buttonLabels[cfg.button] or "?")

        _, y = CreateSubHeader(parent, label, y)
        y = y - 6

        _, y = CreateDropdown(parent, "Action", y, actionItems,
            function() return cfg.action or "none" end,
            function(v)
                cfg.action = v
                for i = 1, 5 do
                    if GR.frames[i] then GR:ApplyClickActions(GR.frames[i]) end
                end
            end)

        -- Quick preset dropdown for spell casting
        if cfg.action == "spell" or cfg.action == "none" or cfg.action == "target" or cfg.action == "focus" then
            _, y = CreateDropdown(parent, "Quick Spell Preset", y, presetItems,
                function() return "_none" end,
                function(v)
                    if v and v ~= "_none" and presetLookup[v] then
                        local p = presetLookup[v]
                        if p.action == "spell" then
                            cfg.action = "spell"
                            cfg.spell = p.spell
                        elseif p.action == "macro" then
                            cfg.action = "macro"
                            -- Store raw macro with *unit placeholder
                            cfg.spell = p.macro
                        end
                        for i = 1, 5 do
                            if GR.frames[i] then GR:ApplyClickActions(GR.frames[i]) end
                        end
                    end
                end)
        end

        -- Manual spell/macro input
        if cfg.action == "spell" or cfg.action == "macro" then
            local spellLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            spellLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, y)
            spellLabel:SetText(cfg.action == "spell" and "Spell Name:" or "Macro Text:")
            spellLabel:SetTextColor(0.7, 0.7, 0.7)

            local box = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
            box:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, y - 14)
            box:SetSize(220, 22)
            box:SetAutoFocus(false)
            box:SetText(cfg.spell or "")
            box:SetScript("OnEnterPressed", function(self)
                cfg.spell = self:GetText()
                self:ClearFocus()
                for i = 1, 5 do
                    if GR.frames[i] then GR:ApplyClickActions(GR.frames[i]) end
                end
            end)
            box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
            y = y - 42
        end

        y = y - 6
    end
end

------------------------------------------------------------
-- Page: Macro Toolkit
------------------------------------------------------------
local function BuildMacroToolkitPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Arena Macro Toolkit", y)
    y = y - 4

    _, y = CreateInfoText(parent,
        "Select your class to browse proven arena macros. Click Import to create the macro on your character. Macros use /cast [@focus] and /cast [@arena1] targeting for arena play.",
        y, 36)
    y = y - 8

    local classKeys = { "ROGUE", "MAGE", "WARLOCK", "PRIEST", "DRUID", "PALADIN", "WARRIOR", "HUNTER", "SHAMAN" }
    local classNames = {
        ROGUE = "Rogue", MAGE = "Mage", WARLOCK = "Warlock",
        PRIEST = "Priest", DRUID = "Druid", PALADIN = "Paladin",
        WARRIOR = "Warrior", HUNTER = "Hunter", SHAMAN = "Shaman",
    }

    local classDropdownItems = {}
    for _, k in ipairs(classKeys) do
        classDropdownItems[k] = classNames[k]
    end

    -- Detect player class as default
    local _, playerClass = UnitClass("player")
    local selectedClass = playerClass or "ROGUE"

    -- Container for macro list (we'll rebuild this on class change)
    local macroListContainer = CreateFrame("Frame", nil, parent)
    macroListContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y - 56)
    macroListContainer:SetSize(600, 1200)

    local function BuildMacroList()
        -- Clear existing children
        local children = { macroListContainer:GetChildren() }
        for _, child in ipairs(children) do
            child:Hide()
            child:SetParent(nil)
        end

        local macros = GR.MACRO_CATALOG and GR.MACRO_CATALOG[selectedClass]
        if not macros then return end

        local my = 0
        for idx, m in ipairs(macros) do
            -- Macro card
            local card = CreateFrame("Frame", nil, macroListContainer, BackdropTemplateMixin and "BackdropTemplate" or nil)
            card:SetPoint("TOPLEFT", macroListContainer, "TOPLEFT", 0, my)
            card:SetSize(560, 70)
            if card.SetBackdrop then
                card:SetBackdrop({
                    bgFile = "Interface\\Buttons\\WHITE8x8",
                    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                    edgeSize = 8,
                    insets = { left = 2, right = 2, top = 2, bottom = 2 },
                })
                card:SetBackdropColor(0.08, 0.08, 0.08, 0.9)
                card:SetBackdropBorderColor(0.25, 0.25, 0.25, 0.8)
            end

            -- Macro name
            local nameText = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nameText:SetPoint("TOPLEFT", card, "TOPLEFT", 8, -6)
            nameText:SetText("|cff33ff99" .. m.name .. "|r")

            -- Description
            local descText = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            descText:SetPoint("TOPLEFT", nameText, "BOTTOMLEFT", 0, -2)
            descText:SetWidth(400)
            descText:SetJustifyH("LEFT")
            descText:SetText(m.desc)
            descText:SetTextColor(0.6, 0.6, 0.6)

            -- Macro body preview
            local bodyPreview = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            bodyPreview:SetPoint("BOTTOMLEFT", card, "BOTTOMLEFT", 8, 6)
            bodyPreview:SetWidth(400)
            bodyPreview:SetJustifyH("LEFT")
            bodyPreview:SetFont(STANDARD_TEXT_FONT, 9, "")
            local previewText = m.body:gsub("\n", " | ")
            if #previewText > 60 then previewText = previewText:sub(1, 57) .. "..." end
            bodyPreview:SetText("|cff888888" .. previewText .. "|r")

            -- Import button
            local importBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
            importBtn:SetSize(80, 22)
            importBtn:SetPoint("RIGHT", card, "RIGHT", -8, 0)
            importBtn:SetText("Import")
            importBtn:SetScript("OnClick", function()
                local macroName = "GR: " .. m.name
                -- Check if macro already exists
                local existingId = GetMacroIndexByName(macroName)
                if existingId and existingId > 0 then
                    EditMacro(existingId, macroName, m.icon or "INV_Misc_QuestionMark", m.body)
                    GR:Print("Macro updated: " .. macroName)
                else
                    local numGlobal, numChar = GetNumMacros()
                    -- Create as character-specific macro
                    if numChar < 18 then
                        CreateMacro(macroName, m.icon or "INV_Misc_QuestionMark", m.body, true)
                        GR:Print("Macro created: " .. macroName)
                    else
                        GR:Print("|cffff0000Character macro slots full! Delete a macro first.|r")
                    end
                end
            end)

            my = my - 76
        end
    end

    _, y = CreateDropdown(parent, "Select Class", y, classDropdownItems,
        function() return selectedClass end,
        function(v)
            selectedClass = v
            BuildMacroList()
        end)

    BuildMacroList()
end

------------------------------------------------------------
-- Page: About
------------------------------------------------------------
local function BuildAboutPage(parent)
    local y = -10
    _, y = CreateSectionHeader(parent, "Gladius Reborn", y)
    y = y - 4

    local lines = {
        { "|cff33ff99Version:|r 1.0.0", 0.9, 0.9, 0.9 },
        { "|cff33ff99Author:|r evildz on nightslayer", 0.9, 0.9, 0.9 },
        { "", 1, 1, 1 },
        { "Arena unit frames for TBC Classic Anniversary (2.5.5).", 0.7, 0.7, 0.7 },
        { "A modern Gladius replacement, built from scratch.", 0.7, 0.7, 0.7 },
        { "", 1, 1, 1 },
        { "|cff33ff99Features:|r", 0.9, 0.9, 0.9 },
        { "  - Arena enemy unit frames with HP, Mana, Cast bars", 0.7, 0.7, 0.7 },
        { "  - Configurable click actions with arena macro presets", 0.7, 0.7, 0.7 },
        { "  - PvP Trinket tracking with cooldown spirals", 0.7, 0.7, 0.7 },
        { "  - DR tracking with spell icons and timers", 0.7, 0.7, 0.7 },
        { "  - Aura tracking (buffs/debuffs on enemies)", 0.7, 0.7, 0.7 },
        { "  - Spec detection from combat log", 0.7, 0.7, 0.7 },
        { "  - Smart alerts: offensive/defensive CDs, kill windows", 0.7, 0.7, 0.7 },
        { "  - Teammate low HP warnings", 0.7, 0.7, 0.7 },
        { "  - Full announcement system (self/party/both)", 0.7, 0.7, 0.7 },
        { "  - Forced enemy nameplates in arena", 0.7, 0.7, 0.7 },
        { "  - Auto party raid markers", 0.7, 0.7, 0.7 },
        { "  - Arena macro toolkit with one-click import", 0.7, 0.7, 0.7 },
        { "  - Full appearance customization with themes", 0.7, 0.7, 0.7 },
        { "  - 5 profile slots + per-character defaults", 0.7, 0.7, 0.7 },
        { "", 1, 1, 1 },
        { "|cffffff00Special Thanks:|r", 1, 0.82, 0 },
        { "", 1, 1, 1 },
        { "|cff33ff99Gladius|r by Proditor (Resike)", 0.8, 0.8, 0.8 },
        { "The original arena frames addon that started it all.", 0.6, 0.6, 0.6 },
        { "Your work defined what arena addons should be and gave", 0.6, 0.6, 0.6 },
        { "every PvP player a better experience for years.", 0.6, 0.6, 0.6 },
        { "", 1, 1, 1 },
        { "|cff33ff99GladiusEx|r by slaren & vendethiel", 0.8, 0.8, 0.8 },
        { "The spiritual successor that pushed arena frames forward", 0.6, 0.6, 0.6 },
        { "with modular design, DR tracking, cooldown tracking,", 0.6, 0.6, 0.6 },
        { "and countless features the community relied on.", 0.6, 0.6, 0.6 },
        { "", 1, 1, 1 },
        { "Gladius Reborn exists because of their work. Without the", 0.6, 0.6, 0.6 },
        { "foundation they built and the standard they set, this addon", 0.6, 0.6, 0.6 },
        { "would not exist. Thank you for everything you contributed", 0.6, 0.6, 0.6 },
        { "to the WoW PvP community.", 0.6, 0.6, 0.6 },
    }

    for _, line in ipairs(lines) do
        local t = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        t:SetPoint("TOPLEFT", parent, "TOPLEFT", 14, y)
        t:SetWidth(500)
        t:SetJustifyH("LEFT")
        t:SetText(line[1])
        t:SetTextColor(line[2], line[3], line[4])
        y = y - 16
    end
end

------------------------------------------------------------
-- Categories
------------------------------------------------------------
local categories = {
    { name = "General",        builder = BuildGeneralPage },
    { name = "Appearance",     builder = BuildAppearancePage },
    { name = "Click Actions",  builder = BuildClickActionsPage },
    { name = "Macro Toolkit",  builder = BuildMacroToolkitPage },
    { name = "Nameplates",     builder = BuildNameplatesPage },
    { name = "Tracking",       builder = BuildTrackingPage },
    { name = "Announcements",  builder = BuildAnnouncementsPage },
    { name = "About",          builder = BuildAboutPage },
}

------------------------------------------------------------
-- Show Category
------------------------------------------------------------
local function ShowCategory(index)
    if activeCategory == index then return end
    activeCategory = index

    for _, cf in pairs(contentFrames) do cf:Hide() end
    for _, btn in pairs(sidebarButtons) do
        btn:UnlockHighlight()
        btn.text:SetTextColor(0.7, 0.7, 0.7)
    end

    if contentFrames[index] then contentFrames[index]:Show() end
    if sidebarButtons[index] then
        sidebarButtons[index]:LockHighlight()
        sidebarButtons[index].text:SetTextColor(1, 0.82, 0)
    end
end

------------------------------------------------------------
-- Build Main Panel
------------------------------------------------------------
local function CreateOptionsPanel()
    if optionsFrame then return optionsFrame end

    local f = CreateFrame("Frame", "GladiusReborn_Options", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    f:SetSize(PANEL_WIDTH, PANEL_HEIGHT)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:SetFrameStrata("DIALOG")
    f:SetToplevel(true)
    ApplyBackdrop(f, { 0.05, 0.05, 0.05, 0.95 }, { 0.3, 0.3, 0.3, 1 })
    f:Hide()

    -- Title bar
    local titleBar = CreateFrame("Frame", nil, f)
    titleBar:SetHeight(32)
    titleBar:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
    titleBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0)
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function() f:StartMoving() end)
    titleBar:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)

    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -8)
    title:SetText("|cff33ff99Gladius Reborn|r")

    local version = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    version:SetPoint("LEFT", title, "RIGHT", 8, 0)
    version:SetText("v1.0.0")
    version:SetTextColor(0.5, 0.5, 0.5)

    local closeBtn = CreateFrame("Button", nil, f)
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -6, -6)
    closeBtn:SetFrameStrata("FULLSCREEN_DIALOG")
    closeBtn:SetFrameLevel(f:GetFrameLevel() + 20)
    closeBtn:EnableMouse(true)
    closeBtn:RegisterForClicks("AnyUp")

    local closeBg = closeBtn:CreateTexture(nil, "BACKGROUND")
    closeBg:SetAllPoints()
    closeBg:SetColorTexture(0.15, 0.15, 0.15, 0.9)

    local closeText = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    closeText:SetPoint("CENTER", closeBtn, "CENTER", 0, 0)
    closeText:SetText("X")
    closeText:SetTextColor(0.9, 0.3, 0.3)

    closeBtn:SetScript("OnClick", function() f:Hide() end)
    closeBtn:SetScript("OnEnter", function()
        closeBg:SetColorTexture(0.5, 0.1, 0.1, 1)
        closeText:SetTextColor(1, 1, 1)
    end)
    closeBtn:SetScript("OnLeave", function()
        closeBg:SetColorTexture(0.15, 0.15, 0.15, 0.9)
        closeText:SetTextColor(0.9, 0.3, 0.3)
    end)

    -- Sidebar
    local sidebar = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate" or nil)
    sidebar:SetWidth(SIDEBAR_WIDTH)
    sidebar:SetPoint("TOPLEFT", f, "TOPLEFT", 6, -36)
    sidebar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 6, 6)
    ApplyBackdrop(sidebar, { 0.08, 0.08, 0.08, 0.9 }, { 0.2, 0.2, 0.2, 0.6 })

    local divider = f:CreateTexture(nil, "ARTWORK")
    divider:SetWidth(1)
    divider:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 3, 0)
    divider:SetPoint("BOTTOMLEFT", sidebar, "BOTTOMRIGHT", 3, 0)
    divider:SetColorTexture(0.3, 0.3, 0.3, 0.8)

    -- Sidebar buttons
    for i, cat in ipairs(categories) do
        local btn = CreateFrame("Button", nil, sidebar)
        btn:SetSize(SIDEBAR_WIDTH - 12, 28)
        if i == 1 then
            btn:SetPoint("TOPLEFT", sidebar, "TOPLEFT", 6, -8)
        else
            btn:SetPoint("TOPLEFT", sidebarButtons[i - 1], "BOTTOMLEFT", 0, -2)
        end
        btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
        btn:GetHighlightTexture():SetVertexColor(0.3, 0.6, 1, 0.3)

        btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        btn.text:SetPoint("LEFT", btn, "LEFT", 10, 0)
        btn.text:SetText(cat.name)
        btn.text:SetTextColor(0.7, 0.7, 0.7)

        btn:SetScript("OnClick", function() ShowCategory(i) end)
        sidebarButtons[i] = btn
    end

    -- Content frames
    for i, cat in ipairs(categories) do
        local content = CreateFrame("Frame", nil, f)
        content:SetPoint("TOPLEFT", f, "TOPLEFT", CONTENT_LEFT, -40)
        content:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -28, 10)
        content:Hide()

        local scroll = CreateFrame("ScrollFrame", "GR_Scroll_" .. i, content, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
        scroll:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", -20, 0)

        -- Move the scrollbar inside the content area
        local scrollBar = scroll.ScrollBar or _G["GR_Scroll_" .. i .. "ScrollBar"]
        if scrollBar then
            scrollBar:ClearAllPoints()
            scrollBar:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -16)
            scrollBar:SetPoint("BOTTOMRIGHT", content, "BOTTOMRIGHT", 0, 16)
        end

        local scrollChild = CreateFrame("Frame", nil, scroll)
        scrollChild:SetWidth(PANEL_WIDTH - CONTENT_LEFT - 40)
        scrollChild:SetHeight(1200)
        scroll:SetScrollChild(scrollChild)

        cat.builder(scrollChild)
        contentFrames[i] = content
    end

    tinsert(UISpecialFrames, "GladiusReborn_Options")
    optionsFrame = f
    return f
end

------------------------------------------------------------
-- Show / Toggle
------------------------------------------------------------
function GR:ShowOptionsPanel()
    local panel = CreateOptionsPanel()
    panel:Show()
    ShowCategory(1)
end

function GR:ToggleOptionsPanel()
    local panel = CreateOptionsPanel()
    if panel:IsShown() then
        panel:Hide()
    else
        panel:Show()
        ShowCategory(activeCategory or 1)
    end
end

------------------------------------------------------------
-- Blizzard Interface Panel
------------------------------------------------------------
local blizzPanel = CreateFrame("Frame", "GladiusReborn_BlizzOptions")
blizzPanel.name = "Gladius Reborn"

local blizzText = blizzPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
blizzText:SetPoint("TOPLEFT", 16, -16)
blizzText:SetText("|cff33ff99Gladius Reborn|r")

local blizzDesc = blizzPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
blizzDesc:SetPoint("TOPLEFT", blizzText, "BOTTOMLEFT", 0, -8)
blizzDesc:SetText("Arena enemy unit frames for TBC Classic Anniversary.")

local blizzBtn = CreateFrame("Button", nil, blizzPanel, "UIPanelButtonTemplate")
blizzBtn:SetSize(200, 30)
blizzBtn:SetPoint("TOPLEFT", blizzDesc, "BOTTOMLEFT", 0, -16)
blizzBtn:SetText("Open Gladius Reborn Options")
blizzBtn:SetScript("OnClick", function() GR:ShowOptionsPanel() end)

if InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(blizzPanel)
end
