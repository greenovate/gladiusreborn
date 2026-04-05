local _, GR = ...

------------------------------------------------------------
-- Advanced Click Presets (for Click Actions tab)
-- These replace the simple spell casts with real arena macros
------------------------------------------------------------
GR.CLICK_PRESETS = {
    -- ===== ROGUE =====
    { name = "Sstep > Kick",          classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Shadowstep\n/cast [@*unit] Kick" },
    { name = "Sstep > Cheap Shot",    classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Shadowstep\n/cast [@*unit] Cheap Shot" },
    { name = "Sstep > Garrote",       classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Shadowstep\n/cast [@*unit] Garrote" },
    { name = "Sstep > Kidney Shot",   classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Shadowstep\n/cast [@*unit] Kidney Shot" },
    { name = "Blind",                 classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Blind" },
    { name = "Sap",                   classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Sap" },
    { name = "Kick",                  classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Kick" },
    { name = "Gouge",                 classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Gouge" },
    { name = "Kidney Shot",           classFilter = "ROGUE", action = "macro", macro = "/cast [@*unit] Kidney Shot" },
    { name = "Vanish > Sstep > CS",   classFilter = "ROGUE", action = "macro", macro = "/cast Vanish\n/cast [@*unit] Shadowstep\n/cast [@*unit] Cheap Shot" },
    { name = "Vanish > Sap",          classFilter = "ROGUE", action = "macro", macro = "/cast Vanish\n/cast [@*unit] Sap" },
    { name = "Cloak > Vanish",        classFilter = "ROGUE", action = "macro", macro = "/cast Cloak of Shadows\n/cast Vanish" },

    -- ===== MAGE =====
    { name = "Stop > Poly",           classFilter = "MAGE", action = "macro", macro = "/stopcasting\n/cast [@*unit] Polymorph" },
    { name = "Stop > CS",             classFilter = "MAGE", action = "macro", macro = "/stopcasting\n/cast [@*unit] Counterspell" },
    { name = "Stop > Spellsteal",     classFilter = "MAGE", action = "macro", macro = "/stopcasting\n/cast [@*unit] Spellsteal" },
    { name = "PoM > Poly",            classFilter = "MAGE", action = "macro", macro = "/stopcasting\n/cast Presence of Mind\n/cast [@*unit] Polymorph" },
    { name = "PoM > Pyro",            classFilter = "MAGE", action = "macro", macro = "/cast Presence of Mind\n/cast [@*unit] Pyroblast" },
    { name = "Frost Nova",            classFilter = "MAGE", action = "spell", spell = "Frost Nova" },
    { name = "Ele / Freeze",          classFilter = "MAGE", action = "macro", macro = "/cast [nopet] Summon Water Elemental\n/cast [pet] Freeze" },

    -- ===== WARLOCK =====
    { name = "Stop > Fear",           classFilter = "WARLOCK", action = "macro", macro = "/stopcasting\n/cast [@*unit] Fear" },
    { name = "Stop > Spell Lock",     classFilter = "WARLOCK", action = "macro", macro = "/stopcasting\n/cast [@*unit] Spell Lock" },
    { name = "Death Coil",            classFilter = "WARLOCK", action = "macro", macro = "/cast [@*unit] Death Coil" },
    { name = "Devour (self dispel)",   classFilter = "WARLOCK", action = "macro", macro = "/cast [@player] Devour Magic" },
    { name = "Fear > Howl combo",     classFilter = "WARLOCK", action = "macro", macro = "/stopcasting\n/cast [@*unit] Howl of Terror" },

    -- ===== PRIEST =====
    { name = "Stop > Silence",        classFilter = "PRIEST", action = "macro", macro = "/stopcasting\n/cast [@*unit] Silence" },
    { name = "Stop > SW:Death",       classFilter = "PRIEST", action = "macro", macro = "/stopcasting\n/cast [@*unit] Shadow Word: Death" },
    { name = "Stop > Mass Dispel",    classFilter = "PRIEST", action = "macro", macro = "/stopcasting\n/cast Mass Dispel" },
    { name = "Dispel Magic",          classFilter = "PRIEST", action = "macro", macro = "/cast [@*unit] Dispel Magic" },
    { name = "Psychic Scream",        classFilter = "PRIEST", action = "spell", spell = "Psychic Scream" },
    { name = "Pain Supp (self)",      classFilter = "PRIEST", action = "macro", macro = "/cast [@player] Pain Suppression" },
    { name = "Fear Ward (self)",      classFilter = "PRIEST", action = "macro", macro = "/cast [@player] Fear Ward" },

    -- ===== DRUID =====
    { name = "Stop > Cyclone",        classFilter = "DRUID", action = "macro", macro = "/stopcasting\n/cast [@*unit] Cyclone" },
    { name = "Stop > Roots",          classFilter = "DRUID", action = "macro", macro = "/stopcasting\n/cast [@*unit] Entangling Roots" },
    { name = "Bash",                  classFilter = "DRUID", action = "macro", macro = "/cast [@*unit] Bash" },
    { name = "Feral Charge",          classFilter = "DRUID", action = "macro", macro = "/cast [@*unit] Feral Charge" },
    { name = "NS > HT (self)",        classFilter = "DRUID", action = "macro", macro = "/cast Nature's Swiftness\n/cast [@player] Healing Touch" },
    { name = "Abolish Poison (self)",  classFilter = "DRUID", action = "macro", macro = "/cast [@player] Abolish Poison" },

    -- ===== PALADIN =====
    { name = "HoJ",                   classFilter = "PALADIN", action = "macro", macro = "/cast [@*unit] Hammer of Justice" },
    { name = "Repentance",            classFilter = "PALADIN", action = "macro", macro = "/cast [@*unit] Repentance" },
    { name = "Cleanse",               classFilter = "PALADIN", action = "macro", macro = "/cast [@*unit] Cleanse" },
    { name = "BoP Partner",           classFilter = "PALADIN", action = "macro", macro = "/cast [@party1] Blessing of Protection" },
    { name = "BoF (self)",            classFilter = "PALADIN", action = "macro", macro = "/cast [@player] Blessing of Freedom" },

    -- ===== WARRIOR =====
    { name = "Pummel",                classFilter = "WARRIOR", action = "macro", macro = "/cast [@*unit] Pummel" },
    { name = "Intercept",             classFilter = "WARRIOR", action = "macro", macro = "/cast [@*unit] Intercept" },
    { name = "Charge / Intercept",    classFilter = "WARRIOR", action = "macro", macro = "/cast [stance:1] Charge; [stance:3] Intercept\n/cast [@*unit] Hamstring" },
    { name = "Hamstring",             classFilter = "WARRIOR", action = "macro", macro = "/cast [@*unit] Hamstring" },
    { name = "Disarm",                classFilter = "WARRIOR", action = "macro", macro = "/cast [@*unit] Disarm" },
    { name = "Intervene Partner",     classFilter = "WARRIOR", action = "macro", macro = "/cast Defensive Stance\n/cast [@party1] Intervene" },
    { name = "Spell Reflect",         classFilter = "WARRIOR", action = "macro", macro = "/cast Defensive Stance\n/cast Spell Reflection" },

    -- ===== HUNTER =====
    { name = "Scatter Shot",          classFilter = "HUNTER", action = "macro", macro = "/cast [@*unit] Scatter Shot" },
    { name = "Scatter > Trap",        classFilter = "HUNTER", action = "macro", macro = "/cast [@*unit] Scatter Shot\n/cast Freezing Trap" },
    { name = "Stop > Silencing Shot", classFilter = "HUNTER", action = "macro", macro = "/stopcasting\n/cast [@*unit] Silencing Shot" },
    { name = "Viper Sting",           classFilter = "HUNTER", action = "macro", macro = "/cast [@*unit] Viper Sting" },
    { name = "BW + Intimidation",     classFilter = "HUNTER", action = "macro", macro = "/cast Bestial Wrath\n/cast Intimidation" },
    { name = "Concussive Shot",       classFilter = "HUNTER", action = "macro", macro = "/cast [@*unit] Concussive Shot" },

    -- ===== SHAMAN =====
    { name = "Stop > Wind Shear",     classFilter = "SHAMAN", action = "macro", macro = "/stopcasting\n/cast [@*unit] Wind Shear" },
    { name = "Purge",                 classFilter = "SHAMAN", action = "macro", macro = "/cast [@*unit] Purge" },
    { name = "Stop > Earth Shock",    classFilter = "SHAMAN", action = "macro", macro = "/stopcasting\n/cast [@*unit] Earth Shock" },
    { name = "Grounding Totem",       classFilter = "SHAMAN", action = "spell", spell = "Grounding Totem" },
    { name = "NS > Heal (self)",      classFilter = "SHAMAN", action = "macro", macro = "/cast Nature's Swiftness\n/cast [@player] Healing Wave" },
}

------------------------------------------------------------
-- Macro Toolkit Catalog
-- Full arena macros by class, importable to character macros
------------------------------------------------------------
GR.MACRO_CATALOG = {
    ROGUE = {
        {
            name = "Shadowstep Kick",
            icon = "Ability_Rogue_Shadowstep",
            body = "#showtooltip Kick\n/cast [target=focus,exists,harm] Shadowstep\n/cast [target=focus,exists,harm] Kick",
            desc = "Shadowstep to focus then Kick. One button interrupt.",
        },
        {
            name = "Blind Focus",
            icon = "Spell_Shadow_MindSteal",
            body = "#showtooltip Blind\n/cast [target=focus,exists,harm] Blind",
            desc = "Blind your focus target without switching targets.",
        },
        {
            name = "Sap Arena 1/2/3",
            icon = "Ability_Sap",
            body = "#showtooltip Sap\n/cast [target=arena1,exists] Sap",
            desc = "Sap arena1. Duplicate and change to arena2/arena3.",
        },
        {
            name = "Cheap Shot Focus",
            icon = "Ability_CheapShot",
            body = "#showtooltip Cheap Shot\n/cast [target=focus,exists,harm] Cheap Shot",
            desc = "Cheap Shot your focus target.",
        },
        {
            name = "Kidney Shot Focus",
            icon = "Ability_Rogue_KidneyShot",
            body = "#showtooltip Kidney Shot\n/cast [target=focus,exists,harm] Kidney Shot",
            desc = "Kidney Shot your focus target.",
        },
        {
            name = "Cloak + Vanish",
            icon = "Spell_Shadow_NetherCloak",
            body = "#showtooltip\n/cast Cloak of Shadows\n/cast Vanish",
            desc = "Panic button. Cloak to remove dots then Vanish.",
        },
        {
            name = "Trinket + Vanish",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Vanish",
            desc = "Trinket CC then immediately Vanish.",
        },
        {
            name = "Gouge Focus",
            icon = "Ability_Gouge",
            body = "#showtooltip Gouge\n/cast [target=focus,exists,harm] Gouge",
            desc = "Gouge focus target for a swap or peel.",
        },
    },
    MAGE = {
        {
            name = "Stopcasting Poly",
            icon = "Spell_Nature_Polymorph",
            body = "#showtooltip Polymorph\n/stopcasting\n/cast [target=focus,exists,harm] Polymorph",
            desc = "Cancel current cast and Poly your focus target.",
        },
        {
            name = "Stopcasting CS",
            icon = "Spell_Frost_IceShock",
            body = "#showtooltip Counterspell\n/stopcasting\n/cast [target=focus,exists,harm] Counterspell",
            desc = "Cancel cast and Counterspell focus. The bread and butter.",
        },
        {
            name = "Poly Arena 1",
            icon = "Spell_Nature_Polymorph",
            body = "#showtooltip Polymorph\n/stopcasting\n/cast [target=arena1] Polymorph",
            desc = "Stopcasting Poly arena1. Duplicate for arena2/3.",
        },
        {
            name = "CS Arena 1",
            icon = "Spell_Frost_IceShock",
            body = "#showtooltip Counterspell\n/stopcasting\n/cast [target=arena1] Counterspell",
            desc = "Stopcasting CS arena1. Duplicate for arena2/3.",
        },
        {
            name = "Spellsteal Focus",
            icon = "Spell_Arcane_Arcane02",
            body = "#showtooltip Spellsteal\n/stopcasting\n/cast [target=focus,exists] Spellsteal",
            desc = "Stopcasting Spellsteal focus. Steal HoTs and buffs.",
        },
        {
            name = "Ice Block Cancel",
            icon = "Spell_Frost_Frost",
            body = "#showtooltip Ice Block\n/cancelaura Ice Block\n/cast Ice Block",
            desc = "Toggle Ice Block on/off with one button.",
        },
        {
            name = "Icy Veins + AP",
            icon = "Spell_Frost_ColdHearted",
            body = "#showtooltip Icy Veins\n/cast Icy Veins\n/cast Arcane Power",
            desc = "Stack Icy Veins and Arcane Power for burst. PoM Pyro setup.",
        },
        {
            name = "Water Ele / Freeze",
            icon = "Spell_Frost_SummonWaterElemental_2",
            body = "#showtooltip\n/cast [nopet] Summon Water Elemental\n/cast [pet] Freeze",
            desc = "Summon Water Elemental if dead/missing, cast pet Freeze if it's out. One button.",
        },
        {
            name = "Cold Snap Reset",
            icon = "Spell_Frost_WizardMark",
            body = "#showtooltip Cold Snap\n/cast Cold Snap\n/cast Ice Barrier",
            desc = "Cold Snap and immediately reapply Ice Barrier.",
        },
        {
            name = "PoM Pyro",
            icon = "Spell_Fire_Fireball02",
            body = "#showtooltip Pyroblast\n/cast Presence of Mind\n/cast Pyroblast",
            desc = "Presence of Mind into instant Pyroblast. The classic oneshot opener.",
        },
        {
            name = "PoM Poly",
            icon = "Spell_Nature_Polymorph",
            body = "#showtooltip Polymorph\n/stopcasting\n/cast Presence of Mind\n/cast [target=focus,exists,harm] Polymorph",
            desc = "Stopcasting, PoM, instant Poly on focus. Uninterruptible CC.",
        },
        {
            name = "PoM Frostbolt",
            icon = "Spell_Frost_FrostBolt02",
            body = "#showtooltip Frostbolt\n/cast Presence of Mind\n/cast Frostbolt",
            desc = "PoM instant Frostbolt for burst or finishing a kill in shatter.",
        },
        {
            name = "AP + Trinket Burst",
            icon = "Spell_Nature_Lightning",
            body = "#showtooltip Arcane Power\n/cast Arcane Power\n/use 13",
            desc = "Arcane Power and PvP trinket (on-use) for maximum burst window.",
        },
        {
            name = "Combustion Burst",
            icon = "Spell_Fire_SealOfFire",
            body = "#showtooltip Combustion\n/cast Combustion\n/use 13",
            desc = "Combustion and on-use trinket. Fire burst setup.",
        },
    },
    WARLOCK = {
        {
            name = "Stopcasting Fear",
            icon = "Spell_Shadow_Possession",
            body = "#showtooltip Fear\n/stopcasting\n/cast [target=focus,exists,harm] Fear",
            desc = "Cancel cast and Fear focus target.",
        },
        {
            name = "Devour Magic",
            icon = "Spell_Nature_Purge",
            body = "#showtooltip Devour Magic\n/cast [target=player] Devour Magic",
            desc = "Felhunter dispels you. Use on yourself to break CC.",
        },
        {
            name = "Spell Lock Focus",
            icon = "Spell_Shadow_MindRot",
            body = "#showtooltip Spell Lock\n/stopcasting\n/cast [target=focus,exists,harm] Spell Lock",
            desc = "Stopcasting then Spell Lock focus. Elite interrupt.",
        },
        {
            name = "Death Coil Focus",
            icon = "Spell_Shadow_DeathCoil",
            body = "#showtooltip Death Coil\n/cast [target=focus,exists,harm] Death Coil",
            desc = "Death Coil focus. Horror effect for peels.",
        },
        {
            name = "Trinket + SL",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Soul Link",
            desc = "Trinket and re-enable Soul Link.",
        },
        {
            name = "Fear Arena 1",
            icon = "Spell_Shadow_Possession",
            body = "#showtooltip Fear\n/stopcasting\n/cast [target=arena1] Fear",
            desc = "Stopcasting Fear arena1. Duplicate for arena2/3.",
        },
    },
    PRIEST = {
        {
            name = "Stopcasting Silence",
            icon = "Spell_Shadow_Curse",
            body = "#showtooltip Silence\n/stopcasting\n/cast [target=focus,exists,harm] Silence",
            desc = "Cancel cast and Silence focus. Shadow priest staple.",
        },
        {
            name = "Mass Dispel Cursor",
            icon = "Spell_Arcane_MassDispel",
            body = "#showtooltip Mass Dispel\n/stopcasting\n/cast Mass Dispel",
            desc = "Stopcasting Mass Dispel for Paladin bubbles and Block.",
        },
        {
            name = "SW:Death (stop+cast)",
            icon = "Spell_Shadow_DeathPact",
            body = "#showtooltip Shadow Word: Death\n/stopcasting\n/cast Shadow Word: Death",
            desc = "Execute range finish. Also breaks CC via damage to self.",
        },
        {
            name = "Dispel Focus",
            icon = "Spell_Holy_DispelMagic",
            body = "#showtooltip Dispel Magic\n/cast [target=focus,exists] Dispel Magic",
            desc = "Offensive dispel focus target. Remove HoTs, shields.",
        },
        {
            name = "Pain Supp Self",
            icon = "Spell_Holy_PainSupression",
            body = "#showtooltip Pain Suppression\n/cast [target=player] Pain Suppression",
            desc = "Pain Suppression yourself instantly.",
        },
        {
            name = "Trinket + Shield",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Power Word: Shield",
            desc = "Trinket and immediately shield yourself.",
        },
        {
            name = "Fear Ward Self",
            icon = "Spell_Holy_Excorcism",
            body = "#showtooltip Fear Ward\n/cast [target=player] Fear Ward",
            desc = "Fear Ward yourself. Keep it up vs Warlocks.",
        },
    },
    DRUID = {
        {
            name = "Stopcasting Cyclone",
            icon = "Spell_Nature_EarthBind",
            body = "#showtooltip Cyclone\n/stopcasting\n/cast [target=focus,exists,harm] Cyclone",
            desc = "Cancel cast and Cyclone focus target.",
        },
        {
            name = "Stopcasting Roots",
            icon = "Spell_Nature_StrangleVines",
            body = "#showtooltip Entangling Roots\n/stopcasting\n/cast [target=focus,exists,harm] Entangling Roots",
            desc = "Cancel cast and root focus target.",
        },
        {
            name = "Cyclone Arena 1",
            icon = "Spell_Nature_EarthBind",
            body = "#showtooltip Cyclone\n/stopcasting\n/cast [target=arena1] Cyclone",
            desc = "Stopcasting Cyclone arena1. Duplicate for arena2/3.",
        },
        {
            name = "Bash Focus",
            icon = "Ability_Druid_Bash",
            body = "#showtooltip Bash\n/cast [target=focus,exists,harm] Bash",
            desc = "Bash focus target. Bear form stun.",
        },
        {
            name = "NS + Heal",
            icon = "Spell_Nature_RavenForm",
            body = "#showtooltip Nature's Swiftness\n/cast Nature's Swiftness\n/cast [target=player] Healing Touch",
            desc = "Nature's Swiftness into instant Healing Touch on self.",
        },
        {
            name = "Trinket + Bear",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Dire Bear Form",
            desc = "Trinket and go Bear for survival.",
        },
        {
            name = "Abolish Poison Self",
            icon = "Spell_Nature_NullifyPoison_02",
            body = "#showtooltip Abolish Poison\n/cast [target=player] Abolish Poison",
            desc = "Cleanse poisons from yourself (Crippling, Wound).",
        },
    },
    PALADIN = {
        {
            name = "HoJ Focus",
            icon = "Spell_Holy_SealOfMight",
            body = "#showtooltip Hammer of Justice\n/cast [target=focus,exists,harm] Hammer of Justice",
            desc = "HoJ focus target without switching.",
        },
        {
            name = "Repentance Focus",
            icon = "Spell_Holy_PrayerOfHealing",
            body = "#showtooltip Repentance\n/cast [target=focus,exists,harm] Repentance",
            desc = "Repentance focus. Long range incapacitate.",
        },
        {
            name = "Bubble Cancel",
            icon = "Spell_Holy_DivineIntervention",
            body = "#showtooltip Divine Shield\n/cancelaura Divine Shield\n/cast Divine Shield",
            desc = "Toggle Divine Shield on/off.",
        },
        {
            name = "BoP Partner",
            icon = "Spell_Holy_SealOfProtection",
            body = "#showtooltip Blessing of Protection\n/cast [target=party1] Blessing of Protection",
            desc = "BoP your partner instantly.",
        },
        {
            name = "Cleanse Self",
            icon = "Spell_Holy_Purify",
            body = "#showtooltip Cleanse\n/cast [target=player] Cleanse",
            desc = "Cleanse yourself of debuffs.",
        },
        {
            name = "Trinket + Bubble",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Divine Shield",
            desc = "Trinket into immediate Bubble.",
        },
    },
    WARRIOR = {
        {
            name = "Charge / Intercept",
            icon = "Ability_Warrior_Charge",
            body = "#showtooltip\n/cast [stance:1] Charge; [stance:3] Intercept",
            desc = "Charge in Battle, Intercept in Berserker. One button gap close.",
        },
        {
            name = "Pummel (zerker)",
            icon = "INV_Gauntlets_04",
            body = "#showtooltip Pummel\n/cast [stance:3] Pummel; Berserker Stance\n/cast Pummel",
            desc = "Switch to Berserker and Pummel in one press.",
        },
        {
            name = "Shield Bash (def)",
            icon = "Ability_Warrior_ShieldBash",
            body = "#showtooltip Shield Bash\n/equip [noequipped:Shields] YOUR_SHIELD_NAME\n/cast Defensive Stance\n/cast Shield Bash",
            desc = "Equip shield, swap to Defensive, Shield Bash. Edit shield name.",
        },
        {
            name = "Intervene Partner",
            icon = "Ability_Warrior_Intervene",
            body = "#showtooltip Intervene\n/cast [stance:2] Intervene; Defensive Stance\n/cast [target=party1] Intervene",
            desc = "Swap to Defensive and Intervene your partner.",
        },
        {
            name = "Spell Reflect",
            icon = "Ability_Warrior_ShieldReflect",
            body = "#showtooltip Spell Reflection\n/equip [noequipped:Shields] YOUR_SHIELD_NAME\n/cast Defensive Stance\n/cast Spell Reflection",
            desc = "Shield + Defensive + Spell Reflect. Edit shield name.",
        },
        {
            name = "Hamstring / MS",
            icon = "Ability_Warrior_SavageBlow",
            body = "#showtooltip\n/castsequence reset=target Hamstring, Mortal Strike",
            desc = "Hamstring first hit then Mortal Strike on second.",
        },
        {
            name = "Trinket + Zerk Rage",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Berserker Rage",
            desc = "Trinket and Berserker Rage for fear immunity.",
        },
    },
    HUNTER = {
        {
            name = "Scatter Focus",
            icon = "Ability_GolemStormBolt",
            body = "#showtooltip Scatter Shot\n/cast [target=focus,exists,harm] Scatter Shot",
            desc = "Scatter Shot focus without switching targets.",
        },
        {
            name = "Silencing Shot Focus",
            icon = "Ability_TheBlackArrow",
            body = "#showtooltip Silencing Shot\n/stopcasting\n/cast [target=focus,exists,harm] Silencing Shot",
            desc = "Stopcasting then Silencing Shot focus. Marksman interrupt.",
        },
        {
            name = "Scatter + Trap",
            icon = "Spell_Frost_ChainsOfIce",
            body = "#showtooltip Scatter Shot\n/cast [target=focus,exists,harm] Scatter Shot\n/cast Freezing Trap",
            desc = "Scatter focus then drop Freezing Trap on them.",
        },
        {
            name = "Viper Sting Focus",
            icon = "Ability_Hunter_AimedShot",
            body = "#showtooltip Viper Sting\n/cast [target=focus,exists,harm] Viper Sting",
            desc = "Mana drain focus target healer.",
        },
        {
            name = "BW + Intimidation",
            icon = "Ability_Hunter_BeastWithin",
            body = "#showtooltip Bestial Wrath\n/cast Bestial Wrath\n/cast Intimidation",
            desc = "Pop The Beast Within and pet stun at the same time.",
        },
        {
            name = "Trinket + FD",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Feign Death",
            desc = "Trinket then Feign Death to drop targeting.",
        },
    },
    SHAMAN = {
        {
            name = "Wind Shear Focus",
            icon = "Spell_Nature_Cyclone",
            body = "#showtooltip Wind Shear\n/stopcasting\n/cast [target=focus,exists,harm] Wind Shear",
            desc = "Stopcasting Wind Shear focus. Fastest interrupt in TBC.",
        },
        {
            name = "Purge Focus",
            icon = "Spell_Nature_Purge",
            body = "#showtooltip Purge\n/cast [target=focus,exists,harm] Purge",
            desc = "Purge focus target buffs. Remove BoP, shields, HoTs.",
        },
        {
            name = "Grounding Totem",
            icon = "Spell_Nature_GroundingTotem",
            body = "#showtooltip Grounding Totem\n/cast Grounding Totem",
            desc = "Drop Grounding Totem to eat incoming CC.",
        },
        {
            name = "NS + Heal",
            icon = "Spell_Nature_RavenForm",
            body = "#showtooltip Nature's Swiftness\n/cast Nature's Swiftness\n/cast [target=player] Healing Wave",
            desc = "Nature's Swiftness instant Healing Wave on self.",
        },
        {
            name = "Trinket + Ground",
            icon = "INV_Jewelry_TrinketPVP_02",
            body = "#showtooltip\n/use 13\n/cast Grounding Totem",
            desc = "Trinket and immediately drop Grounding.",
        },
        {
            name = "Earth Shock Focus",
            icon = "Spell_Nature_EarthShock",
            body = "#showtooltip Earth Shock\n/stopcasting\n/cast [target=focus,exists,harm] Earth Shock",
            desc = "Backup interrupt when Wind Shear is on CD.",
        },
    },
}
