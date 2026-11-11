# Task 004: Opening an app rearranges the home (Files prototype)

Status: draft
Branch: task/004-app-as-context
Depends on: 003 (merged)

## Goal

Opening an app must not look like a new window appearing. The home itself
rearranges to become the app: the headings change to the app's own, the
content area fills with the app's content, the other home items move
aside, and the bar updates. This task builds that behaviour once, with a
sample Files app made of mock data.

## Background

Read the decision "Apps are contexts, not windows" in `docs/DECISIONS.md`.

The idea: the shell always shows exactly one **context**. Home is a
context. An open app is a context. Every context is drawn with the same
parts in the same places:

| Part | On Home | In Files |
|---|---|---|
| Headings (the tab row) | Now, Apps, All apps | Recent, Home, Documents, Downloads |
| Content area | The panel for the current heading | The folder for the current heading |
| Bar | Home marked active | Files marked as the app in front |

Because both use the same components, colours, grid, and type, moving from
one to the other is a rearrangement, not a switch of screens.

### What a context provides

A context is data, not a special screen:

- a name ("Files")
- its headings (a list of names) and which one is current
- for each heading, what to show in the content area

`HomePage.qml` currently owns the tabs and panels directly. After this
task, one component draws the headings and the content area for whichever
context is current, and Home is the first context.

### The sample Files context

All mock data. Nothing reads the real disk.

- **Headings:** Recent, Home, Documents, Downloads.
- **Content for a heading:** folders first, shown as tiles on the same
  grid as Home (medium size, same `Tile` component, name as label). Below
  them, files as plain rows: name on the left, size and date on the right
  in secondary text, with a thin shade change on hover.
- At least 4 folders and 8 files per heading, with ordinary names.
- Clicking a folder or file writes its name to the console. Nothing opens.

### The rearrangement

Clicking the **Files** tile on Home's Apps panel opens the Files context.

1. The headings change in place: the old names move out and the new names
   move in along the same line. The row never disappears.
2. The clicked tile is the origin: Files' content grows out from that
   tile's position to fill the content area.
3. The other tiles move away from the clicked tile, toward the nearest
   edge of the content area, and are gone by the time the content has
   filled it.
4. In the bar, Files appears among the running apps and is marked as in
   front; Home is no longer marked active.

Returning to Home (the Home button in the bar, or the Escape key) plays
the same thing in reverse: the content shrinks back to the Files tile and
the other tiles return to their places.

Timing: the whole move takes 300 ms or less, starts on the same frame as
the click, and uses values from the theme. Nothing fades to black, no
frame or title bar is drawn, and no overlay covers the screen.

Only the Files tile opens a context. Other tiles keep writing a line to
the console.

### Running apps in the bar

The bar's sample running apps become real state: a context that has been
opened stays in the list after you return to Home, and clicking it in the
bar goes back to it using the same rearrangement (growing from its bar
button, since there may be no tile on screen). Remove the three fixed
sample entries.

## Files you may change

- Any existing `.qml` or `.ui.qml` file in `OSContent/`
- New `.qml` and `.ui.qml` files in `OSContent/`
- `OSContent/CMakeLists.txt` — only the `QML_FILES` list
- `OS/Theme.qml`, `OS/Shell.qml`, `OS/RunningAppsModel.qml`
- New `.qml` files in `OS/`
- `OS/qmldir`
- `OS/CMakeLists.txt` — only the `QML_FILES` list and singleton entries

## Done when

- [ ] Clicking the Files tile turns the home into Files as described in
      "The rearrangement", with no frame, title bar, overlay, or blank
      moment
- [ ] The heading row shows Files' four headings and moves between them
      by click, sideways drag, and Left and Right keys, exactly as Home's
      do
- [ ] Each Files heading shows at least 4 folder tiles and 8 file rows
      from mock data
- [ ] The Home button and the Escape key return to Home with the reverse
      move, to the same panel and scroll position as before
- [ ] The bar lists Files once it has been opened, marks whichever
      context is in front, and clicking Files there returns to it
- [ ] Home and Files are both drawn by the same heading and content
      components; there is no separate "Files screen"
- [ ] The Reference page still works and looks the same
- [ ] The move takes 300 ms or less, with durations in the theme
- [ ] No literal colours or sizes in components; `.ui.qml` files contain
      no JavaScript; new files are registered
- [ ] All checks below pass, or the report says exactly which could not be
      run and why

## Checks to run

- `qmllint -I .` on every changed or new QML file. No new warnings.
- A headless run that confirms: clicking the Files tile changes the
  current context, the headings, and the bar; each heading shows its
  folders and files; Home and Escape return to Home on the earlier panel;
  reopening from the bar works; and the measured move time is within
  300 ms.

You cannot judge how the motion feels. Say so, and list what the owner
must look at.

## Out of scope

- Reading real files, opening files, or navigating into folders
- Any app other than Files
- Showing two apps side by side
- Apps not written for this shell (ordinary Linux programs)
- A menu or actions area for the app (a later task)
- Other window sizes, phones, touch-specific behaviour
- Anything in `Dependencies/`, `App/`, `cmake/`, `qds.cmake`,
  `OS.qmlproject`, or the top-level `CMakeLists.txt`
