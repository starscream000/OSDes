# Task 002: Our home: the bar and three panels

Status: done
Branch: task/002-shell-bar-and-home-panels
Depends on: 001, merged into the main branch

**Before you start:** check that `OSContent/Tile.qml` exists on the main
branch. If it does not, task 001 is not merged yet. Stop and tell the owner.

## Goal

Keep the Metro Start screen from task 001 as a reference screen, and build
the first version of our own home next to it: a thin bar that is always
visible, and a home made of three side-by-side panels (Now, Apps, All apps).
The Apps panel shows the existing tiles. The other two are empty shells.

## Background

Read `docs/PLAN.md` and `docs/DECISIONS.md` first, especially the decisions
dated 2026-11-11 about the bar, the three panels, and the reference screen.

Task 001 left these pieces, which you reuse:

- `OS/Theme.qml` — every colour and size
- `OS/HomeModel.qml` — groups of tiles
- `OSContent/Tile.qml`, `TileGroup.qml`, `TileArea.qml`
- `OSContent/Screen01.ui.qml` — the Metro Start screen

`OS.qmlproject` names `OSContent/Screen01.ui.qml` as the main screen and you
may not edit that file. So `Screen01.ui.qml` stays the main screen and
becomes the **shell root**; the Metro Start content moves out of it.

### 1. Keep the reference screen

- Move the current content of `Screen01.ui.qml` into a new
  `OSContent/MetroStartReference.ui.qml`. It must look the same as it does
  after task 001, except that it now fills the page area it is given
  instead of having a fixed size.
- Do not delete or simplify anything in it. `TileArea.qml` stays as it is.

### 2. The shell root (`Screen01.ui.qml`)

Top to bottom:

- **Page area:** fills everything above the bar. It shows one page at a
  time: **Home** (the default) or **Reference**.
- **Bar:** along the bottom edge, full width.

Which page is showing is a single shared value (for example a small
singleton in the `OS` module). Components change that value; the shell root
only reads it. This keeps `Screen01.ui.qml` declarative.

### 3. The bar

A flat strip, 48 high, in a colour slightly lighter than the page
background. No blur, shadow, or rounded corners. From left to right:

| Item | Looks like | Does |
|---|---|---|
| Home button | A 48 × 48 square with a small solid square centred in it | Shows the Home page. Marked as active when Home is showing. |
| Running apps | Three sample entries (Browser, Terminal, Files), each a 48 × 48 square with the app's first letter. The first has a thin line along its bottom edge to mark it as the app in front. | Hover highlight only. Click writes the app's name to the console. |
| (empty space) | | |
| Reference button | The text "Reference" | Shows the Reference page. Marked as active when it is showing. |
| Quick settings button | A 48 × 48 square with three short horizontal lines | Click writes a line to the console. |
| Clock | The current time (hours and minutes) above the current date, right-aligned, with a right margin | Updates by itself. |

Every button shows a hover highlight and a pressed state. The sample
running apps come from a small data model, not from items written out one
by one.

Do not draw a four-pane window mark or anything else that resembles
another company's logo.

### 4. The Home page

- **Panel tabs:** a fixed row at the top left, starting at the page margin:
  "Now", "Apps", "All apps" in large light-weight type. The current
  panel's name is in the primary text colour; the others are dimmed.
  Clicking a name moves to that panel.
- **Panels:** below the tabs, three panels side by side. Each panel is the
  width of the page area minus a "peek" of 160, so the edge of the next
  panel is always visible. Dragging sideways moves between panels and
  settles on one panel, never between two. The move is animated.
- **Keyboard:** the Left and Right arrow keys move to the previous and next
  panel.
- The tabs, the drag, and the keys all stay in step: whichever way the
  panel changes, the tabs show the right one.
- Home opens on the **Apps** panel.

Panel contents:

| Panel | Contents |
|---|---|
| Now | Empty for now. One line of dimmed text near the top left: "Your widgets will live here." |
| Apps | The groups from `HomeModel`, built from `TileGroup`. Groups are laid out left to right and **wrap** onto a new row when they do not fit the panel's width. If the rows are taller than the panel, the panel scrolls up and down, by drag and by mouse wheel. There is no sideways scrolling inside the panel. |
| All apps | Empty for now. One line of dimmed text: "All your apps will be listed here." |

### 5. Theme

Add every new colour and size to `OS/Theme.qml` (bar height, bar colours,
button states, peek width, tab type size, and so on). As before, components
contain no literal colours or sizes.

### 6. Housekeeping

Add `OS.qrc` to `.gitignore`. Qt Design Studio generates it.

## Files you may change

- `OSContent/Screen01.ui.qml`
- New `.qml` and `.ui.qml` files in `OSContent/`
- `OSContent/CMakeLists.txt` — only the `QML_FILES` list
- `OS/Theme.qml`
- New `.qml` files in `OS/`
- `OS/qmldir`
- `OS/CMakeLists.txt` — only the `QML_FILES` list and singleton entries
- `.gitignore`

## Done when

- [ ] Running the project opens on Home, on the Apps panel, with the bar
      along the bottom
- [ ] The bar has the six items in the table, in that order, and the clock
      shows the real time and date
- [ ] The Reference button shows the Metro Start screen, looking as it did
      after task 001 and still scrolling sideways; the Home button returns
      to Home; the bar stays visible on both pages
- [ ] Home has three panels with the peek of the next panel visible, and
      moves between them by tab click, by sideways drag, and by Left and
      Right keys, with the tabs always showing the current panel
- [ ] The Apps panel shows all groups from `HomeModel`, wrapped, and
      scrolls up and down when they do not fit
- [ ] Now and All apps show their one line of text
- [ ] `MetroStartReference.ui.qml` exists and `TileArea.qml`, `Tile.qml`,
      `TileGroup.qml`, and `HomeModel.qml` are unchanged
- [ ] `Screen01.ui.qml` and every other `.ui.qml` file contain no
      JavaScript functions or code blocks
- [ ] No literal colours or pixel sizes in the components
- [ ] Every new QML file is registered as `CLAUDE.md` requires
- [ ] `OS.qrc` is in `.gitignore`
- [ ] All checks below pass, or the report says exactly which could not be
      run and why

## Checks to run

- `qmllint -I . <each changed or new QML file>` — see `CLAUDE.md` for where
  `qmllint` is. No new warnings.
- A headless run (`QT_QPA_PLATFORM=offscreen`) that confirms: the project
  loads without errors; Home is the first page and Apps the first panel;
  setting the page to Reference and back works; moving to each panel
  updates the tabs. Do not commit the test.

You probably cannot see the running interface. Say what you verified and
list what the owner needs to check by running the project.

## Out of scope

- Real running apps, launching apps, or opening windows
- A quick settings panel (only its button exists)
- Real widgets in the Now panel
- The list and search in the All apps panel
- Other window sizes, phones, touch-specific behaviour
- Changing the look of tiles or of the reference screen
- Smooth wheel scrolling and other motion polish
- Anything in `Dependencies/`, `App/`, `cmake/`, `qds.cmake`,
  `OS.qmlproject`, or the top-level `CMakeLists.txt`
