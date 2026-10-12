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
-- Update by: Wolfgang Dirks (2026) - Model name + model image + English texts
-- Update: optimized model name input (no page rebuild on keypress)

local RUN_DIR = "/TEMPLATES/1.Wizard/lib"
local IMG_DIR = "/TEMPLATES/1.Wizard/img"
local MODEL_IMG_DIR = "/IMAGES"

local wizard = loadScript(RUN_DIR .. "/wizard-ui.lua")()

local WIZARD_TITLE = "Helicopter Wizard"

local page = 1
local pages = {}
local channels = { "CH1", "CH2", "CH3", "CH4", "CH5", "CH6", "CH7", "CH8" }

-- =========================================================================
-- Constants + Helpers
-- =========================================================================
local function getImagePath(filename)
	return IMG_DIR .. "/helicopter/" .. filename
end

local function selectPage(step)
	page = page + step
	pages[page]()
end

-- =========================================================================
-- Keyboard layouts
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
-- Model Name page (optimized: no page rebuild on keypress)
-- =========================================================================
local modelNameLabel = nil

local function buildKeyboardRow(rowKeys, onKey)
	local rowChildren = {}
	for _, key in ipairs(rowKeys) do
		rowChildren[#rowChildren + 1] = {
			type = "button",
			text = key,
			w = 26,
			h = 28,
			press = function()
				onKey(key)
			end,
		}
	end
	return {
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 3,
		children = rowChildren,
	}
end

local function refreshModelNameLabel()
	if modelNameLabel ~= nil then
		local display = ModelNameValue
		if display == "" then
			display = "(empty)"
		end
		modelNameLabel:set({ text = display })
	end
end

local function runModelNamePage()
	lvgl.clear()

	local layout = getKeyboardLayout()

	local function onKey(key)
		if #ModelNameValue < 20 then
			ModelNameValue = ModelNameValue .. key
			refreshModelNameLabel()
		end
	end

	local function onSpace()
		if #ModelNameValue < 20 then
			ModelNameValue = ModelNameValue .. " "
			refreshModelNameLabel()
		end
	end

	local function onDelete()
		ModelNameValue = string.sub(ModelNameValue, 1, -2)
		refreshModelNameLabel()
	end

	local function onModeToggle()
		if NamePageKeyboardMode == 2 then
			NamePageKeyboardMode = 1
		else
			NamePageKeyboardMode = 2
		end
		modelNameLabel = nil
		runModelNamePage()
	end

	local function onModeNumbers()
		if NamePageKeyboardMode == 3 then
			NamePageKeyboardMode = 1
		else
			NamePageKeyboardMode = 3
		end
		modelNameLabel = nil
		runModelNamePage()
	end

	local controlRow = {
		type = "rectangle",
		flexFlow = lvgl.FLOW_ROW,
		flexPad = 3,
		children = {
			{ type = "button", text = "a/A", w = 40, h = 28, press = onModeToggle },
			{ type = "button", text = "123", w = 40, h = 28, press = onModeNumbers },
			{ type = "button", text = "SPACE", w = 90, h = 28, press = onSpace },
			{ type = "button", text = "DEL", w = 50, h = 28, press = onDelete },
			{ type = "button", text = "OK", w = 50, h = 28, press = function() selectPage(1) end },
		},
	}

	local display = ModelNameValue
	if display == "" then
		display = "(empty)"
	end

	local children1 = {
		wizard.settings({
			title = "Model Name",
			children = {
				{
					type = "label",
					text = display,
					name = "modelNameLabel",
				},
			},
		}),
		{
			type = "rectangle",
			w = lvgl.PERCENT_SIZE + 100,
			h = 12,
			thickness = 0,
		},
		buildKeyboardRow(layout[1], onKey),
		buildKeyboardRow(layout[2], onKey),
		buildKeyboardRow(layout[3], onKey),
		controlRow,
	}

	local children2 = {
		wizard.image({
			file = getImagePath("throttle.png"),
		}),
	}

	local pageDef = wizard.page({
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

	local built = lvgl.build(pageDef)
	if built ~= nil then
		modelNameLabel = built["modelNameLabel"]
	end
end

-- =========================================================================
-- Model Image page (with 3-letter filter)
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
		subtitle = "Select Model Image",
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
-- Helicopter Type
-- =========================================================================
local TypeFields = {
	heli_type = { value = 0, available_values = { "FBL", "FB" } },
	swash_type = { value = 0, available_values = { "120", "120X", "140", "90" } },
}

local function runTypeConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "What type of helicopter?",
			children = {
				{
					type = "choice",
					values = TypeFields.heli_type.available_values,
					get = function()
						return TypeFields.heli_type.value + 1
					end,
					set = function(val)
						TypeFields.heli_type.value = val - 1
					end,
				},
			},
		}),

		wizard.settings({
			title = "Swashplate type",
			children = {
				{
					type = "choice",
					values = TypeFields.swash_type.available_values,
					get = function()
						return TypeFields.swash_type.value + 1
					end,
					set = function(val)
						TypeFields.swash_type.value = val - 1
					end,
				},
			},
			visible = function()
				return TypeFields.heli_type.value == 1
			end,
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("type.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Helicopter Type",
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
-- Flying Style
-- =========================================================================
local StyleFields = { value = 0, available_values = { "Sport", "Light 3D", "Full 3D" } }

local function runStyleConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "What is your flying style?",
			children = {
				{
					type = "choice",
					values = StyleFields.available_values,
					get = function()
						return StyleFields.value + 1
					end,
					set = function(val)
						StyleFields.value = val - 1
					end,
				},
			},
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("style.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Flying Style",
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
-- Switches
-- =========================================================================
local SwitchFields = {
	FlightMode = { value = 1, available_values = { "SA", "SB", "SC", "SD", "SE", "SF" } },
	ThrottleHold = { value = 5, available_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG" } },
	TailGain = { value = 0, available_values = { "SA", "SB", "SC", "SD", "SE", "SF", "SG" } },
}

local function runSwitchConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "FM (Idle Up)",
			children = {
				{
					type = "choice",
					values = SwitchFields.FlightMode.available_values,
					get = function()
						return SwitchFields.FlightMode.value + 1
					end,
					set = function(val)
						SwitchFields.FlightMode.value = val - 1
					end,
				},
			},
		}),

		wizard.settings({
			title = "Throttle Hold",
			children = {
				{
					type = "choice",
					values = SwitchFields.ThrottleHold.available_values,
					get = function()
						return SwitchFields.ThrottleHold.value + 1
					end,
					set = function(val)
						SwitchFields.ThrottleHold.value = val - 1
					end,
				},
			},
		}),

		wizard.settings({
			title = "Tail Gain",
			children = {
				{
					type = "choice",
					values = SwitchFields.TailGain.available_values,
					get = function()
						return SwitchFields.TailGain.value + 1
					end,
					set = function(val)
						SwitchFields.TailGain.value = val - 1
					end,
				},
			},
			visible = function()
				return TypeFields.heli_type.value == 1
			end,
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("switch.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Switch Configuration",
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
-- Throttle Channel
-- =========================================================================
local ThrFields = { value = 2, available_values = channels }

local function runThrConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Throttle Channel",
			children = {
				{
					type = "choice",
					values = ThrFields.available_values,
					get = function()
						return ThrFields.value + 1
					end,
					set = function(val)
						ThrFields.value = val - 1
					end,
				},
			},
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("throttle.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Throttle Config",
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
-- Throttle Curves
-- =========================================================================
local CurveFields = {
	FlightMode0 = { value = 0, available_values = { "Thr Up", "V Curve", "Flat" } },
	FlightMode1 = { value = 0, available_values = { "V Curve", "Flat" } },
	FlightMode2 = { value = 1, available_values = { "V Curve", "Flat" } },
}

local function runCurveConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Throttle Curve FM0",
			children = {
				{
					type = "choice",
					values = CurveFields.FlightMode0.available_values,
					get = function()
						return CurveFields.FlightMode0.value + 1
					end,
					set = function(val)
						CurveFields.FlightMode0.value = val - 1
					end,
				},
			},
		}),

		wizard.settings({
			title = "Throttle Curve FM1",
			children = {
				{
					type = "choice",
					values = CurveFields.FlightMode1.available_values,
					get = function()
						return CurveFields.FlightMode1.value + 1
					end,
					set = function(val)
						CurveFields.FlightMode1.value = val - 1
					end,
				},
			},
		}),

		wizard.settings({
			title = "Throttle Curve FM2",
			children = {
				{
					type = "choice",
					values = CurveFields.FlightMode2.available_values,
					get = function()
						return CurveFields.FlightMode2.value + 1
					end,
					set = function(val)
						CurveFields.FlightMode2.value = val - 1
					end,
				},
			},
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("curve.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Throttle Curves",
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
-- Roll Channel
-- =========================================================================
local AilerFields = { value = 0, available_values = channels }

local function runAilerConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Roll Channel",
			children = {
				{
					type = "choice",
					values = AilerFields.available_values,
					get = function()
						return AilerFields.value + 1
					end,
					set = function(val)
						AilerFields.value = val - 1
					end,
				},
			},
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("roll.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Roll Config",
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
-- Nick Channel
-- =========================================================================
local EleFields = { value = 1, available_values = channels }

local function runEleConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Nick Channel",
			children = {
				{
					type = "choice",
					values = EleFields.available_values,
					get = function()
						return EleFields.value + 1
					end,
					set = function(val)
						EleFields.value = val - 1
					end,
				},
			},
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("nick.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Nick Config",
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
-- Tail Channel
-- =========================================================================
local RudFields = { value = 3, available_values = channels }

local function runRudConfig()
	lvgl.clear()

	local children1 = {
		wizard.settings({
			title = "Tail Channel",
			children = {
				{
					type = "choice",
					values = RudFields.available_values,
					get = function()
						return RudFields.value + 1
					end,
					set = function(val)
						RudFields.value = val - 1
					end,
				},
			},
		}),
	}

	local children2 = {
		wizard.image({
			file = getImagePath("tail.png"),
		}),
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = "Tail Config",
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
-- createModel
-- =========================================================================
local function createModel()
	local switchValues = { [0] = 2, 5, 8, 11, 14, 17, 19 }

	local tUp = switchValues[SwitchFields.FlightMode.value]
	local hold = switchValues[SwitchFields.ThrottleHold.value]
	local gyRate = switchValues[SwitchFields.TailGain.value]

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
	model.deleteMixes()

	-- Curve FM0
	if StyleFields.value == 0 and CurveFields.FlightMode0.value == 0 then
		model.setCurve(0, { name = "TC0", y = { -100, 0, 20, 40, 40 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode0.value == 0 then
		model.setCurve(0, { name = "TC0", y = { -100, 0, 35, 50, 50 } })
	elseif StyleFields.value == 2 and CurveFields.FlightMode0.value == 0 then
		model.setCurve(0, { name = "TC0", y = { -100, 0, 40, 80, 80 } })
	elseif StyleFields.value == 0 and CurveFields.FlightMode0.value == 1 then
		model.setCurve(0, { name = "TC0", y = { 50, 40, 50 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode0.value == 1 then
		model.setCurve(0, { name = "TC0", y = { 65, 55, 65 } })
	elseif StyleFields.value == 2 and CurveFields.FlightMode0.value == 1 then
		model.setCurve(0, { name = "TC0", y = { 70, 60, 70 } })
	elseif StyleFields.value == 0 and CurveFields.FlightMode0.value == 2 then
		model.setCurve(0, { name = "TC0", y = { 60, 60, 60 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode0.value == 2 then
		model.setCurve(0, { name = "TC0", y = { 65, 65, 65 } })
	else
		model.setCurve(0, { name = "TC0", y = { 70, 70, 70 } })
	end

	-- Curve FM1
	if StyleFields.value == 0 and CurveFields.FlightMode1.value == 0 then
		model.setCurve(1, { name = "TC1", y = { 60, 50, 60 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode1.value == 0 then
		model.setCurve(1, { name = "TC1", y = { 70, 60, 70 } })
	elseif StyleFields.value == 2 and CurveFields.FlightMode1.value == 0 then
		model.setCurve(1, { name = "TC1", y = { 85, 75, 85 } })
	elseif StyleFields.value == 0 and CurveFields.FlightMode1.value == 1 then
		model.setCurve(1, { name = "TC1", y = { 65, 65, 65 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode1.value == 1 then
		model.setCurve(1, { name = "TC1", y = { 70, 70, 70 } })
	else
		model.setCurve(1, { name = "TC1", y = { 85, 85, 85 } })
	end

	-- Curve FM2
	if StyleFields.value >= 0 and CurveFields.FlightMode2.value == 0 then
		model.setCurve(2, { name = "TC2", y = { 70, 60, 70 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode2.value == 0 then
		model.setCurve(2, { name = "TC2", y = { 85, 70, 85 } })
	elseif StyleFields.value == 2 and CurveFields.FlightMode2.value == 0 then
		model.setCurve(2, { name = "TC2", y = { 100, 90, 100 } })
	elseif StyleFields.value == 0 and CurveFields.FlightMode2.value == 1 then
		model.setCurve(2, { name = "TC2", y = { 75, 75, 75 } })
	elseif StyleFields.value == 1 and CurveFields.FlightMode2.value == 1 then
		model.setCurve(2, { name = "TC2", y = { 85, 85, 85 } })
	else
		model.setCurve(2, { name = "TC2", y = { 95, 95, 95 } })
	end

	-- Throttle Hold curve
	model.setCurve(3, { name = "THD", y = { -100, -100, -100 } })

	-- Throttle
	model.insertMix(ThrFields.value, 0, { name = "Th0", weight = 100, curveType = 3, curveValue = 1 })
	model.insertMix(
		ThrFields.value,
		1,
		{ name = "Th1", weight = 100, switch = tUp, multiplex = 2, curveType = 3, curveValue = 2 }
	)
	model.insertMix(
		ThrFields.value,
		2,
		{ name = "Th2", weight = 100, switch = tUp - 1, multiplex = 2, curveType = 3, curveValue = 3 }
	)
	model.insertMix(
		ThrFields.value,
		3,
		{ name = "Hld", weight = 100, offset = -15, switch = hold + 1, multiplex = 2, curveType = 3, curveValue = 4 }
	)
	model.setOutput(ThrFields.value, { name = "Throt" })

	-- Roll
	if TypeFields.heli_type.value == 0 then
		model.insertMix(AilerFields.value, 0, { name = "Roll", weight = 100 })
		model.setOutput(AilerFields.value, { name = "Roll" })
	else
		local col2 = getFieldInfo("cyc2").id
		model.insertMix(AilerFields.value, 0, { source = col2, name = "Roll", weight = 100 })
		model.setOutput(AilerFields.value, { name = "Roll" })
	end

	-- Nick
	if TypeFields.heli_type.value == 0 then
		model.insertMix(EleFields.value, 0, { name = "Nick", weight = 100 })
		model.setOutput(EleFields.value, { name = "Nick" })
	else
		local col1 = getFieldInfo("cyc1").id
		model.insertMix(EleFields.value, 0, { source = col1, name = "Nick", weight = 100 })
		model.setOutput(EleFields.value, { name = "Nick" })
	end

	-- Tail
	model.insertMix(RudFields.value, 0, { name = "Tail", weight = 100 })
	model.setOutput(RudFields.value, { name = "Tail" })

	-- Gyro
	if TypeFields.heli_type.value == 0 then
		model.insertMix(4, 0, { source = 110, name = "T.Gain", weight = 25 })
			model.setOutput(4, { name = "T.Gain" })
	else
		model.insertMix(4, 0, { source = 110, name = "HHold", weight = 25 })
		model.insertMix(4, 1, { source = 110, name = "Rate", weight = -25, switch = gyRate + 1, multiplex = 2 })
		model.setOutput(4, { name = "T.Gain" })
	end

	-- Pitch
	if TypeFields.heli_type.value == 0 then
		model.insertMix(5, 0, { source = 89, name = "Pitch", weight = 100 })
		model.setOutput(5, { name = "Pitch" })
	else
		local col3 = getFieldInfo("cyc3").id
		model.insertMix(5, 0, { source = col3, name = "Pitch", weight = 100 })
		model.setOutput(5, { name = "Pitch" })
	end

	-- Swashplate
	if TypeFields.heli_type.value == 1 and TypeFields.swash_type.value == 0 then
		model.setSwashRing({
			type = 1,
			collectiveSource = 89,
			aileronSource = 90,
			elevatorSource = 88,
			collectiveWeight = 60,
			aileronWeight = 60,
			elevatorWeight = 60,
		})
	elseif TypeFields.swash_type.value == 1 then
		model.setSwashRing({
			type = 2,
			collectiveSource = 89,
			aileronSource = 90,
			elevatorSource = 88,
			collectiveWeight = 60,
			aileronWeight = 60,
			elevatorWeight = 60,
		})
	elseif TypeFields.swash_type.value == 2 then
		model.setSwashRing({
			type = 3,
			collectiveSource = 89,
			aileronSource = 90,
			elevatorSource = 88,
			collectiveWeight = 40,
			aileronWeight = 40,
			elevatorWeight = 60,
		})
	elseif TypeFields.swash_type.value == 3 then
		model.setSwashRing({
			type = 4,
			collectiveSource = 89,
			aileronSource = 90,
			elevatorSource = 88,
			collectiveWeight = 35,
			aileronWeight = 35,
			elevatorWeight = 60,
		})
	end
end

-- =========================================================================
-- Summary
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

	addRows(wizard.summaryLine("Type", nil, TypeFields.heli_type.available_values[TypeFields.heli_type.value + 1]))

	if TypeFields.heli_type.value == 1 then
		addRows(
			wizard.summaryLine(
				"Swash Type",
				nil,
				TypeFields.swash_type.available_values[TypeFields.swash_type.value + 1]
			)
		)
	end

	addRows(wizard.summaryLine("Flying Style", nil, StyleFields.available_values[StyleFields.value + 1]))

	addRows(
		wizard.summaryLine(
			"FM Switch",
			nil,
			SwitchFields.FlightMode.available_values[SwitchFields.FlightMode.value + 1]
		)
	)
	addRows(
		wizard.summaryLine(
			"Throttle Hold Switch",
			nil,
			SwitchFields.ThrottleHold.available_values[SwitchFields.ThrottleHold.value + 1]
		)
	)
	if TypeFields.heli_type.value == 1 then
		addRows(
			wizard.summaryLine(
				"Tail Gain Switch",
				nil,
				SwitchFields.TailGain.available_values[SwitchFields.TailGain.value + 1]
			)
		)
	end

	addRows(wizard.summaryLine("Throttle Channel", ThrFields.value))

	addRows(
		wizard.summaryLine(
			"FM0 Curve",
			nil,
			CurveFields.FlightMode0.available_values[CurveFields.FlightMode0.value + 1]
		)
	)
	addRows(
		wizard.summaryLine(
			"FM1 Curve",
			nil,
			CurveFields.FlightMode1.available_values[CurveFields.FlightMode1.value + 1]
		)
	)
	addRows(
		wizard.summaryLine(
			"FM2 Curve",
			nil,
			CurveFields.FlightMode2.available_values[CurveFields.FlightMode2.value + 1]
		)
	)

	addRows(wizard.summaryLine("Roll Channel", AilerFields.value))
	addRows(wizard.summaryLine("Nick Channel", EleFields.value))
	addRows(wizard.summaryLine("Tail Channel", RudFields.value))

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
		nextFunc = function()
			selectPage(1)
		end,
		previousFunc = function()
			selectPage(-1)
		end,
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
	pages = {
		runModelNamePage,
		runModelImagePage,
		runTypeConfig,
		runStyleConfig,
		runSwitchConfig,
		runThrConfig,
		runCurveConfig,
		runAilerConfig,
		runEleConfig,
		runRudConfig,
		runConfigSummary,
		runFinished,
	}

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

-- === END OF FILE ===