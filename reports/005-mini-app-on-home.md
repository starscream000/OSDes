# Report — Task 005: An app can sit on Home in a small size (Files prototype)

Branch: task/005-mini-app-on-home
Result: complete

## What was done

- **State in `Shell`** (`OS/Shell.qml`, `OS/RunningAppsModel.qml`):
  - Each running app now carries `size` (`Shell.fullSize` or
    `Shell.miniSize`) and `shown`. Where an app is follows from those: full
    (in front), mini (a block on Home), or hidden (running, not shown).
  - Every change goes through one function, `arrange(context, now)`. It
    updates the running app, `front`, and the page, then emits one signal,
    `arranged(context, was, now)`. The stage plays the move for that pair.
  - `open()`, `shrink()`, `enlarge()`, `close()`, and `goHome()` are
    built on `arrange()`. None of them names Files, so a second app needs
    no new properties.
  - `lastSizes` keeps each app's last size after it closes, so it reopens
    in that size.
- **The mini block** (`OSContent/MiniApp.qml`, new):
  - It has the footprint of one group: 8 × 8 units plus the group header.
  - The header line shows the app's name in the group label style, with
    enlarge and close controls at the right.
  - The body is a flat fill one shade darker than the page (`#33649A`).
    Inside it, with a 16 px margin, are compact headings (24 px, clickable)
    and the current heading's `FolderView`, which scrolls inside the block.
  - The block's colours are a new look, `Theme.homeBlock`. File rows in
    the block hover one shade lighter (`#3A6EA5`), so the hover still shows
    against the darker fill.
- **The first slot** (`OSContent/AppsPanel.qml`):
  - The Apps panel's flow now starts with a slot the block sits in. When
    the slot is taken, the groups wrap after it exactly as they wrap after
    each other.
  - When the slot opens or closes while Home is at rest, the groups move to
    their new places over `Theme.slotMoveDuration`, and the block fades in.
    During a move into or out of full size, the groups take their new places
    at once, because Home is out of view at that moment.
  - The panel can also find the tile that opens a context
    (`launcherFor`, also added to `TileGroup`).
- **The controls** (`OSContent/AppControl.qml`, new):
  - A 32 × 32 square with three kinds, drawn from plain rectangles in the
    primary text colour: a small solid square (mini), a larger square
    outline (enlarge), and a cross (close).
  - It fills on hover with the new `controlHover` colour in each look.
- **Full size** (`OSContent/ContextView.qml`):
  - A view can now hold controls at the right end of its heading line.
    Files' view puts mini and close there.
  - The controls slide with the headings during a move.
  - The grow's starting colour is now a property, so a grow out of the
    block starts in the block's colour, not the tile colour.
  - `jumpTo()` shows a heading without the sideways slide.
- **The moves** (`OSContent/ContextStage.qml`):
  - **Full to mini:** the move to Home in reverse, shrinking into the
    block's body in the first slot. Home comes back on the Apps panel,
    scrolled to the top so the block is in view. The groups come back from
    the edges into their places after the block. The block opens on the
    heading Files was on.
  - **Mini to full:** the task 004 move, growing out of the block's body.
    The block keeps its slot while Files grows and leaves once Files is
    full. Files opens on the block's heading.
  - **Home or Escape from full:** as in task 004. If Files grew out of its
    block, the block is gone by then, so Files shrinks into the Files tile
    instead.
  - **Close:** from mini, the block leaves and the groups move back. From
    full, the move home plays first; then Files leaves the bar.
  - **Keys:** Ctrl+Down shrinks the app in front, and Ctrl+W closes it.
    Ctrl+Up and Ctrl+W apply to the block when the pointer is over it or
    when the last press on the page was inside it.
- **The bar** (`OSContent/Bar.qml`, `OSContent/BarButton.qml`):
  - A full-width line marks the app in front, and a 16 px centred line an
    app sitting on Home in mini size.
  - There is no line when the app is running but not shown, or while the
    Reference page shows.
- **Smaller changes:**
  - `PanelTabs` takes a type size.
  - `FolderView` takes its side and bottom margins, which are smaller
    inside the block.
- **Registration:**
  - `AppControl.qml` and `MiniApp.qml` are in the `OSContent` list.
  - Both `QML_FILES` lists are now in sorted order. Task 004 had left its
    five new files appended at the end of the `OSContent` list, and
    `FilesModel.qml` at the end of the `OS` list (see Noticed).

## Done-when checklist

- [x] In full size, Files' heading line has a mini control and a close
      control at its right end
- [x] The mini control puts Files on Home's Apps panel as an 8 × 8 unit
      block in the first slot, with the tile groups flowing after it, and
      Home's headings back in place
- [x] The block shows the app's name, enlarge and close controls, a
      compact clickable heading row, and the current heading's folders
      and files, scrolling inside the block
- [x] Enlarge returns Files to full size with the move growing from the
      block
- [x] Close removes Files from Home and from the bar, from either size,
      and the groups close the gap
- [x] Files reopens in the size it was last in; clicking its tile or bar
      button while it is mini makes it full
- [x] Ctrl+Down, Ctrl+Up, and Ctrl+W work as in the table
- [x] Groups and the block move to new places with an animation, never a
      jump, and nothing overlaps at rest
- [x] The bar shows the full line, the short line, or no line as
      described
- [x] Everything from task 004 still works: opening from the tile and the
      bar, headings by click, drag, and keys, Home and Escape, and the
      Reference page unchanged
- [x] Every move takes 300 ms or less, with durations in the theme
- [x] No literal colours or sizes in components; `.ui.qml` files contain
      no JavaScript; new files are registered
- [x] All checks below pass, or the report says exactly which could not be
      run and why

## Checks run

| Check | Result |
|---|---|
| `qmllint -I .` on every changed and new QML file (6.8.7, from the Qt Design Studio install) | **Passed. No new warnings.** The only message is the existing "unused import OS" note in `App.qml`. |
| Headless `qmltestrunner` run of `Screen01`, `QT_QPA_PLATFORM=offscreen` (test kept in the scratchpad, not committed) | **15 of 15 passed on each of five runs.** Details below. |
| Reference page rendered offscreen from this branch and from `main` | **Identical** (SHA-256 `CD00E3CA…BB0A32`, the same as in tasks 003 and 004). |
| Search of changed components for colour literals and bare sizes; `.ui.qml` files | **None found.** The bare numbers left are indexes, 0 and 1 factors, the block's zero side margin, and the cross's ±45° angles. No `.ui.qml` file changed. |
| Contrast of new text and surface pairs (below) | **All text pairs pass.** |
| Changed files against the brief's list | All are allowed. In the CMake files only the `QML_FILES` lists changed. |

What the headless run confirmed, in order:

**Task 004, unchanged**
- Opening from the tile, with the move details checked as before.
- Files' headings by click, keys, and drag.
- Escape and the Home button return to the same panel and scroll offset.
- Reopening from the bar grows out of the bar.
- At start the groups are already in place; nothing animates on launch.

**Full size**
- Mini and close sit at the right end of the heading line, 120 px from
  the edge, centred on the headings.
- Each control is 32 × 32 and fills `#4A7FB8` on hover.

**Full to mini (the mini control and Ctrl+Down)**
- Home was left on Now; it came back on Apps, scrolled to the top, with
  its headings at their place.
- The move's origin is the block's body. Mid-move, the box is between
  the body and the full area, and its fill blends from `#33649A`.
- Rectangles at rest, in panel coordinates:

  | Item | x | y | width × height |
  |---|---|---|---|
  | Block | 120 | 0 | 630 × 674 |
  | Everyday | 810 | 0 | 630 × 674 |
  | Work | 120 | 734 | 630 × 674 |
  | Play | 810 | 734 | 630 × 674 |

  No two overlap, and every tile's offset is back to zero.
- The block shows the heading Files was on.
- The bar shows the short line, and the Home button is active.

**The block**
- The title is "Files" at the group label size, with enlarge and close
  at the right.
- The body is 630 × 630, `#33649A`.
- The compact headings read Recent, Home, Documents, Downloads at 24 px,
  white for the current one and `#B4CBE5` for the others. Clicking one
  shows its 4–6 folders and 8 files.
- One wheel notch scrolls inside the block and leaves the Apps panel
  where it was.
- Folder and file clicks log as in full size, and a row hovers
  `#3A6EA5`.

**Mini to full (enlarge, Ctrl+Up, and the tile or bar button while mini)**
- Grows out of the block's body.
- The block keeps its slot through the move and is gone at the end.
- Files opens on the block's heading.
- The bar shows the full line.
- Escape afterwards shrinks Files into the Files tile, and the groups are
  back in their places without the block.

**Close**
- From mini, the bar entry and the block are gone at once. The first
  group's x moved over time
  `810, 671, 553, 447, 361, 298, 272, 196, 168, 147, 133, 125, 121, 121, 120`
  and was at rest after 239–272 ms on the five runs.
- From full, the move home plays, then Files leaves the bar.
- Ctrl+W does both.

**Reopening**
- After closing from mini, the Files tile reopens it as a block. The
  groups moved aside with `120, 280, 477, 561, … 808, 810`.
- After closing from full, it reopens full.

**Keys**
- With the pointer away and the last press elsewhere, Ctrl+Up and Ctrl+W
  do nothing.
- With the pointer over the block, Ctrl+Up enlarges it.
- After a press on the block's header with the pointer moved away,
  Ctrl+Up enlarges it.
- A press elsewhere makes the block forget it was clicked.
- A press on a file row inside the block makes Ctrl+W apply to it.

**Bar**
- The full line, the short line (16 px wide), and no line, each in the
  state the brief gives.
- No line on the Reference page.

**Reference**
- The Reference page still shows and its Files tile only logs.
- With Files mini, the Files bar button on Reference brings the home page
  back with Files full.

**Timing**, from the click or key to the end of the move, over five runs:

| Move | Done after |
|---|---|
| Open from the tile | 260–285 ms (285 once, on the first move of one run; otherwise 260–261) |
| Full to mini (control, Ctrl+Down) | 259–263 ms |
| Mini to full (enlarge, Ctrl+Up, tile or bar while mini) | 253–266 ms |
| Back home with Escape or the Home button | 258–270 ms |
| Close from full (control, Ctrl+W) | 262–269 ms |
| Groups moving when the slot opens or closes | 239–272 ms (sampled every 15 ms) |

Both durations are in the theme, 250 ms each: `contextMoveDuration` and
the new `slotMoveDuration`.

**Contrast** (task 003's rule: text under 24 px at least 4.5:1, 24 px and
larger at least 3:1):

| Pair | Ratio | Use |
|---|---|---|
| White on `#33649A` (block body) | 6.12 | Primary text and file names in the block |
| `#EEF4FB` on `#33649A` | 5.53 | File sizes and dates in the block |
| `#B4CBE5` on `#33649A` | 3.68 | Compact headings that are not current, 24 px, so 3:1 applies |
| White on `#3A6EA5` (row hover in the block) | 5.31 | File names on a hovered row |
| `#EEF4FB` on `#3A6EA5` | 4.80 | Sizes and dates on a hovered row |
| White on `#4A7FB8` (control hover) | 4.18 | Control marks, which are graphics (3:1) |
| White on `#2A2E35` (control hover, Reference look) | 13.63 | Not drawn yet; no control is on Reference |

The block body against the page is 1.15:1. It is a region of the same
surface, not text. White on `#4A7FB8` for folder tile labels is the
existing pair from task 003's follow-up.

**What the owner needs to look at.** I cannot judge how the motion
feels. Please run it and check:

- **Full to mini:** Files shrinking into the block while the groups come
  back, and the swap at the end from the full view's top-left corner to
  the block's own compact view.
- **Mini to full:** the growth out of the block.
- **The groups moving** when the block appears or leaves (250 ms).
  Opening in mini fades the block in while the first group slides out of
  its slot, so the two cross briefly during the move.
- **The block's look:** the darker body, the 16 px margin, the compact
  headings at 24 px, and three folder tiles per row inside it.
- **The controls:** the marks, their size, and the hover fill, in full
  size and in the block header.
- **The bar's short line.**
- That `Screen01.ui.qml` still opens in the visual editor. It did not
  change.

## Not done

- Nothing from the brief.

## Questions

- **Full to mini scrolls the Apps panel to the top.** The block sits in
  the first slot, so without this, a panel scrolled down would hide the
  block the app just shrank into. The brief says Home switches to the Apps
  panel; I also bring the block into view. Escape and the Home button
  still keep the scroll position. Say if you'd rather keep the scroll.
- **Where Escape goes after mini to full.** Once Files has grown out of
  its block, the block is gone, so Escape shrinks Files into the Files
  tile. The other choice is the bar button, where the hidden app now
  lives.
- **"Last thing clicked" only sees presses on the home page.** A press in
  the bar does not make the block forget it was clicked, so Ctrl+Up still
  applies after clicking, say, the clock. The bar is outside the stage.
  Watching it too would need a change in `Screen01.ui.qml` or `Bar.qml`
  that crosses components; I left it.
- **Opening in mini from the tile does not scroll.** If the panel is
  scrolled down, the block appears out of view at the top, and only the
  groups moving shows that something happened. Full to mini does scroll,
  as above.
- **Wheel scrolling chains.** One wheel notch scrolls inside the block.
  Scrolling past the end of the block's content carries on and scrolls the
  Apps panel. That is how nested Flickables behave by default in Qt.

## Noticed but not done

- **The CMake lists and Qt Design Studio.** The brief asks for sorted
  lists. While Qt Design Studio has the project open, it rewrites both
  `QML_FILES` lists in its own order whenever a file changes: the files
  it found at load, sorted, with files created since appended. It did this
  twice during this task. Task 004's lists reached `main` unsorted the same
  way, although its report said they were sorted; that was my mistake. I
  wrote the sorted lists again just before committing. Restarting Qt
  Design Studio on the merged branch should end the churn.
- **A reversed move partway through.** If enlarge is reversed with Escape
  partway through, the block's slot closes at once, while the groups are
  still part-way out. This was only checked by reading the code.
- **Files keeps its heading after close.** A closed app comes back on the
  heading it had, in both views. A real app would start fresh; that
  belongs with making contexts a general list.
- **The block is Files'.** The stage declares one `MiniApp` for Files, as
  it declares one full view. Like the full view, it should come from the
  running apps list when contexts become a list (the follow-up recorded on
  task 004).
