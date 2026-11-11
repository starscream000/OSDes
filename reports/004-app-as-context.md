# Report — Task 004: Opening an app rearranges the home (Files prototype)

Branch: task/004-app-as-context
Result: complete

## What was done

- **One component draws every context.** `OSContent/ContextView.qml`
  draws a context's heading row and, below it, the sideways pager with
  one panel per heading. Heading clicks, drags, and the Left and Right
  keys all work in it. The pager logic was moved here from `HomePage`
  unchanged. Home and Files are two instances of it; there is no Files
  screen. `PanelTabs` now takes its names from a `headings` property
  instead of a fixed list.
- **The stage.** `OSContent/HomePage.qml` became
  `OSContent/ContextStage.qml`, renamed with `git mv`, because it now
  holds every context and not only Home. It stacks Home's view and Files'
  view, and drives one `progress` value from 0 (Home in front) to 1
  (Files in front) with a `NumberAnimation`. Everything in the move reads
  that one value, so going back is the exact reverse. `Screen01.ui.qml`
  shows `ContextStage` where it showed `HomePage`.
- **The move** (`OSContent/Rearrangement.qml`, shared with Home's tiles):
  1. **Headings.** The leaving and arriving names move together as one
     strip along the heading line, with the arriving names directly
     behind the leaving ones. The line is clipped at the page margin, so
     the leaving names slide out past it. The names never overlap or
     fade, and the line is never empty.
  2. **Content.** Files' content area is revealed through a box that
     grows from the origin's rectangle to the full content area. The box
     fill blends from the tile colour to the background colour, so the
     tile appears to open into the app. The content itself does not
     scale; it is revealed in place.
  3. **Tiles.** Each other tile on Home, and each group label, moves away
     from the origin's centre toward the nearest content area edge on
     that side. Each item goes horizontally or vertically, whichever edge
     is nearer, and leaves the area completely by the end. Items going
     the same way all travel the full width or height of the area, so
     they move at the same speed and keep their formation. The clicked
     tile stays where it is.
  4. **Bar.** Files is added to the running apps and marked as in front,
     and Home is no longer marked active.
- **Contexts and running apps are state** (`OS/Shell.qml`):
  - `front` holds the context in front, and `origin` holds the item the
    move grows from.
  - `open(context, from)` and `goHome()` change them.
  - `runningApps` is the one shared `RunningAppsModel`. It starts empty;
    the three fixed sample entries are gone.
  - A Home tile opens a context when its name matches the context's name
    (`Shell.contextFor`). Only Files matches. Tiles on the Reference page
    and folder tiles in Files are given no `move`, so they never open
    anything.
- **Going back.** The Home button and Escape call `Shell.goHome()`. Home's
  view is never destroyed, so it comes back on the panel and at the
  scroll position it was left at. Files keeps its current heading too.
- **The bar.** Clicking Files in the bar calls `Shell.open()` with the bar
  button as the origin, so the content grows up out of the bar. The
  button is marked while Files is in front on the home page. The Home
  button is active only when Home is in front. When opened from the
  Reference page, Files comes back already in front.
- **Files mock data** (`OS/FilesModel.qml`): four headings (Recent, Home,
  Documents, Downloads). Each has 4–6 folders and 8 files with ordinary
  names, sizes, and dates.
  - `FolderView.qml` shows a heading's folders as medium `Tile`s on the
    home grid, with the files below them as `FileRow`s.
  - A file row shows the name on the left and the size and date on the
    right in secondary text. It turns a shade darker on hover.
  - Clicking a folder logs `Tile clicked: <name>`, and clicking a file
    logs `File clicked: <name>`.
- **Theme** (`OS/Theme.qml`):
  - Motion: `contextMoveDuration` (250 ms) and `contextMoveEasing`
    (`Easing.OutCubic`).
  - File row sizes and the gap between the folders and the files.
  - A `rowHover` colour in the `Look` type. Home uses `#33649A`, which
    keeps both text colours readable on it: white 6.12:1, secondary
    5.53:1. Reference uses `#22252B`, but no row is drawn there.
- **Registration.** `FilesModel` is in `OS/qmldir`, and both `QML_FILES`
  lists now include the new files, with `HomePage.qml` swapped for
  `ContextStage.qml`. As the brief asked, both lists are committed in Qt
  Design Studio's alphabetical order, in a separate commit made before
  the code changes.

## Done-when checklist

- [x] Clicking the Files tile turns the home into Files as described in
      "The rearrangement", with no frame, title bar, overlay, or blank
      moment
- [x] The heading row shows Files' four headings and moves between them
      by click, sideways drag, and Left and Right keys, exactly as Home's
      do
- [x] Each Files heading shows at least 4 folder tiles and 8 file rows
      from mock data
- [x] The Home button and the Escape key return to Home with the reverse
      move, to the same panel and scroll position as before
- [x] The bar lists Files once it has been opened, marks whichever
      context is in front, and clicking Files there returns to it
- [x] Home and Files are both drawn by the same heading and content
      components; there is no separate "Files screen"
- [x] The Reference page still works and looks the same
- [x] The move takes 300 ms or less, with durations in the theme
- [x] No literal colours or sizes in components; `.ui.qml` files contain
      no JavaScript; new files are registered
- [x] All checks below pass, or the report says exactly which could not be
      run and why

## Checks run

| Check | Result |
|---|---|
| `qmllint -I .` on every changed and new QML file (6.8.7, from the Qt Design Studio install) | **Passed. No new warnings.** The only message is the existing "unused import OS" note in `App.qml`. |
| Headless `qmltestrunner` run of `Screen01`, `QT_QPA_PLATFORM=offscreen` (test kept in the scratchpad, not committed) | **9 of 9 passed, with no QML warnings, on each of several runs.** Details below. |
| Reference page rendered offscreen and compared with the image from `main` | **Identical** (SHA-256 `CD00E3CA…BB0A32`, the same as in task 003). |
| Search of `OSContent/*.qml` for colour literals and bare sizes, and of `*.ui.qml` for functions, handler blocks, and arrows | **None found.** The only bare numbers are the starting indexes 0 and 1. |
| Changed files against the brief's list | All are allowed. In the CMake files only the `QML_FILES` lists changed. |

What the headless run confirmed:

**Start**
- Home is in front, on Apps, with focus.
- No running apps are listed, and the Home button is active.

**Opening from the Files tile**
- `Shell.front` changes, and the move animation is already running when
  the click handler returns.
- From the click frame on, both views are visible.
- The origin is the tile's rectangle.
- At sampled frames mid-move:
  - both views are visible;
  - the content box is larger than the tile and smaller than the area;
  - Home's names have moved left and Files' names are coming in from the
    right;
  - the two sets of names never overlap.
- At the end:
  - the box fills the area exactly and Home's view is hidden;
  - the Files tile has not moved;
  - every other tile ends fully outside the content area, having moved
    away from the origin along one axis;
  - Files is listed in the bar and marked, and Home is not active;
  - Files has focus.

**Files headings**
- Clicking Documents goes to heading 2 and the pager rests there.
- Right moves on and stops at the end; Left moves back down to 0.
- A long sideways drag moves to the next heading and rests on it.
- Each of the 4 headings shows 4–6 medium folder tiles in the home tile
  fill and 8 file rows.
- A folder click and a file click each log the name, and Files stays in
  front.
- A row turns `#33649A` on hover.

**Escape**
- Home returns on Apps, at the same scroll offset (40 px), with every
  tile back in place.
- The Home button is active, and Files is still listed but not marked.
- Home has focus, and the arrow keys work again.

**Reopening from the bar**
- The origin is the bar button, below the content area.
- Files comes back on the heading it was left on.
- The Home button returns to the same Home panel and scroll position.

**Reference**
- With Files open, Reference shows the reference page.
- Nothing is marked as in front there, and the Reference tile named Files
  only logs.
- Files in the bar brings the home page back with Files in front.
- After returning Home, other Home tiles (Mail) only log.

**Timing**, from the click to the end, measured from the progress changes
with nothing else running during the timed moves:

| Move | First visible change after the click | Done |
|---|---|---|
| Open from the tile | 25–28 ms | 259–263 ms |
| Back home with Escape | 17–19 ms | 258–259 ms |
| Reopen from the bar | 22–27 ms | 251–265 ms |

The animation starts inside the click handler. The time before the first
change is the next animation tick plus one rendered frame. Offscreen
frames here arrive about every 15 ms. I first used 280 ms, which measured
up to 295 ms from click to end, and lowered it to 250 ms to leave room on
slower machines.

**What the owner needs to look at.** I cannot judge how the motion
feels. Please run it and check:

- How the open feels: the speed (`Theme.contextMoveDuration`), the easing
  (`Theme.contextMoveEasing`), and whether the box growing out of the
  tile, blending from the tile colour to the background, reads as "the
  tile becomes the app".
- The headings moving as one strip: whether the arriving names following
  the leaving ones reads well, and whether clipping at the page margin
  looks right.
- The tiles leaving: each goes to its nearest edge, and same-direction
  tiles keep formation. Tiles going in different directions can still
  briefly cross each other's path.
- Opening Files from the bar, where the content grows up out of the bar.
- The Files layout: folder tiles, row spacing, and the size and date
  columns.
- That `Screen01.ui.qml` still opens in the visual editor.

## Not done

- Nothing from the brief.

## Questions

- **The reverse move goes back to the item the open started from.** When
  Files was opened from its tile, Home and Escape shrink it back into that
  tile, as the brief describes. When it was reopened from the bar, it
  shrinks back into the bar button. That makes every return the exact
  reverse of its open. The alternative is to always shrink into the Files
  tile whenever it is on screen. Say if you'd prefer that.
- **Home's All apps edge does not move.** The edge of the All apps panel
  that peeks in at the right ("All you…") is not a tile, so it stays
  still until the growing content covers it. I moved the group labels
  along with the tiles; the peek could move the same way if you'd like.
- **Tiles open contexts by name.** `HomeModel.qml` was not on the list of
  files I could change, so a tile is linked to Files by its name, which
  is the same `qsTr("Files")` in both places. A `context` field in
  `HomeModel` would be sturdier. That is a small later change.
- **File names are not translated.** File names, sizes, and dates in the
  mock data are plain strings, not `qsTr()`, because they stand for data
  on disk rather than interface text. The headings and folder names do
  use `qsTr()`.

## Noticed but not done

- The stage currently knows one app context (Files) by name: it has a
  `filesView` and a `FilesModel`. A second app will need a small list of
  contexts and a view per running app. That is out of scope here because
  the brief has only Files.
- The `Rearrangement` object is handed down to the tiles
  (`AppsPanel` → `TileGroup` → `Tile`), in the same way as `look`. Future
  widgets in the Now panel will need it too if they should move aside.
- Clicking a different context in the middle of a move (for example Home,
  then immediately Files again) reverses from wherever the move is. That
  works, but it was only checked by reading the code, not in a test.
