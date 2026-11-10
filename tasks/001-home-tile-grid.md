# Task 001: Home screen with a static tile grid

Status: in review
Branch: task/001-home-tile-grid
Depends on: none

## Goal

Replace the starter "Hello OS" screen with the desktop home screen: a titled
page of flat, rectangular tiles in four sizes, arranged in groups, that
scrolls sideways. It is static: nothing launches and no tile shows live
data.

## Background

Read `docs/PLAN.md` (principles and milestone 1) and the project rules in
`CLAUDE.md` first.

The project is a standard Qt Design Studio project. `OSContent/App.qml`
opens a window and shows `OSContent/Screen01.ui.qml`. Shared values live in
the `OS` module (`OS/Constants.qml`). The design size is 1920×1080.

### What the screen looks like

- **Background:** one solid dark colour filling the window.
- **Header:** the page title "Start" at the top left in large, light-weight
  type. At the top right, a placeholder user area: a name ("User") with a
  plain square beside it.
- **Tile area:** below the header, starting at the same left margin as the
  title. Tiles sit in **groups**. Groups are laid out left to right with a
  wider gap between groups than between tiles. Each group has a small
  header label above it.
- **Scrolling:** when the groups are wider than the window, the tile area
  scrolls sideways. The mouse wheel scrolls it sideways too. The header
  stays in place.

### The grid

Everything is measured in grid units.

| Name | Theme value |
|---|---|
| Unit (one small tile's side) | 70 |
| Gap between tiles | 10 |
| Gap between groups | 60 |
| Left page margin (title and first group start here) | 120 |
| Top of the tile area, measured from the top of the window | 180 |

| Tile size | Units (columns × rows) | Pixels |
|---|---|---|
| Small | 1 × 1 | 70 × 70 |
| Medium | 2 × 2 | 150 × 150 |
| Wide | 4 × 2 | 310 × 150 |
| Large | 4 × 4 | 310 × 310 |

A tile that spans N units is `N × unit + (N − 1) × gap` pixels.

A group is 8 units wide (two wide tiles side by side) and 8 units tall.

**Tile positions come from the data.** Each tile entry says which group it
is in, its column and row inside that group (in units, counted from 0), and
its size. The screen places it there. Do not write code that packs tiles
automatically; that is a later task.

### A tile

- A solid-colour rectangle with square corners. No border, shadow,
  gradient, or blur.
- **Label:** the tile's name at the bottom left, in small white type, with
  a small inner margin. Small (1 × 1) tiles show no label.
- **Mark:** centred, the first letter of the tile's name in large white
  light-weight type. This stands in for an icon. Do not add image files.
- **Hover:** a thin white outline appears inside the tile's edge.
- **Press:** the tile shrinks slightly (to about 97%) while held and
  returns on release, with a short animation.
- **Click:** writes one line with the tile's name to the console. Nothing
  else happens.

### Sample content

Provide at least three groups and 18 tiles in total, using all four sizes,
with ordinary app names (for example Mail, Calendar, Photos, Music, Files,
Terminal, Browser, Settings, Weather, Notes). Use six to eight flat tile
colours from the theme. No two tiles in one group may overlap, and none may
extend past its group's 8 × 8 units.

### How to structure it

- A **theme** singleton in the `OS` module holds the grid values above, the
  background colour, the text colours, the tile colour palette, and the
  type sizes. Components read from it; they contain no literal colours or
  sizes.
- A **data model** in the `OS` module holds the groups and tiles.
- A **tile** component and a **tile group** component in `OSContent/`.
- `Screen01.ui.qml` composes the header and the scrolling tile area from
  those components and stays declarative (see `CLAUDE.md`).
- Remove the starter button, label, and animation from `Screen01.ui.qml`.
- `OS/EventListModel.qml` and `OS/EventListSimulator.qml` are unused
  starter files; leave them alone.

## Files you may change

- `OSContent/Screen01.ui.qml`
- `OSContent/App.qml`
- New `.qml` files in `OSContent/`
- `OSContent/CMakeLists.txt` — only the `QML_FILES` list
- `OS/Constants.qml`
- New `.qml` files in `OS/`
- `OS/qmldir`
- `OS/CMakeLists.txt` — only the `QML_FILES` list and, for a new
  singleton, a `set_source_files_properties` entry like the existing one
- `.gitignore` (new)

## Done when

- [ ] Running the project shows the home screen described above in place
      of the "Hello OS" screen
- [ ] All four tile sizes appear, at the pixel sizes in the table
- [ ] At least three groups and 18 tiles, with no overlaps and nothing
      outside a group's 8 × 8 units
- [ ] The tile area scrolls sideways by dragging and by mouse wheel, and
      the header does not move
- [ ] Tiles show hover outline, press shrink, and a console line on click
- [ ] Tile positions and sizes come from the data model, not from code
      that packs them
- [ ] No literal colours or pixel sizes in the components; they come from
      the theme
- [ ] `Screen01.ui.qml` contains no JavaScript functions or code blocks
- [ ] Every new QML file is registered as `CLAUDE.md` requires
- [ ] A `.gitignore` keeps build output and Qt Design Studio's per-user
      files (such as `*.qtds`, `build/`, `.qtc_clangd/`) out of the
      repository
- [ ] All checks below pass, or the report says exactly which could not be
      run and why

## Checks to run

- `qmllint <each changed .qml file>` — the files parse and have no
  unresolved names. If `qmllint` is not on the PATH, look for it inside the
  Qt Design Studio or Qt installation; if you cannot find it, say so in the
  report.
- Read through the tile data once more and confirm by arithmetic that no
  two tiles in a group overlap.

You probably cannot see the running interface. Do not claim it "looks
right". Say what you verified and what the owner needs to check by running
the project.

## Out of scope

- Launching apps or opening any second screen
- Live or changing tile content
- Automatic tile packing, drag to rearrange, resizing tiles
- Adapting to other window sizes, phones, or touch-specific behaviour
- Entrance animations, tile tilt, or any motion beyond the press shrink
- Image or icon files, custom fonts
- Anything in `Dependencies/`, `App/`, `cmake/`, `qds.cmake`,
  `OS.qmlproject`, or the top-level `CMakeLists.txt`
