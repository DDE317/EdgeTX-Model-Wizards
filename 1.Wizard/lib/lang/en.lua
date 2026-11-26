---- #########################################################################
---- #                                                                       #
---- # Language File (English) for the Model Wizard                          #
---- #                                                                       #
---- # This file contains all English texts for the user interface.          #
---- # It is loaded on demand by the main script (e.g. fixed-wing.lua).      #
---- #                                                                       #
---- # Important Note:                                                       #
---- # For the texts to display correctly, the keys (e.g. "title" or         #
---- # "msg_tap_to_type") must match exactly with the other language files.  #
---- #                                                                       #
---- # Settings and structure by Wolfgang Dirks (2026)                       #
---- #########################################################################

return {
    title = "Airplane Wizard",
    title_heli = "Helicopter Wizard",
    title_multi = "Multirotor Wizard",
    subtitle_name = "Model Name",
    msg_tap_to_type = "Tap the field to open keyboard.",
    
    -- General Options
    opt_no = "No",
    opt_yes = "Yes",
    opt_none = "None",
    opt_one = "One",
    opt_two = "Two",
    opt_yes_one = "Yes (one)",
    opt_yes_two = "Yes (two)",

    -- Image Selection
    sub_image = "Select Model Image",
    btn_all = "All",
    msg_no_images = "No images",
    msg_image = "Image",
    
    -- Airplane: Motor Page
    sub_motor = "Motor Settings",
    title_motor_exist = "Motor present?",
    title_motor_ch = "Motor Channel",
    title_safety_sw = "Safety Switch",
    
    -- Airplane: Aileron Page
    sub_ail = "Aileron Settings",
    title_ail_count = "Number of Ailerons",
    title_elevon_count = "Number of Elevons",
    title_ail_ch_a = "A (right)",
    title_ail_ch_b = "B (left)",
    
    -- Airplane: Flap Page
    sub_flaps = "Flap Settings",
    title_flaps_exist = "Flaps present?",
    title_flap_ch_a = "A (right)",
    title_flap_ch_b = "B (left)",
    
    -- Airplane: Tail Page
    sub_tail = "Tail Settings",
    title_tail_type = "Select Tail Configuration",
    opt_tail_1 = "1 Ch Elev, no Rud",
    opt_tail_2 = "1 Ch Elev, 1 Ch Rud",
    opt_tail_3 = "2 Ch Elev, 1 Ch Rud",
    opt_tail_4 = "V-Tail",
    title_ch_a = "Channel for A",
    title_ch_b = "Channel for B",
    title_ch_c = "Channel for C",

    -- Airplane: Gear Page
    sub_gear = "Landing Gear",
    title_gear_exist = "Retractable gear present?",
    title_gear_switch = "Gear Switch",
    title_gear_ch = "Gear Channel",
    
    -- Airplane: Additional Settings Page
    sub_additional = "Additional Settings",
    title_dual_rate = "Dual Rate",
    title_switch_select = "Switch selection:",
    
    -- Airplane: Detailed Expo Page
    sub_expo = "Detailed Expo",
    title_setting = "Setting ",
    label_expo = "Expo:",
    ch_ail = "Ail",
    ch_ele = "Ele",
    ch_rud = "Rud",
    ch_rud_v = "Rud(V)",
    
    -- Airplane: Summary
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
    title_base_dr = "Dual Rate (Base)",
    
    -- Heli: Type Page
    sub_heli_type = "Heli Type",
    title_heli_type = "Which Heli Type?",
    title_swash_type = "Swashplate Type",

    -- Heli: Style Page
    sub_style = "Flight Style",
    title_style = "Which Flight Style?",

    -- Heli: Switch Page
    sub_switch = "Switch Configuration",
    title_fm_sw = "FM (Idle Up)",
    title_hold_sw = "Throttle Hold",
    title_gain_sw = "Tail Gain",

    -- Heli: Channels
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

    -- Heli: Summary
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

    -- Multi: Pages
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

    -- Multi: Summary
    title_multi_thr_sum = "Throttle Channel",
    title_multi_roll_sum = "Roll Channel",
    title_multi_pitch_sum = "Pitch Channel",
    title_multi_yaw_sum = "Yaw Channel",
    title_multi_arm_sum = "Arm Switch",
    title_multi_beeper_sum = "Beeper Switch",
    title_multi_mode_sum = "Mode Switch",

    -- Finished
    msg_finished = "Model successfully created!",
    msg_hold_exit = "Hold [RTN] to exit.",

    -- New keys for complete translation
    msg_select_language = "Please select language",
    title_language = "Language",
    sub_language = "Please select",
    
    mix_name_thr = "Thr",
    mix_name_ail = "Ail",
    mix_name_ail_r = "Ail-R",
    mix_name_ail_l = "Ail-L",
    mix_name_ele = "Ele",
    mix_name_ele_r = "Ele-R",
    mix_name_ele_l = "Ele-L",
    mix_name_rud = "Rud",
    mix_name_flap = "Flap",
    mix_name_flap_r = "FlapR",
    mix_name_flap_l = "FlapL",
    mix_name_vtail_r = "V-EleR",
    mix_name_vtail_l = "V-EleL",
    mix_name_gear = "Gear"
}