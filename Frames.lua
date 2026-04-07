local _, GR = ...

------------------------------------------------------------
-- Appearance Helpers
------------------------------------------------------------
local function A()
    return GR.db and GR.db.appearance or {}
end

local MAX_DR_ICONS = 5

------------------------------------------------------------
-- Presets (actual themes, not just resizes)
------------------------------------------------------------
GR.PRESETS = {
    default = {
        name = "Default",
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
        hpFont = "Fonts\\FRIZQT__.TTF",
        hpFontSize = 10,
        hpFontFlags = "OUTLINE",
        castFont = "Fonts\\FRIZQT__.TTF",
        castFontSize = 9,
        castFontFlags = "OUTLINE",
        drFontSize = 8,
        drTimerFontSize = 7,
        classColorBars = true,
        castBarColor = { 1, 0.7, 0 },
        channelBarColor = { 0, 0.7, 1 },
        powerBarHeight = 6,
        hpBarHeight = 28,
        trinketSize = 26,
        drIconSize = 22,
    },
    elvui = {
        name = "ElvUI Dark",
        barWidth = 220,
        barHeight = 40,
        castBarHeight = 14,
        spacing = 3,
        barTexture = "Interface\\AddOns\\ElvUI\\Core\\Media\\Textures\\NormTex",
        bgAlpha = 0.9,
        borderSize = 1,
        borderColor = { 0, 0, 0, 1 },
        bgColor = { 0.06, 0.06, 0.06, 0.92 },
        nameFont = "Fonts\\ARIALN.TTF",
        nameFontSize = 11,
        nameFontFlags = "",
        nameFontShadow = true,
        nameFontShadowColor = { 0, 0, 0, 1 },
        nameFontShadowOffset = { 1, -1 },
        hpFont = "Fonts\\ARIALN.TTF",
        hpFontSize = 10,
        hpFontFlags = "",
        castFont = "Fonts\\ARIALN.TTF",
        castFontSize = 9,
        castFontFlags = "",
        drFontSize = 8,
        drTimerFontSize = 7,
        classColorBars = true,
        castBarColor = { 0.84, 0.75, 0.15 },
        channelBarColor = { 0.15, 0.65, 0.84 },
        powerBarHeight = 5,
        hpBarHeight = 28,
        trinketSize = 26,
        drIconSize = 22,
    },
    shadow = {
        name = "Shadow",
        barWidth = 220,
        barHeight = 42,
        castBarHeight = 14,
        spacing = 2,
        barTexture = "Interface\\RaidFrame\\Raid-Bar-Hp-Fill",
        bgAlpha = 0.88,
        borderSize = 0,
        borderColor = { 0, 0, 0, 0 },
        bgColor = { 0.03, 0.03, 0.03, 0.92 },
        nameFont = "Fonts\\MORPHEUS.TTF",
        nameFontSize = 12,
        nameFontFlags = "",
        nameFontShadow = true,
        nameFontShadowColor = { 0, 0, 0, 1 },
        nameFontShadowOffset = { 2, -2 },
        hpFont = "Fonts\\MORPHEUS.TTF",
        hpFontSize = 11,
        hpFontFlags = "",
        castFont = "Fonts\\MORPHEUS.TTF",
        castFontSize = 10,
        castFontFlags = "",
        drFontSize = 9,
        drTimerFontSize = 7,
        classColorBars = true,
        castBarColor = { 0.8, 0.4, 0 },
        channelBarColor = { 0.4, 0.2, 0.8 },
        powerBarHeight = 6,
        hpBarHeight = 28,
        trinketSize = 26,
        drIconSize = 22,
    },
    gothic = {
        name = "Gothic",
        barWidth = 230,
        barHeight = 44,
        castBarHeight = 14,
        spacing = 2,
        barTexture = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar",
        bgAlpha = 0.85,
        borderSize = 12,
        borderColor = { 0.6, 0.5, 0.3, 1 },
        bgColor = { 0.08, 0.05, 0.02, 0.9 },
        nameFont = "Fonts\\MORPHEUS.TTF",
        nameFontSize = 13,
        nameFontFlags = "THICKOUTLINE",
        nameFontShadow = true,
        nameFontShadowColor = { 0, 0, 0, 1 },
        nameFontShadowOffset = { 2, -2 },
        hpFont = "Fonts\\MORPHEUS.TTF",
        hpFontSize = 12,
        hpFontFlags = "THICKOUTLINE",
        castFont = "Fonts\\MORPHEUS.TTF",
        castFontSize = 10,
        castFontFlags = "OUTLINE",
        drFontSize = 9,
        drTimerFontSize = 8,
        classColorBars = true,
        castBarColor = { 0.9, 0.6, 0.1 },
        channelBarColor = { 0.2, 0.8, 0.4 },
        powerBarHeight = 6,
        hpBarHeight = 28,
        trinketSize = 26,
        drIconSize = 22,
    },
    minimal = {
        name = "Minimal",
        barWidth = 200,
        barHeight = 36,
        castBarHeight = 10,
        spacing = 1,
        barTexture = "Interface\\Buttons\\WHITE8x8",
        bgAlpha = 0.7,
        borderSize = 1,
        borderColor = { 0.15, 0.15, 0.15, 1 },
        bgColor = { 0.04, 0.04, 0.04, 0.8 },
        nameFont = "Fonts\\ARIALN.TTF",
        nameFontSize = 10,
        nameFontFlags = "",
        nameFontShadow = true,
        nameFontShadowColor = { 0, 0, 0, 0.8 },
        nameFontShadowOffset = { 1, -1 },
        hpFont = "Fonts\\ARIALN.TTF",
        hpFontSize = 9,
        hpFontFlags = "",
        castFont = "Fonts\\ARIALN.TTF",
        castFontSize = 8,
        castFontFlags = "",
        drFontSize = 7,
        drTimerFontSize = 6,
        classColorBars = true,
        castBarColor = { 0.9, 0.8, 0.3 },
        channelBarColor = { 0.3, 0.7, 0.9 },
        powerBarHeight = 3,
        hpBarHeight = 28,
        trinketSize = 22,
        drIconSize = 18,
    },
    neon = {
        name = "Neon",
        barWidth = 220,
        barHeight = 42,
        castBarHeight = 14,
        spacing = 3,
        barTexture = "Interface\\TargetingFrame\\UI-StatusBar",
        bgAlpha = 0.92,
        borderSize = 10,
        borderColor = { 0, 0.8, 0.8, 0.6 },
        bgColor = { 0, 0.02, 0.06, 0.95 },
        nameFont = "Fonts\\skurri.TTF",
        nameFontSize = 12,
        nameFontFlags = "OUTLINE",
        nameFontShadow = true,
        nameFontShadowColor = { 0, 0.4, 0.4, 0.8 },
        nameFontShadowOffset = { 1, -1 },
        hpFont = "Fonts\\skurri.TTF",
        hpFontSize = 11,
        hpFontFlags = "OUTLINE",
        castFont = "Fonts\\skurri.TTF",
        castFontSize = 10,
        castFontFlags = "OUTLINE",
        drFontSize = 9,
        drTimerFontSize = 7,
        classColorBars = true,
        castBarColor = { 0, 1, 0.6 },
        channelBarColor = { 1, 0, 0.6 },
        powerBarHeight = 6,
        hpBarHeight = 28,
        trinketSize = 26,
        drIconSize = 22,
    },
    blizzard = {
        name = "Blizzard Classic",
        barWidth = 220,
        barHeight = 44,
        castBarHeight = 14,
        spacing = 2,
        barTexture = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill",
        bgAlpha = 0.7,
        borderSize = 14,
        borderColor = { 0.6, 0.6, 0.6, 1 },
        bgColor = { 0, 0, 0, 0.65 },
        nameFont = "Fonts\\FRIZQT__.TTF",
        nameFontSize = 11,
        nameFontFlags = "OUTLINE",
        nameFontShadow = false,
        nameFontShadowColor = { 0, 0, 0, 1 },
        nameFontShadowOffset = { 1, -1 },
        hpFont = "Fonts\\FRIZQT__.TTF",
        hpFontSize = 10,
        hpFontFlags = "OUTLINE",
        castFont = "Fonts\\FRIZQT__.TTF",
        castFontSize = 9,
        castFontFlags = "OUTLINE",
        drFontSize = 8,
        drTimerFontSize = 7,
        classColorBars = false,
        castBarColor = { 1, 0.7, 0 },
        channelBarColor = { 0, 0.7, 1 },
        powerBarHeight = 6,
        hpBarHeight = 28,
        trinketSize = 26,
        drIconSize = 22,
    },
}

function GR:ApplyPreset(presetKey)
    local preset = GR.PRESETS[presetKey]
    if not preset then return end
    for k, v in pairs(preset) do
        if k ~= "name" then
            if type(v) == "table" then
                GR.db.appearance[k] = { unpack(v) }
            else
                GR.db.appearance[k] = v
            end
        end
    end
    GR.db.appearance.preset = presetKey
    GR:RebuildAllFrames()
end

------------------------------------------------------------
-- Anchor Frame (drag to reposition)
------------------------------------------------------------
local anchor = CreateFrame("Frame", "GladiusReborn_Anchor", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
anchor:SetSize(220, 16)
anchor:SetPoint("RIGHT", UIParent, "RIGHT", -100, 0)
anchor:SetMovable(true)
anchor:EnableMouse(false)
anchor:SetClampedToScreen(true)
anchor:Hide()

anchor.title = anchor:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
anchor.title:SetPoint("CENTER")
anchor.title:SetText("Gladius Reborn - drag to move")

anchor:SetScript("OnDragStart", function(self) self:StartMoving() end)
anchor:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relPoint, x, y = self:GetPoint()
    GR.db.position = { point = point, relPoint = relPoint, x = x, y = y }
end)

function GR:RestorePosition()
    local p = GR.db.position
    anchor:ClearAllPoints()
    anchor:SetPoint(p.point or "RIGHT", UIParent, p.relPoint or "RIGHT", p.x or -100, p.y or 0)
    anchor:SetSize(A().barWidth or 220, 16)
end

function GR:SetLocked(locked)
    GR.db.locked = locked
    if locked then
        anchor:EnableMouse(false)
        anchor:RegisterForDrag()
        anchor:Hide()
    else
        anchor:EnableMouse(true)
        anchor:RegisterForDrag("LeftButton")
        anchor:Show()
    end
end

------------------------------------------------------------
-- Apply Appearance to a single frame
------------------------------------------------------------
local function ApplyAppearance(f)
    local a = A()
    local FRAME_WIDTH = a.barWidth or 220
    local CAST_HEIGHT = a.castBarHeight or 14
    local SPACING = a.spacing or 2
    local PAD = 3
    local TRINKET_SIZE = a.trinketSize or 26
    local DR_ICON_SIZE = a.drIconSize or 22
    local POWER_HEIGHT = a.powerBarHeight or 6
    local HP_HEIGHT = a.hpBarHeight or 28
    local BAR_TEXTURE = a.barTexture or "Interface\\TargetingFrame\\UI-StatusBar"

    -- Auto frame height: frame grows to fit content
    local BARS_HEIGHT = HP_HEIGHT + POWER_HEIGHT + 1 -- hp + gap + power
    local ICON_SIZE = BARS_HEIGHT
    local FRAME_HEIGHT = BARS_HEIGHT + (PAD * 2)
    local TOTAL_HEIGHT = FRAME_HEIGHT + CAST_HEIGHT + SPACING
    f:SetSize(FRAME_WIDTH, TOTAL_HEIGHT)

    -- Background - inset so it doesn't bleed past border
    f.bg:ClearAllPoints()
    f.bg:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
    f.bg:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
    local bgC = a.bgColor or { 0, 0, 0, 0.7 }
    f.bg:SetColorTexture(bgC[1], bgC[2], bgC[3], bgC[4] or a.bgAlpha or 0.7)

    -- Border
    if f.border.SetBackdrop then
        local bs = a.borderSize or 10
        local inset = math.max(1, math.floor(bs / 4))
        f.border:SetBackdrop({
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = bs,
            insets = { left = inset, right = inset, top = inset, bottom = inset },
        })
        local bc = a.borderColor or { 0.3, 0.3, 0.3, 0.8 }
        f.border:SetBackdropBorderColor(bc[1], bc[2], bc[3], bc[4])
    end

    -- Class icon: optional
    local showIcon = a.showClassIcon ~= false
    f.classIcon:SetSize(ICON_SIZE, ICON_SIZE)
    f.classIcon:ClearAllPoints()
    f.classIcon:SetPoint("TOPLEFT", f, "TOPLEFT", PAD, -PAD)
    if showIcon then
        f.classIcon:Show()
    else
        f.classIcon:Hide()
    end

    -- Spec text position
    local specPos = a.specPosition or "ICON"
    f.specText:ClearAllPoints()
    f.specText:SetFont(a.nameFont or STANDARD_TEXT_FONT, math.max(7, (a.nameFontSize or 11) - 3), a.nameFontFlags or "OUTLINE")
    f.specText:SetTextColor(0.8, 0.8, 0.8)
    if not showIcon and specPos == "ICON" then
        -- If icon is hidden and spec is set to show on icon, hide spec too
        f.specText:Hide()
    elseif specPos == "ICON" then
        f.specText:SetPoint("BOTTOM", f.classIcon, "BOTTOM", 0, 1)
    elseif specPos == "NAME" then
        -- Will be appended to name text in UpdateFrameUnit
        f.specText:SetPoint("BOTTOM", f.classIcon, "BOTTOM", 0, 1)
    else
        f.specText:SetPoint("BOTTOM", f.classIcon, "BOTTOM", 0, 1)
    end

    -- Name text
    f.nameText:SetFont(a.nameFont or STANDARD_TEXT_FONT, a.nameFontSize or 11, a.nameFontFlags or "OUTLINE")
    -- Name color: white by default, class-colored handled in UpdateFrameUnit
    if not a.nameColorByClass then
        local nc = a.nameFontColor or { 1, 1, 1, 1 }
        f.nameText:SetTextColor(nc[1], nc[2], nc[3], nc[4] or 1)
    end
    if a.nameFontShadow then
        local sc = a.nameFontShadowColor or { 0, 0, 0, 1 }
        local so = a.nameFontShadowOffset or { 1, -1 }
        f.nameText:SetShadowColor(sc[1], sc[2], sc[3], sc[4])
        f.nameText:SetShadowOffset(so[1], so[2])
    else
        f.nameText:SetShadowOffset(0, 0)
    end

    -- Name position
    local namePos = a.namePosition or "LEFT"
    f.nameText:ClearAllPoints()
    if namePos == "LEFT" then
        f.nameText:SetJustifyH("LEFT")
    elseif namePos == "CENTER" then
        f.nameText:SetJustifyH("CENTER")
    elseif namePos == "RIGHT" then
        f.nameText:SetJustifyH("RIGHT")
    end

    -- Health bar: fills from icon to right edge of frame
    local barW
    if showIcon then
        barW = FRAME_WIDTH - ICON_SIZE - (PAD * 2) - 3
        f.healthBar:ClearAllPoints()
        f.healthBar:SetPoint("TOPLEFT", f.classIcon, "TOPRIGHT", 2, 0)
    else
        barW = FRAME_WIDTH - (PAD * 2) - 2
        f.healthBar:ClearAllPoints()
        f.healthBar:SetPoint("TOPLEFT", f, "TOPLEFT", PAD + 1, -PAD)
    end
    f.healthBar:SetSize(barW, HP_HEIGHT)
    f.healthBar:SetStatusBarTexture(BAR_TEXTURE)
    f.healthBar.bg:SetTexture(BAR_TEXTURE)

    -- HP text
    f.healthText:SetFont(a.hpFont or STANDARD_TEXT_FONT, a.hpFontSize or 10, a.hpFontFlags or "OUTLINE")
    local hpc = a.hpFontColor or { 1, 1, 1, 1 }
    f.healthText:SetTextColor(hpc[1], hpc[2], hpc[3], hpc[4] or 1)
    if a.nameFontShadow then
        local sc = a.nameFontShadowColor or { 0, 0, 0, 1 }
        local so = a.nameFontShadowOffset or { 1, -1 }
        f.healthText:SetShadowColor(sc[1], sc[2], sc[3], sc[4])
        f.healthText:SetShadowOffset(so[1], so[2])
    else
        f.healthText:SetShadowOffset(0, 0)
    end

    -- HP text position
    local hpPos = a.hpPosition or "RIGHT"
    f.healthText:ClearAllPoints()
    if hpPos == "RIGHT" then
        f.healthText:SetPoint("RIGHT", f.healthBar, "RIGHT", -2, 0)
        f.healthText:SetJustifyH("RIGHT")
    elseif hpPos == "LEFT" then
        f.healthText:SetPoint("LEFT", f.healthBar, "LEFT", 2, 0)
        f.healthText:SetJustifyH("LEFT")
    elseif hpPos == "CENTER" then
        f.healthText:SetPoint("CENTER", f.healthBar, "CENTER", 0, 0)
        f.healthText:SetJustifyH("CENTER")
    end

    -- Name on health bar (after HP position so we can avoid overlap)
    f.nameText:SetParent(f.healthBar)
    if namePos == "LEFT" then
        f.nameText:SetPoint("LEFT", f.healthBar, "LEFT", 2, 0)
        f.nameText:SetPoint("RIGHT", f.healthText, "LEFT", -2, 0)
    elseif namePos == "CENTER" then
        f.nameText:SetPoint("CENTER", f.healthBar, "CENTER", 0, 0)
    elseif namePos == "RIGHT" then
        f.nameText:SetPoint("RIGHT", f.healthText, "LEFT", -4, 0)
    end

    -- Power bar: below health bar
    f.powerBar:SetSize(barW, POWER_HEIGHT)
    f.powerBar:ClearAllPoints()
    f.powerBar:SetPoint("TOPLEFT", f.healthBar, "BOTTOMLEFT", 0, -1)
    f.powerBar:SetStatusBarTexture(BAR_TEXTURE)
    f.powerBar.bg:SetTexture(BAR_TEXTURE)

    -- Cast bar
    f.castBar:SetSize(FRAME_WIDTH - PAD * 2, CAST_HEIGHT)
    f.castBar:ClearAllPoints()
    f.castBar:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", PAD, PAD)
    f.castBar:SetStatusBarTexture(BAR_TEXTURE)
    f.castBar.bg:SetTexture(BAR_TEXTURE)
    f.castBar.icon:SetSize(CAST_HEIGHT, CAST_HEIGHT)

    -- Cast bar text colors
    local cfc = a.castFontColor or { 1, 1, 1, 1 }
    local ctc = a.castTimerColor or { 1, 1, 1, 1 }
    f.castBar.text:SetFont(a.castFont or STANDARD_TEXT_FONT, a.castFontSize or 9, a.castFontFlags or "OUTLINE")
    f.castBar.text:SetTextColor(cfc[1], cfc[2], cfc[3], cfc[4] or 1)
    f.castBar.timer:SetFont(a.castFont or STANDARD_TEXT_FONT, a.castFontSize or 9, a.castFontFlags or "OUTLINE")
    f.castBar.timer:SetTextColor(ctc[1], ctc[2], ctc[3], ctc[4] or 1)

    -- Trinket: OUTSIDE the frame, anchored to the right edge
    f.trinket:SetSize(TRINKET_SIZE, TRINKET_SIZE)
    f.trinket:ClearAllPoints()
    f.trinket:SetPoint("TOPLEFT", f, "TOPRIGHT", 2, 0)

    -- Trinket cooldown style
    local trinketCDStyle = a.trinketCDStyle or "spiral"
    if trinketCDStyle == "text" then
        f.trinket.cooldown:SetDrawSwipe(false)
        f.trinket.cooldown:SetHideCountdownNumbers(false)
    elseif trinketCDStyle == "spiral" then
        f.trinket.cooldown:SetDrawSwipe(true)
        f.trinket.cooldown:SetHideCountdownNumbers(false)
    elseif trinketCDStyle == "spiralonly" then
        f.trinket.cooldown:SetDrawSwipe(true)
        f.trinket.cooldown:SetHideCountdownNumbers(true)
    elseif trinketCDStyle == "none" then
        f.trinket.cooldown:SetDrawSwipe(false)
        f.trinket.cooldown:SetHideCountdownNumbers(true)
    end

    -- Trinket CD text size and opacity — use our own timer text
    local trinketTextSize = a.trinketCDTextSize or 12
    local trinketTextOpacity = a.trinketCDTextOpacity or 1.0
    f.trinket.cooldown:SetHideCountdownNumbers(true) -- always hide Blizzard's
    if not f.trinket.timerText then
        f.trinket.timerText = f.trinket.cooldown:CreateFontString(nil, "OVERLAY")
        f.trinket.timerText:SetPoint("CENTER", f.trinket, "CENTER", 0, 0)
    end
    f.trinket.timerText:SetFont(a.nameFont or STANDARD_TEXT_FONT, trinketTextSize, "OUTLINE")
    f.trinket.timerText:SetAlpha(trinketTextOpacity)

    -- DR icons: OUTSIDE the frame, growing LEFT from the class icon
    local drCDStyle = a.drCDStyle or "spiral"
    local drTextSize = a.drFontSize or 10
    local drTextOpacity = a.drCDTextOpacity or 1.0
    for i = 1, MAX_DR_ICONS do
        local dr = f.drIcons[i]
        dr:SetSize(DR_ICON_SIZE, DR_ICON_SIZE)
        dr:ClearAllPoints()
        if i == 1 then
            dr:SetPoint("TOPRIGHT", f.classIcon, "TOPLEFT", -2, 0)
        else
            dr:SetPoint("RIGHT", f.drIcons[i - 1], "LEFT", -1, 0)
        end
        dr.drText:SetFont(a.nameFont or STANDARD_TEXT_FONT, drTextSize, "OUTLINE")
        dr.drText:SetAlpha(drTextOpacity)
        dr.cooldown:SetHideCountdownNumbers(true) -- always hide Blizzard's

        -- Custom DR timer text (our own, resizable)
        if not dr.timerText then
            dr.timerText = dr:CreateFontString(nil, "OVERLAY")
            dr.timerText:SetPoint("CENTER", dr, "CENTER", 0, 0)
        end
        local drCDTextSize = a.drCDTextSize or 10
        dr.timerText:SetFont(a.nameFont or STANDARD_TEXT_FONT, drCDTextSize, "OUTLINE")
        dr.timerText:SetAlpha(drTextOpacity)

        -- DR cooldown style
        if drCDStyle == "text" then
            dr.cooldown:SetDrawSwipe(false)
            dr.cooldown:SetHideCountdownNumbers(false)
        elseif drCDStyle == "spiral" then
            dr.cooldown:SetDrawSwipe(true)
            dr.cooldown:SetHideCountdownNumbers(true)
        elseif drCDStyle == "both" then
            dr.cooldown:SetDrawSwipe(true)
            dr.cooldown:SetHideCountdownNumbers(false)
        elseif drCDStyle == "none" then
            dr.cooldown:SetDrawSwipe(false)
            dr.cooldown:SetHideCountdownNumbers(true)
        end
    end

    -- Aura icons: OUTSIDE the frame, below trinket
    if f.auraIcons then
        for i = 1, 3 do
            local aura = f.auraIcons[i]
            if aura then
                aura:SetSize(TRINKET_SIZE, TRINKET_SIZE)
                aura:ClearAllPoints()
                if i == 1 then
                    aura:SetPoint("TOP", f.trinket, "BOTTOM", 0, -2)
                else
                    aura:SetPoint("TOP", f.auraIcons[i - 1], "BOTTOM", 0, -1)
                end
            end
        end
    end
end

------------------------------------------------------------
-- Create a single arena frame
------------------------------------------------------------
local function CreateArenaFrame(index)
    local unitId = "arena" .. index
    local frameName = "GladiusReborn_Arena" .. index

    local f = CreateFrame("Button", frameName, UIParent, "SecureUnitButtonTemplate")
    f:SetSize(220, 58)
    f:SetAttribute("unit", unitId)
    f:RegisterForClicks("AnyUp")
    f:Hide()
    f.unitId = unitId
    f.index = index

    f.bg = f:CreateTexture(nil, "BACKGROUND")
    f.bg:SetAllPoints()
    f.bg:SetColorTexture(0, 0, 0, 0.7)

    f.border = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate" or nil)
    f.border:SetAllPoints()
    f.border:SetFrameLevel(f:GetFrameLevel() + 3)

    f.classIcon = f:CreateTexture(nil, "ARTWORK")
    f.classIcon:SetSize(38, 38)
    f.classIcon:SetPoint("LEFT", f, "LEFT", 3, 8)
    f.classIcon:SetTexture(GR.CLASS_TEXTURE)
    f.classIcon:Hide()

    f.specText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.specText:SetPoint("BOTTOM", f.classIcon, "BOTTOM", 0, 1)
    f.specText:SetFont(STANDARD_TEXT_FONT, 8, "OUTLINE")
    f.specText:SetTextColor(1, 1, 1)
    f.specText:Hide()

    f.nameText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.nameText:SetJustifyH("LEFT")
    f.nameText:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    f.nameText:SetText("")

    f.healthBar = CreateFrame("StatusBar", frameName .. "_HP", f)
    f.healthBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.healthBar:SetStatusBarColor(0.2, 0.8, 0.2)
    f.healthBar:SetMinMaxValues(0, 100)
    f.healthBar:SetValue(100)

    f.healthBar.bg = f.healthBar:CreateTexture(nil, "BACKGROUND")
    f.healthBar.bg:SetAllPoints()
    f.healthBar.bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.healthBar.bg:SetVertexColor(0.15, 0.15, 0.15, 0.8)

    f.healthText = f.healthBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.healthText:SetPoint("RIGHT", f.healthBar, "RIGHT", -2, 0)
    f.healthText:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    f.healthText:SetJustifyH("RIGHT")
    f.healthText:SetText("")

    f.nameText:SetParent(f.healthBar)
    f.nameText:SetPoint("LEFT", f.healthBar, "LEFT", 2, 0)
    f.nameText:SetPoint("RIGHT", f.healthText, "LEFT", -2, 0)

    f.powerBar = CreateFrame("StatusBar", frameName .. "_Power", f)
    f.powerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.powerBar:SetStatusBarColor(0, 0, 1)
    f.powerBar:SetMinMaxValues(0, 100)
    f.powerBar:SetValue(100)

    f.powerBar.bg = f.powerBar:CreateTexture(nil, "BACKGROUND")
    f.powerBar.bg:SetAllPoints()
    f.powerBar.bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.powerBar.bg:SetVertexColor(0.1, 0.1, 0.1, 0.8)

    f.castBar = CreateFrame("StatusBar", frameName .. "_Cast", f)
    f.castBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.castBar:SetStatusBarColor(1, 0.7, 0)
    f.castBar:SetMinMaxValues(0, 1)
    f.castBar:SetValue(0)
    f.castBar:Hide()

    f.castBar.bg = f.castBar:CreateTexture(nil, "BACKGROUND")
    f.castBar.bg:SetAllPoints()
    f.castBar.bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.castBar.bg:SetVertexColor(0.1, 0.1, 0.1, 0.8)

    f.castBar.icon = f.castBar:CreateTexture(nil, "OVERLAY")
    f.castBar.icon:SetSize(14, 14)
    f.castBar.icon:SetPoint("LEFT", f.castBar, "LEFT", 0, 0)

    f.castBar.text = f.castBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.castBar.text:SetPoint("LEFT", f.castBar.icon, "RIGHT", 4, 0)
    f.castBar.text:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    f.castBar.text:SetJustifyH("LEFT")

    f.castBar.timer = f.castBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.castBar.timer:SetPoint("RIGHT", f.castBar, "RIGHT", -2, 0)
    f.castBar.timer:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    f.castBar.timer:SetJustifyH("RIGHT")

    f.castBar.casting = false
    f.castBar.channeling = false

    f.castBar:SetScript("OnUpdate", function(bar, elapsed)
        if not bar.casting and not bar.channeling then return end
        local now = GetTime() * 1000
        if bar.casting then
            if now >= bar.endTime then
                bar:SetValue(1)
                bar.casting = false
                bar:Hide()
                return
            end
            local duration = bar.endTime - bar.startTime
            if duration > 0 then
                bar:SetValue((now - bar.startTime) / duration)
            end
            bar.timer:SetText(format("%.1f", (bar.endTime - now) / 1000))
        elseif bar.channeling then
            if now >= bar.endTime then
                bar:SetValue(0)
                bar.channeling = false
                bar:Hide()
                return
            end
            local duration = bar.endTime - bar.startTime
            if duration > 0 then
                bar:SetValue((bar.endTime - now) / duration)
            end
            bar.timer:SetText(format("%.1f", (bar.endTime - now) / 1000))
        end
    end)

    f.trinket = CreateFrame("Frame", nil, f)
    f.trinket:SetSize(26, 26)

    f.trinket.icon = f.trinket:CreateTexture(nil, "ARTWORK")
    f.trinket.icon:SetAllPoints()
    f.trinket.icon:SetTexture("Interface\\Icons\\INV_Jewelry_TrinketPVP_02")
    f.trinket.icon:SetDesaturated(false)

    f.trinket.cooldown = CreateFrame("Cooldown", frameName .. "_TrinketCD", f.trinket, "CooldownFrameTemplate")
    f.trinket.cooldown:SetAllPoints()
    f.trinket.cooldown:SetHideCountdownNumbers(false)
    f.trinket.ready = true

    -- DR Icons: proper spell icons with cooldown spirals (GladiusEx style)
    f.drIcons = {}
    for i = 1, MAX_DR_ICONS do
        local dr = CreateFrame("Frame", frameName .. "_DR" .. i, f)
        dr:SetSize(22, 22)
        dr:Hide()

        -- Dark background
        dr.bg = dr:CreateTexture(nil, "BACKGROUND")
        dr.bg:SetAllPoints()
        dr.bg:SetColorTexture(0, 0, 0, 0.8)

        -- Spell icon texture
        dr.texture = dr:CreateTexture(nil, "ARTWORK")
        dr.texture:SetAllPoints()
        dr.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        -- DR-colored border (changes color based on DR state)
        dr.colorBorder = dr:CreateTexture(nil, "OVERLAY")
        dr.colorBorder:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
        dr.colorBorder:SetAllPoints()
        dr.colorBorder:Hide()

        -- Cooldown spiral (no built-in numbers — we use our own DR text)
        dr.cooldown = CreateFrame("Cooldown", frameName .. "_DRCD" .. i, dr, "CooldownFrameTemplate")
        dr.cooldown:SetAllPoints()
        dr.cooldown:SetHideCountdownNumbers(true)
        dr.cooldown:SetDrawBling(false)

        -- DR state text (½ ¼ Ø)
        dr.drText = dr:CreateFontString(nil, "OVERLAY")
        dr.drText:SetPoint("BOTTOMRIGHT", dr, "BOTTOMRIGHT", -1, 1)
        dr.drText:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        dr.drText:SetJustifyH("RIGHT")

        f.drIcons[i] = dr
    end

    -- Aura Icons: shown between trinket and frame
    f.auraIcons = {}
    for i = 1, 3 do
        local aura = CreateFrame("Frame", frameName .. "_Aura" .. i, f)
        aura:SetSize(22, 22)
        aura:Hide()

        aura.bg = aura:CreateTexture(nil, "BACKGROUND")
        aura.bg:SetAllPoints()
        aura.bg:SetColorTexture(0, 0, 0, 0.8)

        aura.texture = aura:CreateTexture(nil, "ARTWORK")
        aura.texture:SetAllPoints()
        aura.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        aura.cooldown = CreateFrame("Cooldown", frameName .. "_AuraCD" .. i, aura, "CooldownFrameTemplate")
        aura.cooldown:SetAllPoints()
        aura.cooldown:SetHideCountdownNumbers(false)

        f.auraIcons[i] = aura
    end

    f.highlight = f:CreateTexture(nil, "HIGHLIGHT")
    f.highlight:SetAllPoints()
    f.highlight:SetColorTexture(1, 1, 1, 0.1)

    return f
end

------------------------------------------------------------
-- Apply Click Actions (SecureActionButton attributes)
------------------------------------------------------------
function GR:ApplyClickActions(f)
    if InCombatLockdown() then return end
    local unit = f.unitId
    local actions = GR.db.clicks and GR.db.clicks.actions

    -- Clear existing attributes
    for _, mod in ipairs({"", "shift-", "ctrl-", "alt-"}) do
        for btn = 1, 2 do
            f:SetAttribute(mod .. "type" .. btn, nil)
            f:SetAttribute(mod .. "spell" .. btn, nil)
            f:SetAttribute(mod .. "macrotext" .. btn, nil)
        end
    end

    -- Always set unit
    f:SetAttribute("unit", unit)

    if not actions then
        -- Fallback defaults
        f:SetAttribute("type1", "target")
        f:SetAttribute("type2", "focus")
        return
    end

    for _, cfg in ipairs(actions) do
        local attrPrefix = cfg.modifier or ""
        local btn = cfg.button or 1
        local action = cfg.action or "none"
        local spell = cfg.spell or ""

        if action == "target" then
            f:SetAttribute(attrPrefix .. "type" .. btn, "target")
        elseif action == "focus" then
            f:SetAttribute(attrPrefix .. "type" .. btn, "focus")
        elseif action == "spell" and spell ~= "" then
            f:SetAttribute(attrPrefix .. "type" .. btn, "spell")
            f:SetAttribute(attrPrefix .. "spell" .. btn, spell)
        elseif action == "macro" and spell ~= "" then
            -- Replace *unit with this frame's actual arena unit
            local macroText = spell:gsub("%*unit", unit)
            f:SetAttribute(attrPrefix .. "type" .. btn, "macro")
            f:SetAttribute(attrPrefix .. "macrotext" .. btn, macroText)
        end
        -- "none" = no attribute set, click does nothing
    end
end

------------------------------------------------------------
-- Create / Rebuild All Frames
------------------------------------------------------------
function GR:CreateAllFrames()
    GR:RestorePosition()
    for i = 1, 5 do
        if not GR.frames[i] then
            GR.frames[i] = CreateArenaFrame(i)
        end
        local f = GR.frames[i]
        GR:ApplyClickActions(f)
        ApplyAppearance(f)
        f:ClearAllPoints()
        if i == 1 then
            f:SetPoint("TOP", anchor, "BOTTOM", 0, -2)
        else
            f:SetPoint("TOP", GR.frames[i - 1], "BOTTOM", 0, -(A().spacing or 2))
        end
    end
end

function GR:RebuildAllFrames()
    GR:RestorePosition()
    for i = 1, 5 do
        local f = GR.frames[i]
        if f then
            ApplyAppearance(f)
            f:ClearAllPoints()
            if i == 1 then
                f:SetPoint("TOP", anchor, "BOTTOM", 0, -2)
            else
                f:SetPoint("TOP", GR.frames[i - 1], "BOTTOM", 0, -(A().spacing or 2))
            end
            -- Re-show DR icons if data exists
            if GR.arenaData[i] and GR.arenaData[i].dr then
                GR:UpdateDRIcons(i)
            end
            -- Re-apply test mode visuals
            if GR.testMode and GR.arenaData[i] and GR.arenaData[i].classFile then
                local data = GR.arenaData[i]
                local a = A()
                local classFile = data.classFile
                if classFile and GR.CLASS_TCOORDS[classFile] then
                    f.classIcon:SetTexCoord(unpack(GR.CLASS_TCOORDS[classFile]))
                    if a.showClassIcon ~= false then
                        f.classIcon:Show()
                    end
                end
                local color = RAID_CLASS_COLORS[classFile]
                if color then
                    if a.nameColorByClass ~= false then
                        f.nameText:SetTextColor(color.r, color.g, color.b)
                    end
                    if a.classColorBars then
                        f.healthBar:SetStatusBarColor(color.r, color.g, color.b)
                    else
                        f.healthBar:SetStatusBarColor(0.2, 0.8, 0.2)
                    end
                end
            end
        end
    end
end

------------------------------------------------------------
-- Show / Hide
------------------------------------------------------------
local pendingShow = {}

function GR:ShowFrame(index)
    local f = GR.frames[index]
    if not f then return end
    if f:IsShown() then return end -- already visible, skip
    if InCombatLockdown() then
        -- Frame is secure, can't show during combat
        -- But it should already be shown from prep phase
        -- Queue it for after combat just in case
        pendingShow[index] = true
    else
        f:Show()
    end
end

local combatEndFrame = CreateFrame("Frame")
combatEndFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
combatEndFrame:SetScript("OnEvent", function()
    for index in pairs(pendingShow) do
        local f = GR.frames[index]
        if f and not f:IsShown() then f:Show() end
    end
    wipe(pendingShow)
end)

function GR:HideAllFrames()
    if InCombatLockdown() then return end
    for i = 1, 5 do
        local f = GR.frames[i]
        if f then
            f:Hide()
            f.castBar.casting = false
            f.castBar.channeling = false
            f.castBar:Hide()
        end
    end
    if not GR.testMode then
        anchor:Hide()
    end
end

------------------------------------------------------------
-- Update Frame Data
------------------------------------------------------------
function GR:UpdateFrameUnit(index)
    local f = GR.frames[index]
    if not f then return end
    local unit = f.unitId
    local data = GR.arenaData[index]

    if not UnitExists(unit) then
        f:SetAlpha(0.4)
        return
    end
    f:SetAlpha(1)

    local name = UnitName(unit) or "?"
    local _, classFile = UnitClass(unit)
    data.name = name
    data.classFile = classFile

    local a = A()

    if classFile and GR.CLASS_TCOORDS[classFile] then
        f.classIcon:SetTexCoord(unpack(GR.CLASS_TCOORDS[classFile]))
        if a.showClassIcon ~= false then
            f.classIcon:Show()
        else
            f.classIcon:Hide()
        end
    end

    local color = RAID_CLASS_COLORS[classFile]
    if color then
        if a.nameColorByClass ~= false then
            f.nameText:SetTextColor(color.r, color.g, color.b)
        else
            local nc = a.nameFontColor or { 1, 1, 1, 1 }
            f.nameText:SetTextColor(nc[1], nc[2], nc[3], nc[4] or 1)
        end
        if a.classColorBars then
            f.healthBar:SetStatusBarColor(color.r, color.g, color.b)
        else
            f.healthBar:SetStatusBarColor(0.2, 0.8, 0.2)
        end
    end

    -- Build display name based on spec settings
    local displayName = name
    local showSpec = a.nameShowSpec ~= false
    local specPos = a.specPosition or "ICON"
    if data.spec then
        if showSpec and specPos == "NAME" then
            displayName = name .. " (" .. data.spec .. ")"
            f.specText:Hide()
        elseif showSpec and specPos == "ICON" then
            displayName = name
            f.specText:SetText(data.spec)
            f.specText:Show()
        else
            displayName = name
            f.specText:Hide()
        end
    end
    f.nameText:SetText(displayName)

    GR:UpdateHealth(index)
    GR:UpdatePower(index)

    local powerType = UnitPowerType(unit)
    local pc = GR.POWER_COLORS[powerType] or GR.POWER_COLORS[0]
    f.powerBar:SetStatusBarColor(pc[1], pc[2], pc[3])

    GR:ShowFrame(index)
end

function GR:UpdateHealth(index)
    local f = GR.frames[index]
    if not f or not f:IsShown() then return end
    local unit = f.unitId
    if not UnitExists(unit) then return end
    local hp = UnitHealth(unit)
    local hpMax = UnitHealthMax(unit)
    if hpMax > 0 then
        f.healthBar:SetMinMaxValues(0, hpMax)
        f.healthBar:SetValue(hp)
        f.healthText:SetText(floor(hp / hpMax * 100) .. "%")
    end
end

function GR:UpdatePower(index)
    local f = GR.frames[index]
    if not f or not f:IsShown() then return end
    local unit = f.unitId
    if not UnitExists(unit) then return end
    local power = UnitPower(unit)
    local powerMax = UnitPowerMax(unit)
    if powerMax > 0 then
        f.powerBar:SetMinMaxValues(0, powerMax)
        f.powerBar:SetValue(power)
    end
end

------------------------------------------------------------
-- Event Handlers
------------------------------------------------------------
function GR:OnArenaOpponentUpdate(unit, reason)
    if not GR.inArena then return end
    local index = tonumber(unit:match("arena(%d)"))
    if not index then return end
    if reason == "seen" then
        GR.arenaData[index].seen = true
        GR:UpdateFrameUnit(index)
        -- First opponent seen = gates are open
        if not GR._gatesOpened then
            GR._gatesOpened = true
            if GR.OnArenaGatesOpen then
                GR:OnArenaGatesOpen()
            end
        end
    elseif reason == "unseen" then
        local f = GR.frames[index]
        if f then f:SetAlpha(0.4) end
    elseif reason == "destroyed" then
        local f = GR.frames[index]
        if f then
            f.healthBar:SetValue(0)
            f.healthText:SetText("DEAD")
            f:SetAlpha(0.3)
        end
    elseif reason == "cleared" then
        local f = GR.frames[index]
        if f then f:Hide() end
    end
end

function GR:OnUnitHealth(unit)
    local index = tonumber(unit:match("^arena(%d)$"))
    if index then GR:UpdateHealth(index) end
end

function GR:OnUnitPower(unit)
    local index = tonumber(unit:match("^arena(%d)$"))
    if index then GR:UpdatePower(index) end
end

------------------------------------------------------------
-- Cast Bar Handlers
------------------------------------------------------------
function GR:OnCastStart(unit)
    local index = tonumber(unit:match("^arena(%d)$"))
    if not index then return end
    local f = GR.frames[index]
    if not f then return end
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
    if not name then return end
    f.castBar.startTime = startTimeMS
    f.castBar.endTime = endTimeMS
    f.castBar.casting = true
    f.castBar.channeling = false
    f.castBar:SetMinMaxValues(0, 1)
    f.castBar:SetValue(0)
    f.castBar.text:SetText(name)
    f.castBar.timer:SetText("")
    if texture then f.castBar.icon:SetTexture(texture) end
    local a = A()
    if notInterruptible then
        f.castBar:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        local cc = a.castBarColor or { 1, 0.7, 0 }
        f.castBar:SetStatusBarColor(cc[1], cc[2], cc[3])
    end
    f.castBar:Show()
end

function GR:OnCastStop(unit)
    local index = tonumber(unit:match("^arena(%d)$"))
    if not index then return end
    local f = GR.frames[index]
    if not f then return end
    f.castBar.casting = false
    f.castBar.channeling = false
    f.castBar:Hide()
end

function GR:OnChannelStart(unit)
    local index = tonumber(unit:match("^arena(%d)$"))
    if not index then return end
    local f = GR.frames[index]
    if not f then return end
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo(unit)
    if not name then return end
    f.castBar.startTime = startTimeMS
    f.castBar.endTime = endTimeMS
    f.castBar.channeling = true
    f.castBar.casting = false
    f.castBar:SetMinMaxValues(0, 1)
    f.castBar:SetValue(1)
    f.castBar.text:SetText(name)
    f.castBar.timer:SetText("")
    if texture then f.castBar.icon:SetTexture(texture) end
    local a = A()
    if notInterruptible then
        f.castBar:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        local cc = a.channelBarColor or { 0, 0.7, 1 }
        f.castBar:SetStatusBarColor(cc[1], cc[2], cc[3])
    end
    f.castBar:Show()
end

function GR:OnChannelStop(unit)
    GR:OnCastStop(unit)
end

------------------------------------------------------------
-- Trinket UI Update
------------------------------------------------------------
function GR:UpdateTrinket(index)
    local f = GR.frames[index]
    if not f then return end
    local data = GR.arenaData[index]
    if data.trinketUsed > 0 then
        local remaining = data.trinketUsed + GR.TRINKET_COOLDOWN - GetTime()
        if remaining > 0 then
            f.trinket.icon:SetDesaturated(true)
            f.trinket.cooldown:SetCooldown(data.trinketUsed, GR.TRINKET_COOLDOWN)
            f.trinket.ready = false
        else
            f.trinket.icon:SetDesaturated(false)
            f.trinket.cooldown:Clear()
            f.trinket.ready = true
            data.trinketUsed = 0
            if f.trinket.timerText then f.trinket.timerText:SetText("") end
        end
    else
        f.trinket.icon:SetDesaturated(false)
        f.trinket.cooldown:Clear()
        f.trinket.ready = true
        if f.trinket.timerText then f.trinket.timerText:SetText("") end
    end
end

-- Trinket timer text updater
local trinketTimerFrame = CreateFrame("Frame")
local trinketTimerElapsed = 0
trinketTimerFrame:SetScript("OnUpdate", function(self, elapsed)
    trinketTimerElapsed = trinketTimerElapsed + elapsed
    if trinketTimerElapsed < 0.5 then return end
    trinketTimerElapsed = 0
    if not GR.inArena and not GR.testMode then return end

    for i = 1, 5 do
        local f = GR.frames[i]
        if f and f:IsShown() and f.trinket.timerText then
            local data = GR.arenaData[i]
            if data and data.trinketUsed > 0 then
                local remaining = data.trinketUsed + GR.TRINKET_COOLDOWN - GetTime()
                if remaining > 0 then
                    if remaining > 60 then
                        f.trinket.timerText:SetText(math.floor(remaining / 60) .. "m")
                    else
                        f.trinket.timerText:SetText(math.floor(remaining))
                    end
                    f.trinket.timerText:SetTextColor(1, 1, 1)
                else
                    f.trinket.timerText:SetText("")
                end
            else
                f.trinket.timerText:SetText("")
            end
        end
    end
end)


------------------------------------------------------------
-- Test Mode (with live DR, trinket cooldown, cast bars)
------------------------------------------------------------
local testClasses   = { "WARRIOR", "MAGE", "PRIEST", "ROGUE", "DRUID" }
local testNames     = { "Warrglaives", "Frostboltx", "Holylightqt", "Gankyou", "Restoking" }
local testSpecs     = { "Arms", "Frost", "Discipline", "Subtlety", "Restoration" }
local testPowerType = { 1, 0, 0, 3, 0 }

local testDRSets = {
    { { cat = "stun", dim = 0.5 }, { cat = "root", dim = 1 } },
    { { cat = "polymorph", dim = 1 }, { cat = "silence", dim = 0 } },
    { { cat = "fear", dim = 1 } },
    { { cat = "stun", dim = 1 }, { cat = "incapacitate", dim = 0.5 }, { cat = "cyclone", dim = 1 } },
    { { cat = "cyclone", dim = 0.25 }, { cat = "fear", dim = 1 } },
}

local testCasts = {
    { name = "Mortal Strike", duration = 0, icon = "Interface\\Icons\\Ability_Warrior_SavageBlow" },
    { name = "Frostbolt", duration = 2.5, icon = "Interface\\Icons\\Spell_Frost_FrostBolt02" },
    { name = "Greater Heal", duration = 2.0, icon = "Interface\\Icons\\Spell_Holy_GreaterHeal" },
    { name = "Eviscerate", duration = 0, icon = "Interface\\Icons\\Ability_Rogue_Eviscerate" },
    { name = "Regrowth", duration = 1.5, icon = "Interface\\Icons\\Spell_Nature_ResistNature" },
}

local testTimers = {}

local function CancelTestTimers()
    for _, t in ipairs(testTimers) do
        if t.Cancel then t:Cancel() end
    end
    wipe(testTimers)
end

local function StartTestCastBar(f, castInfo)
    if castInfo.duration <= 0 then return end
    local a = A()
    local function DoCast()
        if not GR.testMode or not f:IsShown() then return end
        local now = GetTime() * 1000
        local dur = castInfo.duration * 1000
        f.castBar.startTime = now
        f.castBar.endTime = now + dur
        f.castBar.casting = true
        f.castBar.channeling = false
        f.castBar:SetMinMaxValues(0, 1)
        f.castBar:SetValue(0)
        f.castBar.text:SetText(castInfo.name)
        f.castBar.timer:SetText(format("%.1f", castInfo.duration))
        f.castBar.icon:SetTexture(castInfo.icon)
        local cc = a.castBarColor or { 1, 0.7, 0 }
        f.castBar:SetStatusBarColor(cc[1], cc[2], cc[3])
        f.castBar:Show()
    end
    DoCast()
    local ticker = C_Timer.NewTicker(castInfo.duration + 0.8, DoCast)
    tinsert(testTimers, ticker)
end

function GR:ShowTest(count)
    CancelTestTimers()
    GR.testMode = true
    count = count or 3
    if count < 1 then count = 1 end
    if count > 5 then count = 5 end
    GR._lastTestCount = count

    GR:ResetArenaData()
    GR:RestorePosition()

    for i = 1, count do
        local f = GR.frames[i]
        local classFile = testClasses[i]
        local data = GR.arenaData[i]
        local a = A()

        ApplyAppearance(f)

        data.name = testNames[i]
        data.classFile = classFile
        data.spec = testSpecs[i]
        data.seen = true

        if GR.CLASS_TCOORDS[classFile] then
            f.classIcon:SetTexCoord(unpack(GR.CLASS_TCOORDS[classFile]))
            if a.showClassIcon ~= false then
                f.classIcon:Show()
            else
                f.classIcon:Hide()
            end
        end

        local color = RAID_CLASS_COLORS[classFile]
        if color then
            if a.nameColorByClass ~= false then
                f.nameText:SetTextColor(color.r, color.g, color.b)
            else
                f.nameText:SetTextColor(1, 1, 1)
            end
            if a.classColorBars then
                f.healthBar:SetStatusBarColor(color.r, color.g, color.b)
            else
                f.healthBar:SetStatusBarColor(0.2, 0.8, 0.2)
            end
        end

        f.nameText:SetText(testNames[i] .. " (" .. testSpecs[i] .. ")")
        f.specText:SetText(testSpecs[i])
        f.specText:Show()

        local maxHP = 10000 + i * 1000
        local curHP = maxHP * (0.3 + i * 0.15)
        f.healthBar:SetMinMaxValues(0, maxHP)
        f.healthBar:SetValue(curHP)
        f.healthText:SetText(floor(curHP / maxHP * 100) .. "%")

        local pType = testPowerType[i]
        local maxP = (pType == 0 and 8000) or (pType == 1 and 100) or (pType == 3 and 100) or 8000
        f.powerBar:SetMinMaxValues(0, maxP)
        f.powerBar:SetValue(maxP * (0.2 + i * 0.18))
        local pc = GR.POWER_COLORS[pType] or GR.POWER_COLORS[0]
        f.powerBar:SetStatusBarColor(pc[1], pc[2], pc[3])

        -- Trinket cooldown on units 2 and 4
        if i == 2 or i == 4 then
            data.trinketUsed = GetTime() - (i * 10)
            f.trinket.icon:SetDesaturated(true)
            f.trinket.cooldown:SetCooldown(data.trinketUsed, GR.TRINKET_COOLDOWN)
            f.trinket.ready = false
        else
            f.trinket.icon:SetDesaturated(false)
            f.trinket.cooldown:Clear()
            f.trinket.ready = true
        end

        -- DR: real spell icons with cooldown spirals
        local drSet = testDRSets[i]
        if drSet then
            for _, d in ipairs(drSet) do
                local testSpellId = GR.TEST_DR_SPELLS[d.cat]
                data.dr[d.cat] = {
                    diminished = d.dim,
                    spellId = testSpellId or 118,
                    active = true,
                    resetTime = GetTime() + math.random(8, 16), -- realistic countdown
                }
            end
            GR:UpdateDRIcons(i)
        end

        -- Test aura icons (class-appropriate)
        if f.auraIcons then
            local testAurasByClass = {
                WARRIOR = { { icon = "Interface\\Icons\\Ability_GolemThunderClap", cd = 12 } },
                MAGE    = {
                    { icon = "Interface\\Icons\\Spell_Frost_Frost", cd = 10 },
                    { icon = "Interface\\Icons\\Spell_Frost_IceBarrier", cd = 6 },
                },
                PRIEST  = { { icon = "Interface\\Icons\\Spell_Holy_PainSupression", cd = 8 } },
                ROGUE   = { { icon = "Interface\\Icons\\Spell_Shadow_NetherCloak", cd = 5 } },
                DRUID   = { { icon = "Interface\\Icons\\INV_Misc_Herb_07", cd = 15 } },
            }
            local classAuras = testAurasByClass[classFile] or {}
            for j = 1, 3 do
                local aura = f.auraIcons[j]
                if aura then
                    if classAuras[j] then
                        aura.texture:SetTexture(classAuras[j].icon)
                        aura.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                        CooldownFrame_Set(aura.cooldown, GetTime(), classAuras[j].cd, 1)
                        aura:Show()
                    else
                        aura:Hide()
                    end
                end
            end
        end

        -- Looping cast bars
        local cast = testCasts[i]
        if cast then
            StartTestCastBar(f, cast)
        end

        f:Show()
    end

    for i = count + 1, 5 do
        GR.frames[i]:Hide()
    end

    GR:SetLocked(false)
    GR:Print("Test mode: " .. count .. " frames. |cff00ff00/gladius hide|r to dismiss.")

    -- Looping ticker: reset expired DR timers and trinket CDs so preview stays alive
    if not GR._testLoopTicker then
        GR._testLoopTicker = C_Timer.NewTicker(2, function()
            if not GR.testMode then
                if GR._testLoopTicker then GR._testLoopTicker:Cancel(); GR._testLoopTicker = nil end
                return
            end
            for i = 1, 5 do
                local data = GR.arenaData[i]
                if data and data.dr then
                    for cat, drData in pairs(data.dr) do
                        if drData.active and drData.resetTime > 0 and GetTime() >= drData.resetTime then
                            -- Reset with new timer
                            drData.resetTime = GetTime() + math.random(8, 16)
                        end
                    end
                end
                -- Reset trinket when it expires (units 2 and 4)
                if data and data.trinketUsed > 0 then
                    local remaining = data.trinketUsed + GR.TRINKET_COOLDOWN - GetTime()
                    if remaining <= 0 then
                        data.trinketUsed = GetTime() - math.random(5, 30)
                        local f = GR.frames[i]
                        if f then
                            f.trinket.icon:SetDesaturated(true)
                            f.trinket.cooldown:SetCooldown(data.trinketUsed, GR.TRINKET_COOLDOWN)
                        end
                    end
                end
            end
        end)
    end
end

function GR:HideTest()
    CancelTestTimers()
    if GR._testLoopTicker then GR._testLoopTicker:Cancel(); GR._testLoopTicker = nil end
    GR.testMode = false
    GR:HideAllFrames()
    GR:SetLocked(GR.db.locked)
    GR:Print("Test frames hidden.")
end
