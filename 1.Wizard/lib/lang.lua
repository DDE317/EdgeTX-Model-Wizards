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
-- Update by: Wolfgang Dirks (2026) - Modellname + Modellbild in LVGL, deutsche Texte


local lang = {}

lang.de = {
    title = "Flugzeug-Assistent",
    title_heli = "Helikopter-Assistent",
    title_multi = "Multirotor-Assistent",
    subtitle_name = "Modellname",
    msg_tap_to_type = "Tippe auf das Feld, um die Tastatur zu öffnen.",
    
    -- Allgemeine Optionen
    opt_no = "Nein",
    opt_yes = "Ja",
    opt_none = "Keine",
    opt_one = "Eine",
    opt_two = "Zwei",
    opt_yes_one = "Ja (eine)",
    opt_yes_two = "Ja (zwei)",

    -- Bildauswahl
    sub_image = "Modellbild auswählen",
    btn_all = "Alle",
    msg_no_images = "Keine Bilder",
    msg_image = "Bild",
    
    -- Flugzeug: Motor Seite
    sub_motor = "Motor Einstellungen",
    title_motor_exist = "Motor vorhanden?",
    title_motor_ch = "Motor-Kanal",
    title_safety_sw = "Sicherheitsschalter",
    
    -- Flugzeug: Querruder Seite
    sub_ail = "Querruder Einstellungen",
    title_ail_count = "Anzahl Querruder",
    title_ail_ch_a = "A (rechts)",
    title_ail_ch_b = "B (links)",
    
    -- Flugzeug: Klappen Seite
    sub_flaps = "Klappen Einstellungen",
    title_flaps_exist = "Klappen vorhanden?",
    title_flap_ch_a = "A (rechts)",
    title_flap_ch_b = "B (links)",
    
    -- Flugzeug: Heck Seite
    sub_tail = "Heck Einstellungen",
    title_tail_type = "Heckkonfiguration wählen",
    opt_tail_1 = "1 Kanal Höhe, kein Seite",
    opt_tail_2 = "1 Kanal Höhe, 1 Kanal Seite",
    opt_tail_3 = "2 Kanal Höhe, 1 Kanal Seite",
    opt_tail_4 = "V-Leitwerk",
    title_ch_a = "Kanal für A",
    title_ch_b = "Kanal für B",
    title_ch_c = "Kanal für C",

    -- Flugzeug: Fahrwerk Seite
    sub_gear = "Fahrwerk",
    title_gear_exist = "Einziehfahrwerk vorhanden?",
    title_gear_switch = "Fahrwerk-Schalter",
    title_gear_ch = "Fahrwerk-Kanal",
    
    -- Flugzeug: Zusätzliche Einstellungen Seite
    sub_additional = "Zusätzliche Einstellungen",
    title_expo = "Expo",
    title_dual_rate = "Dual Rate",
    
    -- Flugzeug: Detaillierte Expo Seite
    sub_expo = "Detailliertes Expo",
    title_setting = "Einstellung ",
    label_expo = "Expo:",
    ch_ail = "Quer",
    ch_ele = "Höh",
    ch_rud = "Seite",
    ch_rud_v = "Seite(V)",
    
    -- Flugzeug: Zusammenfassung
    sub_summary = "Zusammenfassung",
    msg_check_config = "Bitte prüfe die Konfiguration.",
    msg_press_next = "Danach Weiter drücken zum Anwenden.",
    title_model_name_sum = "Modellname",
    title_motor_ch_sum = "Motor-Kanal",
    title_ch_sum = "Kanal",
    title_ch_a_sum = "Rechts",
    title_ch_b_sum = "Links",
    title_flap_ch_sum = "Klappen Kanal",
    title_flap_a_sum = "Klappen Rechts",
    title_flap_b_sum = "Klappen Links",
    title_ele_ch_sum = "Höhenruder Kanal",
    title_ele_r_sum = "Höhenruder Rechts",
    title_ele_l_sum = "Höhenruder Links",
    title_rud_ch_sum = "Seitenruder Kanal",
    title_vtail_r_sum = "V-Leitwerk Rechts",
    title_vtail_l_sum = "V-Leitwerk Links",
    title_gear_sw_sum = "Fahrwerk-Schalter",
    title_gear_ch_sum = "Fahrwerk-Kanal",
    title_base_expo = "Expo (Basis)",
    title_base_dr = "Dual Rate (Basis)",
    
    -- Heli: Typ Seite
    sub_heli_type = "Heli-Typ",
    title_heli_type = "Welcher Heli-Typ?",
    title_swash_type = "Taumelscheiben-Typ",

    -- Heli: Flugstil Seite
    sub_style = "Flugstil",
    title_style = "Welcher Flugstil?",

    -- Heli: Schalter Seite
    sub_switch = "Schalter-Konfiguration",
    title_fm_sw = "FM (Idle Up)",
    title_hold_sw = "Motor-Stopp",
    title_gain_sw = "Heck-Gain",

    -- Heli: Kanäle
    sub_thr_ch = "Gaskanal-Konfiguration",
    title_thr_ch = "Gaskanal",
    sub_curve = "Gaskurven",
    title_curve_fm0 = "Gaskurve FM0",
    title_curve_fm1 = "Gaskurve FM1",
    title_curve_fm2 = "Gaskurve FM2",
    sub_ail_ch = "Roll-Konfiguration",
    title_ail_ch = "Roll-Kanal (Querruder)",
    sub_ele_ch = "Nick-Konfiguration",
    title_ele_ch = "Nick-Kanal (Höhenruder)",
    sub_rud_ch = "Heck-Konfiguration",
    title_rud_ch = "Heck-Kanal (Seitenruder)",

    -- Heli: Zusammenfassung
    title_type_sum = "Typ",
    title_swash_sum = "Taumelscheibe",
    title_style_sum = "Flugstil",
    title_fm_sw_sum = "FM-Schalter",
    title_hold_sw_sum = "Motor-Stopp-Schalter",
    title_gain_sw_sum = "Heck-Gain-Schalter",
    title_thr_ch_sum = "Gaskanal",
    title_curve_fm0_sum = "Kurve FM0",
    title_curve_fm1_sum = "Kurve FM1",
    title_curve_fm2_sum = "Kurve FM2",
    title_ail_ch_sum = "Roll-Kanal",
    title_ele_ch_sum_heli = "Nick-Kanal",
    title_rud_ch_sum_heli = "Heck-Kanal",

    -- Multi: Seiten
    sub_multi_thr = "Gas-Einstellungen",
    title_multi_thr = "Gaskanal zuweisen",
    sub_multi_roll = "Roll-Einstellungen",
    title_multi_roll = "Roll-Kanal zuweisen",
    sub_multi_pitch = "Nick-Einstellungen",
    title_multi_pitch = "Nick-Kanal zuweisen",
    sub_multi_yaw = "Heck-Einstellungen",
    title_multi_yaw = "Heck-Kanal zuweisen",
    sub_multi_arm = "Arm-Schalter",
    title_multi_arm = "Arm-Schalter zuweisen",
    sub_multi_beeper = "Beeper-Schalter",
    title_multi_beeper = "Beeper-Schalter zuweisen",
    sub_multi_mode = "Mode-Schalter",
    title_multi_mode = "Mode-Schalter zuweisen",

    -- Multi: Zusammenfassung
    title_multi_thr_sum = "Gaskanal",
    title_multi_roll_sum = "Roll-Kanal",
    title_multi_pitch_sum = "Nick-Kanal",
    title_multi_yaw_sum = "Heck-Kanal",
    title_multi_arm_sum = "Arm-Schalter",
    title_multi_beeper_sum = "Beeper-Schalter",
    title_multi_mode_sum = "Mode-Schalter",

    -- Finished
    msg_finished = "Modell erfolgreich erstellt!",
    msg_hold_exit = "Zum Beenden [RTN] gedrückt halten."
}

lang.en = {
    title = "Airplane Wizard",
    title_heli = "Helicopter Wizard",
    title_multi = "Multirotor Wizard",
    subtitle_name = "Model Name",
    msg_tap_to_type = "Tap the field to open keyboard.",
    
    -- Allgemeine Optionen
    opt_no = "No",
    opt_yes = "Yes",
    opt_none = "None",
    opt_one = "One",
    opt_two = "Two",
    opt_yes_one = "Yes (one)",
    opt_yes_two = "Yes (two)",

    -- Bildauswahl
    sub_image = "Select Model Image",
    btn_all = "All",
    msg_no_images = "No images",
    msg_image = "Image",
    
    -- Flugzeug: Motor Seite
    sub_motor = "Motor Settings",
    title_motor_exist = "Motor present?",
    title_motor_ch = "Motor Channel",
    title_safety_sw = "Safety Switch",
    
    -- Flugzeug: Querruder Seite
    sub_ail = "Aileron Settings",
    title_ail_count = "Number of Ailerons",
    title_ail_ch_a = "A (right)",
    title_ail_ch_b = "B (left)",
    
    -- Flugzeug: Klappen Seite
    sub_flaps = "Flap Settings",
    title_flaps_exist = "Flaps present?",
    title_flap_ch_a = "A (right)",
    title_flap_ch_b = "B (left)",
    
    -- Flugzeug: Heck Seite
    sub_tail = "Tail Settings",
    title_tail_type = "Select Tail Configuration",
    opt_tail_1 = "1 Ch Elev, no Rud",
    opt_tail_2 = "1 Ch Elev, 1 Ch Rud",
    opt_tail_3 = "2 Ch Elev, 1 Ch Rud",
    opt_tail_4 = "V-Tail",
    title_ch_a = "Channel for A",
    title_ch_b = "Channel for B",
    title_ch_c = "Channel for C",

    -- Flugzeug: Fahrwerk Seite
    sub_gear = "Landing Gear",
    title_gear_exist = "Retractable gear present?",
    title_gear_switch = "Gear Switch",
    title_gear_ch = "Gear Channel",
    
    -- Flugzeug: Zusätzliche Einstellungen Seite
    sub_additional = "Additional Settings",
    title_expo = "Expo",
    title_dual_rate = "Dual Rate",
    
    -- Flugzeug: Detaillierte Expo Seite
    sub_expo = "Detailed Expo",
    title_setting = "Setting ",
    label_expo = "Expo:",
    ch_ail = "Ail",
    ch_ele = "Ele",
    ch_rud = "Rud",
    ch_rud_v = "Rud(V)",
    
    -- Flugzeug: Zusammenfassung
    sub_summary = "Summary",
    msg_check_config = "Please check the configuration.",
    msg_press_next = "Press Next to apply.",
    title_model_name_sum = "Model Name",
    title_motor_ch_sum = "Motor Channel",
    title_ch_sum = "Channel",
    title_ch_a_sum = "Right",
    title_ch_b_sum = "Left",
    title_flap_ch_sum = "Flap Channel",
    title_flap_a_sum = "Flap Right",
    title_flap_b_sum = "Flap Left",
    title_ele_ch_sum = "Elevator Channel",
    title_ele_r_sum = "Elevator Right",
    title_ele_l_sum = "Elevator Left",
    title_rud_ch_sum = "Rudder Channel",
    title_vtail_r_sum = "V-Tail Right",
    title_vtail_l_sum = "V-Tail Left",
    title_gear_sw_sum = "Gear Switch",
    title_gear_ch_sum = "Gear Channel",
    title_base_expo = "Expo (Base)",
    title_base_dr = "Dual Rate (Base)",
    
    -- Heli: Typ Seite
    sub_heli_type = "Heli Type",
    title_heli_type = "Which Heli Type?",
    title_swash_type = "Swashplate Type",

    -- Heli: Flugstil Seite
    sub_style = "Flight Style",
    title_style = "Which Flight Style?",

    -- Heli: Schalter Seite
    sub_switch = "Switch Configuration",
    title_fm_sw = "FM (Idle Up)",
    title_hold_sw = "Throttle Hold",
    title_gain_sw = "Tail Gain",

    -- Heli: Kanäle
    sub_thr_ch = "Throttle Channel",
    title_thr_ch = "Throttle Channel",
    sub_curve = "Throttle Curves",
    title_curve_fm0 = "Throttle Curve FM0",
    title_curve_fm1 = "Throttle Curve FM1",
    title_curve_fm2 = "Throttle Curve FM2",
    sub_ail_ch = "Roll Configuration",
    title_ail_ch = "Roll Channel (Aileron)",
    sub_ele_ch = "Pitch Configuration",
    title_ele_ch = "Pitch Channel (Elevator)",
    sub_rud_ch = "Tail Configuration",
    title_rud_ch = "Tail Channel (Rudder)",

    -- Heli: Zusammenfassung
    title_type_sum = "Type",
    title_swash_sum = "Swashplate",
    title_style_sum = "Flight Style",
    title_fm_sw_sum = "FM Switch",
    title_hold_sw_sum = "Hold Switch",
    title_gain_sw_sum = "Gain Switch",
    title_thr_ch_sum = "Throttle Channel",
    title_curve_fm0_sum = "Curve FM0",
    title_curve_fm1_sum = "Curve FM1",
    title_curve_fm2_sum = "Curve FM2",
    title_ail_ch_sum = "Roll Channel",
    title_ele_ch_sum_heli = "Pitch Channel",
    title_rud_ch_sum_heli = "Tail Channel",

    -- Multi: Seiten
    sub_multi_thr = "Throttle Settings",
    title_multi_thr = "Assign Throttle Channel",
    sub_multi_roll = "Roll Settings",
    title_multi_roll = "Assign Roll Channel",
    sub_multi_pitch = "Pitch Settings",
    title_multi_pitch = "Assign Pitch Channel",
    sub_multi_yaw = "Yaw Settings",
    title_multi_yaw = "Assign Yaw Channel",
    sub_multi_arm = "Arm Switch",
    title_multi_arm = "Assign Arm Switch",
    sub_multi_beeper = "Beeper Switch",
    title_multi_beeper = "Assign Beeper Switch",
    sub_multi_mode = "Mode Switch",
    title_multi_mode = "Assign Mode Switch",

    -- Multi: Zusammenfassung
    title_multi_thr_sum = "Throttle Channel",
    title_multi_roll_sum = "Roll Channel",
    title_multi_pitch_sum = "Pitch Channel",
    title_multi_yaw_sum = "Yaw Channel",
    title_multi_arm_sum = "Arm Switch",
    title_multi_beeper_sum = "Beeper Switch",
    title_multi_mode_sum = "Mode Switch",

    -- Finished
    msg_finished = "Model successfully created!",
    msg_hold_exit = "Hold [RTN] to exit."
}

return lang