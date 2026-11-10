# Report — Task 001: Home screen with a static tile grid

Branch: task/001-home-tile-grid
Result: complete

## What was done

- **Theme singleton:** `OS/Theme.qml` holds the grid values (unit 70, gap 10,
  group gap 60, page margin 120, tile area top 180, group 8 units), the
  `span(units)` formula, the four tile sizes (columns, rows, mark size), the
  background and text colours, eight flat tile colours by name, type sizes,
  header sizes, and the press/scroll motion values.
- **Data model:** `OS/HomeModel.qml` is a `ListModel` of three groups
  (Everyday, Work, Play) holding 26 tiles in all. Each tile gives its name,
  size, colour name, and its column and row inside the group.
- **Tile:** `OSContent/Tile.qml` is a flat rectangle with a centred
  first-letter mark and a bottom-left label (hidden on small tiles), a
  2 px white outline inside the edge on hover, a press shrink to 0.97 with
  a 90 ms animation, and `console.log("Tile clicked:", name)` on click.
- **Tile group:** `OSContent/TileGroup.qml` is a group label plus an 8 × 8
  unit field. Each tile goes at `column × 80`, `row × 80`, taken from the
  data. Nothing is packed automatically.
- **Tile area:** `OSContent/TileArea.qml` is a horizontal `Flickable`
  holding a row of groups. A `WheelHandler` turns vertical (or sideways
  touchpad) wheel movement into sideways scrolling, clamped to the content.
- **Screen:** `OSContent/Screen01.ui.qml` no longer has the starter button,
  label, animation, and state. It now has the background, the "Start"
  title, the "User" name with a placeholder square, and the `TileArea`
  below the header. It is purely declarative.
- **Registration:** `Theme` (singleton) and `HomeModel` were added to
  `OS/qmldir` and the `OS/CMakeLists.txt` `QML_FILES` list, plus a
  `set_source_files_properties` singleton entry for `Theme.qml`. `Tile.qml`,
  `TileArea.qml`, and `TileGroup.qml` were added to the
  `OSContent/CMakeLists.txt` `QML_FILES` list.
- **`.gitignore`:** new. It ignores `build/`, `build-*/`, `out/`, `*.qmlc`,
  `*.jsc`, `*.qtds`, `*.user*`, `CMakeUserPresets.json`, `.qtc_clangd/`,
  `.qtcreator/`, editor folders, and OS junk files.
- `OSContent/App.qml` and `OS/Constants.qml` are unchanged. `Theme` reuses
  `Constants.font.family` for the font family.

## Done-when checklist

- [x] Running the project shows the home screen described above in place
      of the "Hello OS" screen. I checked this with a headless render (see
      Checks); **the owner still needs to run it in Qt Design Studio.**
- [x] All four tile sizes appear, at the pixel sizes in the table (measured
      at run time: small 70×70, medium 150×150, wide 310×150, large 310×310)
- [x] At least three groups and 18 tiles, with no overlaps and nothing
      outside a group's 8 × 8 units (3 groups and 26 tiles; arithmetic
      below)
- [x] The tile area scrolls sideways by dragging and by mouse wheel, and
      the header does not move. The header is outside the `Flickable`.
- [x] Tiles show hover outline, press shrink, and a console line on click
- [x] Tile positions and sizes come from the data model, not from code
      that packs them
- [x] No literal colours or pixel sizes in the components; they come from
      the theme
- [x] `Screen01.ui.qml` contains no JavaScript functions or code blocks
- [x] Every new QML file is registered as `CLAUDE.md` requires
- [x] A `.gitignore` keeps build output and Qt Design Studio's per-user
      files out of the repository
- [x] All checks below pass, or the report says exactly which could not be
      run and why

## Checks run

`qmllint` is not on the PATH. I used the copy that ships with Qt Design
Studio: `C:/Qt/Tools/QtDesignStudio/qt6_design_studio_reduced_version/bin/qmllint.exe`
(6.8.7).

| Check | Result |
|---|---|
| `qmllint -I . OS/Theme.qml OS/HomeModel.qml OSContent/Tile.qml OSContent/TileGroup.qml OSContent/TileArea.qml OSContent/Screen01.ui.qml` | Passed with no warnings |
| Overlap and bounds arithmetic over `OS/HomeModel.qml` (script, run on the file) | Passed: Everyday has 10 tiles on 48 cells, Work 9 tiles on 32 cells, Play 7 tiles on 42 cells. No cell is used twice and no tile goes past column or row 8. All four sizes are used. |
| Headless run with `qmltestrunner` (`QT_QPA_PLATFORM=offscreen`; throwaway test, not committed) | Measured: 26 tiles at the sizes above. Groups are 630 px wide, 690 px apart (630 + 60 gap). The first tile is at (120, 224), which is the tile area top of 180 plus the 44 px group label. Content is 2250 px wide in a 1920 px window. One wheel notch scrolls 180 px. Wheel stops at 0 and at the 330 px maximum. A 300 px drag scrolls. Hover shows the outline. Press scales to 0.97 and release returns to 1. A click prints `qml: Tile clicked: Mail`. A small tile hides its label. |
| Headless screenshot of `Screen01` | The layout matches the brief: title top left, "User" and a square top right, three labelled groups, and the third group cut off at the right edge until scrolled. The offscreen platform used a fallback font, so the real typeface was **not** checked. |

**Arithmetic, by hand.** A tile covers columns `column … column + width − 1`
and rows `row … row + height − 1`.

- **Everyday:**
  - Mail is wide, columns 0–3, rows 0–1.
  - Calendar is medium, columns 4–5, rows 0–1.
  - Four small tiles, Notes, Contacts, Messages, and Reminders, sit at
    (6,0), (7,0), (6,1), and (7,1).
  - Weather is large, columns 0–3, rows 2–5.
  - Photos is medium, columns 4–5, rows 2–3.
  - Music is medium, columns 6–7, rows 2–3.
  - News is wide, columns 4–7, rows 4–5.
- **Work:**
  - Files is medium, columns 0–1, rows 0–1.
  - Terminal is medium, columns 2–3, rows 0–1.
  - Browser is wide, columns 4–7, rows 0–1.
  - Editor is wide, columns 0–3, rows 2–3.
  - Four small tiles, Calculator, Camera, Maps, and Store, sit at (4,2),
    (5,2), (4,3), and (5,3).
  - Settings is medium, columns 6–7, rows 2–3.
- **Play:**
  - Videos is large, columns 0–3, rows 0–3.
  - Podcasts is medium, columns 4–5, rows 0–1.
  - Games is medium, columns 6–7, rows 0–1.
  - Radio is wide, columns 4–7, rows 2–3.
  - Books is wide, columns 0–3, rows 4–5.
  - Recorder and Scanner are small, at (4,4) and (5,4).

No ranges intersect, and every tile ends at or before column 7 and row 7.

**What the owner needs to check by running the project:**

- The typeface and weights look right.
- The mouse wheel feels right. It scrolls 1.5 px per wheel unit, which is
  `Theme.wheelScrollFactor`.
- The press shrink and the hover outline feel right with a real mouse.
- The project opens in the Qt Design Studio visual editor.

## Not done

- Nothing from the brief.

## Questions

- The brief was still marked `Status: draft` (and `draft` in
  `docs/STATUS.md`) when I started. The owner told me directly to treat it
  as approved and go ahead. The master may want to update the brief's
  status and `docs/STATUS.md`.
- Group membership is given by nesting: each group in `HomeModel` holds its
  own list of tiles, so a tile entry has no separate "group" field. Say if a
  flat list with a group field is wanted instead.

## Noticed but not done

- `OS/Constants.qml` still has the starter `backgroundColor: "#EAEAEA"`,
  which nothing uses any more. It also gives three `qmllint` warnings
  (`Qt.application.font` is unknown to the linter, and an unqualified
  `relativeFontDirectory`). These were already there before this task.
- `OSContent/App.qml` gets a `qmllint` "unused import OS" note. This was
  already there before this task.
- Wheel scrolling jumps rather than glides. Smooth scrolling belongs in
  milestone 2 (motion).
- The screen has a fixed 1920×1080 size from `Constants`. Resizing the
  window is out of scope (milestone 3).
