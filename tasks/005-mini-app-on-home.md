# Task 005: An app can sit on Home in a small size (Files prototype)

Status: ready
Branch: task/005-mini-app-on-home
Depends on: 004 (merged)

## Goal

An open app is not forced to fill the screen. It has two sizes: **full**,
which is what task 004 built, and **mini**, where the app sits on Home as
a block on the same grid as the tiles, and the tiles flow around it. The
user switches between the two with a visible control. This task builds
that for the sample Files app.

## Background

Read the decision "Apps have sizes and live on the one grid" in
`docs/DECISIONS.md`, and principle 7 in `docs/PLAN.md`.

The idea: the interface should be flexible, as a desktop with windows is,
without free-floating windows that overlap. So an app is always a region
of the one surface, aligned to the grid:

| Size | Where the app is | What is in front |
|---|---|---|
| Full | Fills the content area, under its own headings | The app (task 004) |
| Mini | A block on Home's Apps panel, among the tile groups | Home, with the app visible on it |

Nothing ever overlaps anything else. Changing size is a rearrangement,
like opening.

Task 004 left these pieces, which you build on: `Shell` (`front`,
`open()`, `goHome()`, `runningApps`), `ContextStage`, `ContextView`,
`Rearrangement`, `FolderView`, and the tile and panel components.

### The mini block

- **Size:** the same footprint as one tile group: 8 × 8 grid units, plus
  the group header height above it. It takes one slot in the Apps panel's
  flow of groups, so the groups wrap around it exactly as they wrap around
  each other.
- **Position:** the first slot of the Apps panel. The tile groups follow
  it.
- **Header line** (where a group's label would be): the app's name on the
  left in the group label style. On the right, two small square controls:
  **enlarge** (go to full) and **close**.
- **Body:** a flat fill, one shade darker than the page background, the
  full 8 × 8 units. Inside it, with a small inner margin:
  - a compact heading row: the app's headings in a smaller type size, the
    current one in primary text and the others dimmed, clickable;
  - below it, the current heading's folders and files, using
    `FolderView`, scrolling up and down inside the block.
- Folder tiles and file rows behave as they do in full size.
- The block has no border, shadow, or rounded corners.

### Controls

Every size change has a visible control and a key.

| Action | Control | Key |
|---|---|---|
| Full to mini | A small square control at the right end of the app's heading line, in full size | Ctrl+Down |
| Mini to full | The enlarge control in the block's header | Ctrl+Up, when the pointer is over the block or it was the last thing clicked |
| Close the app | The close control in the block's header; and a close control next to the full-to-mini control in full size | Ctrl+W |
| Back to Home, app stays as it is | The Home button or Escape (unchanged from task 004) | Escape |

Draw the controls from plain rectangles and lines in the theme's primary
text colour: for example a small square for mini, a larger square outline
for enlarge, and a cross for close. Each control is 32 × 32, shows a hover
fill, and has a tooltip-free plain look. Do not copy another system's
window button designs.

### What each action does

- **Full to mini:** the reverse of opening, except the content shrinks
  into the block's slot on the Apps panel, not into the Files tile. Home's
  headings return, Home switches to the Apps panel if it was on another,
  and the tile groups come back from the edges into their new places
  after the block.
- **Mini to full:** the task 004 move, growing from the block. The other
  groups move aside as tiles did.
- **Opening Files from its tile or the bar:** opens in the size it was
  last in. The first time, that is full. If Files is already mini on
  Home, clicking its tile or bar button makes it full.
- **Close:** the app leaves Home and the bar's running apps. The tile
  groups close the gap. From full size, close returns to Home first with
  the reverse move.
- **Home button or Escape from full:** as in task 004, the app stays
  running in full size and is not shown on Home.

When the block appears on or leaves the Apps panel, the groups move to
their new places with a short animation. They do not jump.

### The bar

A running app's bar button is marked with the full-width line when the
app is in front (full size), and with a short centred line when it is
sitting on Home in mini size. No line when it is running but not shown.

### State

`Shell` holds each running app's size (full or mini) and whether it is
shown. Keep it as data on the running app, so a second app later needs no
new properties.

## Files you may change

- Any existing `.qml` or `.ui.qml` file in `OSContent/`
- New `.qml` and `.ui.qml` files in `OSContent/`
- `OSContent/CMakeLists.txt` — only the `QML_FILES` list, kept in sorted
  order
- `OS/Theme.qml`, `OS/Shell.qml`, `OS/RunningAppsModel.qml`
- New `.qml` files in `OS/`
- `OS/qmldir`
- `OS/CMakeLists.txt` — only the `QML_FILES` list and singleton entries,
  kept in sorted order

## Done when

- [ ] In full size, Files' heading line has a mini control and a close
      control at its right end
- [ ] The mini control puts Files on Home's Apps panel as an 8 × 8 unit
      block in the first slot, with the tile groups flowing after it, and
      Home's headings back in place
- [ ] The block shows the app's name, enlarge and close controls, a
      compact clickable heading row, and the current heading's folders
      and files, scrolling inside the block
- [ ] Enlarge returns Files to full size with the move growing from the
      block
- [ ] Close removes Files from Home and from the bar, from either size,
      and the groups close the gap
- [ ] Files reopens in the size it was last in; clicking its tile or bar
      button while it is mini makes it full
- [ ] Ctrl+Down, Ctrl+Up, and Ctrl+W work as in the table
- [ ] Groups and the block move to new places with an animation, never a
      jump, and nothing overlaps at rest
- [ ] The bar shows the full line, the short line, or no line as
      described
- [ ] Everything from task 004 still works: opening from the tile and the
      bar, headings by click, drag, and keys, Home and Escape, and the
      Reference page unchanged
- [ ] Every move takes 300 ms or less, with durations in the theme
- [ ] No literal colours or sizes in components; `.ui.qml` files contain
      no JavaScript; new files are registered
- [ ] All checks below pass, or the report says exactly which could not be
      run and why

## Checks to run

- `qmllint -I .` on every changed or new QML file. No new warnings.
- A headless run that confirms each row of "What each action does", the
  three keys, the bar's three states, that the block and the groups do not
  overlap at rest (compare their rectangles), and the measured move times.
- The Reference page rendered offscreen and compared with the image from
  the main branch.
- Contrast ratios for any new text and surface pairs, listed in the
  report, against the rule in task 003's brief.

You cannot judge how the motion feels. Say so, and list what the owner
must look at.

## Out of scope

- Dragging the block to another slot or panel
- Resizing the block by dragging, or any size other than full and mini
- Two apps at once, or two apps side by side
- Any app other than Files
- Making contexts a general list (a later task)
- Reading real files
- Other window sizes, phones, touch-specific behaviour
- Anything in `Dependencies/`, `App/`, `cmake/`, `qds.cmake`,
  `OS.qmlproject`, or the top-level `CMakeLists.txt`
