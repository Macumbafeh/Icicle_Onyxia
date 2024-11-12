-- Spec-specific buffs
-- Strings are self-buffs only. That unit is that spec.
-- Tables are for castable talent buffs or auras.
icicleSpecBuffList = {
        -- WARRIOR
        [GetSpellInfo(56638)]   = "Warrior Arms",            -- Taste for Blood
        [GetSpellInfo(64976)]   = "Warrior Arms",            -- Juggernaut
        [GetSpellInfo(29801)]   = "Warrior Fury",            -- Rampage
        [GetSpellInfo(50227)]   = "Warrior Protection",      -- Sword and Board
        -- PALADIN
        [GetSpellInfo(20375)]   = "Paladin Retribution",     -- If you are using Seal of Command, I hate you so much
        [GetSpellInfo(31836)]   = "Paladin Holy",            -- Light's Grace
        -- ROGUE
        [GetSpellInfo(36554)]   = "Rogue Subtlety",          -- Shadowstep
        [GetSpellInfo(31223)]   = "Rogue Subtlety",          -- Master of Subtlety
        -- PRIEST
        [GetSpellInfo(47788)]   = "Priest Holy",             -- Guardian Spirit
        [GetSpellInfo(52800)]   = "Priest Discipline",       -- Borrowed Time
        [GetSpellInfo(15473)]   = "Priest Shadow",           -- Shadowform
        [GetSpellInfo(15286)]   = "Priest Shadow",           -- Vampiric Embrace
        -- DEATHKNIGHT
        [GetSpellInfo(49222)]   = "Deathknight Unholy",      -- Bone Shield
        [GetSpellInfo(49016)]   = "Deathknight Blood",       -- Hysteria
        [GetSpellInfo(53138)]   = "Deathknight Blood",       -- Abomination's Might
        [GetSpellInfo(55610)]   = "Deathknight Frost",       -- Imp. Icy Talons
        -- MAGE
        [GetSpellInfo(43039)]   = "Mage Frost",              -- Ice Barrier
        [GetSpellInfo(11129)]   = "Mage Fire",               -- Combustion
        [GetSpellInfo(31583)]   = "Mage Arcane",             -- Arcane Empowerment
        -- WARLOCK
        [GetSpellInfo(30302)]   = "Warlock Destruction",     -- Nether Protection
        -- SHAMAN
        [GetSpellInfo(57663)]   = "Shaman Elemental",        -- Totem of Wrath
        [GetSpellInfo(49284)]   = "Shaman Restoration",      -- Earth Shield
        [GetSpellInfo(51470)]   = "Shaman Elemental",        -- Elemental Oath
        [GetSpellInfo(30809)]   = "Shaman Enhancement",      -- Unleashed Rage
        -- HUNTER
        [GetSpellInfo(20895)]   = "Hunter Beast Mastery",    -- Spirit Bond
        [GetSpellInfo(19506)]   = "Hunter Marksmanship",     -- Trueshot Aura
        -- DRUID
        [GetSpellInfo(24932)]   = "Druid Feral",             -- Leader of the Pack
        [GetSpellInfo(34123)]   = "Druid Restoration",       -- Tree of Life
        [GetSpellInfo(24907)]   = "Druid Balance",           -- Moonkin Aura
        [GetSpellInfo(53251)]   = "Druid Restoration"        -- Wild Growth
    }

-- Spec-specific abilities
-- If someone uses that ability, they are that spec.
icicleSpecSpellList = {
        -- WARRIOR
        [47486]   = "Warrior Arms",            -- Mortal Strike
        [46924]   = "Warrior Arms",            -- Bladestorm
        [23881]   = "Warrior Fury",            -- Bloodthirst
        [12809]   = "Warrior Protection",      -- Concussion Blow
        [47498]   = "Warrior Protection",      -- Devastate
        -- PALADIN
        [48827]   = "Paladin Protection",      -- Avenger's Shield
        [48825]   = "Paladin Holy",            -- Holy Shock
        [35395]   = "Paladin Retribution",     -- Crusader Strike
        [53385]   = "Paladin Retribution",     -- Divine Storm
        [20066]   = "Paladin Retribution",     -- Repentance
        -- ROGUE
        [48666]   = "Rogue Assassination",     -- Mutilate
        [51690]   = "Rogue Combat",            -- Killing Spree
        [13877]   = "Rogue Combat",            -- Blade Flurry
        [13750]   = "Rogue Combat",            -- Adrenaline Rush
        [48660]   = "Rogue Subtlety",          -- Hemorrhage
        -- PRIEST
        [53007]   = "Priest Discipline",       -- Penance
        [10060]   = "Priest Discipline",       -- Power Infusion
        [33206]   = "Priest Discipline",       -- Pain Suppression
        [34861]   = "Priest Holy",             -- Circle of Healing
        [15487]   = "Priest Shadow",           -- Silence
        [48160]   = "Priest Shadow",           -- Vampiric Touch   
        -- DEATHKNIGHT
        [55262]   = "Deathknight Blood",       -- Heart Strike
        [49203]   = "Deathknight Frost",       -- Hungering Cold
        [55268]   = "Deathknight Frost",       -- Frost Strike
        [51411]   = "Deathknight Frost",       -- Howling Blast
        [55271]   = "Deathknight Unholy",      -- Scourge Strike
        -- MAGE
        [44781]   = "Mage Arcane",             -- Arcane Barrage
        [55360]   = "Mage Fire",               -- Living Bomb
        [42950]   = "Mage Fire",               -- Dragon's Breath
        [42945]   = "Mage Fire",               -- Blast Wave
        [44572]   = "Mage Frost",              -- Deep Freeze
        -- WARLOCK
        [59164]   = "Warlock Affliction",      -- Haunt
        [47843]   = "Warlock Affliction",      -- Unstable Affliction
        [59672]   = "Warlock Demonology",      -- Metamorphosis
        [59172]   = "Warlock Destruction",     -- Chaos Bolt
        [47847]   = "Warlock Destruction",     -- Shadowfury
        -- SHAMAN
        [59159]   = "Shaman Elemental",        -- Thunderstorm
        [16166]   = "Shaman Elemental",        -- Elemental Mastery
        [51533]   = "Shaman Enhancement",      -- Feral Spirit
        [30823]   = "Shaman Enhancement",      -- Shamanistic Rage
        [17364]   = "Shaman Enhancement",      -- Stormstrike
        [61301]   = "Shaman Restoration",      -- Riptide
        [51886]   = "Shaman Restoration",      -- Cleanse Spirit
        -- HUNTER
        [19577]   = "Hunter Beast Mastery",    -- Intimidation
        [34490]   = "Hunter Marksmanship",     -- Silencing Shot
        [53209]   = "Hunter Marksmanship",     -- Chimera Shot
        [60053]   = "Hunter Survival",         -- Explosive Shot
        [49012]   = "Hunter Survival",         -- Wyvern Sting
        -- DRUID
        [53201]   = "Druid Balance",           -- Starfall
        [61384]   = "Druid Balance",           -- Typhoon
        [48566]   = "Druid Feral",             -- Mangle (Cat)
        [48564]   = "Druid Feral",             -- Mangle (Bear)
        [18562]   = "Druid Restoration"        -- Swiftmend
    }