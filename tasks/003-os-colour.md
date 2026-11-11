# Task 003: Give the OS its own colour

Status: ready
Branch: task/003-os-colour
Depends on: 002 (merged)

## Goal

Our home and the bar take on one distinct colour, the classic Windows 2000
desktop blue, and every surface on them becomes a shade of that one colour,
so the interface reads as a single uniform whole. The Metro Start reference
screen keeps its current dark, multi-colour look.

## Background

Read the decisions dated 2026-11-11 in `docs/DECISIONS.md` about the OS
colour and about uniform surfaces.

Today `OS/Theme.qml` has one set of colours used by everything: a
near-black background and eight tile tints. After this task there are two
looks:

| Where | Look |
|---|---|
| Home (all three panels) and the bar | The new OS look below |
| Reference page (`MetroStartReference.ui.qml`) | Exactly as it is now: dark background, tinted tiles |

### The OS look

One hue. Depth comes from lighter and darker shades of it, never from a
second colour, a border, a shadow, or a gradient.

Start from these values. The owner will tune them by eye afterwards, so
each must be a single named value in the theme.

| Role | Value |
|---|---|
| Background of Home | `#3A6EA5` |
| Bar | `#2B5482` |
| Tile fill on Home (every tile the same) | `#4A7FB8` |
| Hover fill (bar buttons) | `#4A7FB8` |
| Pressed fill (bar buttons) | `#5A8FC8` |
| Active bar button fill | `#346299` |
| Primary text, marks, tile outline on hover | `#FFFFFF` |
| Lines under the active page and the front app in the bar | `#FFFFFF` |
| Secondary text (group labels, the date in the clock) | pick a light blue-white |
| Dimmed text (tabs that are not current, placeholder lines) | pick a light blue-white, dimmer than secondary |

**Readable text is required.** Against the surface it sits on, text
smaller than 24 px must have a contrast ratio of at least 4.5 to 1, and
larger text at least 3 to 1. Choose the secondary and dimmed values to meet
this, work out the ratios, and list them in your report. (Contrast ratio is
the standard WCAG formula based on the two colours' relative luminance.)

### Tiles on Home

- Every tile on Home has the same fill. The per-tile `tint` in `HomeModel`
  is ignored there.
- `HomeModel` does not change. The Reference page still uses the tints.
- Hover and press on a tile stay as they are (white outline, slight
  shrink).

### How to structure it

- The theme owns both looks under clear names, so a component never needs
  a literal colour.
- A tile, group, or panel is told which look to use by whoever places it;
  it does not work it out for itself.
- Do not duplicate `Tile.qml` or `TileGroup.qml` to get the second look.

## Files you may change

- `OS/Theme.qml`
- Any existing `.qml` or `.ui.qml` file in `OSContent/`

No new files are expected. If you need one, it must be in `OSContent/` or
`OS/` and registered as `CLAUDE.md` requires.

## Done when

- [ ] Home's background is `#3A6EA5` and the bar is a darker shade of the
      same blue, on both pages
- [ ] Every tile on Home has the same fill; no other hue appears on Home
      or the bar (white and blue-white text aside)
- [ ] The Reference page looks exactly as it did before this task: same
      dark background, same tile tints, same text colours
- [ ] `OS/HomeModel.qml` is unchanged
- [ ] Each role in the table is one named value in `OS/Theme.qml`
- [ ] Every text colour meets the contrast rule, with the ratios listed in
      the report
- [ ] No literal colours in the components
- [ ] `.ui.qml` files still contain no JavaScript
- [ ] All checks below pass, or the report says exactly which could not be
      run and why

## Checks to run

- `qmllint -I .` on every changed QML file. No new warnings.
- A headless run that loads the project and confirms the background and
  bar colours on Home, one tile's fill on Home, and one tinted tile's fill
  on the Reference page.
- The contrast ratios, computed, in the report.

## Out of scope

- Changing layout, sizes, type, or motion
- Changing the Reference page's look
- A light mode, or letting the user pick the colour
- Anything in `Dependencies/`, `App/`, `cmake/`, `qds.cmake`,
  `OS.qmlproject`, or the top-level `CMakeLists.txt`
