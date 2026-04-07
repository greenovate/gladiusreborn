local _, GR = ...

------------------------------------------------------------
-- DR Categories
------------------------------------------------------------
GR.DR_STUN         = "stun"
GR.DR_FEAR         = "fear"
GR.DR_POLY         = "polymorph"
GR.DR_CYCLONE      = "cyclone"
GR.DR_ROOT         = "root"
GR.DR_SILENCE      = "silence"
GR.DR_INCAPACITATE = "incapacitate"
GR.DR_HORROR       = "horror"
GR.DR_SLEEP        = "sleep"
GR.DR_DISARM       = "disarm"

GR.DR_RESET_TIME = 18

GR.DR_STATES = {
    [1]    = { text = "1/2", r = 0, g = 1, b = 0 },      -- full duration (green)
    [0.5]  = { text = "1/4", r = 1, g = 0.65, b = 0 },   -- half duration (orange)
    [0.25] = { text = "0",   r = 1, g = 0, b = 0 },      -- quarter (red)
    [0]    = { text = "0",   r = 1, g = 0, b = 0 },      -- immune (red)
}

GR.DR_NEXT = {
    [1]   = 0.5,
    [0.5] = 0.25,
    [0.25] = 0,
    [0]   = 0,
}

function GR:NextDR(current)
    if current == nil then return 1 end
    return GR.DR_NEXT[current] or 0
end

------------------------------------------------------------
-- DR Spells: spellID -> { category, spellName (fallback) }
-- These are the TBC 2.4.3 spell IDs
------------------------------------------------------------
GR.DR_SPELL_IDS = {
    -- Stuns
    [1833]  = GR.DR_STUN,   -- Cheap Shot
    [408]   = GR.DR_STUN,   -- Kidney Shot
    [8983]  = GR.DR_STUN,   -- Bash
    [10308] = GR.DR_STUN,   -- Hammer of Justice
    [20253] = GR.DR_STUN,   -- Intercept Stun
    [25274] = GR.DR_STUN,   -- Intercept Stun (rank)
    [20549] = GR.DR_STUN,   -- War Stomp
    [12809] = GR.DR_STUN,   -- Concussion Blow
    [19577] = GR.DR_STUN,   -- Intimidation
    [9005]  = GR.DR_STUN,   -- Pounce
    [30283] = GR.DR_STUN,   -- Shadowfury
    [15269] = GR.DR_STUN,   -- Blackout
    [12355] = GR.DR_STUN,   -- Impact
    [39796] = GR.DR_STUN,   -- Stoneclaw Stun
    [22703] = GR.DR_STUN,   -- Infernal Summon Stun
    [853]   = GR.DR_STUN,   -- Hammer of Justice (rank 1)

    -- Fears
    [5782]  = GR.DR_FEAR,   -- Fear
    [6213]  = GR.DR_FEAR,   -- Fear (rank 2)
    [6215]  = GR.DR_FEAR,   -- Fear (rank 3)
    [8122]  = GR.DR_FEAR,   -- Psychic Scream
    [8124]  = GR.DR_FEAR,   -- Psychic Scream (rank 2)
    [10888] = GR.DR_FEAR,   -- Psychic Scream (rank 3)
    [10890] = GR.DR_FEAR,   -- Psychic Scream (rank 4)
    [5246]  = GR.DR_FEAR,   -- Intimidating Shout
    [5484]  = GR.DR_FEAR,   -- Howl of Terror
    [17928] = GR.DR_FEAR,   -- Howl of Terror (rank 2)
    [6358]  = GR.DR_FEAR,   -- Seduction

    -- Polymorph / Hex
    [118]   = GR.DR_POLY,   -- Polymorph
    [12824] = GR.DR_POLY,   -- Polymorph (rank 2)
    [12825] = GR.DR_POLY,   -- Polymorph (rank 3)
    [12826] = GR.DR_POLY,   -- Polymorph (rank 4)
    [28271] = GR.DR_POLY,   -- Polymorph: Turtle
    [28272] = GR.DR_POLY,   -- Polymorph: Pig

    -- Cyclone (its own category)
    [33786] = GR.DR_CYCLONE, -- Cyclone

    -- Roots
    [122]   = GR.DR_ROOT,   -- Frost Nova
    [865]   = GR.DR_ROOT,   -- Frost Nova (rank 2)
    [6131]  = GR.DR_ROOT,   -- Frost Nova (rank 3)
    [10230] = GR.DR_ROOT,   -- Frost Nova (rank 4)
    [27088] = GR.DR_ROOT,   -- Frost Nova (rank 5)
    [339]   = GR.DR_ROOT,   -- Entangling Roots
    [1062]  = GR.DR_ROOT,   -- Entangling Roots (rank 2)
    [5195]  = GR.DR_ROOT,   -- Entangling Roots (rank 3)
    [5196]  = GR.DR_ROOT,   -- Entangling Roots (rank 4)
    [9852]  = GR.DR_ROOT,   -- Entangling Roots (rank 5)
    [9853]  = GR.DR_ROOT,   -- Entangling Roots (rank 6)
    [26989] = GR.DR_ROOT,   -- Entangling Roots (rank 7)
    [12494] = GR.DR_ROOT,   -- Frostbite

    -- Silence
    [15487] = GR.DR_SILENCE, -- Silence (Priest)
    [18469] = GR.DR_SILENCE, -- Counterspell - Silenced
    [24259] = GR.DR_SILENCE, -- Spell Lock (Silence)
    [28730] = GR.DR_SILENCE, -- Arcane Torrent (BE racial)
    [25046] = GR.DR_SILENCE, -- Arcane Torrent (Energy)

    -- Incapacitate
    [1776]  = GR.DR_INCAPACITATE, -- Gouge
    [19503] = GR.DR_INCAPACITATE, -- Scatter Shot
    [20066] = GR.DR_INCAPACITATE, -- Repentance
    [6770]  = GR.DR_INCAPACITATE, -- Sap
    [2070]  = GR.DR_INCAPACITATE, -- Sap (rank 2)
    [11297] = GR.DR_INCAPACITATE, -- Sap (rank 3)
    [14309] = GR.DR_INCAPACITATE, -- Freezing Trap Effect
    [3355]  = GR.DR_INCAPACITATE, -- Freezing Trap Effect (rank 1)

    -- Horror
    [17926] = GR.DR_HORROR,  -- Death Coil (rank 3)
    [27223] = GR.DR_HORROR,  -- Death Coil (rank 4)

    -- Sleep
    [19386] = GR.DR_SLEEP,   -- Wyvern Sting
    [24132] = GR.DR_SLEEP,   -- Wyvern Sting (rank 2)
    [24133] = GR.DR_SLEEP,   -- Wyvern Sting (rank 3)
    [2637]  = GR.DR_SLEEP,   -- Hibernate
    [18657] = GR.DR_SLEEP,   -- Hibernate (rank 2)
    [18658] = GR.DR_SLEEP,   -- Hibernate (rank 3)

    -- Disarm
    [676]   = GR.DR_DISARM,  -- Disarm

    -- Blind (its own DR in TBC, shares with Fear in later expacs)
    [2094]  = GR.DR_FEAR,    -- Blind
}

-- Also keep name-based lookup as fallback
GR.DR_SPELL_NAMES = {
    ["Cheap Shot"]              = GR.DR_STUN,
    ["Kidney Shot"]             = GR.DR_STUN,
    ["Bash"]                    = GR.DR_STUN,
    ["Hammer of Justice"]       = GR.DR_STUN,
    ["Intercept"]               = GR.DR_STUN,
    ["Charge Stun"]             = GR.DR_STUN,
    ["Pounce"]                  = GR.DR_STUN,
    ["Shadowfury"]              = GR.DR_STUN,
    ["War Stomp"]               = GR.DR_STUN,
    ["Concussion Blow"]         = GR.DR_STUN,
    ["Intimidation"]            = GR.DR_STUN,
    ["Impact"]                  = GR.DR_STUN,
    ["Blackout"]                = GR.DR_STUN,
    ["Fear"]                    = GR.DR_FEAR,
    ["Psychic Scream"]          = GR.DR_FEAR,
    ["Intimidating Shout"]      = GR.DR_FEAR,
    ["Howl of Terror"]          = GR.DR_FEAR,
    ["Seduction"]               = GR.DR_FEAR,
    ["Blind"]                   = GR.DR_FEAR,
    ["Polymorph"]               = GR.DR_POLY,
    ["Polymorph: Pig"]          = GR.DR_POLY,
    ["Polymorph: Turtle"]       = GR.DR_POLY,
    ["Cyclone"]                 = GR.DR_CYCLONE,
    ["Frost Nova"]              = GR.DR_ROOT,
    ["Entangling Roots"]        = GR.DR_ROOT,
    ["Frostbite"]               = GR.DR_ROOT,
    ["Silence"]                 = GR.DR_SILENCE,
    ["Counterspell - Silenced"] = GR.DR_SILENCE,
    ["Spell Lock"]              = GR.DR_SILENCE,
    ["Arcane Torrent"]          = GR.DR_SILENCE,
    ["Gouge"]                   = GR.DR_INCAPACITATE,
    ["Scatter Shot"]            = GR.DR_INCAPACITATE,
    ["Repentance"]              = GR.DR_INCAPACITATE,
    ["Sap"]                     = GR.DR_INCAPACITATE,
    ["Freezing Trap Effect"]    = GR.DR_INCAPACITATE,
    ["Death Coil"]              = GR.DR_HORROR,
    ["Wyvern Sting"]            = GR.DR_SLEEP,
    ["Hibernate"]               = GR.DR_SLEEP,
    ["Disarm"]                  = GR.DR_DISARM,
}

------------------------------------------------------------
-- Important Auras to Track (spellID -> display info)
------------------------------------------------------------
GR.AURA_LIST = {
    -- Immunities / Major Defensives
    [45438] = { priority = 10, type = "immunity" },    -- Ice Block
    [642]   = { priority = 10, type = "immunity" },    -- Divine Shield
    [1022]  = { priority = 9,  type = "immunity" },    -- Blessing of Protection
    [19263] = { priority = 9,  type = "immunity" },    -- Deterrence
    [31224] = { priority = 9,  type = "immunity" },    -- Cloak of Shadows
    [18499] = { priority = 8,  type = "defensive" },   -- Berserker Rage (fear immunity)
    [12976] = { priority = 7,  type = "defensive" },   -- Last Stand
    [871]   = { priority = 8,  type = "defensive" },   -- Shield Wall
    [33206] = { priority = 9,  type = "defensive" },   -- Pain Suppression

    -- CC on target (debuffs)
    [118]   = { priority = 8, type = "cc" },            -- Polymorph
    [12826] = { priority = 8, type = "cc" },            -- Polymorph (rank 4)
    [28271] = { priority = 8, type = "cc" },            -- Polymorph: Turtle
    [28272] = { priority = 8, type = "cc" },            -- Polymorph: Pig
    [33786] = { priority = 8, type = "cc" },            -- Cyclone
    [5782]  = { priority = 7, type = "cc" },            -- Fear
    [8122]  = { priority = 7, type = "cc" },            -- Psychic Scream
    [2094]  = { priority = 7, type = "cc" },            -- Blind
    [6770]  = { priority = 7, type = "cc" },            -- Sap
    [1776]  = { priority = 6, type = "cc" },            -- Gouge
    [19503] = { priority = 6, type = "cc" },            -- Scatter Shot

    -- Offensive CDs
    [13750] = { priority = 6, type = "offensive" },     -- Adrenaline Rush
    [14177] = { priority = 6, type = "offensive" },     -- Cold Blood
    [12042] = { priority = 6, type = "offensive" },     -- Arcane Power
    [12472] = { priority = 6, type = "offensive" },     -- Icy Veins
    [3045]  = { priority = 5, type = "offensive" },     -- Rapid Fire
    [34692] = { priority = 7, type = "offensive" },     -- The Beast Within
    [31884] = { priority = 6, type = "offensive" },     -- Avenging Wrath
    [1719]  = { priority = 5, type = "offensive" },     -- Recklessness
    [12292] = { priority = 5, type = "offensive" },     -- Death Wish

    -- Healing
    [29166] = { priority = 7, type = "healing" },       -- Innervate
}

------------------------------------------------------------
-- Spec Detection: Spell Name -> Spec (per class)
------------------------------------------------------------
GR.SPEC_SPELLS = {
    WARRIOR = {
        ["Mortal Strike"]    = "Arms",
        ["Sweeping Strikes"] = "Arms",
        ["Bloodthirst"]      = "Fury",
        ["Rampage"]          = "Fury",
        ["Shield Slam"]      = "Protection",
        ["Devastate"]        = "Protection",
    },
    PALADIN = {
        ["Holy Shock"]       = "Holy",
        ["Avenger's Shield"] = "Protection",
        ["Crusader Strike"]  = "Retribution",
    },
    HUNTER = {
        ["Bestial Wrath"]    = "Beast Mastery",
        ["The Beast Within"] = "Beast Mastery",
        ["Silencing Shot"]   = "Marksmanship",
        ["Trueshot Aura"]    = "Marksmanship",
        ["Wyvern Sting"]     = "Survival",
        ["Readiness"]        = "Survival",
    },
    ROGUE = {
        ["Mutilate"]         = "Assassination",
        ["Cold Blood"]       = "Assassination",
        ["Blade Flurry"]     = "Combat",
        ["Adrenaline Rush"]  = "Combat",
        ["Shadowstep"]       = "Subtlety",
        ["Hemorrhage"]       = "Subtlety",
        ["Premeditation"]    = "Subtlety",
    },
    PRIEST = {
        ["Pain Suppression"] = "Discipline",
        ["Power Infusion"]   = "Discipline",
        ["Circle of Healing"]= "Holy",
        ["Lightwell"]        = "Holy",
        ["Vampiric Touch"]   = "Shadow",
        ["Shadowform"]       = "Shadow",
    },
    SHAMAN = {
        ["Elemental Mastery"] = "Elemental",
        ["Totem of Wrath"]    = "Elemental",
        ["Stormstrike"]       = "Enhancement",
        ["Shamanistic Rage"]  = "Enhancement",
        ["Earth Shield"]      = "Restoration",
        ["Mana Tide Totem"]   = "Restoration",
    },
    MAGE = {
        ["Arcane Power"]     = "Arcane",
        ["Slow"]             = "Arcane",
        ["Combustion"]       = "Fire",
        ["Dragon's Breath"]  = "Fire",
        ["Blast Wave"]       = "Fire",
        ["Ice Barrier"]      = "Frost",
        ["Summon Water Elemental"] = "Frost",
        ["Cold Snap"]        = "Frost",
    },
    WARLOCK = {
        ["Unstable Affliction"] = "Affliction",
        ["Siphon Life"]      = "Affliction",
        ["Felguard"]         = "Demonology",
        ["Soul Link"]        = "Demonology",
        ["Shadowfury"]       = "Destruction",
        ["Conflagrate"]      = "Destruction",
    },
    DRUID = {
        ["Force of Nature"]  = "Balance",
        ["Moonkin Form"]     = "Balance",
        ["Insect Swarm"]     = "Balance",
        ["Mangle (Cat)"]     = "Feral",
        ["Mangle (Bear)"]    = "Feral",
        ["Mangle"]           = "Feral",
        ["Swiftmend"]        = "Restoration",
        ["Tree of Life"]     = "Restoration",
    },
}

------------------------------------------------------------
-- Trinket / CC-break spell IDs
------------------------------------------------------------
GR.TRINKET_SPELLS = {
    [42292] = true,   -- PvP Trinket
    [7744]  = true,   -- Will of the Forsaken
}
GR.TRINKET_COOLDOWN = 120

------------------------------------------------------------
-- Drink detection
------------------------------------------------------------
GR.DRINK_SPELLS = {
    ["Drink"]        = true,
    ["Refreshment"]  = true,
    ["Food & Drink"] = true,
}

------------------------------------------------------------
-- Class icons
------------------------------------------------------------
GR.CLASS_TEXTURE = "Interface\\GLUES\\CHARACTERCREATE\\UI-CharacterCreate-Classes"

GR.CLASS_TCOORDS = CLASS_ICON_TCOORDS or {
    WARRIOR     = {0, 0.25, 0, 0.25},
    MAGE        = {0.25, 0.49609375, 0, 0.25},
    ROGUE       = {0.49609375, 0.7421875, 0, 0.25},
    DRUID       = {0.7421875, 0.98828125, 0, 0.25},
    HUNTER      = {0, 0.25, 0.25, 0.5},
    SHAMAN      = {0.25, 0.49609375, 0.25, 0.5},
    PRIEST      = {0.49609375, 0.7421875, 0.25, 0.5},
    WARLOCK     = {0.7421875, 0.98828125, 0.25, 0.5},
    PALADIN     = {0, 0.25, 0.5, 0.75},
}

------------------------------------------------------------
-- Power colors
------------------------------------------------------------
GR.POWER_COLORS = {
    [0] = {0, 0, 1},          -- Mana
    [1] = {1, 0, 0},          -- Rage
    [2] = {1, 0.5, 0.25},     -- Focus
    [3] = {1, 1, 0},          -- Energy
}

------------------------------------------------------------
-- Bar Textures
------------------------------------------------------------
GR.BAR_TEXTURES = {
    ["Interface\\TargetingFrame\\UI-StatusBar"]                                         = "Blizzard",
    ["Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar"]                          = "Blizzard Skills",
    ["Interface\\RaidFrame\\Raid-Bar-Hp-Fill"]                                          = "Blizzard Raid",
    ["Interface\\Buttons\\WHITE8x8"]                                                    = "Solid",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\NormTex"]                = "Gloss",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\NormTex2"]               = "Norm",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\NormTex3"]               = "Norm1",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\Minimalist"]             = "Minimalist",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\Melli"]                  = "Melli",
    ["Interface\\AddOns\\ElvUI\\Game\\Shared\\Media\\Textures\\Smooth"]                 = "Smooth",
}

------------------------------------------------------------
-- Test Mode DR spellIDs (for showing spell icons in test)
------------------------------------------------------------
GR.TEST_DR_SPELLS = {
    stun         = 408,    -- Kidney Shot
    fear         = 8122,   -- Psychic Scream
    polymorph    = 118,    -- Polymorph
    cyclone      = 33786,  -- Cyclone
    root         = 122,    -- Frost Nova
    silence      = 15487,  -- Silence
    incapacitate = 1776,   -- Gouge
    horror       = 17926,  -- Death Coil
    sleep        = 19386,  -- Wyvern Sting
    disarm       = 676,    -- Disarm
}
