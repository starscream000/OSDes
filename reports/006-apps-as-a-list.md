# Report — Task 006: More apps, from one list (Music and Photos)

Branch: task/006-apps-as-a-list
Result: complete

## What was done

- **One catalogue** (`OS/AppCatalogue.qml`, `OS/AppEntry.qml`, new):
  - Each `AppEntry` has `context` (the id), `name`, and `content`: a
    ListModel with one element per heading. Each heading has `tiles`, each
    with `name` and an optional `size`, and `rows`, each with `name`,
    `detail`, and `secondDetail`.
  - The catalogue lists Files, Music, and Photos, and finds an entry by id
    (`find`) or by name (`named`).
- **Data for each app** (`OS/FilesModel.qml` reshaped; `OS/MusicModel.qml`
  and `OS/PhotosModel.qml`, new):
  - **Files**: as before, in the new shape. Each heading now has 6 folders
    (two more per heading than before), and its tiles give no size, so they
    are medium.
  - **Music**: Listen now, Albums, Artists, Playlists. Tiles are medium and
    wide. Listen now and Playlists have 8 tracks each; Albums and Artists
    have tiles only. Every name is invented.
  - **Photos**: Recent, Albums, Favourites. Each heading has 6–8 plain
    tiles in all four sizes, named by place or date, and no rows.
- **`Shell`** (`OS/Shell.qml`) names no app:
  - `filesContext` is gone. Names and ids come from `Shell.catalogue`.
  - At most one app is full: making one full sends the one in front to
    hidden.
  - Each running app also keeps its current `heading`.
  - `arranged(context, was, now, from)` now carries the tile or bar button
    the move started from.
  - A new `started(context)` signal tells the stage an app is fresh.
- **One content view and row**:
  - `FolderView.qml` became `ContentView.qml` and `FileRow.qml` became
    `ContentRow.qml`, both renamed with `git mv`.
  - Their properties are now `tiles`, `rows`, `detail`, and
    `secondDetail`. A click logs `Row clicked: <name>`.
  - The tile part or the row part is hidden when empty.
  - The theme's `file…` sizes became `row…` and `tilesRowsGap`. The two
    detail columns are 180 and 140 px wide so artist names fit, and long
    details end in an ellipsis.
  - A `Tile` with no size is now medium.
- **The stage** (`OSContent/ContextStage.qml`):
  - It draws one full view per catalogue entry (a Repeater) and one block
    per app sitting in mini.
  - Every move goes from a `leaving` context to an `arriving` one, so the
    same code plays Home to app, app to Home, and app to app.
  - In a swap between two full apps, the leaving app stays whole underneath.
    The arriving app grows on top from its origin while the headings swap
    along the line.
- **Mini blocks** (`OSContent/AppsPanel.qml`, `OSContent/MiniApp.qml`):
  - The Apps panel holds any number of block slots, one per mini app, in
    the order they became mini. Slots wrap like groups, and the groups
    follow.
  - When another app comes to the front, blocks move aside as the tiles do.
- **The bar** (`OSContent/Bar.qml`) can give the button of a running app,
  so moves can start from it and return to it.
- **Presses** (`OSContent/PressWatcher.qml`, new; `Screen01.ui.qml`):
  - The watcher lies over the whole shell and reports each press without
    taking it.
  - `Screen01.ui.qml` gives the stage the bar and the watcher as
    declarative bindings, with no script.
- **The six settled behaviours:**
  1. Going to mini scrolls the Apps panel so the block is fully in view. It
     scrolls at once during the move, while Home is out of view. Opening
     straight into mini from the tile scrolls with a short animation.
  2. Home or Escape from full shrinks the app into its Home tile if it grew
     out of it, and otherwise into its bar button.
  3. Any press outside a block ends its "last clicked" state, including a
     press on the bar.
  4. The block's body swallows wheel movement its content does not use, so
     scrolling stops at the end of the block.
  5. When an app starts again after closing, its view jumps to the first
     heading and every heading scrolls to the top.
  6. A move that is the exact reverse of the one under way plays back from
     where it is. The roles, heading directions, and grow directions swap,
     and the progress becomes 1 − progress, so the picture does not change.
     This covers Escape during open and enlarge during shrink, and also
     shrink during enlarge, close during open, and opening the leaving app
     again during a swap.
- **Registration:**
  - `AppCatalogue`, `AppEntry`, `MusicModel`, and `PhotosModel` are in
    `OS/qmldir` and the `OS` list.
  - `ContentRow`, `ContentView`, and `PressWatcher` replace `FileRow` and
    `FolderView` in the `OSContent` list.
  - Both lists are sorted.

## Done-when checklist

- [x] `Shell.qml` and the stage contain no app's id or name; apps come
      from one catalogue
- [x] Files, Music, and Photos each open from their Home tile, in full
      size, with their own headings and content
- [x] All three use the same content view and the same row component, and
      neither has "file" or "folder" in its name or properties
- [x] Each app can go mini, enlarge, close, and reopen in its last size,
      as Files did in task 005
- [x] With one app full, opening another from the bar swaps them with the
      move, and the first stays running, hidden
- [x] Two or three apps can be mini on Home together, each in its own
      slot, with the groups after them and nothing overlapping at rest
- [x] The bar lists every running app with the right line: full, short,
      or none
- [x] The six points under "Behaviour settled from task 005's review"
      hold, or the report says exactly which part of point 6 does not
- [x] Adding a fourth app would need only a new catalogue entry and its
      data; say in the report exactly what you would add
- [x] The Reference page is unchanged
- [x] Every move takes 300 ms or less, with durations in the theme
- [x] No literal colours or sizes in components; `.ui.qml` files contain
      no JavaScript; new files are registered and both lists are sorted
- [x] All checks below pass, or the report says exactly which could not be
      run and why

## Checks run

| Check | Result |
|---|---|
| `qmllint -I .` on every changed and new QML file (6.8.7, from the Qt Design Studio install) | **Passed. No new warnings.** The only message is the existing "unused import OS" note in `App.qml`. |
| Headless `qmltestrunner` run of `Screen01`, `QT_QPA_PLATFORM=offscreen` (test kept in the scratchpad, not committed) | **12 of 12 passed on each of three runs, with no QML warnings.** Details below. |
| Reference page rendered offscreen from this branch and from `main` | **Identical** (SHA-256 `CD00E3CA…BB0A32`, the same as in tasks 003–005). |
| Case-insensitive search of `OS/Shell.qml` and `OSContent/ContextStage.qml` for "files", "music", and "photos" | **No matches.** |
| Search of `ContentView.qml` and `ContentRow.qml` for "file" and "folder" | **No matches.** |
| Search of changed components for colour literals and bare sizes | **None found.** No new colours were added, so there are no new contrast pairs. |
| Changed files against the brief's list | All are allowed. In the CMake files only the `QML_FILES` lists changed. |

What the headless run confirmed:

**Each app from its tile**
- Files, Music, and Photos each grow out of their own tile and show their
  own headings.
- Every heading has at least 6 tiles.
- Row counts per heading:

  | App | Rows per heading |
  |---|---|
  | Files | 8, 8, 8, 8 |
  | Music | 8, 0, 0, 8 |
  | Photos | 0, 0, 0 |

- Tile sizes: Files medium only, with no size given; Music medium and
  wide; Photos all four sizes.
- Escape shrinks each back into its tile, and the app stays running with
  no line.
- The bar lists Files, Music, Photos in the order they were opened.

**Swap**
- With Music full, Files from the bar makes Music hidden at once.
- Mid-move, both apps show and Home does not. Music's box stays whole,
  Files' box grows, and the headings swap without overlapping.
- At the end, Files has the full line and Music and Photos have none.
- Escape then shrinks Files into its bar button, since it came from the
  bar.

**Each app's sizes**
- For each app: the mini control makes a block grown from its body, with
  the short line. Enlarge and the close control from full each work.
- Reopening from the tile gives full. Ctrl+Down, then the block's close
  control, then the tile again gives mini.

**Three blocks**

| Item | x | y |
|---|---|---|
| Block, Music | 120 | 0 |
| Block, Files | 810 | 0 |
| Block, Photos | 120 | 734 |
| Everyday | 810 | 734 |
| Work | 120 | 1468 |
| Play | 810 | 1468 |

- No two rectangles overlap at rest.
- Each new block was fully in view after it appeared.
- All three show the short line, and the Home button is active.

**Keys and presses**
- A press on a block's header sets "last clicked", and a press on the bar
  clears it. Ctrl+Up then does nothing.
- With the pointer over the Files block, Ctrl+Up enlarges Files only.
  The other blocks move aside and come back.
- Ctrl+Down returns Files to mini at the end of the slot order:
  music, photos, files.
- Ctrl+W on the last-clicked Music block closes it and the groups close
  the gap.

**Behaviour 4**
- Six large wheel steps scroll the Photos block to its end, and the Apps
  panel does not move.

**Behaviour 5**
- Photos, closed on heading 3 and scrolled, reopens on heading 1, at the
  top.
- While running, Photos keeps its heading across a swap and back.

**Behaviour 6**
- Escape about 90 ms into an open, and enlarge about 90 ms into a shrink.
- Before and after the key, these values are identical: the content box
  position and size, both heading rows, and another Home tile's position.
- The box then shrinks (or grows) from there, and everything ends at rest
  with nothing overlapping.

**Reference**
- No running app has a line on the Reference page.
- Its Music tile only logs.

**Timing**, from the click or key to the end of the move, over three
runs:

| Move | Done after |
|---|---|
| Open from the tile | 263–270 ms |
| Back to the tile or bar with Escape | 261–271 ms |
| Swap two full apps from the bar | 245–260 ms |
| Full to mini (control, Ctrl+Down) | 259–286 ms |
| Mini to full (control, Ctrl+Up) | 258–273 ms |
| Close from full | 257–272 ms |
| Reopen from the tile | 267–271 ms |

Durations are in the theme: `contextMoveDuration` and `slotMoveDuration`,
250 ms each. A move reversed partway takes the remaining share of the
duration.

**What the owner needs to look at.** I cannot judge how the motion
feels. Please run it and check:

- **The swap between two full apps:** the new app growing over the old
  one from its bar button, and the headings swapping.
- **Escape during an open, and enlarge during a shrink:** the move turns
  around in place.
- **Three blocks on Home:** the groups flowing after them, the scroll that
  brings a new block into view, and other blocks moving aside when one
  app grows.
- **Music and Photos:** the content in full and in mini, including Photos'
  mixed tile sizes, which wrap left to right and leave ragged gaps.
- **The wider detail columns.** Files' rows look a little different from
  task 005.
- That `Screen01.ui.qml` still opens in the visual editor. It gained two
  bindings and a `PressWatcher`, but no script.

## Not done

- Nothing from the brief.

### The parts of point 6 that are not smooth

A new move that is not the exact reverse of the one under way first ends
that move at once, which is a jump, and then starts. These are the cases:

- **Escape or the Home button during a swap** between two full apps. The
  swap ends at once, then the arriving app goes home.
- **Opening a third app from the bar during a move.** The move under way
  ends at once.
- **Escape during mini to full** turns around smoothly into the block.
  Because the app is now hidden rather than mini, the block then leaves
  and the groups close the gap with the slot animation. That is two steps,
  but neither jumps.

## Adding a fourth app

For example, Notes (Home already has a Notes tile):

1. `OS/NotesModel.qml`: a ListModel in the shape `AppEntry` describes. One
   element per heading, each with `heading`, `tiles`, and `rows`.
2. One entry in `OS/AppCatalogue.qml`:

   ```qml
   AppEntry { context: "notes"; name: qsTr("Notes"); content: NotesModel {} }
   ```

3. Register `NotesModel.qml` in `OS/qmldir` and in the `OS` `QML_FILES`
   list.

Nothing in `Shell`, the stage, the bar, or the views changes. The Home tile
opens it because its name matches the entry's name.

## Questions

- **Photos' mixed tile sizes wrap left to right.** A large tile next to
  small ones leaves gaps, because the brief's content shape places tiles in
  a flow, not at grid positions as Home's groups do. Packing them would
  need positions in the data or an automatic packer.
- **The detail columns are wider for every app.** One width now has to
  fit both file sizes and artist names, so Files' rows are not quite as
  they were in task 005.

## Noticed but not done

- **The bar does not scroll.** With many apps running, the bar's buttons
  would run into the right-hand group; nothing limits or scrolls them yet.
- **Names are not unique keys.** A Home tile opens an app by its name, as
  before. Two apps with the same name, or a translated name that differs
  between the tile and the catalogue, would break that. A `context` field
  in `HomeModel` would be sturdier.
- **The app views are always created.** Every catalogue app has its full
  view from start-up, even before it runs. That is fine for three apps; a
  large catalogue should create views only for running apps.
