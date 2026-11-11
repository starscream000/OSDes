# Task 006: More apps, from one list (Music and Photos)

Status: ready
Branch: task/006-apps-as-a-list
Depends on: 005 (merged)

## Goal

Files is no longer special. Every app is an entry in one list of apps,
described by data, and the shell draws any app's full view and mini block
from that list. Two more sample apps, Music and Photos, are added as data
to prove it, and several apps can run at the same time.

## Background

Read the decisions "Apps are contexts, not windows" and "Apps have sizes
and live on the one grid" in `docs/DECISIONS.md`.

Today `Shell.qml` names `filesContext` directly, and `ContextStage.qml`
declares one full view and one mini block for Files. A second app would
need new code in both. After this task, adding an app means adding data.

### One list of apps

Create one catalogue of apps in the `OS` module. Each app has:

- an id and a name (the name its Home tile and bar button show)
- its headings, in order
- for each heading, its content (see below)

`Shell` looks apps up in the catalogue. It contains no app's id or name.
A Home tile opens the app whose name matches the tile's name, as now.

### One shape of content

Every app's content for a heading has the same shape, drawn by one view:

- **Tiles** first, on the home grid, wrapping. Each has a name and may
  have a size (small, medium, wide, large); medium if not given.
- **Rows** below them. Each has a name on the left and up to two short
  details on the right in secondary text.
- Either part may be empty.

`FolderView.qml` and `FileRow.qml` become this general view and row.
Rename them and their properties so nothing in them says "file" or
"folder". Files' data moves to the same shape as the other apps'.

### The three sample apps

All mock data. Nothing plays, loads, or reads the disk. Clicking a tile or
row writes its name to the console.

| App | Headings | Tiles | Rows |
|---|---|---|---|
| Files | Recent, Home, Documents, Downloads | Folders, medium | Files: name, size, date (as now) |
| Music | Listen now, Albums, Artists, Playlists | Albums, artists, or playlists; a mix of medium and wide | Tracks: name, artist, length. "Albums" and "Artists" have tiles only |
| Photos | Recent, Albums, Favourites | Photos as plain tiles in a mix of all four sizes, named by where or when they were taken; no rows at all | None |

Give each heading enough items to need scrolling in the mini block: at
least 6 tiles, and where a heading has rows, at least 8.

Use invented album, artist, and track names. Do not use real ones. No
image files.

### Several apps at once

- Any number of apps can be running. The bar lists them in the order they
  were opened.
- **At most one app is full.** Opening or enlarging another app while one
  is full sends the first to hidden (running, no line under its bar
  button) and brings the other to the front with the usual move: the
  headings swap along the line and the new content grows from its origin.
- **Any number of apps can be mini on Home.** Each takes one slot at the
  start of the Apps panel, in the order they became mini, and the tile
  groups follow them. Slots wrap like groups.
- Size controls, close, and the keys from task 005 act on one app: the
  full app, or the mini block under the pointer or last clicked.
- Each app remembers its own last size and, while running, its own
  current heading.

### Behaviour settled from task 005's review

1. Going to mini scrolls the Apps panel so the block is in view. Opening
   an app straight into mini from its tile does the same.
2. Going Home from full (Home button or Escape) reverses whatever brought
   the app to full: it shrinks to its Home tile if it was opened from the
   tile, otherwise to its bar button.
3. A press anywhere outside a mini block, including on the bar, ends that
   block's "last clicked" state.
4. Wheel scrolling inside a mini block stops at the end of the block's
   content. It does not carry on into the Apps panel.
5. A closed app starts fresh: first heading, scrolled to the top.
6. Starting a second move while one is running must not make anything
   jump. If you cannot make every combination smooth, make the common
   ones smooth (Escape during open, enlarge during shrink) and list the
   rest in your report.

## Files you may change

- Any existing `.qml` or `.ui.qml` file in `OSContent/`, including
  renaming `FolderView.qml` and `FileRow.qml` with `git mv`
- New `.qml` and `.ui.qml` files in `OSContent/`
- `OSContent/CMakeLists.txt` — only the `QML_FILES` list
- Any existing `.qml` file in `OS/` except `Constants.qml`,
  `EventListModel.qml`, and `EventListSimulator.qml`
- New `.qml` files in `OS/`
- `OS/qmldir`
- `OS/CMakeLists.txt` — only the `QML_FILES` list and singleton entries

Keep both `QML_FILES` lists in sorted order. Qt Design Studio rewrites
them while it has the project open, so check them just before you commit.

## Done when

- [ ] `Shell.qml` and the stage contain no app's id or name; apps come
      from one catalogue
- [ ] Files, Music, and Photos each open from their Home tile, in full
      size, with their own headings and content
- [ ] All three use the same content view and the same row component, and
      neither has "file" or "folder" in its name or properties
- [ ] Each app can go mini, enlarge, close, and reopen in its last size,
      as Files did in task 005
- [ ] With one app full, opening another from the bar swaps them with the
      move, and the first stays running, hidden
- [ ] Two or three apps can be mini on Home together, each in its own
      slot, with the groups after them and nothing overlapping at rest
- [ ] The bar lists every running app with the right line: full, short,
      or none
- [ ] The six points under "Behaviour settled from task 005's review"
      hold, or the report says exactly which part of point 6 does not
- [ ] Adding a fourth app would need only a new catalogue entry and its
      data; say in the report exactly what you would add
- [ ] The Reference page is unchanged
- [ ] Every move takes 300 ms or less, with durations in the theme
- [ ] No literal colours or sizes in components; `.ui.qml` files contain
      no JavaScript; new files are registered and both lists are sorted
- [ ] All checks below pass, or the report says exactly which could not be
      run and why

## Checks to run

- `qmllint -I .` on every changed or new QML file. No new warnings.
- A headless run that confirms: each app opens from its tile with its own
  headings; each goes mini, enlarges, and closes; swapping between two
  full apps from the bar; three mini blocks at once with no overlapping
  rectangles; the bar's lines in each state; the six settled behaviours;
  and the measured move times.
- The Reference page rendered offscreen and compared with the image from
  the main branch.
- A search of the shell and stage for the words "files", "music", and
  "photos" (any case), with the result in the report.

You cannot judge how the motion feels. Say so, and list what the owner
must look at.

## Out of scope

- A Settings app, and any new kind of control such as a switch (next
  task)
- Real music, photos, or files; images of any kind
- Navigating into a folder, album, or photo
- Dragging or resizing mini blocks
- Two apps side by side in full size
- Other window sizes, phones, touch-specific behaviour
- Anything in `Dependencies/`, `App/`, `cmake/`, `qds.cmake`,
  `OS.qmlproject`, or the top-level `CMakeLists.txt`
