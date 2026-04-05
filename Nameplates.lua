local _, GR = ...

------------------------------------------------------------
-- Nameplate Enforcement (from StickyPlates)
------------------------------------------------------------
local enforceTicker = nil
local isReforcing = false
local savedBinding1 = nil
local savedBinding2 = nil

local function ForceNameplates()
    if GetCVar("nameplateShowEnemies") ~= "1" then
        isReforcing = true
        SetCVar("nameplateShowEnemies", 1)
        isReforcing = false
    end
end

local function DisableNameplateKeybind()
    savedBinding1 = GetBindingKey("NAMEPLATES")
    savedBinding2 = select(2, GetBindingKey("NAMEPLATES"))
    if savedBinding1 then SetBinding(savedBinding1) end
    if savedBinding2 then SetBinding(savedBinding2) end
end

local function RestoreNameplateKeybind()
    if savedBinding1 then SetBinding(savedBinding1, "NAMEPLATES") end
    if savedBinding2 then SetBinding(savedBinding2, "NAMEPLATES") end
    savedBinding1 = nil
    savedBinding2 = nil
end

function GR:StartNameplateEnforcement()
    if not GR.db.nameplates.forceEnemy then return end
    if enforceTicker then return end
    ForceNameplates()
    DisableNameplateKeybind()
    enforceTicker = C_Timer.NewTicker(0.1, function()
        if not GR.inArena then return end
        ForceNameplates()
    end)
end

function GR:StopNameplateEnforcement()
    if enforceTicker then
        enforceTicker:Cancel()
        enforceTicker = nil
    end
    RestoreNameplateKeybind()
end

-- Hook SetCVar for instant re-force
hooksecurefunc("SetCVar", function(cvar, value)
    if isReforcing then return end
    if GR.inArena and cvar == "nameplateShowEnemies" and tostring(value) == "0" then
        isReforcing = true
        C_Timer.After(0, function()
            SetCVar("nameplateShowEnemies", 1)
            isReforcing = false
        end)
    end
end)

-- CVAR_UPDATE handler
function GR:OnCVarUpdate(cvar, value)
    if not GR.inArena or isReforcing then return end
    if (cvar == "nameplateShowEnemies" or cvar == "NAMEPLATE_SHOW_ENEMIES") and tostring(value) == "0" then
        ForceNameplates()
    end
end

------------------------------------------------------------
-- Auto-Markers (from StickyPlates)
------------------------------------------------------------
function GR:ApplyMarkers()
    if not GR.db.nameplates.autoMark then return end
    if not GR:IsInArena() then return end

    local assignments = GR.db.nameplates.markAssignments

    if assignments.player and UnitExists("player") then
        SetRaidTarget("player", assignments.player)
    end

    for i = 1, 4 do
        local unit = "party" .. i
        if assignments[unit] and UnitExists(unit) then
            SetRaidTarget(unit, assignments[unit])
        end
    end
end
