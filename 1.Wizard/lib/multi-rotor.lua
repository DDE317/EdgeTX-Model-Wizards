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
--   - Split structure into separate files (lang/de.lua, lang/en.lua).
--   - Fixed dynamic re-initialization of dropdown tables to ensure correct language on every page load.
---- #########################################################################

local RUN_DIR = "/TEMPLATES/1.Wizard/lib"
local IMG_DIR = "/TEMPLATES/1.Wizard/img"
local MODEL_IMG_DIR = "/IMAGES"
local LANG_DIR = RUN_DIR .. "/lang"

-- Standardmäßig Deutsch laden
local T = loadScript(LANG_DIR .. "/de.lua")()
local WIZARD_TITLE = T.title_multi

local modelConfig = loadScript(RUN_DIR .. "/model-config.lua")()
local wizard = loadScript(RUN_DIR .. "/wizard-ui.lua")()

local page = 1
local pages = {}

local STICK_NUMBER_AIL = 3
local STICK_NUMBER_ELE = 1
local STICK_NUMBER_THR = 2
local STICK_NUMBER_RUD = 0

local channels = { "K1", "K2", "K3", "K4", "K5", "K6", "K7", "K8" }
local switches = { "SA", "SB", "SC", "SD", "SE", "SF" }

-- =========================================================================
-- Konstanten + Hilfsfunktionen
-- =========================================================================
local function getImagePath(filename)
	return IMG_DIR .. "/multirotor/" .. filename
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
                        WIZARD_TITLE = T.title_multi
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
                        WIZARD_TITLE = T.title_multi
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
			file = getImagePath("start.png"),
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
-- Gas
-- =========================================================================
local ThrottleFields = {}

local function runThrottleConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	ThrottleFields = {
		value = defaultChannel(STICK_NUMBER_THR),
		avail_values = channels,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_thr,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_thr,
				children = {
					{
						type = "choice",
						values = ThrottleFields.avail_values,
						get = function()
							return ThrottleFields.value + 1
						end,
						set = function(val)
							ThrottleFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("throttle.png"),
			}),
		},
	})

	lvgl.build(page)
end

-- =========================================================================
-- Roll
-- =========================================================================
local RollFields = {}

local function runRollConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	RollFields = {
		value = defaultChannel(STICK_NUMBER_AIL),
		avail_values = channels,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_roll,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_roll,
				children = {
					{
						type = "choice",
						values = RollFields.avail_values,
						get = function()
							return RollFields.value + 1
						end,
						set = function(val)
							RollFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("roll.png"),
			}),
		},
	})

	lvgl.build(page)
end

-- =========================================================================
-- Nick (Pitch)
-- =========================================================================
local PitchFields = {}

local function runPitchConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	PitchFields = {
		value = defaultChannel(STICK_NUMBER_ELE),
		avail_values = channels,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_pitch,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_pitch,
				children = {
					{
						type = "choice",
						values = PitchFields.avail_values,
						get = function()
							return PitchFields.value + 1
						end,
						set = function(val)
							PitchFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("pitch.png"),
			}),
		},
	})

	lvgl.build(page)
end

-- =========================================================================
-- Heck (Yaw)
-- =========================================================================
local YawFields = {}

local function runYawConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	YawFields = {
		value = defaultChannel(STICK_NUMBER_RUD),
		avail_values = channels,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_yaw,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_yaw,
				children = {
					{
						type = "choice",
						values = YawFields.avail_values,
						get = function()
							return YawFields.value + 1
						end,
						set = function(val)
							YawFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("yaw.png"),
			}),
		},
	})

	lvgl.build(page)
end

-- =========================================================================
-- Arm-Schalter
-- =========================================================================
local ArmFields = {}

local function runArmConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	ArmFields = {
		value = 5,
		avail_values = switches,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_arm,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_arm,
				children = {
					{
						type = "choice",
						values = ArmFields.avail_values,
						get = function()
							return ArmFields.value + 1
						end,
						set = function(val)
							ArmFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("arm.png"),
			}),
		},
	})

	lvgl.build(page)
end

-- =========================================================================
-- Beeper-Schalter
-- =========================================================================
local BeeperFields = {}

local function runBeeperConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	BeeperFields = {
		value = 3,
		avail_values = switches,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_beeper,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_beeper,
				children = {
					{
						type = "choice",
						values = BeeperFields.avail_values,
						get = function()
							return BeeperFields.value + 1
						end,
						set = function(val)
							BeeperFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("beeper.png"),
			}),
		},
	})

	lvgl.build(page)
end

-- =========================================================================
-- Mode-Schalter
-- =========================================================================
local ModeFields = {}

local function runModeConfig()
	lvgl.clear()

	-- Tabelle bei jedem Aufruf neu befüllen
	ModeFields = {
		value = 0,
		avail_values = switches,
	}

	local page = wizard.page({
		title = WIZARD_TITLE,
		subtitle = T.sub_multi_mode,
		hasPrevious = true,
		hasNext = true,
		previousFunc = function()
			selectPage(-1)
		end,
		nextFunc = function()
			selectPage(1)
		end,
		children1 = {
			wizard.settings({
				title = T.title_multi_mode,
				children = {
					{
						type = "choice",
						values = ModeFields.avail_values,
						get = function()
							return ModeFields.value + 1
						end,
						set = function(val)
							ModeFields.value = val - 1
						end,
					},
				},
			}),
		},
		children2 = {
			wizard.image({
				file = getImagePath("mode.png"),
			}),
		},
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
	model.deleteMixes()

	modelConfig.addMix(ThrottleFields.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_THR), T.mix_name_thr)
	modelConfig.addMix(RollFields.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_AIL), T.mix_name_ail)
	modelConfig.addMix(PitchFields.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_ELE), T.mix_name_ele)
	modelConfig.addMix(YawFields.value, MIXSRC_FIRST_INPUT + defaultChannel(STICK_NUMBER_RUD), T.mix_name_rud)

	modelConfig.addMix(4, MIXSRC_SA + ArmFields.value, "Arm")
	modelConfig.addMix(5, MIXSRC_SA + BeeperFields.value, "Beeper")
	modelConfig.addMix(6, MIXSRC_SA + ModeFields.value, "Mode")
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

	addRows(wizard.summaryLine(T.title_multi_thr_sum, ThrottleFields.value))
	addRows(wizard.summaryLine(T.title_multi_roll_sum, RollFields.value))
	addRows(wizard.summaryLine(T.title_multi_pitch_sum, PitchFields.value))
	addRows(wizard.summaryLine(T.title_multi_yaw_sum, YawFields.value))
	addRows(wizard.summaryLine(T.title_multi_arm_sum, nil, ArmFields.avail_values[ArmFields.value + 1]))
	addRows(wizard.summaryLine(T.title_multi_beeper_sum, nil, BeeperFields.avail_values[BeeperFields.value + 1]))
	addRows(wizard.summaryLine(T.title_multi_mode_sum, nil, ModeFields.avail_values[ModeFields.value + 1]))

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
-- Fertig
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
		runLanguageSelection,
		runModelNamePage,
		runModelImagePage,
		runThrottleConfig,
		runRollConfig,
		runPitchConfig,
		runYawConfig,
		runArmConfig,
		runBeeperConfig,
		runModeConfig,
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

-- === ENDE DER DATEI ===