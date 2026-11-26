---- #########################################################################
---- #                                                                       #
---- # Sprachdatei (Deutsch) für den Modell-Assistenten (Wizard)             #
---- #                                                                       #
---- # Diese Datei enthält alle deutschen Texte für die Benutzeroberfläche.  #
---- # Sie wird vom Hauptskript (z.B. fixed-wing.lua) bei Bedarf geladen.    #
---- #                                                                       #
---- # Wichtiger Hinweis:                                                    #
---- # Damit die Texte im Skript angezeigt werden, müssen die Schlüssel      #
---- # (z.B. "title" oder "msg_tap_to_type") exakt mit denen in den anderen  #
---- # Sprachdateien (z.B. en.lua) übereinstimmen.                           #
---- #                                                                       #
---- # Einstellungen und Struktur von Wolfgang Dirks (2026)                  #
---- #########################################################################

return {
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
    title_elevon_count = "Anzahl Elevons",
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
    title_dual_rate = "Dual Rate",
    title_switch_select = "Schalterauswahl:",
    
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
    msg_hold_exit = "Zum Beenden [RTN] gedrückt halten.",

    -- Neue Schlüssel für die komplette Übersetzung
    msg_select_language = "Bitte Sprache wählen / Please select language",
    title_language = "Sprache / Language",
    sub_language = "Bitte wählen / Please select",
    
    mix_name_thr = "Gas",
    mix_name_ail = "Quer",
    mix_name_ail_r = "Quer-R",
    mix_name_ail_l = "Quer-L",
    mix_name_ele = "Höhe",
    mix_name_ele_r = "Höh-R",
    mix_name_ele_l = "Höh-L",
    mix_name_rud = "Seite",
    mix_name_flap = "Klappen",
    mix_name_flap_r = "KlappenR",
    mix_name_flap_l = "KlappenL",
    mix_name_vtail_r = "V-HöhR",
    mix_name_vtail_l = "V-HöhL",
    mix_name_gear = "Fahrw"
}