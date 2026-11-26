---- #########################################################################
---- #                                                                       #
---- # Copyright (C) OpenTX                                                  #
---- #                                                                       #
---- # License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html               #
---- #                                                                       #
---- # This program is free software; you can redistribute it and/or modify  #
---- # it under the terms of the GNU General Public License version 2 as     #
---- # published by the Free Software Foundation.                            #
---- #                                                                       #
---- # This program is distributed in the hope that it will be useful        #
---- # but WITHOUT ANY WARRANTY; without even the implied warranty of        #
---- # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
---- # GNU General Public License for more details.                          #
---- #                                                                       #
---- #########################################################################

-- Author: 3djc (2017)
-- Update by: Offer Shmuely (2023)
-- Update by: Alexander Gnauck (2025)
-- 
-- Update by: Wolfgang Dirks (2026):
--   - Added full German translation.
--   - Integrated multi-language support (language selection on startup, dynamic loading of language files).
--   - Changed model name input to native LVGL keyboard.
--   - Added model image selection with filter function (a-c, d-f, etc.).
--   - Added detailed Expo settings page for aileron, elevator, and rudder (without mandatory dual rate).
--   - Split structure into separate files (lang/de.lua, lang/en.lua).
--   - Fixed ALL hardcoded text strings to use translation variables (100% translated).
--   - Fixed dynamic re-initialization of dropdown tables to ensure correct language on every page load.
---- #########################################################################

local wizardType = ...

local RUN_DIR = "/TEMPLATES/1.Wizard/lib"
local IMG_DIR = "/TEMPLATES/1.Wizard/img"
local MODEL_IMG_DIR = "/IMAGES"
local LANG_DIR = RUN_DIR .. "/lang"

-- Standardmäßig Deutsch laden
local T = loadScript(LANG_DIR .. "/de.lua")()
local WIZARD_TITLE = T.title

local RUDDER_NAME_AIL = (wizardType ~= "wing") and T.title_ail_count or T.title_elevon_count
local modelConfig = loadScript(RUN_DIR .. "/model-config.lua")()
local wizard = loadScript(RUN_DIR .. "/wizard-ui.lua")()

local exitWizard = false

local page = 1
local pages = {}

-- =========================================================================
-- Konstanten + Hilfsfunktionen
-- =========================================================================
local STICK_NUMBER_AIL = 3
local STICK_NUMBER_ELE = 1
local STICK_NUMBER_THR = 2
local STICK_NUMBER_RUD = 0

local defaultChannel_0_AIL = defaultChannel(STICK_NUMBER_AIL)
local defaultChannel_0_ELE = defaultChannel(STICK_NUMBER_ELE)
local defaultChannel_0_THR = defaultChannel(STICK_NUMBER_THR)
local defaultChannel_0_RUD = defaultChannel(STICK_NUMBER_RUD)

local function getImagePath(filename)
	return IMG_DIR .. "/" .. wizardType .. "/" .. filename
end

local function selectPage(step)
	page = page + step
	if pages[page] then
		pages[page]()
	end
end

-- =========================================================================
-- Sprachauswahl-Seite (dynamisches Laden)
-- =========================================================================
local function runLanguageSelection()
    lvgl.clear()
    
    local children1 = {
        {
            type = "label",
            text = T.msg_select_language,
            w = lvgl.PERCENT_SIZE + 100,
        },
        {
            type = "rectangle",
            flexFlow = lvgl.FLOW_ROW,
            flexPad = 10,
            children = {
                {
                    type = "button",
                    text = "Deutsch",
                    w = 120,
                    h = 40,
                    press = function()
                        T = loadScript(LANG_DIR .. "/de.lua")()
                        WIZARD_TITLE = T.title
                        RUDDER_NAME_AIL = (wizardType ~= "wing") and T.title_ail_count or T.title_elevon_count
                        page = 1 
                        selectPage(1) 
                    end,
                },
                {
                    type = "button",
                    text = "English",
                    w = 120,
                    h = 40,
                    press = function()
                        T = loadScript(LANG_DIR .. "/en.lua")()
                        WIZARD_TITLE = T.title
                        RUDDER_NAME_AIL = (wizardType ~= "wing") and T.title_ail_count or T.title_elevon_count
                        page = 1 
                        selectPage(1) 
                    end,
                },
            }
        },
    }

    local page = wizard.page({
        title = T.title_language,
        subtitle = T.sub_language,
        hasPrevious = false,
        hasNext = false,
        children1 = children1,
        children2 = nil,
    })

    lvgl.build(page)
end

-- =========================================================================
-- Modellname-Seite
-- =========================================================================
local ModelNameValue = ""

local function runModelNamePage()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = T.subtitle_name,
			children = {
				{
					type = "textEdit",
					w = lvgl.PERCENT_SIZE + 100,
					h = 40,
					value = ModelNameValue,
					length = 20,
					set = function(text)
						ModelNameValue = text
					end,
				},
			},
		}),
		{
			type = "label",
			w = lvgl.PERCENT_SIZE + 100,
			text = T.msg_tap_to_type,
		},
	}

	local children2 = {
		wizard.image({
			file = IMG_DIR .. "/" .. wizardType .. "/plane.png",
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.subtitle_name,
		hasPrevious = false,
		hasNext = true,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Modellbild-Seite
-- =========================================================================
local ImageList = {}
local ImageIndex = 1
local ImageListLoaded = false

local ImageFilteredList = {}
local ImageFilterIndex = 1
local ImageFilter = "all"

local function loadImageList()
	ImageList = {}
	for file in dir(MODEL_IMG_DIR) do
		if file ~= nil then
			local ext = string.lower(string.sub(file, -4))
			if ext == ".png" or ext == ".jpg" then
				table.insert(ImageList, file)
			end
		end
	end
	ImageIndex = 1
	ImageListLoaded = true
end

local function matchFilter(filename, filter)
	if filter == "all" then
		return true
	end
	local firstChar = string.lower(string.sub(filename, 1, 1))
	if filter == "a-c" then
		return firstChar >= "a" and firstChar <= "c"
	elseif filter == "d-f" then
		return firstChar >= "d" and firstChar <= "f"
	elseif filter == "g-i" then
		return firstChar >= "g" and firstChar <= "i"
	elseif filter == "j-l" then
		return firstChar >= "j" and firstChar <= "l"
	elseif filter == "m-o" then
		return firstChar >= "m" and firstChar <= "o"
	elseif filter == "p-r" then
		return firstChar >= "p" and firstChar <= "r"
	elseif filter == "s-u" then
		return firstChar >= "s" and firstChar <= "u"
	elseif filter == "v-z" then
		return firstChar >= "v" and firstChar <= "z"
	end
	return true
end

local function rebuildFilteredList()
	ImageFilteredList = {}
	for _, name in ipairs(ImageList) do
		if matchFilter(name, ImageFilter) then
			table.insert(ImageFilteredList, name)
		end
	end
	ImageFilterIndex = 1
end

local function getCurrentImageName()
	if #ImageFilteredList > 0 and ImageFilteredList[ImageFilterIndex] then
		return ImageFilteredList[ImageFilterIndex]
	end
	return nil
end

local function runModelImagePage()
	lvgl.clear()

	if not ImageListLoaded then
		loadImageList()
		rebuildFilteredList()
	end

	local filterRow1 = {
		type = "rectangle", flexFlow = lvgl.FLOW_ROW, flexPad = 3,
		children = {
			{ type = "button", text = T.btn_all, w = 50, h = 28, press = function() ImageFilter = "all"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "a-c", w = 45, h = 28, press = function() ImageFilter = "a-c"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "d-f", w = 45, h = 28, press = function() ImageFilter = "d-f"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "g-i", w = 45, h = 28, press = function() ImageFilter = "g-i"; rebuildFilteredList(); runModelImagePage() end },
		},
	}

	local filterRow2 = {
		type = "rectangle", flexFlow = lvgl.FLOW_ROW, flexPad = 3,
		children = {
			{ type = "button", text = "j-l", w = 45, h = 28, press = function() ImageFilter = "j-l"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "m-o", w = 45, h = 28, press = function() ImageFilter = "m-o"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "p-r", w = 45, h = 28, press = function() ImageFilter = "p-r"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "s-u", w = 45, h = 28, press = function() ImageFilter = "s-u"; rebuildFilteredList(); runModelImagePage() end },
		},
	}

	local filterRow3 = {
		type = "rectangle", flexFlow = lvgl.FLOW_ROW, flexPad = 3,
		children = {
			{ type = "button", text = "v-z", w = 60, h = 28, press = function() ImageFilter = "v-z"; rebuildFilteredList(); runModelImagePage() end },
		},
	}

	local currentName = getCurrentImageName()
	local infoText = T.msg_no_images
	if currentName ~= nil then
		infoText = T.msg_image .. " " .. ImageFilterIndex .. " / " .. #ImageFilteredList
	end

	local infoRow = wizard.settings({
		title = infoText,
		children = { { type = "label", text = (currentName ~= nil and currentName or "-") } },
	})

	local navRow = {
		type = "rectangle", flexFlow = lvgl.FLOW_ROW, flexPad = 6,
		children = {
			{ type = "button", text = "<", w = 50, h = 32, press = function() if #ImageFilteredList > 0 then ImageFilterIndex = ImageFilterIndex - 1; if ImageFilterIndex < 1 then ImageFilterIndex = #ImageFilteredList end end; runModelImagePage() end },
			{ type = "button", text = "OK", w = 80, h = 32, press = function() selectPage(1) end },
			{ type = "button", text = ">", w = 50, h = 32, press = function() if #ImageFilteredList > 0 then ImageFilterIndex = ImageFilterIndex + 1; if ImageFilterIndex > #ImageFilteredList then ImageFilterIndex = 1 end end; runModelImagePage() end },
		},
	}

	local children1 = { filterRow1, filterRow2, filterRow3, infoRow, navRow }
	local children2 = {}
	if currentName ~= nil then
		children2[#children2 + 1] = wizard.image({ file = MODEL_IMG_DIR .. "/" .. currentName })
	end

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_image,
		hasPrevious = true, hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1, children2 = children2,
	})
	lvgl.build(page)
end

-- =========================================================================
-- Motor
-- =========================================================================
local MotorFields = {}

local function runMotorConfig()
	lvgl.clear()
	
	-- Tabelle bei jedem Aufruf neu befüllen, um die aktuelle Sprache zu nutzen
	MotorFields = {
		is_motor = { id = "is_motor", value = 1, avail_values = { T.opt_no, T.opt_yes } },
		motor_ch = {
			id = "motor_ch",
			value = defaultChannel_0_THR,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
		is_arm = { id = "is_arm", value = 1, avail_values = { T.opt_no, T.opt_yes } },
		arm_switch = {
			id = "arm_switch",
			value = 5,
			avail_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG", "SH" },
		},
	}

	local children1 = {
		wizard.settings({
			title = T.title_motor_exist,
			children = {
				{
					type = "toggle",
					get = function() return MotorFields.is_motor.value end,
					set = function(val) MotorFields.is_motor.value = val end,
				},
			},
		}),
		wizard.settings({
			title = T.title_motor_ch,
			children = {
				{
					type = "choice",
					values = MotorFields.motor_ch.avail_values,
					get = function() return MotorFields.motor_ch.value + 1 end,
					set = function(val) MotorFields.motor_ch.value = val - 1 end,
				},
			},
			visible = function() return MotorFields.is_motor.value end,
		}),
		wizard.settings({
			title = T.title_safety_sw,
			children = {
				{
					type = "toggle",
					get = function() return MotorFields.is_arm.value end,
					set = function(val) MotorFields.is_arm.value = val end,
				},
				{
					type = "choice",
					values = MotorFields.arm_switch.avail_values,
					visible = function() return MotorFields.is_arm.value == 1 end,
					get = function() return MotorFields.arm_switch.value + 1 end,
					set = function(val) MotorFields.arm_switch.value = val - 1 end,
				},
			},
			visible = function() return MotorFields.is_motor.value end,
		}),
	}

	local children2 = {
		wizard.image({ file = getImagePath("prop.png") }),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_motor,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Querruder
-- =========================================================================
local AilFields = {}

local function runAilConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	AilFields = {
		ail_type = { id = "ail_type", value = 2, avail_values = { T.opt_none, T.opt_one, T.opt_two } },
		ail_ch_a = {
			id = "ail_ch_a",
			value = defaultChannel_0_AIL,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
		ail_ch_b = {
			id = "ail_ch_b",
			value = defaultChannel_0_AIL + 1,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
	}

	local children1 = {
		wizard.settings({
			title = RUDDER_NAME_AIL,
			children = {
				{
					type = "choice",
					values = AilFields.ail_type.avail_values,
					get = function() return AilFields.ail_type.value + 1 end,
					set = function(val) AilFields.ail_type.value = val - 1 end,
				},
			},
			visible = function() return (wizardType ~= "wing") end,
		}),
		wizard.settings({
			title = T.title_ail_ch_a,
			children = {
				{
					type = "choice",
					values = AilFields.ail_ch_a.avail_values,
					get = function() return AilFields.ail_ch_a.value + 1 end,
					set = function(val) AilFields.ail_ch_a.value = val - 1 end,
				},
			},
			visible = function() return AilFields.ail_type.value > 0 end,
		}),
		wizard.settings({
			title = T.title_ail_ch_b,
			children = {
				{
					type = "choice",
					values = AilFields.ail_ch_b.avail_values,
					get = function() return AilFields.ail_ch_b.value + 1 end,
					set = function(val) AilFields.ail_ch_b.value = val - 1 end,
				},
			},
			visible = function() return AilFields.ail_type.value == 2 end,
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("plane-2a.png"),
			visibleFunc = function() return AilFields.ail_type.value == 2 end,
		}),
		wizard.image({
			file = getImagePath("plane-1a.png"),
			visibleFunc = function() return AilFields.ail_type.value == 1 end,
		}),
		wizard.image({
			file = getImagePath("plane.png"),
			visibleFunc = function() return AilFields.ail_type.value == 0 end,
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_ail,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Klappen
-- =========================================================================
local FlapsFields = {}

local function runFlapsConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	FlapsFields = {
		flap_type = { id = "flap_type", value = 0, avail_values = { T.opt_no, T.opt_yes_one, T.opt_yes_two } },
		flap_ch_a = {
			id = "flap_ch_a",
			value = 8 - 1,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
		flap_ch_b = {
			id = "flap_ch_b",
			value = 9 - 1,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
	}

	local children1 = {
		wizard.settings({
			title = T.title_flaps_exist,
			children = {
				{
					type = "choice",
					values = FlapsFields.flap_type.avail_values,
					get = function() return FlapsFields.flap_type.value + 1 end,
					set = function(val) FlapsFields.flap_type.value = val - 1 end,
				},
			},
		}),
		wizard.settings({
			title = T.title_flap_ch_a,
			children = {
				{
					type = "choice",
					values = FlapsFields.flap_ch_a.avail_values,
					get = function() return FlapsFields.flap_ch_a.value + 1 end,
					set = function(val) FlapsFields.flap_ch_a.value = val - 1 end,
				},
			},
			visible = function() return FlapsFields.flap_type.value > 0 end,
		}),
		wizard.settings({
			title = T.title_flap_ch_b,
			children = {
				{
					type = "choice",
					values = FlapsFields.flap_ch_b.avail_values,
					get = function() return FlapsFields.flap_ch_b.value + 1 end,
					set = function(val) FlapsFields.flap_ch_b.value = val - 1 end,
				},
			},
			visible = function() return FlapsFields.flap_type.value == 2 end,
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("plane-2f.png"),
			visibleFunc = function() return FlapsFields.flap_type.value == 2 end,
		}),
		wizard.image({
			file = getImagePath("plane-1f.png"),
			visibleFunc = function() return FlapsFields.flap_type.value == 1 end,
		}),
		wizard.image({
			file = getImagePath("plane.png"),
			visibleFunc = function() return FlapsFields.flap_type.value == 0 end,
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_flaps,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Heck
-- =========================================================================
local TailFields = {}

local function runTailConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	TailFields = {
		tail_type = {
			id = "tail_type",
			value = 1,
			avail_values = {
				T.opt_tail_1,
				T.opt_tail_2,
				T.opt_tail_3,
				T.opt_tail_4,
			},
		},
		ch_a = {
			id = "ch_a",
			value = defaultChannel_0_ELE,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
		ch_b = {
			id = "ch_b",
			value = defaultChannel_0_RUD,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
		ch_c = {
			id = "ch_c",
			value = 6 - 1,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
	}

	local children1 = {
		wizard.settingsVertical({
			title = T.title_tail_type,
			children = {
				{
					type = "choice",
					values = TailFields.tail_type.avail_values,
					get = function() return TailFields.tail_type.value + 1 end,
					set = function(val) TailFields.tail_type.value = val - 1 end,
				},
			},
		}),
		wizard.settings({
			title = T.title_ch_a,
			children = {
				{
					type = "choice",
					values = TailFields.ch_a.avail_values,
					get = function() return TailFields.ch_a.value + 1 end,
					set = function(val) TailFields.ch_a.value = val - 1 end,
				},
			},
		}),
		wizard.settings({
			title = T.title_ch_b,
			children = {
				{
					type = "choice",
					values = TailFields.ch_b.avail_values,
					get = function() return TailFields.ch_b.value + 1 end,
					set = function(val) TailFields.ch_b.value = val - 1 end,
				},
			},
			visible = function() return TailFields.tail_type.value > 0 end,
		}),
		wizard.settings({
			title = T.title_ch_c,
			children = {
				{
					type = "choice",
					values = TailFields.ch_c.avail_values,
					get = function() return TailFields.ch_c.value + 1 end,
					set = function(val) TailFields.ch_c.value = val - 1 end,
				},
			},
			visible = function() return TailFields.tail_type.value == 2 end,
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("tail-1.png"),
			visibleFunc = function() return TailFields.tail_type.value == 0 end,
		}),
		wizard.image({
			file = getImagePath("tail-2.png"),
			visibleFunc = function() return TailFields.tail_type.value == 1 end,
		}),
		wizard.image({
			file = getImagePath("tail-3.png"),
			visibleFunc = function() return TailFields.tail_type.value == 2 end,
		}),
		wizard.image({
			file = getImagePath("tail-4.png"),
			visibleFunc = function() return TailFields.tail_type.value == 3 end,
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_tail,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Fahrwerk
-- =========================================================================
local GearFields = {}

local function runGearConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	GearFields = {
		is_gear = { id = "is_gear", value = 0, avail_values = { T.opt_no, T.opt_yes } },
		switch = { id = "switch", value = 3, avail_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG", "SH" } },
		channel = {
			id = "channel",
			value = 7 - 1,
			avail_values = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8", "K9", "K10" },
		},
	}

	local children1 = {
		wizard.settings({
			title = T.title_gear_exist,
			children = {
				{
					type = "choice",
					values = GearFields.is_gear.avail_values,
					get = function() return GearFields.is_gear.value + 1 end,
					set = function(val) GearFields.is_gear.value = val - 1 end,
				},
			},
		}),
		wizard.settings({
			title = T.title_gear_switch,
			children = {
				{
					type = "choice",
					values = GearFields.switch.avail_values,
					get = function() return GearFields.switch.value + 1 end,
					set = function(val) GearFields.switch.value = val - 1 end,
				},
			},
			visible = function() return GearFields.is_gear.value > 0 end,
		}),
		wizard.settings({
			title = T.title_gear_ch,
			children = {
				{
					type = "choice",
					values = GearFields.channel.avail_values,
					get = function() return GearFields.channel.value + 1 end,
					set = function(val) GearFields.channel.value = val - 1 end,
				},
			},
			visible = function() return GearFields.is_gear.value > 0 end,
		}),
	}

	local children2 = {
		wizard.image({ file = getImagePath("plane.png") }),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_gear,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Zusätzliche Einstellungen (Nur Dual Rate)
-- =========================================================================
local AdditionalSettingsFields = {}

local function runAdditionalSettings()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	AdditionalSettingsFields = {
		is_dual_rate = { id = "is_dual_rate", value = 1, avail_values = { T.opt_no, T.opt_yes } },
		dr_switch = { id = "dr_switch", value = 2, avail_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG", "SH" } },
	}

	local toggleRow = wizard.settings({
		title = T.title_dual_rate,
		children = {
			{
				type = "toggle",
				get = function() return AdditionalSettingsFields.is_dual_rate.value end,
				set = function(val) 
					AdditionalSettingsFields.is_dual_rate.value = val 
					runAdditionalSettings()
				end,
			},
		},
	})

	local switchRow = nil
	if AdditionalSettingsFields.is_dual_rate.value == 1 then
		switchRow = wizard.settings({
			title = T.title_switch_select,
			children = {
				{
					type = "choice",
					values = AdditionalSettingsFields.dr_switch.avail_values,
					get = function() return AdditionalSettingsFields.dr_switch.value + 1 end,
					set = function(val) AdditionalSettingsFields.dr_switch.value = val - 1 end,
				},
			},
		})
	end

	local children1 = { toggleRow }
	if switchRow ~= nil then
		table.insert(children1, switchRow)
	end

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_additional,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = nil,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Detaillierte Expo Seite
-- =========================================================================
local ExpoSettings = {}

local function getSteeringChannels()
	local chans = {}
	if AilFields.ail_type and AilFields.ail_type.value > 0 then
		chans[#chans + 1] = { id = AilFields.ail_ch_a.value, name = T.ch_ail }
	end
	if TailFields.tail_type and TailFields.tail_type.value >= 0 then
		chans[#chans + 1] = { id = TailFields.ch_a.value, name = T.ch_ele }
	end
	if TailFields.tail_type and (TailFields.tail_type.value == 1 or TailFields.tail_type.value == 2) then
		chans[#chans + 1] = { id = TailFields.ch_b.value, name = T.ch_rud }
	elseif TailFields.tail_type and TailFields.tail_type.value == 3 then
		chans[#chans + 1] = { id = TailFields.ch_b.value, name = T.ch_rud_v }
	end

	return chans
end

local function initExpoSettings()
	ExpoSettings = {}
	local chans = getSteeringChannels()
	
	for i = 1, 3 do
		ExpoSettings[i] = {
			expo = { value = 30, min = 0, max = 100 },
			channelName = (chans[i] and chans[i].name) or "N/A",
			channelId = (chans[i] and chans[i].id) or nil
		}
	end
end

local function runExpoSettings()
	lvgl.clear()
	initExpoSettings() 

	local function makeRow(index)
		local field = ExpoSettings[index]
		if not field.channelId then
			return nil
		end

		return wizard.settingsVertical({
			title = T.title_setting .. index .. " - " .. field.channelName .. " (K" .. (field.channelId + 1) .. ")",
			children = {
				{
					type = "rectangle",
					flexFlow = lvgl.FLOW_ROW,
					flexPad = 5,
					children = {
						{ type = "label", text = T.label_expo },
						{
							type = "numberEdit",
							w = 80,
							min = field.expo.min,
							max = field.expo.max,
							get = function() return field.expo.value end,
							set = function(val) field.expo.value = val end,
						},
					}
				},
			},
		})
	end

	local children1 = {}
	for i = 1, 3 do
		local row = makeRow(i)
		if row then
			children1[#children1 + 1] = row
		end
	end

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_expo,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = children1,
		children2 = nil,
	})

	lvgl.build(page)
end

-- =========================================================================
-- createModel
-- =========================================================================
local function createModel()
	local info = {}
	if ModelNameValue ~= nil and ModelNameValue ~= "" then
		info.name = ModelNameValue
	end
	local chosenImage = getCurrentImageName()
	if chosenImage ~= nil then
		info.bitmap = chosenImage
	end
	if info.name or info.bitmap then
		model.setInfo(info)
	end

	model.defaultInputs()

	if wizardType == "wing" then
		model.deleteInput(defaultChannel(STICK_NUMBER_RUD), 0)
	end

	model.deleteMixes()

	-- 1. Dual Rate (Zusätzliche Einstellungen)
	local is_dual_rate = (AdditionalSettingsFields.is_dual_rate and AdditionalSettingsFields.is_dual_rate.value == 1)
	local dr_switch = AdditionalSettingsFields.dr_switch and AdditionalSettingsFields.dr_switch.avail_values[1 + AdditionalSettingsFields.dr_switch.value] or "SC"
	if is_dual_rate then
		modelConfig.updateInputLine(defaultChannel_0_AIL, 0, 0, 100, dr_switch .. CHAR_UP)
		modelConfig.updateInputLine(defaultChannel_0_AIL, 1, 0, 75, dr_switch .. "-")
		modelConfig.updateInputLine(defaultChannel_0_AIL, 2, 0, 50, dr_switch .. CHAR_DOWN)

		modelConfig.updateInputLine(defaultChannel_0_ELE, 0, 0, 100, dr_switch .. CHAR_UP)
		modelConfig.updateInputLine(defaultChannel_0_ELE, 1, 0, 75, dr_switch .. "-")
		modelConfig.updateInputLine(defaultChannel_0_ELE, 2, 0, 50, dr_switch .. CHAR_DOWN)
	else
		modelConfig.updateInputLine(defaultChannel_0_AIL, 0, 0, 100, nil)
		modelConfig.updateInputLine(defaultChannel_0_ELE, 0, 0, 100, nil)
	end

	if wizardType ~= "wing" then
		modelConfig.updateInputLine(defaultChannel_0_RUD, 0, 0, 100, nil)
	end

	-- 2. Detaillierte Expo-Seite
	initExpoSettings()
	for i = 1, 3 do
		local field = ExpoSettings[i]
		if field.channelId then
			local expo = field.expo.value
			modelConfig.updateInputLine(field.channelId, 0, expo, 100, nil)
		end
	end

	if MotorFields.is_motor and MotorFields.is_motor.value == 1 then
		modelConfig.addMix(MotorFields.motor_ch.value, MIXSRC_FIRST_INPUT + defaultChannel_0_THR, T.mix_name_thr)
	end

	if wizardType ~= "wing" then
		if AilFields.ail_type and AilFields.ail_type.value == 1 then
			modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel_0_AIL, T.mix_name_ail)
		elseif AilFields.ail_type and AilFields.ail_type.value == 2 then
			modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel_0_AIL, T.mix_name_ail_r)
			modelConfig.addMix(AilFields.ail_ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel_0_AIL, T.mix_name_ail_l, -100)
		end
	else
		modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_ELE), T.mix_name_ele_r, 50)
		modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_AIL), T.mix_name_ail_r, -50)
		modelConfig.addMix(AilFields.ail_ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_ELE), T.mix_name_ele_l, 50)
		modelConfig.addMix(AilFields.ail_ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_AIL), T.mix_name_ail_l, 50)
	end

	if wizardType ~= "wing" then
		if FlapsFields.flap_type and FlapsFields.flap_type.value == 1 then
			modelConfig.addMix(FlapsFields.flap_ch_a.value, MIXSRC_SA, T.mix_name_flap)
		elseif FlapsFields.flap_type and FlapsFields.flap_type.value == 2 then
			modelConfig.addMix(FlapsFields.flap_ch_a.value, MIXSRC_SA, T.mix_name_flap_r)
			modelConfig.addMix(FlapsFields.flap_ch_b.value, MIXSRC_SA, T.mix_name_flap_l)
		end
	end

	if wizardType ~= "wing" then
		if TailFields.tail_type and TailFields.tail_type.value == 0 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), T.mix_name_ele)
		elseif TailFields.tail_type and TailFields.tail_type.value == 1 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), T.mix_name_ele)
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(0), T.mix_name_rud)
		elseif TailFields.tail_type and TailFields.tail_type.value == 2 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), T.mix_name_ele_r)
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(0), T.mix_name_rud)
			modelConfig.addMix(TailFields.ch_c.value, MIXSRC_FIRST_INPUT + defaultChannel(1), T.mix_name_ele_l)
		elseif TailFields.tail_type and TailFields.tail_type.value == 3 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), T.mix_name_vtail_r, 50)
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(0), T.mix_name_vtail_r, 50, 1)
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(1), T.mix_name_vtail_l, 50)
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(0), T.mix_name_vtail_l, -50, 1)
		end
	end

	if wizardType ~= "wing" then
		if GearFields.is_gear and GearFields.is_gear.value == 1 then
			local switchIndex = MIXSRC_SA + GearFields.switch.value
			modelConfig.addMix(GearFields.channel.value, switchIndex, T.mix_name_gear, 100, 0)
		end
	end

	if MotorFields.is_arm and MotorFields.is_arm.value == 1 then
		local switchName = MotorFields.arm_switch.avail_values[1 + MotorFields.arm_switch.value]
		local switchIndex = getSwitchIndex(switchName .. CHAR_DOWN)
		local channelIndex = MotorFields.motor_ch.value

		model.setCustomFunction(FUNC_OVERRIDE_CHANNEL, {
			switch = switchIndex,
			func = 0,
			value = -100,
			mode = 0,
			param = channelIndex,
			active = 1,
		})
	end
end

-- =========================================================================
-- Zusammenfassung
-- =========================================================================
local function runConfigSummary()
	local rows = {}

	local function addRows(...)
		for i, v in ipairs({ ... }) do
			rows[#rows + 1] = v
		end
	end

	if ModelNameValue ~= nil and ModelNameValue ~= "" then
		addRows(wizard.summaryLine(T.title_model_name_sum, nil, ModelNameValue))
	end

	if MotorFields.is_motor and MotorFields.is_motor.value == 1 then
		addRows(wizard.summaryLine(T.title_motor_ch_sum, MotorFields.motor_ch.value))
	end

	if AilFields.ail_type and AilFields.ail_type.value == 1 then
		addRows(wizard.summaryLine(RUDDER_NAME_AIL .. " " .. T.title_ch_sum, AilFields.ail_ch_a.value))
	elseif AilFields.ail_type and AilFields.ail_type.value == 2 then
		addRows(
			wizard.summaryLine(RUDDER_NAME_AIL .. " " .. T.title_ch_a_sum, AilFields.ail_ch_a.value),
			wizard.summaryLine(RUDDER_NAME_AIL .. " " .. T.title_ch_b_sum, AilFields.ail_ch_b.value)
		)
	end

	if FlapsFields.flap_type and FlapsFields.flap_type.value == 1 then
		addRows(wizard.summaryLine(T.title_flap_ch_sum, FlapsFields.flap_ch_a.value))
	elseif FlapsFields.flap_type and FlapsFields.flap_type.value == 2 then
		addRows(
			wizard.summaryLine(T.title_flap_a_sum, FlapsFields.flap_ch_a.value),
			wizard.summaryLine(T.title_flap_b_sum, FlapsFields.flap_ch_b.value)
		)
	end

	if wizardType ~= "wing" then
		if TailFields.tail_type and TailFields.tail_type.value == 0 then
			addRows(wizard.summaryLine(T.title_ele_ch_sum, TailFields.ch_a.value))
		elseif TailFields.tail_type and TailFields.tail_type.value == 1 then
			addRows(
				wizard.summaryLine(T.title_ele_ch_sum, TailFields.ch_a.value),
				wizard.summaryLine(T.title_rud_ch_sum, TailFields.ch_b.value)
			)
		elseif TailFields.tail_type and TailFields.tail_type.value == 2 then
			addRows(
				wizard.summaryLine(T.title_ele_r_sum, TailFields.ch_a.value),
				wizard.summaryLine(T.title_rud_ch_sum, TailFields.ch_b.value),
				wizard.summaryLine(T.title_ele_l_sum, TailFields.ch_c.value)
			)
		elseif TailFields.tail_type and TailFields.tail_type.value == 3 then
			addRows(
				wizard.summaryLine(T.title_vtail_r_sum, TailFields.ch_a.value),
				wizard.summaryLine(T.title_vtail_l_sum, TailFields.ch_b.value)
			)
		end
	end

	if wizardType ~= "wing" then
		if GearFields.is_gear and GearFields.is_gear.value == 1 then
			local switchName = GearFields.switch.avail_values[1 + GearFields.switch.value]
			addRows(
				wizard.summaryLine(T.title_gear_sw_sum, nil, switchName),
				wizard.summaryLine(T.title_gear_ch_sum, GearFields.channel.value)
			)
		else
			addRows(wizard.summaryLine(T.title_gear_sw_sum, nil, T.opt_none), wizard.summaryLine(T.title_gear_ch_sum, nil, T.opt_none))
		end
	end

	if AdditionalSettingsFields.is_dual_rate then
		addRows(
			wizard.summaryLine(
				T.title_base_dr,
				nil,
				AdditionalSettingsFields.is_dual_rate.avail_values[1 + AdditionalSettingsFields.is_dual_rate.value]
					.. (
						AdditionalSettingsFields.is_dual_rate.value == 1
							and " (" .. AdditionalSettingsFields.dr_switch.avail_values[1 + AdditionalSettingsFields.dr_switch.value] .. ")"
						or ""
					)
			)
		)
	end

	local chans = getSteeringChannels()
	for i = 1, 3 do
		if chans[i] then
			local field = ExpoSettings[i]
			if field then
				addRows(wizard.summaryLine(T.label_expo .. " " .. chans[i].name, nil, field.expo.value .. "%"))
			end
		end
	end

	if MotorFields.is_arm and MotorFields.is_arm.value == 1 then
		local switchName = MotorFields.arm_switch.avail_values[1 + MotorFields.arm_switch.value]
		addRows(wizard.summaryLine(T.title_safety_sw, nil, switchName))
	end

	lvgl.clear()

	local children2 = {
		{ type = "label", w = lvgl.PERCENT_SIZE + 100, text = T.msg_check_config },
		{ type = "label", w = lvgl.PERCENT_SIZE + 100, text = T.msg_press_next },
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_summary,
		hasPrevious = true,
		hasNext = true,
		nextFunc = function() selectPage(1) end,
		previousFunc = function() selectPage(-1) end,
		children1 = rows,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Finished
-- =========================================================================
local function runFinished()
	createModel()

	lvgl.clear()

	local endPage = wizard.finishedPage({ title = WIZARD_TITLE })

	lvgl.build(endPage)
end

-- =========================================================================
-- Init
-- =========================================================================
local function init()
	if wizardType ~= "wing" then
		pages = {
			runLanguageSelection,
			runModelNamePage,
			runModelImagePage,
			runMotorConfig,
			runAilConfig,
			runFlapsConfig,
			runTailConfig,
			runGearConfig,
			runAdditionalSettings,
			runExpoSettings,
			runConfigSummary,
			runFinished,
		}
	else
		pages = {
			runLanguageSelection,
			runModelNamePage,
			runModelImagePage,
			runMotorConfig,
			runAilConfig,
			runAdditionalSettings,
			runExpoSettings,
			runConfigSummary,
			runFinished,
		}
	end

	pages[page]()
end

-- =========================================================================
-- Main run
-- =========================================================================
local function run(event, touchState)
	if event == EVT_VIRTUAL_PREV_PAGE and page > 1 and page < #pages then
		killEvents(event)
		selectPage(-1)
	elseif event == EVT_VIRTUAL_NEXT_PAGE and page < #pages then
		killEvents(event)
		selectPage(1)
	end

	if wizard.exitWizard() == true then
		return 2
	end

	return 0
end

return {
	run = run,
	init = init,
}

-- === ENDE DER DATEI ===