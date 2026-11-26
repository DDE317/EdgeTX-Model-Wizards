# EdgeTX Model Wizards (DE / EN)

Erweiterte Modell-Assistenten für EdgeTX 2.12+ – mit Modellname, Modellbild und **integrierter Sprachauswahl**.

* * *

## 🇩🇪 Deutsch

### Was ist das?

Dies ist eine **erweiterte und modernisierte Version** der offiziellen EdgeTX Modell-Assistenten für EdgeTX 2.12+.

Die Original-Wizards helfen beim Erstellen von neuen Modellen (Flugzeug, Segler, Delta, Helikopter, Multirotor).  
Diese Version ergänzt wichtige Funktionen und bringt ein neues, flexibles Sprachsystem mit.

### Was ist neu gegenüber dem Original?

*   ✨ **Modellname direkt im Wizard eingeben** – mit nativer Bildschirmtastatur.
*   ✨ **Modellbild direkt im Wizard auswählen** – aus dem `/IMAGES`-Ordner.
*   ✨ **Filter-Funktion für Bilder** – bei vielen Bildern schnell zum Ziel (Alle, a-c, d-f, etc.).
*   ✨ **Integrierte Sprachauswahl** – beim Start des Wizards kann zwischen **Deutsch und Englisch** gewählt werden. Die Texte werden dynamisch aus dem Ordner `lib/lang/` geladen.
*   ✨ **Detaillierte Expo-Einstellungen** – separate Seite für Quer-, Höhen- und Seitenruder (ohne Zwang zu Dual Rate).
*   ✨ **Bugfixes** – einige kleinere Fehler der Original-Version behoben.

### Enthaltene Assistenten

Datei | Modelltyp
---|---
`1.Plane.lua` | Flugzeug
`2.Glider.lua` | Segler
`3.Wing.lua` | Delta / Nurflügler
`4.Helicopter.lua` | Helikopter
`5.Multirotor.lua` | Multirotor / Drohne

### Installation

1.  **Backup machen:** Kopiere den bestehenden Ordner `TEMPLATES/1.Wizard` von deiner SD-Karte auf den PC.
2.  **Alten Ordner löschen:** Lösche auf der SD-Karte den Ordner `TEMPLATES/1.Wizard`.
3.  **Download entpacken:** Lade die ZIP-Datei herunter und entpacke sie auf dem PC.
4.  **Neuen Ordner kopieren:** Kopiere den entpackten Ordner `1.Wizard` (aus dem Download) auf die SD-Karte nach `TEMPLATES/`.
5.  **SD-Karte in den Sender stecken.**
6.  **Modell-Manager öffnen → „Neues Modell" → Wizard auswählen.**

**⚠️ Wichtig:**
*   Dein Backup kannst du jederzeit wieder zurückkopieren.
*   Die neue Version überschreibt **nicht** deine bestehenden Modelle – nur den Wizard selbst.

### Voraussetzungen

*   EdgeTX **2.12** oder neuer
*   Sender mit SD-Karte und Lua-Unterstützung

### Lizenz

GPL v2 – siehe LICENSE

### Danksagung

Basiert auf den offiziellen EdgeTX Modell-Assistenten.  
Danke an die EdgeTX-Entwickler und alle Mitwirkenden.

### Autor

Wolfgang Dirks (DDE317)

* * *

## 🇬🇧 English

### What is this?

This is an **extended and modernized version** of the official EdgeTX Model Wizards for EdgeTX 2.12+.

The original wizards help you create new models (plane, glider, wing, helicopter, multirotor).  
This version adds important features and introduces a new, flexible language system.

### What's new compared to the original?

*   ✨ **Enter model name directly in the wizard** – with native on-screen keyboard.
*   ✨ **Select model image directly in the wizard** – from the `/IMAGES` folder.
*   ✨ **Filter function for images** – quickly find what you need (All, a-c, d-f, etc.).
*   ✨ **Integrated language selection** – choose between **German and English** at the start of the wizard. Texts are loaded dynamically from the `lib/lang/` folder.
*   ✨ **Detailed Expo settings** – separate page for aileron, elevator, and rudder (without mandatory dual rate).
*   ✨ **Bug fixes** – some minor bugs from the original version fixed.

### Included Wizards

File | Model type
---|---
`1.Plane.lua` | Plane
`2.Glider.lua` | Glider
`3.Wing.lua` | Wing / Delta
`4.Helicopter.lua` | Helicopter
`5.Multirotor.lua` | Multirotor

### Installation

1.  **Make a backup:** Copy the existing `TEMPLATES/1.Wizard` folder from your SD card to your PC.
2.  **Delete old folder:** Delete the `TEMPLATES/1.Wizard` folder from your SD card.
3.  **Extract download:** Download the ZIP file and extract it on your PC.
4.  **Copy new folder:** Copy the extracted `1.Wizard` folder to your SD card under `TEMPLATES/`.
5.  **Insert SD card into your radio.**
6.  **Open Model Manager → "New Model" → select wizard.**

**⚠️ Important:**
*   Your backup can be restored at any time.
*   The new version does **not** overwrite your existing models – only the wizard itself.

### Requirements

*   EdgeTX **2.12** or newer
*   Radio with SD card support and Lua

### License

GPL v2 – see LICENSE

### Credits

Based on the official EdgeTX Model Wizards.  
Thanks to the EdgeTX developers and all contributors.

### Author

Wolfgang Dirks (DDE317)
