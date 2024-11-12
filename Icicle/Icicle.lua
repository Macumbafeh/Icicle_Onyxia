Icicle = LibStub("AceAddon-3.0"):NewAddon("Icicle", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local self , Icicle = Icicle , Icicle
local Icicle_TEXT="|cffFF7D0AIcicle|r"
local Icicle_VERSION= " 2.0"
local Icicle_AUTHOR=" remastered by |cff0070DEbgggwp|r & |cffC41F3BXeqtr|r - Visit EZwow.org"
local Icicledb

-- Your Mom's spaghetti code ;]

function Icicle:OnInitialize()
self.db2 = LibStub("AceDB-3.0"):New("Icicledb",dbDefaults, "Default");
	DEFAULT_CHAT_FRAME:AddMessage(Icicle_TEXT .. Icicle_VERSION .. Icicle_AUTHOR .."  - /Icicle ");
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("Icicle", Icicle.Options, {"Icicle", "SS"})
	self:RegisterChatCommand("Icicle", "ShowConfig")
	self.db2.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db2.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db2.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	Icicledb = self.db2.profile
	Icicle.options = {
		name = "Icicle",
		desc = "Icons above enemy nameplates showing cooldowns",
		type = 'group',
		icon = [[Interface\Icons\Spell_Nature_ForceOfNature]],
		args = {},
	}
	local bliz_options = CopyTable(Icicle.options)
	bliz_options.args.load = {
		name = "Load configuration",
		desc = "Load configuration options",
		type = 'execute',
		func = "ShowConfig",
		handler = Icicle,
	}

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Icicle_bliz", bliz_options)
	AceConfigDialog:AddToBlizOptions("Icicle_bliz", "Icicle")
end
function Icicle:OnDisable()
end
local function initOptions()
	if Icicle.options.args.general then
		return
	end

	Icicle:OnOptionsCreate()

	for k, v in Icicle:IterateModules() do
		if type(v.OnOptionsCreate) == "function" then
			v:OnOptionsCreate()
		end
	end
	AceConfig:RegisterOptionsTable("Icicle", Icicle.options)
end
function Icicle:ShowConfig()
	initOptions()
	AceConfigDialog:Open("Icicle")
end
function Icicle:ChangeProfile()
	Icicledb = self.db2.profile
	for k,v in Icicle:IterateModules() do
		if type(v.ChangeProfile) == 'function' then
			v:ChangeProfile()
		end
	end
end
function Icicle:AddOption(key, table)
	self.options.args[key] = table
end
local function setOption(info, value)
	local name = info[#info]
	Icicledb[name] = value
end
local function getOption(info)
	local name = info[#info]
	return Icicledb[name]
end

function Icicle:OnOptionsCreate()
	self:AddOption("profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db2))
	self.options.args.profiles.order = -1
	self:AddOption('General', {
		type = 'group',
		name = "General",
		desc = "General Options",
		order = 1,
		args = {
			enableArea = {
				type = 'group',
				inline = true,
				name = "General options",
				set = setOption,
				get = getOption,
				args = {
					all = {
						type = 'toggle',
						name = "Enable Everything",
						desc = "Enables Icicle for BGs, world and arena",
						order = 1,
					},
					arena = {
						type = 'toggle',
						name = "Arena",
						desc = "Enabled in the arena",
						disabled = function() return Icicledb.all end,
						order = 2,
					},
					battleground = {
						type = 'toggle',
						name = "Battleground",
						desc = "Enable Battleground",
						disabled = function() return Icicledb.all end,
						order = 3,
					},
					field = {
						type = 'toggle',
						name = "World",
						desc = "Enabled outside Battlegrounds and arenas",
						disabled = function() return Icicledb.all end,
						order = 4,
					},
					iconsizer = {
						type = "range",
						min = 10,
						max = 50,
						step = 1,
						name = "Icon Size",
						desc = "Size of the Icons",
						order = 5,
						width = full,
					},
					YOffsetter = {
						type = "range",
						min = -100,
						max = 100,
						step = 1,
						name = "Y Offsets",
						desc = "Verticle Range from the Namplate and Icon",
						order = 7,
					},
					XOffsetter = {
						type = "range",
						min = -100,
						max = 100,
						step = 1,
						name = "X Offsets",
						desc = "Horizontal Range from the Namplate and Icon",
						order = 8,
					},
					alpha = {
						type = "range",
						min = 0,
						max = 100,
						step = 1,
						name = "Opacity",
						desc = "Changes opacity of Icons.",
						order = 6
					},
					changeAlpha = {
						type = 'toggle',
						name = "Dynamic opacity",
						desc = "Change opacity of Icons when target changes",
						order = 9
					},
					cdShadow = {
						type = 'toggle',
						name = "Cooldown shadow",
						desc = "Toggles cooldown shadow on icons.",
						order = 10
					},
					colorByClass = {
						type = 'toggle',
						name = "Color nameplates by class",
						desc = "Toggles nameplates' color by class",
						order = 11
					}
				},
			},
            othersArea = {
                type = 'group',
                inline = true,
                name = "Npc Stuff",
                set = setOption,
                get = getOption,
                args = {
                    npcShorterName = {
                        type = "range",
                        min = 0,
                        max = 100,
                        step = 1,
                        name = "Max length of NPC name",
                        desc = "Changes max NPC names above nameplate",
                        order = 1,
                    },
                },
            },
		}
	})
	end

local db = {}
local eventcheck = {}
local purgeframe = CreateFrame("frame")
local plateframe = CreateFrame("frame")
local count = 0
local width
local UPDATE_RATE = .25
local pvpZone = false;

local totemIDs = {
    8170,
    2062,
    2484,
    2894,
    8184,
    10537,
    10538,
    25563,
    58737,
    58739,
    8227,
    8249,
    10526,
    16387,
    25557,
    58649,
    58652,
    58656,
    8181,
    10478,
    10479,
    25560,
    58741,
    58745,
    8177,
    5394,
    6375,
    6377,
    10462,
    10463,
    25567,
    58755,
    58756,
    58757,
    8190,
    10585,
    10586,
    10587,
    25552,
    58731,
    58734,
    5675,
    10495,
    10496,
    10497,
    25570,
    58771,
    58773,
    58774,
    16190,
    10595,
    10600,
    10601,
    25574,
    58746,
    58749,
    3599,
    6363,
    6364,
    6365,
    10437,
    10438,
    25533,
    58699,
    58703,
    58704,
    6495,
    5730,
    6390,
    6391,
    6392,
    10427,
    10428,
    25525,
    58580,
    58581,
    58582,
    8071,
    8154,
    8155,
    10406,
    10407,
    10408,
    25508,
    25509,
    58751,
    58753,
    8075,
    8160,
    8161,
    10442,
    25361,
    25528,
    57622,
    58643,
    30706,
    57720,
    57721,
    57722,
    36936,
    8143,
    8512,
    3738,
}
local totems = {}
for i = 1, #totemIDs do
    local t = select(1, GetSpellInfo(totemIDs[i]))
    if not tContains(totems, t) then
        table.insert(totems, t)
    end
end


local isTotem = function(name)
    for i = 1, #totems do
        if strfind(name, totems[i]) then
            return true
        end
    end
end

local addicons = function(name, f)
	local num = #db[name]
	local size
	if not width then width = f:GetWidth() end
	--if num * Icicledb.iconsizer + (num * 2 - 2) > width then
	--	size = (width - (num * 2 - 2)) / num
	--else 
		size = Icicledb.iconsizer
	--end
	for i = 1, #db[name] do
		db[name][i]:ClearAllPoints()
		db[name][i]:SetWidth(size)
		db[name][i]:SetHeight(size)
		if i == 1 then
			db[name][i]:SetPoint("TOPLEFT", f, Icicledb.XOffsetter, size + Icicledb.YOffsetter)--10
		else
			db[name][i]:SetPoint("TOPLEFT", db[name][i-1], size + 2, 0)
		end
		db[name][i]:SetParent(nil)
	end
end

local hideicons = function(name, f)
	f.icicle = 0
	f.pet = nil
    f.npc = nil
	if db and db[name] then
		for i = 1, #db[name] do
			db[name][i]:Hide()
			db[name][i]:SetParent(nil)
			db[name][i].parent = nil
		end
	end
	-- f:SetScript("OnHide", nil)
end

local getIcon = function(spellID)
	if IcicleSpellIcons[spellID] then
		return IcicleSpellIcons[spellID]
	else
		return select(3, GetSpellInfo(spellID))
	end
end

local sourcetable = function(Name, spellID, spellName)
	if not db[Name] then db[Name] = {} end
	local texture = getIcon(spellID)
	local duration = IcicleCds[spellID]

	if db[Name].specCds then
        if db[Name].specCds[spellID] then
            duration = db[Name].specCds[spellID]
        end
    end

	local icon = CreateFrame("frame", nil, UIParent)
	icon.texture = icon:CreateTexture(nil, "ARTWORK")
	icon.texture:SetAllPoints(icon)
	icon.texture:SetTexture(texture)
	icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	icon.cooldown:SetAllPoints(icon.texture)
	icon.cooldown:SetDrawEdge(true)
	icon.cooldown:SetReverse(true)
	icon.endtime = GetTime() + duration
	icon.name = spellName
	icon:SetAlpha(Icicledb.alpha / 100)
	for k, v in ipairs(IcicleInterrupts) do
		if v == spellName then
			local iconBorder = icon:CreateTexture(nil, "OVERLAY")
			iconBorder:SetTexture("Interface\\AddOns\\Icicle\\Border.tga")
			iconBorder:SetVertexColor(1, 0.6, 0.1)
			iconBorder:SetAllPoints(icon)
		end
	end
	icon.cooldown:SetCooldown(GetTime(), duration)
	--CooldownFrame_SetTimer(icon.cooldown, GetTime(), duration, 1)
	if spellID == 14185 or spellID == 23989 or spellID == 11958 then --Preperation, Cold Snap, Readiness
		for k, v in ipairs(IcicleReset[spellID]) do			
			for i = 1, #db[Name] do
				if db[Name][i] then
					if db[Name][i].name == v then
						if db[Name][i]:IsVisible() then
							local f = db[Name][i].parent
							if f and f.icicle and f.icicle ~= 0 then
								f.icicle = 0
							end
						end
						db[Name][i]:Hide()
						db[Name][i]:SetParent(nil)
						db[Name][i].parent = nil
						tremove(db[Name], i)
						count = count - 1
					end
				end
			end
		end
	else
		for i = 1, #db[Name] do
			if db[Name][i] then
				if db[Name][i].name == spellName then
					if db[Name][i]:IsVisible() then
						local f = db[Name][i].parent
						if f and f.icicle then
							f.icicle = 0
						end
					end
					db[Name][i]:Hide()
					db[Name][i]:SetParent(nil)
					db[Name][i].parent = nil
					tremove(db[Name], i)
					count = count - 1
				end
			end
		end
	end
	tinsert(db[Name], icon)
end

--[[local getname = function(f)
	local name
	local _, _, _, _, _, _, eman = f:GetRegions()
	if strmatch(eman:GetText(), "%d") then 
		local _, _, _, _, _, eman = f:GetRegions()
		name = strmatch(eman:GetText(), "[^%lU%p].+%P")
	else
		name = strmatch(eman:GetText(), "[^%lU%p].+%P")
	end
	return name
end]]

local getname = function(f)
	local name
	local _, _, _, _, _, _, eman = f:GetRegions()

	if f and f.aloftData then
		name = f.aloftData.name
	elseif eman:GetText() then 
		name = eman:GetText()
	end

    if name and f.npc and not(db[name] or db[name.."+"]) and not isTotem(name) then
        if Icicledb.npcShorterName == 0 then
            eman:SetText("")
        else
            eman:SetText(strsub(name,1,Icicledb.npcShorterName))
        end
    end

	return name
end
		
local onpurge = 0
local uppurge = function(self, elapsed)
	onpurge = onpurge + elapsed
	-- if onpurge >= UPDATE_RATE then
		onpurge = 0
		if count == 0 then
			-- wipe(db)
		-- 	plateframe:SetScript("OnUpdate", nil)
		-- 	purgeframe:SetScript("OnUpdate", nil)
		end
		-- local naMe
		for k, v in pairs(db) do
			for i, c in ipairs(v) do
				if c.endtime < GetTime() then
					if c:IsVisible() then
						local f = c.parent
						if f and f.icicle then
							f.icicle = 0
						end
					end
					c:Hide()
					c:SetParent(nil)
					c.parent = nil
					tremove(db[k], i)
					count = count - 1
				end
			end
		end
	-- end
end

local isPlayerColor = function(r, g, b)
	local iR =  tonumber(string.format("%.2f", r))
	local iG =  tonumber(string.format("%.2f", g))
	local iB =  tonumber(string.format("%.2f", b))
	for k, v in pairs(RAID_CLASS_COLORS) do
		tR, tG, tB = v["r"], v["g"], v["b"]
		if tR == iR and tG == iG and tB == iB then
			return "enemy"
		end
	end
    if iR == 0 and iG == 0 and iB ==1 then
        return "friend"
    end
	return false
end

local isPetNameplate = function(nameplate)
	local healthbar = nameplate:GetChildren()
	local r,g,b = healthbar:GetStatusBarColor()
	if nameplate.pet == nil then
		nameplate.pet = r > .99 and g == 0 and b ==0
	end
    if nameplate.npc == nil and not isPlayerColor(r,g,b) then
        nameplate.npc = true
    end
	if not Icicledb.colorByClass and isPlayerColor(r,g,b) == "enemy" then
        nameplate.npc = false
		healthbar:SetStatusBarColor(1,0,0)
	end

	return nameplate.pet
end

local function isFrameNameplate(frame)
	local region = frame:GetRegions()
	return region and region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\TargetingFrame\\UI-TargetingFrame-Flash" 
end

local onplate = 0
local getplate = function(frame, elapsed)
	onplate = onplate + elapsed
	-- local curNumChildren = WorldFrame:GetNumChildren()
	-- if curNumChildren ~= numChildren then
	local num = WorldFrame:GetNumChildren()
	for i = 1,num do
		f = select(i, WorldFrame:GetChildren())
		if isFrameNameplate(f) then
			isPetNameplate(f)
			if f:IsVisible() then
				-- if onplate > UPDATE_RATE then
					
					local name = getname(f)
					if name and not f.pet then
						name = name.."+"
					end

					if db[name] ~= nil then
						if f.icicle ~= #db[name] then
							addicons(name, f)
							f.icicle = #db[name]
							for i = 1, #db[name] do
								if Icicledb.changeAlpha then
                                    db[name][i]:SetParent(f)
                                end
                            	if not Icicledb.cdShadow then
									db[name][i]:SetFrameLevel(1)
									db[name][i].cooldown:SetFrameLevel(0)--icon:GetFrameLevel()-1)
								end
                                db[name][i].parent = f
								db[name][i]:Show()
							end
						end
						f:SetScript("OnHide", function()
							hideicons(name, f)
						end)
					end
				-- end
			else
				f.pet = nil
                f.npc = nil
				f.icicle = nil
			end
			
		end
	end
	if onplate > UPDATE_RATE then
		onplate = 0
	end
end


local possibleTargets = {'target', 'arena1', 'arena2', 'arena3', 'focus', 'mouseover'}

local IcicleEvent = {}
function IcicleEvent.COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local _,currentZoneType = IsInInstance()
	local pvpType, _, _ = GetZonePVPInfo();
	local _, eventType, _, srcName, srcFlags, _, _, _, spellID, spellName = ...

	if not (Icicledb.all
			or (Icicledb.arena and currentZoneType == "arena")
			or (Icicledb.battleground and currentZoneType == "pvp")
			or (Icicledb.field and not pvpZone)
			) then
		return
	end

    local Name = ""

    --Spec detection
    -- if bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_NPC) == 0 then
    if bit.band(srcFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) ~= 0 and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
        Name = strmatch(srcName, "[%P]+")
        local isPet = bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) ~= 0
        if not isPet then
        	Name = Name.."+"
        end
        if not db[Name] then
            db[Name] = {}
            db[Name].pet = isPet
        end

        if not (db[Name].specCds and pvpZone) then
            if icicleSpecSpellList[spellID] then
                db[Name].specCds = icicleSpecSpecificCds[icicleSpecSpellList[spellID]]
                -- print(Name, icicleSpecSpellList[spellID])
            else
                for i = 1, #possibleTargets do
                    if select(1, UnitName(possibleTargets[i])) == Name then
                        for j = 1, 40 do
                            local buff = select(1,UnitBuff(possibleTargets[i],j))
                            if buff == nil then break end
                            if icicleSpecBuffList[buff] then
                                -- print(Name, icicleSpecBuffList[buff])
                                db[Name].specCds = icicleSpecSpecificCds[icicleSpecBuffList[buff]]
                                break
                            end
                        end
                        break
                    end
                end
            end
        end
    end

	if IcicleCds[spellID] and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
		if eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_MISSED" or eventType == "SPELL_SUMMON" then
			if not eventcheck[Name] then eventcheck[Name] = {} end
			if not eventcheck[Name][spellName] or GetTime() >= eventcheck[Name][spellName] + 1 then
				count = count + 1
				sourcetable(Name, spellID, spellName)
				eventcheck[Name][spellName] = GetTime()
			end
			-- if not plateframe:GetScript("OnUpdate") then
			-- 	plateframe:SetScript("OnUpdate", getplate)
			-- 	purgeframe:SetScript("OnUpdate", uppurge)
			-- end
		end
	end
end

function IcicleEvent.PLAYER_ENTERING_WORLD(event, ...)
	wipe(eventcheck)
	count = 0
	numChildren = 0

	for k, v in pairs(db) do
		for i, c in ipairs(v) do
			c:Hide()
		end
	end
	wipe(db)

    local pvpType, _, _ = GetZonePVPInfo();
    pvpZone = (currentZoneType == "arena" or currentZoneType == "pvp")
end

function IcicleEvent.VARIABLES_LOADED(event, ... )
	if not Icicledb.colorByClassInitialized and GetCVar("ShowClassColorInNameplate") == "0" then
		Icicledb.colorByClass = false
		SetCVar("ShowClassColorInNameplate", 1, "hi")
	end
end

local Icicle = CreateFrame("frame")
Icicle:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Icicle:RegisterEvent("PLAYER_ENTERING_WORLD")
Icicle:RegisterEvent("VARIABLES_LOADED")
Icicle:SetScript("OnEvent", function(frame, event, ...)
	IcicleEvent[event](IcicleEvent, ...)
end)

--/console ShowClassColorInNameplate 1
plateframe:SetScript("OnUpdate", getplate)
purgeframe:SetScript("OnUpdate", uppurge)