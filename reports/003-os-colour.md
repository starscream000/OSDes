# Report — Task 003: Give the OS its own colour

Branch: task/003-os-colour
Result: partly complete. Everything is built. One "Done when" item is
not met because the brief's fixed fills conflict with its contrast rule.
The owner chose to keep the fills as briefed (see Questions).

## What was done

- **Two looks in the theme (`OS/Theme.qml`).** A small `Look` type,
  declared inline in the theme, holds one look's colours:
  `background`, `tileFill`, `tinted`, `textPrimary`, `textSecondary`,
  `textDimmed`, and `tabDimmed`. The theme has two of them:
  - `Theme.home` is the OS look, in shades of `#3A6EA5`.
  - `Theme.reference` holds the old dark values, unchanged.

  The old shared names `background`, `textPrimary`, `textSecondary`,
  `textDimmed`, `tileText`, and `tileOutline` are gone, so nothing can
  pick up the wrong look by accident.
- **Bar colours** stay as flat theme values, since the bar only ever has
  the OS look. They are set to the brief's values. The two indicator
  colours (blue for the active page, white for the app in front) became
  one `barIndicator`, because the brief gives both lines one role.
- **The look is set by whoever places a component.**
  - `Tile`, `TileGroup`, `TileArea`, `AppsPanel`, and `PanelTabs` have a
    `required property Theme.Look look`.
  - `HomePage` passes `Theme.home` to its tabs and three panels.
  - `MetroStartReference` passes `Theme.reference` to its tile area.
  - Each group passes its look on to its tiles.
  - `NowPanel.ui.qml` and `AllAppsPanel.ui.qml` have the same property
    with `Theme.home` as its default, so the visual editor can still
    preview them on their own. `HomePage` sets it explicitly anyway.
- **Tiles.** A tile uses `look.tileFill`, or its own `tint` when the look
  is `tinted`. Its mark, label, and hover outline use `look.textPrimary`.
  There is one `Tile.qml` and one `TileGroup.qml`; neither was duplicated.
- **Shell root and bar.** `Screen01.ui.qml` uses `Theme.home.background`.
  `Bar`, `BarButton`, and `BarClock` read the bar values and
  `Theme.home` text colours.
- **`pragma ComponentBehavior: Bound`** is now in `AppsPanel.qml`,
  `TileArea.qml`, and `TileGroup.qml`, as `PanelTabs.qml` already had.
  Their delegates now read the parent's `look` by id, and qmllint warns
  about that without the pragma.

### Colour values

| Role | Theme name | Value |
|---|---|---|
| Background of Home | `home.background` | `#3A6EA5` |
| Bar | `barBackground` | `#2B5482` |
| Tile fill on Home | `home.tileFill` | `#4A7FB8` |
| Hover fill (bar buttons) | `barButtonHover` | `#4A7FB8` |
| Pressed fill (bar buttons) | `barButtonPressed` | `#5A8FC8` |
| Active bar button fill | `barButtonActive` | `#346299` |
| Primary text, marks, tile outline on hover | `home.textPrimary` | `#FFFFFF` |
| Lines under the active page and the front app | `barIndicator` | `#FFFFFF` |
| Secondary text | `home.textSecondary` | `#EEF4FB` (chosen) |
| Dimmed text: placeholder lines | `home.textDimmed` | `#E6EEF8` (chosen) |
| Dimmed text: tabs that are not current | `home.tabDimmed` | `#B4CBE5` (chosen, extra role, owner approved) |

### Contrast ratios (WCAG 2 formula)

Rule: text under 24 px needs at least 4.5:1, larger text at least 3:1.

| Text | Size | Surface | Ratio | Meets rule |
|---|---|---|---|---|
| Current tab (white) | 48 px | background `#3A6EA5` | 5.31 | yes |
| Tabs not current `#B4CBE5` | 48 px | background | 3.19 | yes (large) |
| Group labels `#EEF4FB` | 20 px | background | 4.80 | yes |
| Placeholder lines `#E6EEF8` | 20 px | background | 4.54 | yes |
| Tile marks (white) | 34–128 px | tile `#4A7FB8` | 4.18 | yes (large) |
| **Tile labels (white)** | 14 px | tile `#4A7FB8` | **4.18** | **no** |
| Bar letters, "Reference", clock time (white) | 15–20 px | bar `#2B5482` | 7.80 | yes |
| Clock date `#EEF4FB` | 12 px | bar | 7.04 | yes |
| Bar text (white) on the active button | 15–20 px | `#346299` | 6.26 | yes |
| **Bar text (white) while hovered** | 15–20 px | `#4A7FB8` | **4.18** | **no** |
| **Bar text (white) while pressed** | 15–20 px | `#5A8FC8` | **3.39** | **no** |

## Done-when checklist

- [x] Home's background is `#3A6EA5` and the bar is a darker shade of the
      same blue, on both pages
- [x] Every tile on Home has the same fill; no other hue appears on Home
      or the bar (white and blue-white text aside)
- [x] The Reference page looks exactly as it did before this task: same
      dark background, same tile tints, same text colours
- [x] `OS/HomeModel.qml` is unchanged
- [x] Each role in the table is one named value in `OS/Theme.qml`
- [ ] Every text colour meets the contrast rule, with the ratios listed in
      the report. All ratios are listed, and the colours I chose all
      pass. Three pairs that use the brief's fixed fills do not: tile
      labels on the tile fill, and bar text on the hover and pressed
      fills. See Questions.
- [x] No literal colours in the components
- [x] `.ui.qml` files still contain no JavaScript
- [x] All checks below pass, or the report says exactly which could not be
      run and why

## Checks run

| Check | Result |
|---|---|
| `qmllint -I . OS/Theme.qml OSContent/*.qml` (6.8.7, from the Qt Design Studio install), before and after | **Passed. No new warnings.** Both runs give only the existing "unused import OS" note in `App.qml`. |
| Headless `qmltestrunner` run of `Screen01`, `QT_QPA_PLATFORM=offscreen` (test kept in the scratchpad, not committed) | **5 of 5 passed, no QML warnings.** Details below. |
| Reference page pixel comparison: the Reference page item rendered offscreen from `main` and from this branch | **Identical.** Both PNGs have SHA-256 `CD00E3CA…BB0A32`. |
| Search of `OSContent/*.qml` for colour literals, and of `*.ui.qml` for functions, handler blocks, and arrows | **None found.** |
| `git diff main -- OS/HomeModel.qml` | **Empty.** |
| Contrast ratios | Computed with the WCAG relative-luminance formula. Table above. |

What the headless run confirmed:

**Home**
- The shell root is `#3A6EA5`.
- The bar is `#2B5482`.
- All tiles on Home (every tile in `HomeModel`) are `#4A7FB8`, and no
  other fill appears. The Files tile is `#4A7FB8`.
- Every visible text colour on Home and the bar is one of `#FFFFFF`,
  `#EEF4FB`, `#E6EEF8`, or `#B4CBE5`.
- The Now tab is `#B4CBE5` and the current Apps tab is white.
- The "Everyday" label is `#EEF4FB`.

**Bar states**
- The active Home button is `#346299`, with a white line.
- The app in front has a white line.
- A button is `#4A7FB8` on hover, `#5A8FC8` when pressed, and transparent
  at rest.

**Reference**
- The background is `#15171B` and the bar is `#2B5482`.
- Every tile has its tint colour from `HomeModel`. Mail is `#2456C7`.
- Text colours are only `#FFFFFF` and `#A9AFB8`.
- The user square is `#3C4250`.

**What the owner needs to check by running the project:**

- The blue itself, and each shade beside it, by eye. Every value is one
  named line in `OS/Theme.qml`.
- That the tabs that are not current read as dimmed but stay readable.
- That the tile labels and the bar's hover and pressed text are readable
  enough to you (see Questions).
- That `Screen01.ui.qml`, `NowPanel.ui.qml`, `AllAppsPanel.ui.qml`, and
  `MetroStartReference.ui.qml` still open in the visual editor.

## Not done

- The contrast item above, for the three pairs listed. I left them on
  the owner's instruction.

## Questions

- **The fixed fills and the contrast rule conflict.** White on `#4A7FB8`
  is 4.18:1. That is below 4.5:1 for the 14 px tile labels and for the
  15–20 px bar text on hover. White on `#5A8FC8` is 3.39:1 while a bar
  button is pressed. I asked the owner during the task. The owner chose
  to keep the brief's values and settle this when tuning the colours by
  eye. Passing options I found:
  - Make tiles darker than the page, for example `#2F5C8F` (6.89:1).
    Tiles then sit close to the bar colour.
  - Make tiles only slightly lighter than the page, for example
    `#3F78B3` (4.62:1). Tiles then differ from the background by only
    1.15:1 and nearly disappear.
  - Make tile labels 24 px or larger. That is a type change, which this
    task leaves out of scope.
- **There is an extra dimmed role, approved by the owner.** White on
  the background is only 5.31:1. Any text there that must reach 4.5:1
  therefore has to sit between `#E6EEF8` and white, which would make the
  tabs that are not current look almost the same as the current one. The
  brief's single "dimmed" role is now two values:
  - `textDimmed`, `#E6EEF8`, for placeholders: 4.54:1, meeting the
    20 px rule.
  - `tabDimmed`, `#B4CBE5`, for tabs: 3.19:1, meeting the 3:1 rule for
    48 px text.
- **`look` is a type, not a plain object.** I declared it as an inline
  `component Look` in the theme singleton and typed the properties
  `Theme.Look`, so qmllint checks every role name. Say if you'd prefer
  another structure.

## Noticed but not done

- Qt Design Studio was open on the project during this task and keeps
  re-sorting the `QML_FILES` lists in `OS/CMakeLists.txt` and
  `OSContent/CMakeLists.txt` alphabetically. I reverted that each time
  and did not commit it. It also happened on the task 002 branch; that
  change is in a local stash ("QDS re-sorted QML_FILES lists on
  task/002"). Committing the sorted order once, on the main branch,
  would stop this churn showing up in every task.
- `Theme.userPlaceholder` (the user square) is used only by the
  Reference page. It could move into `Theme.reference` later. I left it
  where it was so the Reference page stays untouched.
- On the Reference page the white labels on some tints are also below
  4.5:1, for example on orange `#D35400`. That page is out of scope and
  was kept exactly as it was.
