local _, GR = ...
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Helpers
local function aGet(info) return GR.db.appearance[info[#info]] end
local function aSet(info, v) GR.db.appearance[info[#info]] = v; if GR.RebuildAllFrames then GR:RebuildAllFrames() end end

local fontValues = {}
local function GetFonts()
    if GR.FONT_LIST then for p, n in pairs(GR.FONT_LIST) do fontValues[p] = n end end
    return fontValues
end
local function GetBarTextures() return GR.BAR_TEXTURES or {} end
local function GetPresetNames()
    local t = {} ; if GR.PRESETS then for k, v in pairs(GR.PRESETS) do t[k] = v.name end end ; return t
end

local OUTLINE = {["OUTLINE"]="Outline",["THICKOUTLINE"]="Thick",[""]="None"}
local POS = {["LEFT"]="Left",["CENTER"]="Center",["RIGHT"]="Right"}
local CDSTYLE = {["spiral"]="Spiral+Text",["spiralonly"]="Spiral",["text"]="Text",["none"]="None"}
local DRCD = {["spiral"]="Spiral",["both"]="Spiral+Text",["text"]="Text",["none"]="None"}
local OUTPUT = {["both"]="Self + Party",["self"]="Self Only",["party"]="Party Only",["none"]="Disabled"}

function GR:GetOptionsTable()
    return {
        type = "group",
        name = "|cff33ff99Gladius Reborn|r v1.1.0",
        childGroups = "tree",
        args = {
            --------------------------------------------------------
            -- GENERAL
            --------------------------------------------------------
            general = {
                type = "group", name = "General", order = 1,
                args = {
                    testHeader = { type = "header", name = "Testing & Positioning", order = 1 },
                    testBtn = { type = "execute", name = "Arena Frames", order = 2, width = "half",
                        func = function() if GR.testMode then GR:HideTest() else GR:ShowTest(3) end end },
                    testAll = { type = "execute", name = "Preview All", order = 3, width = "half",
                        func = function() if GR.TogglePreviewAll then GR:TogglePreviewAll() end end },
                    lockBtn = { type = "execute", name = "Toggle Lock", order = 4, width = "half",
                        func = function() GR.db.locked = not GR.db.locked; GR:SetLocked(GR.db.locked) end },

                    settingsHeader = { type = "header", name = "Settings", order = 10 },
                    locked = { type = "toggle", name = "Lock Frames", order = 11,
                        get = function() return GR.db.locked end,
                        set = function(_, v) GR.db.locked = v; GR:SetLocked(v) end },
                    scale = { type = "range", name = "Frame Scale", order = 12, min = 0.5, max = 3, step = 0.05,
                        get = function() return GR.db.scale end,
                        set = function(_, v) GR.db.scale = v; for i=1,5 do if GR.frames[i] then GR.frames[i]:SetScale(v) end end end },

                    profileHeader = { type = "header", name = "Profiles", order = 20 },
                    profileDesc = { type = "description", name = "Select a slot, then save or load. Character default auto-loads.\n", order = 21 },
                    profileSlot = { type = "select", name = "Slot", order = 22, width = "normal",
                        values = function()
                            local t = {}
                            for i=1,5 do t[i] = "Profile "..i..(GR:HasProfile(i) and " |cff00ff00(saved)|r" or " |cff666666(empty)|r") end
                            return t
                        end,
                        get = function() return GR._selectedProfileSlot or 1 end,
                        set = function(_, v) GR._selectedProfileSlot = v end },
                    saveP = { type = "execute", name = "Save", order = 23, width = "half", func = function() GR:SaveProfile(GR._selectedProfileSlot or 1) end },
                    loadP = { type = "execute", name = "Load", order = 24, width = "half", func = function() GR:LoadProfile(GR._selectedProfileSlot or 1) end },
                    delP = { type = "execute", name = "Delete", order = 25, width = "half", func = function() GR:DeleteProfile(GR._selectedProfileSlot or 1) end },
                    charHeader = { type = "header", name = "Character Default", order = 30 },
                    charSave = { type = "execute", name = "Save Character Default", order = 31, width = "double",
                        func = function() if GR.SaveCharDefault then GR:SaveCharDefault() end end },
                },
            },

            --------------------------------------------------------
            -- APPEARANCE (sub-tabs)
            --------------------------------------------------------
            appearance = {
                type = "group", name = "Appearance", order = 2, childGroups = "tab",
                args = {
                    themes = { type = "group", name = "Themes", order = 1, args = {
                        desc = { type = "description", name = "Apply a complete visual theme. Customize in other tabs.\n", order = 0 },
                        preset = { type = "select", name = "Apply Theme", order = 1, width = "double", values = GetPresetNames,
                            get = function() return GR.db.appearance.preset or "default" end,
                            set = function(_, v) if GR.ApplyPreset then GR:ApplyPreset(v) end end },
                    }},
                    layout = { type = "group", name = "Layout", order = 2, args = {
                        dims = { type = "group", name = "Frame Dimensions", order = 1, inline = true, args = {
                            barWidth = { type = "range", name = "Width", order = 1, min = 120, max = 400, step = 5, get = aGet, set = aSet },
                            hpBarHeight = { type = "range", name = "HP Height", order = 2, min = 16, max = 60, step = 1,
                                get = function() return GR.db.appearance.hpBarHeight or 28 end, set = aSet },
                            castBarHeight = { type = "range", name = "Cast Height", order = 3, min = 6, max = 30, step = 1, get = aGet, set = aSet },
                            powerBarHeight = { type = "range", name = "Power Height", order = 4, min = 2, max = 16, step = 1, get = aGet, set = aSet },
                            spacing = { type = "range", name = "Spacing", order = 5, min = 0, max = 20, step = 1, get = aGet, set = aSet },
                            borderSize = { type = "range", name = "Border", order = 6, min = 0, max = 20, step = 1, get = aGet, set = aSet },
                        }},
                        bg = { type = "group", name = "Background & Texture", order = 2, inline = true, args = {
                            bgAlpha = { type = "range", name = "BG Opacity", order = 1, min = 0, max = 1, step = 0.05,
                                get = function() return GR.db.appearance.bgColor and GR.db.appearance.bgColor[4] or GR.db.appearance.bgAlpha end,
                                set = function(_, v) GR.db.appearance.bgAlpha = v; if GR.db.appearance.bgColor then GR.db.appearance.bgColor[4] = v end; GR:RebuildAllFrames() end },
                            barTexture = { type = "select", name = "Bar Texture", order = 2, width = "double", values = GetBarTextures, get = aGet, set = aSet },
                        }},
                        display = { type = "group", name = "Display", order = 3, inline = true, args = {
                            classColorBars = { type = "toggle", name = "Class-Colored Bars", order = 1, get = aGet, set = aSet },
                            showClassIcon = { type = "toggle", name = "Show Class Icon", order = 2,
                                get = function() return GR.db.appearance.showClassIcon ~= false end, set = aSet },
                        }},
                    }},
                    text = { type = "group", name = "Text", order = 3, args = {
                        nameGrp = { type = "group", name = "Name Text", order = 1, inline = true, args = {
                            nameFont = { type = "select", name = "Font", order = 1, values = GetFonts, get = aGet, set = aSet },
                            nameFontSize = { type = "range", name = "Size", order = 2, min = 7, max = 20, step = 1, get = aGet, set = aSet },
                            nameFontFlags = { type = "select", name = "Outline", order = 3, values = OUTLINE, get = aGet, set = aSet },
                            nameFontShadow = { type = "toggle", name = "Shadow", order = 4, get = aGet, set = aSet },
                            nameColorByClass = { type = "toggle", name = "Class Colors", order = 5,
                                get = function() return GR.db.appearance.nameColorByClass ~= false end, set = aSet },
                            namePosition = { type = "select", name = "Position", order = 6, values = POS,
                                get = function() return GR.db.appearance.namePosition or "LEFT" end, set = aSet },
                            nameShowSpec = { type = "toggle", name = "Show Spec", order = 7,
                                get = function() return GR.db.appearance.nameShowSpec ~= false end, set = aSet },
                            specPosition = { type = "select", name = "Spec Position", order = 8,
                                values = {["ICON"]="On Icon",["NAME"]="After Name"},
                                get = function() return GR.db.appearance.specPosition or "ICON" end, set = aSet },
                        }},
                        hpGrp = { type = "group", name = "HP Text", order = 2, inline = true, args = {
                            hpFont = { type = "select", name = "Font", order = 1, values = GetFonts, get = aGet, set = aSet },
                            hpFontSize = { type = "range", name = "Size", order = 2, min = 7, max = 20, step = 1, get = aGet, set = aSet },
                            hpPosition = { type = "select", name = "Position", order = 3, values = POS,
                                get = function() return GR.db.appearance.hpPosition or "RIGHT" end, set = aSet },
                        }},
                        castGrp = { type = "group", name = "Cast Bar Text", order = 3, inline = true, args = {
                            castFont = { type = "select", name = "Font", order = 1, values = GetFonts, get = aGet, set = aSet },
                            castFontSize = { type = "range", name = "Size", order = 2, min = 6, max = 18, step = 1, get = aGet, set = aSet },
                            castFontFlags = { type = "select", name = "Outline", order = 3, values = OUTLINE, get = aGet, set = aSet },
                        }},
                    }},
                    trinketdr = { type = "group", name = "Trinket & DR", order = 4, args = {
                        trinketGrp = { type = "group", name = "Trinket Icon", order = 1, inline = true, args = {
                            trinketSize = { type = "range", name = "Size", order = 1, min = 14, max = 50, step = 1,
                                get = function() return GR.db.appearance.trinketSize or 26 end, set = aSet },
                            trinketCDStyle = { type = "select", name = "CD Style", order = 2, values = CDSTYLE,
                                get = function() return GR.db.appearance.trinketCDStyle or "spiral" end, set = aSet },
                            trinketCDTextSize = { type = "range", name = "Text Size", order = 3, min = 6, max = 24, step = 1,
                                get = function() return GR.db.appearance.trinketCDTextSize or 12 end, set = aSet },
                        }},
                        drGrp = { type = "group", name = "DR Icons", order = 2, inline = true, args = {
                            drIconSize = { type = "range", name = "Size", order = 1, min = 12, max = 40, step = 1,
                                get = function() return GR.db.appearance.drIconSize or 22 end, set = aSet },
                            drCDStyle = { type = "select", name = "CD Style", order = 2, values = DRCD,
                                get = function() return GR.db.appearance.drCDStyle or "spiral" end, set = aSet },
                            drFontSize = { type = "range", name = "Label Size", order = 3, min = 5, max = 14, step = 1, get = aGet, set = aSet },
                            drCDTextSize = { type = "range", name = "CD Text", order = 4, min = 6, max = 20, step = 1,
                                get = function() return GR.db.appearance.drCDTextSize or 10 end, set = aSet },
                            drCDTextOpacity = { type = "range", name = "Text Opacity", order = 5, min = 0, max = 1, step = 0.05,
                                get = function() return GR.db.appearance.drCDTextOpacity or 1 end, set = aSet },
                        }},
                    }},
                },
            },

            --------------------------------------------------------
            -- ARENA
            --------------------------------------------------------
            arena = {
                type = "group", name = "Arena", order = 3, childGroups = "tab",
                args = {
                    frames = { type = "group", name = "Frames", order = 1, args = {
                        desc = { type = "description", name = "Arena frames show automatically when you enter an arena. Use the test buttons in General to preview.\n", order = 0 },
                        nameplateGrp = { type = "group", name = "Nameplates", order = 1, inline = true, args = {
                            forceEnemy = { type = "toggle", name = "Force Enemy Nameplates", order = 1, width = "double",
                                desc = "Force enemy nameplates ON in arena. Blocks keybind toggles.",
                                get = function() return GR.db.nameplates.forceEnemy end,
                                set = function(_, v) GR.db.nameplates.forceEnemy = v end },
                        }},
                        markerGrp = { type = "group", name = "Auto-Markers", order = 2, inline = true, args = {
                            autoMark = { type = "toggle", name = "Enable Auto-Marking", order = 1,
                                get = function() return GR.db.nameplates.autoMark end,
                                set = function(_, v) GR.db.nameplates.autoMark = v end },
                        }},
                    }},
                    announcements = { type = "group", name = "Callouts", order = 2, args = {
                        outputGrp = { type = "group", name = "Output", order = 1, inline = true, args = {
                            output = { type = "select", name = "Send To", order = 1, width = "double", values = OUTPUT,
                                get = function() return GR.db.announcements.output or "both" end,
                                set = function(_, v) GR.db.announcements.output = v end },
                        }},
                        enemyGrp = { type = "group", name = "Enemy Callouts", order = 2, inline = true, args = {
                            trinket = { type = "toggle", name = "Trinket Used", order = 1,
                                get = function() return GR.db.announcements.trinket end, set = function(_, v) GR.db.announcements.trinket = v end },
                            ccBreaker = { type = "toggle", name = "CC Breaker", order = 2,
                                get = function() return GR.db.announcements.ccBreaker end, set = function(_, v) GR.db.announcements.ccBreaker = v end },
                            drinking = { type = "toggle", name = "Drinking", order = 3,
                                get = function() return GR.db.announcements.drinking end, set = function(_, v) GR.db.announcements.drinking = v end },
                            enemySpec = { type = "toggle", name = "Spec Detected", order = 4,
                                get = function() return GR.db.announcements.enemySpec end, set = function(_, v) GR.db.announcements.enemySpec = v end },
                            offensiveCD = { type = "toggle", name = "Offensive CDs", order = 5,
                                get = function() return GR.db.announcements.offensiveCD end, set = function(_, v) GR.db.announcements.offensiveCD = v end },
                            defensiveCD = { type = "toggle", name = "Defensive CDs", order = 6,
                                get = function() return GR.db.announcements.defensiveCD end, set = function(_, v) GR.db.announcements.defensiveCD = v end },
                        }},
                        winGrp = { type = "group", name = "Win Conditions", order = 3, inline = true, args = {
                            enemyLowHP = { type = "toggle", name = "Enemy Low HP", order = 1,
                                get = function() return GR.db.announcements.enemyLowHP end, set = function(_, v) GR.db.announcements.enemyLowHP = v end },
                            killTarget = { type = "toggle", name = "Kill Target", order = 2,
                                get = function() return GR.db.announcements.killTarget end, set = function(_, v) GR.db.announcements.killTarget = v end },
                            enemyLowHPThreshold = { type = "range", name = "Enemy Low %", order = 3, min = 10, max = 50, step = 5,
                                get = function() return GR.db.announcements.enemyLowHPThreshold or 25 end,
                                set = function(_, v) GR.db.announcements.enemyLowHPThreshold = v end },
                        }},
                        teamGrp = { type = "group", name = "Team Callouts", order = 4, inline = true, args = {
                            teamLowHP = { type = "toggle", name = "Teammate Low HP", order = 1,
                                get = function() return GR.db.announcements.teamLowHP end, set = function(_, v) GR.db.announcements.teamLowHP = v end },
                            teamLowHPThreshold = { type = "range", name = "Team Low %", order = 2, min = 15, max = 50, step = 5,
                                get = function() return GR.db.announcements.teamLowHPThreshold or 30 end,
                                set = function(_, v) GR.db.announcements.teamLowHPThreshold = v end },
                        }},
                    }},
                    utilities = { type = "group", name = "Utilities", order = 3, args = {
                        arenaUtils = { type = "group", name = "Arena Tools", order = 1, inline = true, args = {
                            eyeTracker = { type = "toggle", name = "Shadow Sight Timer", order = 1,
                                desc = "Countdown timer for Shadow Sight orb spawns.",
                                get = function() return GR.db.announcements.eyeTracker ~= false end,
                                set = function(_, v) GR.db.announcements.eyeTracker = v end },
                            prepChecklist = { type = "toggle", name = "Prep Checklist", order = 2,
                                desc = "Show missing items (trinket, poisons) in prep room.",
                                get = function() return GR.db.announcements.prepChecklist ~= false end,
                                set = function(_, v) GR.db.announcements.prepChecklist = v end },
                            loseControl = { type = "toggle", name = "Lose Control (CC Icon)", order = 3,
                                desc = "Big icon on screen when you're CC'd with countdown.",
                                get = function() return GR.db.announcements.loseControl ~= false end,
                                set = function(_, v) GR.db.announcements.loseControl = v end },
                        }},
                    }},
                },
            },

            --------------------------------------------------------
            -- BATTLEGROUNDS
            --------------------------------------------------------
            battlegrounds = {
                type = "group", name = "Battlegrounds", order = 4,
                args = {
                    calloutGrp = { type = "group", name = "BG Callout Bar", order = 1, inline = true, args = {
                        bgCallouts = { type = "toggle", name = "Enable BG Callout Bar", order = 1, width = "double",
                            desc = "Movable quick-action bar with one-click callout buttons per BG.",
                            get = function() return GR.db.announcements.bgCallouts ~= false end,
                            set = function(_, v) GR.db.announcements.bgCallouts = v end },
                        bgPreview = { type = "execute", name = "Preview BG Bar", order = 2,
                            func = function() if GR.ToggleBGPreview then GR:ToggleBGPreview() end end },
                    }},
                    scoreGrp = { type = "group", name = "Scoreboard Fix", order = 2, inline = true, args = {
                        desc = { type = "description", name = "The scoreboard is automatically set to render below the spirit release popup so you can view scores and release without closing it.\n", order = 1 },
                    }},
                    queueGrp = { type = "group", name = "Queue Alerts", order = 3, inline = true, args = {
                        queueAlert = { type = "toggle", name = "Queue Pop Alert", order = 1,
                            desc = "Big countdown + sound + taskbar flash when queue pops. Works minimized.",
                            get = function() return GR.db.announcements.queueAlert ~= false end,
                            set = function(_, v) GR.db.announcements.queueAlert = v end },
                    }},
                },
            },

            --------------------------------------------------------
            -- ABOUT
            --------------------------------------------------------
            about = {
                type = "group", name = "About", order = 10,
                args = {
                    info = { type = "description", fontSize = "medium", order = 1,
                        name = "|cff33ff99Gladius Reborn|r v1.1.0\nby evildz on nightslayer\n\nArena unit frames for TBC Classic Anniversary.\n\n"..
                            "|cff33ff99Features:|r\n"..
                            "- Arena frames: HP, Mana, Cast, DR, Auras\n"..
                            "- Click actions with combo macro presets\n"..
                            "- Trinket + DR tracking with spell icons\n"..
                            "- Smart alerts & announcements\n"..
                            "- Arena macro toolkit\n"..
                            "- Shadow Sight timer + prep checklist\n"..
                            "- Queue pop alerts (background sound)\n"..
                            "- BG callout bar + scoreboard fix\n"..
                            "- Lose Control CC indicator\n"..
                            "- Themes, profiles, per-char defaults\n" },
                    sep = { type = "header", name = "", order = 2 },
                    thanks = { type = "description", fontSize = "medium", order = 3,
                        name = "|cffffff00Special Thanks:|r\n\n"..
                            "|cff33ff99Gladius|r by Proditor (Resike)\n"..
                            "The original arena frames addon.\n\n"..
                            "|cff33ff99GladiusEx|r by slaren & vendethiel\n"..
                            "Pushed arena frames forward with modular design\n"..
                            "and features the community relied on.\n\n"..
                            "This addon exists because of their work.\n"..
                            "Thank you for everything." },
                },
            },
        },
    }
end

------------------------------------------------------------
-- Register & Open
------------------------------------------------------------
function GR:SetupAceConfig()
    AceConfig:RegisterOptionsTable("GladiusReborn", GR:GetOptionsTable())
    AceConfigDialog:SetDefaultSize("GladiusReborn", 880, 560)

    -- Hook the dialog frame to add close button after it's created
    C_Timer.After(0, function()
        local f = AceConfigDialog.OpenFrames and AceConfigDialog.OpenFrames["GladiusReborn"]
        if f and f.frame then
            GR:AddDialogControls(f.frame)
        end
    end)
end

function GR:AddDialogControls(frame)
    if frame._grControlsAdded then return end
    frame._grControlsAdded = true

    -- Close button (top right)
    local cls = CreateFrame("Button", nil, frame)
    cls:SetSize(20, 20); cls:SetPoint("TOPRIGHT", -4, -4)
    cls:SetFrameLevel(frame:GetFrameLevel() + 10)
    local clsT = cls:CreateFontString(nil, "OVERLAY")
    clsT:SetPoint("CENTER"); clsT:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    clsT:SetText("x"); clsT:SetTextColor(1, 0.3, 0.3)
    cls:SetScript("OnClick", function() AceConfigDialog:Close("GladiusReborn") end)
    cls:SetScript("OnEnter", function() clsT:SetTextColor(1, 1, 1) end)
    cls:SetScript("OnLeave", function() clsT:SetTextColor(1, 0.3, 0.3) end)

    -- Reset size button (next to close)
    local rst = CreateFrame("Button", nil, frame)
    rst:SetSize(20, 20); rst:SetPoint("RIGHT", cls, "LEFT", -2, 0)
    rst:SetFrameLevel(frame:GetFrameLevel() + 10)
    local rstT = rst:CreateFontString(nil, "OVERLAY")
    rstT:SetPoint("CENTER"); rstT:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
    rstT:SetText("[]"); rstT:SetTextColor(0.6, 0.6, 0.6)
    rst:SetScript("OnClick", function()
        frame:SetSize(880, 560)
        frame:ClearAllPoints()
        frame:SetPoint("CENTER")
    end)
    rst:SetScript("OnEnter", function() rstT:SetTextColor(1, 0.82, 0)
        GameTooltip:SetOwner(rst, "ANCHOR_TOP"); GameTooltip:SetText("Reset window size & position"); GameTooltip:Show() end)
    rst:SetScript("OnLeave", function() rstT:SetTextColor(0.6, 0.6, 0.6); GameTooltip:Hide() end)
end

function GR:ShowOptionsPanel()
    AceConfigDialog:Open("GladiusReborn")
    -- Add controls to the dialog frame
    C_Timer.After(0.1, function()
        local f = AceConfigDialog.OpenFrames and AceConfigDialog.OpenFrames["GladiusReborn"]
        if f and f.frame then GR:AddDialogControls(f.frame) end
    end)
end

function GR:ToggleOptionsPanel()
    if AceConfigDialog.OpenFrames and AceConfigDialog.OpenFrames["GladiusReborn"] then
        AceConfigDialog:Close("GladiusReborn")
    else
        GR:ShowOptionsPanel()
    end
end
