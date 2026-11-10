# Report — Task 002: Our home: the bar and three panels

Branch: task/002-shell-bar-and-home-panels
Result: complete

## What was done

- **Reference screen:** `OSContent/MetroStartReference.ui.qml` is the task
  001 screen moved out of `Screen01.ui.qml`. Only three lines differ: the
  root `id`, and `width`/`height` became `implicitWidth`/`implicitHeight`.
  It still previews at 1920×1080 in Qt Design Studio but fills the page
  area it is given.
- **Shell root:** `OSContent/Screen01.ui.qml` now holds a page area above
  the bar. The page area shows `HomePage` or `MetroStartReference`,
  depending on `Shell.page`. The bar runs along the bottom. The file is
  fully declarative.
- **Shared page state:** `OS/Shell.qml` is a new singleton holding `page`
  (`homePage` or `referencePage`; Home is the default). The bar buttons
  change it; the shell root only reads it.
- **Bar:** `OSContent/Bar.qml` is a 48 px flat strip. Left to right:
  - the Home button;
  - three running apps from `OS/RunningAppsModel.qml`, with Browser marked
    as the app in front;
  - empty space;
  - the "Reference" button;
  - the quick settings button (three lines);
  - the clock, with a right margin.

  Supporting pieces:
  - `OSContent/BarButton.qml` is the shared 48 × 48 button. It has hover,
    pressed, and active colours, and a 2 px bottom line: blue for the active
    page, white for the app in front.
  - `OSContent/BarClock.qml` shows the time (locale short format) above the
    date ("Wed 11 Nov"), updated every second.
  - Running-app and quick-settings clicks write a line to the console.
- **Home page:** `OSContent/HomePage.qml` holds the tabs (`PanelTabs.qml`)
  and a sideways pager of three panels.
  - Each panel is 1760 px wide (page width minus a 160 px peek).
  - The pager always comes to rest with one panel at its left edge. After a
    drag it settles on the nearest panel, or the next one if the drag ended
    in a quick flick (over 400 px/s). It never stops between two panels.
  - Moves animate in 250 ms.
  - Tab clicks, the Left and Right keys, and drags all change the same
    `currentIndex`, which the tabs read.
  - The wheel cannot move between panels.
  - Home opens on Apps.
  - When you come back from Reference, the home page takes keyboard focus
    again.
- **Panels:**
  - `NowPanel.ui.qml` and `AllAppsPanel.ui.qml` each show their one dimmed
    line.
  - `AppsPanel.qml` is a vertical `Flickable` holding a `Flow` of
    `TileGroup`s from `HomeModel`. Groups wrap onto new rows: two per row at
    1920 px, so the third group goes on a second row. The panel scrolls up
    and down by drag and wheel, and never sideways.
- **Theme:** `OS/Theme.qml` gained bar sizes and colours, button states,
  indicator colours, clock and tab type sizes, a dimmed text colour, the
  peek width, the panel top, the panel move duration, and the flick
  threshold.
- **Registration:**
  - `Shell` (singleton) and `RunningAppsModel` are in `OS/qmldir` and the
    `OS/CMakeLists.txt` `QML_FILES` list, with a singleton entry for
    `Shell.qml`.
  - The nine new `OSContent` files are appended to the
    `OSContent/CMakeLists.txt` `QML_FILES` list.
- **`.gitignore`:** added `OS.qrc` and `*.autosave`.

## Done-when checklist

- [x] Running the project opens on Home, on the Apps panel, with the bar
      along the bottom. Verified headless; the owner should run it.
- [x] The bar has the six items in the table, in that order, and the clock
      shows the real time and date
- [x] The Reference button shows the Metro Start screen, looking as it did
      after task 001 and still scrolling sideways; the Home button returns
      to Home; the bar stays visible on both pages
- [x] Home has three panels with the peek of the next panel visible, and
      moves between them by tab click, by sideways drag, and by Left and
      Right keys, with the tabs always showing the current panel
- [x] The Apps panel shows all groups from `HomeModel`, wrapped, and
      scrolls up and down when they do not fit
- [x] Now and All apps show their one line of text
- [x] `MetroStartReference.ui.qml` exists and `TileArea.qml`, `Tile.qml`,
      `TileGroup.qml`, and `HomeModel.qml` are unchanged
- [x] `Screen01.ui.qml` and every other `.ui.qml` file contain no
      JavaScript functions or code blocks
- [x] No literal colours or pixel sizes in the components
- [x] Every new QML file is registered as `CLAUDE.md` requires
- [x] `OS.qrc` is in `.gitignore`
- [x] All checks below pass, or the report says exactly which could not be
      run and why

## Checks run

| Check | Result |
|---|---|
| `qmllint -I . OS/Theme.qml OS/Shell.qml OS/RunningAppsModel.qml OSContent/*.qml` (6.8.7, from the Qt Design Studio install) | **Passed. No new warnings.** The only message is the "unused import OS" note in `App.qml`, which was already there before this task. |
| Headless `qmltestrunner` run, `QT_QPA_PLATFORM=offscreen` (test kept in the scratchpad, not committed) | **10 of 10 passed, no QML warnings.** Details below. |
| Slow-drag check, same setup | **Passed.** Details below. |
| Search of `OSContent/*.qml` for literal colours or sizes, and of `*.ui.qml` for functions and handlers | **None found.** The only numbers left are counts and indexes, and the clock's 1000 ms tick. |
| `git diff main -- TileArea.qml Tile.qml TileGroup.qml HomeModel.qml` | **Empty:** these files are unchanged. |

What the headless run confirmed:

**Startup**
- The project loads and Home is the first page.
- Apps is the first panel, with `contentX` at 1760 and no jump.
- The tabs read "Now | Apps | All apps", with Apps in the primary colour.
- The home page has keyboard focus.

**Tabs**
- Clicking Now goes to panel 0, and the tab colours swap.
- Clicking All apps animates the move: 100 ms in, the strip was part way
  there.
- Clicking Apps goes back to panel 1.

**Keys**
- Right goes to panel 2. Pressed again at the end, it stays.
- Left goes down to panel 0. Pressed again at the start, it stays.
- The tabs follow every move.

**Dragging between panels**
- A fast drag left moves to the next panel, and a fast drag right moves
  back.
- A slow 300 px drag snaps back to the same panel.
- A slow 1000 px drag moves on to the next panel.
- Every drag comes to rest on an exact multiple of 1760.

**Apps panel**
- It shows 3 groups at (0,0), (690,0), and (0,734), so the third group
  wraps onto a second row.
- The content is 1468 px tall in an 892 px panel, so it scrolls.
- The wheel scrolls it vertically, and the panel strip does not move, even
  at the top and bottom edges.
- A vertical drag scrolls it and does not change the panel.

**Placeholders**
- Both placeholder lines are present.

**Bar**
- It is 48 px tall at y = 1032.
- The buttons run left to right in the order of the brief.
- Home is active and Browser is marked as in front.
- The clock sits right of quick settings and showed the real time and date.
- A button's colour changes on hover and changes again on press.
- Clicking prints `Running app clicked: Terminal` and
  `Quick settings clicked`.

**Pages**
- Reference shows at 1920×1032. Home is hidden and the bar stays visible.
- The Reference button shows as active.
- The Reference tile area still scrolls sideways (the wheel moved it to
  180).
- Home brings the home page back, keyboard focus returns, and the arrow
  keys work again.

I also checked offscreen screenshots of Home and Reference. The layout
matched the brief. The offscreen run uses a fallback font.

**What the owner needs to check by running the project:**

- The look of the bar: colours, the blue active line, and the white
  front-app line.
- The tab typeface.
- How dragging between panels feels with a real mouse and touchpad,
  including the flick threshold (`Theme.panelFlickVelocity`).
- That the clock format reads well in your locale.
- That `Screen01.ui.qml` and the other `.ui.qml` files open in the visual
  editor.

## Not done

- Nothing from the brief.

## Questions

- I did not use `ListView` with `SnapOneItem` for the panels. It positioned
  itself before its width was known: it opened on the last panel, and it
  sometimes came to rest between panels after a drag. `HomePage.qml` uses
  a small `Flickable` pager with explicit snapping instead. Say if a
  `ListView` or `SwipeView` is preferred.
- On the last panel (All apps), the 160 px to its right is empty, because
  there is no next panel to peek. The alternative is to rest that panel
  160 px further right, so the edge of Apps shows on the left instead.
  Tell me if you'd prefer that.

## Noticed but not done

- Qt Design Studio was open on the project and wrote
  `OSContent/Screen01.ui.qml.autosave`. I added `*.autosave` to
  `.gitignore` next to `OS.qrc`. Both are generated files. If Qt Design
  Studio still has the old `Screen01.ui.qml` open, saving it there would
  overwrite this branch's version. Reload it before saving.
- Merging task 001 left the CMake `QML_FILES` lists in a different order
  from the task 001 branch. It looks like Qt Design Studio rewrote them. I
  appended the new entries and did not reorder the old ones.
- QtTest's mouse events only advance their timestamps through a `delay`
  argument, not through `wait()`. A test that waits before releasing a drag
  still looks like a fast flick to `Flickable`. This is worth remembering
  for future headless tests.
- The bar's running-app and quick-settings buttons have no tooltips or
  keyboard access yet. That fits milestone 2 or 3 (every input is
  complete).
