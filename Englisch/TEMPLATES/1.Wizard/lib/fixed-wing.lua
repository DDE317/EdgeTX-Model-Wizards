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
-- Update by: Wolfgang Dirks (2026) - Modellname + Modellbild in LVGL

local wizardType = ...

local RUN_DIR = "/TEMPLATES/1.Wizard/lib"
local IMG_DIR = "/TEMPLATES/1.Wizard/img"
local MODEL_IMG_DIR = "/IMAGES"

local RUDDER_NAME_AIL = (wizardType ~= "wing") and "Aileron" or "Elevron"
local WIZARD_TITLE = string.gsub(string.lower(wizardType), "^%l", string.upper) .. " Wizard"

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
	pages[page]()
end

-- =========================================================================
-- Tastatur-Layouts
-- =========================================================================
local KEYBOARD_UPPER = {
	{ "Q", "W", "E", "R", "T", "Z", "U", "I", "O", "P" },
	{ "A", "S", "D", "F", "G", "H", "J", "K", "L" },
	{ "Y", "X", "C", "V", "B", "N", "M", ",", ".", "-" },
}
local KEYBOARD_LOWER = {
	{ "q", "w", "e", "r", "t", "z", "u", "i", "o", "p" },
	{ "a", "s", "d", "f", "g", "h", "j", "k", "l" },
	{ "y", "x", "c", "v", "b", "n", "m", ",", ".", "-" },
}
local KEYBOARD_NUMBER = {
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" },
	{ "!", "@", "#", "$", "%", "^", "&", "*", "(", ")" },
	{ "+", "-", "_", "=", "?", "/", ".", ",", ":", ";" },
}

local ModelNameValue = ""
local NamePageKeyboardMode = 1

local function getKeyboardLayout()
	if NamePageKeyboardMode == 1 then
		return KEYBOARD_UPPER
	elseif NamePageKeyboardMode == 2 then
		return KEYBOARD_LOWER
	else
		return KEYBOARD_NUMBER
	end
end

-- =========================================================================
-- Modellname-Seite
-- =========================================================================
local function runModelNamePage()
	lvgl.clear()

	local layout = getKeyboardLayout()

	local row1Buttons = {}
	for _, key in ipairs(layout[1]) do
		row1Buttons[#row1Buttons + 1] = {
			type = "button",
			text = key,
			w = 26,
			h = 28,
			press = function()
				if #ModelNameValue < 20 then
					ModelNameValue = ModelNameValue .. key
				end
				runModelNamePage()
			end,
		}
	end

	local row2Buttons = {}
	for _, key in ipairs(layout[2]) do
		row2Buttons[#row2Buttons + 1] = {
			type = "button",
			text = key,
			w = 26,
			h = 28,
			press = function()
				if #ModelNameValue < 20 then
					ModelNameValue = ModelNameValue .. key
				end
				runModelNamePage()
			end,
		}
	end

	local row3Buttons = {}
	for _, key in ipairs(layout[3]) do
		row3Buttons[#row3Buttons + 1] = {
			type = "button",
			text = key,
			w = 26,
			h = 28,
			press = function()
				if #ModelNameValue < 20 then
					ModelNameValue = ModelNameValue .. key
				end
				runModelNamePage()
			end,
		}
	end

	local controlRow = {
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 3,
		children = {
			{
				type = "button",
				text = "a/A",
				w = 40,
				h = 28,
				press = function()
					if NamePageKeyboardMode == 2 then
						NamePageKeyboardMode = 1
					else
						NamePageKeyboardMode = 2
					end
					runModelNamePage()
				end,
			},
			{
				type = "button",
				text = "123",
				w = 40,
				h = 28,
				press = function()
					if NamePageKeyboardMode == 3 then
						NamePageKeyboardMode = 1
					else
						NamePageKeyboardMode = 3
					end
					runModelNamePage()
				end,
			},
			{
				type = "button",
				text = "SPACE",
				w = 90,
				h = 28,
				press = function()
					if #ModelNameValue < 20 then
						ModelNameValue = ModelNameValue .. " "
					end
					runModelNamePage()
				end,
			},
			{
				type = "button",
				text = "DEL",
				w = 40,
				h = 28,
				press = function()
					ModelNameValue = string.sub(ModelNameValue, 1, -2)
					runModelNamePage()
				end,
			},
			{
				type = "button",
				text = "OK",
				w = 50,
				h = 28,
				press = function()
					selectPage(1)
				end,
			},
		},
	}

	local nameDisplay = ModelNameValue
	if nameDisplay == "" then
		nameDisplay = "(empty)"
	end

	local children1 = {
		wizard.settings({
			title = "Model Name",
			children = {
				{
					type = "label",
					text = nameDisplay,
				},
			},
		}),
		{
			type = "rectangle",
			w = lvgl.PERCENT_SIZE + 100,
			h = 12,
			thickness = 0,
		},
		{
			type = "rectangle",
			flexFlow = lvgl.FLOW_ROW,
			flexPad = 3,
			children = row1Buttons,
		},
		{
			type = "rectangle",
			flexFlow = lvgl.FLOW_ROW,
			flexPad = 3,
			children = row2Buttons,
		},
		{
			type = "rectangle",
			flexFlow = lvgl.FLOW_ROW,
			flexPad = 3,
			children = row3Buttons,
		},
		controlRow,
	}

	local children2 = {
		wizard.image({
			file = IMG_DIR .. "/" .. wizardType .. "/plane.png",
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Model Name (max 20 chars)",
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
-- Modellbild-Seite (mit 3-Buchstaben-Filter)
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
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 3,
		children = {
			{ type = "button", text = "All", w = 50, h = 28, press = function() ImageFilter = "all"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "a-c", w = 45, h = 28, press = function() ImageFilter = "a-c"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "d-f", w = 45, h = 28, press = function() ImageFilter = "d-f"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "g-i", w = 45, h = 28, press = function() ImageFilter = "g-i"; rebuildFilteredList(); runModelImagePage() end },
		},
	}

	local filterRow2 = {
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 3,
		children = {
			{ type = "button", text = "j-l", w = 45, h = 28, press = function() ImageFilter = "j-l"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "m-o", w = 45, h = 28, press = function() ImageFilter = "m-o"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "p-r", w = 45, h = 28, press = function() ImageFilter = "p-r"; rebuildFilteredList(); runModelImagePage() end },
			{ type = "button", text = "s-u", w = 45, h = 28, press = function() ImageFilter = "s-u"; rebuildFilteredList(); runModelImagePage() end },
		},
	}

	local filterRow3 = {
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 3,
		children = {
			{ type = "button", text = "v-z", w = 60, h = 28, press = function() ImageFilter = "v-z"; rebuildFilteredList(); runModelImagePage() end },
		},
	}

	local currentName = getCurrentImageName()
	local infoText = "No images"
	if currentName ~= nil then
		infoText = "Image " .. ImageFilterIndex .. " / " .. #ImageFilteredList
	end

	local infoRow = wizard.settings({
		title = infoText,
		children = {
			{
				type = "label",
				text = (currentName ~= nil and currentName or "-"),
			},
		},
	})

	local navRow = {
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 6,
		children = {
			{
				type = "button",
				text = "<",
				w = 50,
				h = 32,
				press = function()
					if #ImageFilteredList > 0 then
						ImageFilterIndex = ImageFilterIndex - 1
						if ImageFilterIndex < 1 then ImageFilterIndex = #ImageFilteredList end
					end
					runModelImagePage()
				end,
			},
			{
				type = "button",
				text = "OK",
				w = 80,
				h = 32,
				press = function()
					selectPage(1)
				end,
			},
			{
				type = "button",
				text = ">",
				w = 50,
				h = 32,
				press = function()
					if #ImageFilteredList > 0 then
						ImageFilterIndex = ImageFilterIndex + 1
						if ImageFilterIndex > #ImageFilteredList then ImageFilterIndex = 1 end
					end
					runModelImagePage()
				end,
			},
		},
	}

	local children1 = {
		filterRow1,
		filterRow2,
		filterRow3,
		infoRow,
		navRow,
	}

	local children2 = {}
	if currentName ~= nil then
		children2[#children2 + 1] = wizard.image({
			file = MODEL_IMG_DIR .. "/" .. currentName,
		})
	end

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Model Image",
		hasPrevious = true,
		hasNext = true,
		nextFunc = function()
			selectPage(1)
		end,
		previousFunc = function()
			selectPage(-1)
		end,
		children1 = children1,
		children2 = children2,
	})

	lvgl.build(page)
end

-- =========================================================================
-- Motor
-- =========================================================================
local MotorFields = {
	is_motor = { id = "is_motor", value = 1, avail_values = { "No", "Yes" } },
	motor_ch = {
		id = "motor_ch",
		value = defaultChannel_0_THR,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
	is_arm = { id = "is_arm", value = 1, avail_values = { "No", "Yes" } },
	arm_switch = {
		id = "arm_switch",
		value = 5,
		avail_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG", "SH" },
	},
}

local function runMotorConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Have a motor?",
			children = {
				{
					type = "toggle",
					get = function() return MotorFields.is_motor.value end,
					set = function(val) MotorFields.is_motor.value = val end,
				},
			},
		}),
		wizard.settings({
			title = "Motor channel",
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
			title = "Safety Switch",
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
		subtitle = "Motor Settings",
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
local AilFields = {
	ail_type = { id = "ail_type", value = 2, avail_values = { "None", "One", "Two" } },
	ail_ch_a = {
		id = "ail_ch_a",
		value = defaultChannel_0_AIL,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
	ail_ch_b = {
		id = "ail_ch_b",
		value = defaultChannel_0_AIL + 1,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
}

local function runAilConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Number of " .. RUDDER_NAME_AIL,
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
			title = "A (right)",
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
			title = "B (left)",
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
		subtitle = RUDDER_NAME_AIL .. " Settings",
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
local FlapsFields = {
	flap_type = { id = "flap_type", value = 0, avail_values = { "No", "Yes (one)", "Yes (two)" } },
	flap_ch_a = {
		id = "flap_ch_a",
		value = 8 - 1,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
	flap_ch_b = {
		id = "flap_ch_b",
		value = 9 - 1,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
}

local function runFlapsConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Do you have flaps",
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
			title = "A (right)",
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
			title = "B (left)",
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
		subtitle = "Flaps Settings",
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
local TailFields = {
	tail_type = {
		id = "tail_type",
		value = 1,
		avail_values = {
			"1 CH for Elevator, no Rudder",
			"1 CH for Elevator, 1 for Rudder",
			"2 CH for Elevator, 1 for Rudder",
			"V Tail",
		},
	},
	ch_a = {
		id = "ch_a",
		value = defaultChannel_0_ELE,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
	ch_b = {
		id = "ch_b",
		value = defaultChannel_0_RUD,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
	ch_c = {
		id = "ch_c",
		value = 6 - 1,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
}

local function runTailConfig()
	lvgl.clear()

	local children1 = {
		wizard.settingsVertical({
			title = "Select your tail configuration",
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
			title = "Channel for A",
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
			title = "Channel for B",
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
			title = "Channel for C",
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
		subtitle = "Tail Settings",
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
local GearFields = {
	is_gear = { id = "is_gear", value = 0, avail_values = { "No", "Yes" } },
	switch = { id = "switch", value = 3, avail_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG", "SH" } },
	channel = {
		id = "channel",
		value = 7 - 1,
		avail_values = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8", "CH9", "CH10" },
	},
}

local function runGearConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Does your model have retract landing gears?",
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
			title = "Retracts switch",
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
			title = "Retracts channel",
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
		subtitle = "Landing Gear",
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
-- Zusätzliche Einstellungen
-- =========================================================================
local AdditionalSettingsFields = {
	expo = { id = "expo", value = 30, min = 0, max = 100 },
	is_dual_rate = { id = "is_dual_rate", value = 1, avail_values = { "No", "Yes" } },
	dr_switch = { id = "dr_switch", value = 2, avail_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG", "SH" } },
}

local function runAdditionalSettings()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Expo",
			children = {
				{
					type = "numberEdit",
					w = lvgl.PERCENT_SIZE + 100,
					min = AdditionalSettingsFields.expo.min,
					max = AdditionalSettingsFields.expo.max,
					get = function() return AdditionalSettingsFields.expo.value end,
					set = function(val) AdditionalSettingsFields.expo.value = val end,
				},
			},
		}),
		wizard.settings({
			title = "Dual Rate",
			children = {
				{
					type = "toggle",
					get = function() return AdditionalSettingsFields.is_dual_rate.value end,
					set = function(val) AdditionalSettingsFields.is_dual_rate.value = val end,
				},
				{
					type = "choice",
					values = AdditionalSettingsFields.dr_switch.avail_values,
					visible = function() return AdditionalSettingsFields.is_dual_rate.value == 1 end,
					get = function() return AdditionalSettingsFields.dr_switch.value + 1 end,
					set = function(val) AdditionalSettingsFields.dr_switch.value = val - 1 end,
				},
			},
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Additional Settings",
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

	local expoVal = AdditionalSettingsFields.expo.value
	local is_dual_rate = (AdditionalSettingsFields.is_dual_rate.value == 1)
	local dr_switch = AdditionalSettingsFields.dr_switch.avail_values[1 + AdditionalSettingsFields.dr_switch.value]
	if is_dual_rate then
		modelConfig.updateInputLine(defaultChannel_0_AIL, 0, expoVal, 100, dr_switch .. CHAR_UP)
		modelConfig.updateInputLine(defaultChannel_0_AIL, 1, expoVal, 75, dr_switch .. "-")
		modelConfig.updateInputLine(defaultChannel_0_AIL, 2, expoVal, 50, dr_switch .. CHAR_DOWN)

		modelConfig.updateInputLine(defaultChannel_0_ELE, 0, expoVal, 100, dr_switch .. CHAR_UP)
		modelConfig.updateInputLine(defaultChannel_0_ELE, 1, expoVal, 75, dr_switch .. "-")
		modelConfig.updateInputLine(defaultChannel_0_ELE, 2, expoVal, 50, dr_switch .. CHAR_DOWN)
	else
		modelConfig.updateInputLine(defaultChannel_0_AIL, 0, expoVal, 100, nil)
		modelConfig.updateInputLine(defaultChannel_0_ELE, 0, expoVal, 100, nil)
	end

	if wizardType ~= "wing" then
		modelConfig.updateInputLine(defaultChannel_0_RUD, 0, expoVal, 100, nil)
	end

	if MotorFields.is_motor.value == 1 then
		modelConfig.addMix(MotorFields.motor_ch.value, MIXSRC_FIRST_INPUT + defaultChannel_0_THR, "Motor")
	end

	if wizardType ~= "wing" then
		if AilFields.ail_type.value == 1 then
			modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel_0_AIL, "Ail")
		elseif AilFields.ail_type.value == 2 then
			modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel_0_AIL, "Ail-R")
			modelConfig.addMix(AilFields.ail_ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel_0_AIL, "Ail-L", -100)
		end
	else
		modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_ELE), "ele-R", 50)
		modelConfig.addMix(AilFields.ail_ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_AIL), "ail-R", -50)
		modelConfig.addMix(AilFields.ail_ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_ELE), "ele-L", 50)
		modelConfig.addMix(AilFields.ail_ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_AIL), "ail-L", 50)
	end

	if wizardType ~= "wing" then
		if FlapsFields.flap_type.value == 1 then
			modelConfig.addMix(FlapsFields.flap_ch_a.value, MIXSRC_SA, "Flaps")
		elseif FlapsFields.flap_type.value == 2 then
			modelConfig.addMix(FlapsFields.flap_ch_a.value, MIXSRC_SA, "FlapsR")
			modelConfig.addMix(FlapsFields.flap_ch_b.value, MIXSRC_SA, "FlapsL")
		end
	end

	if wizardType ~= "wing" then
		if TailFields.tail_type.value == 0 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), "Elev")
		elseif TailFields.tail_type.value == 1 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), "Elev")
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(0), "Rudder")
		elseif TailFields.tail_type.value == 2 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), "Elev-R")
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(0), "Rudder")
			modelConfig.addMix(TailFields.ch_c.value, MIXSRC_FIRST_INPUT + defaultChannel(1), "Elev-L")
		elseif TailFields.tail_type.value == 3 then
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(1), "V-EleR", 50)
			modelConfig.addMix(TailFields.ch_a.value, MIXSRC_FIRST_INPUT + defaultChannel(0), "V-RudR", 50, 1)
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(1), "V-EleL", 50)
			modelConfig.addMix(TailFields.ch_b.value, MIXSRC_FIRST_INPUT + defaultChannel(0), "V-RudL", -50, 1)
		end
	end

	if wizardType ~= "wing" then
		if GearFields.is_gear.value == 1 then
			local switchIndex = MIXSRC_SA + GearFields.switch.value
			modelConfig.addMix(GearFields.channel.value, switchIndex, "Gear", 100, 0)
		end
	end

	if MotorFields.is_arm.value == 1 then
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
		addRows(wizard.summaryLine("Model Name", nil, ModelNameValue))
	end

	if MotorFields.is_motor.value == 1 then
		addRows(wizard.summaryLine("Motor Channel", MotorFields.motor_ch.value))
	end

	if AilFields.ail_type.value == 1 then
		addRows(wizard.summaryLine(RUDDER_NAME_AIL .. " channel", AilFields.ail_ch_a.value))
	elseif AilFields.ail_type.value == 2 then
		addRows(
			wizard.summaryLine(RUDDER_NAME_AIL .. " Right channel", AilFields.ail_ch_a.value),
			wizard.summaryLine(RUDDER_NAME_AIL .. " Left channel", AilFields.ail_ch_b.value)
		)
	end

	if FlapsFields.flap_type.value == 1 then
		addRows(wizard.summaryLine("Flaps channel", FlapsFields.flap_ch_a.value))
	elseif FlapsFields.flap_type.value == 2 then
		addRows(
			wizard.summaryLine("Flaps Right channel", FlapsFields.flap_ch_a.value),
			wizard.summaryLine("Flaps Left channel", FlapsFields.flap_ch_b.value)
		)
	end

	if wizardType ~= "wing" then
		if TailFields.tail_type.value == 0 then
			addRows(wizard.summaryLine("Elevator channel", TailFields.ch_a.value))
		elseif TailFields.tail_type.value == 1 then
			addRows(
				wizard.summaryLine("Elevator channel", TailFields.ch_a.value),
				wizard.summaryLine("Rudder channel", TailFields.ch_b.value)
			)
		elseif TailFields.tail_type.value == 2 then
			addRows(
				wizard.summaryLine("Elevator Right channel", TailFields.ch_a.value),
				wizard.summaryLine("Rudder channel", TailFields.ch_b.value),
				wizard.summaryLine("Elevator Left channel", TailFields.ch_c.value)
			)
		elseif TailFields.tail_type.value == 3 then
			addRows(
				wizard.summaryLine("V-Tail Right", TailFields.ch_a.value),
				wizard.summaryLine("V-Tail Left", TailFields.ch_b.value)
			)
		end
	end

	if wizardType ~= "wing" then
		if GearFields.is_gear.value == 1 then
			local switchName = GearFields.switch.avail_values[1 + GearFields.switch.value]
			addRows(
				wizard.summaryLine("Gear Switch", nil, switchName),
				wizard.summaryLine("Gear Channel", GearFields.channel.value)
			)
		else
			addRows(wizard.summaryLine("Gear Switch", nil, "None"), wizard.summaryLine("Gear Channel", nil, "None"))
		end
	end

	addRows(wizard.summaryLine("Expo", nil, AdditionalSettingsFields.expo.value))

	addRows(
		wizard.summaryLine(
			"Dual Rate",
			nil,
			AdditionalSettingsFields.is_dual_rate.avail_values[1 + AdditionalSettingsFields.is_dual_rate.value]
				.. (
					AdditionalSettingsFields.is_dual_rate.value == 1
						and " (" .. AdditionalSettingsFields.dr_switch.avail_values[1 + AdditionalSettingsFields.dr_switch.value] .. ")"
					or ""
				)
		)
	)

	if MotorFields.is_arm.value == 1 then
		local switchName = MotorFields.arm_switch.avail_values[1 + MotorFields.arm_switch.value]
		addRows(wizard.summaryLine("Arm switch", nil, switchName))
	end

	lvgl.clear()

	local children2 = {
		{
			type = "label",
			w = lvgl.PERCENT_SIZE + 100,
			text = "Please review the configuration.",
		},
		{
			type = "label",
			w = lvgl.PERCENT_SIZE + 100,
			text = "After review press next to apply the configuration.",
		},
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Model Summary",
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
			runModelNamePage,
			runModelImagePage,
			runMotorConfig,
			runAilConfig,
			runFlapsConfig,
			runTailConfig,
			runGearConfig,
			runAdditionalSettings,
			runConfigSummary,
			runFinished,
		}
	else
		pages = {
			runModelNamePage,
			runModelImagePage,
			runMotorConfig,
			runAilConfig,
			runAdditionalSettings,
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