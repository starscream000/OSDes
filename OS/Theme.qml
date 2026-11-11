pragma Singleton
import QtQuick

// The shared look of the shell: grid, colours, type sizes, and motion.
// Components read every colour and size from here; they contain no literals.
QtObject {
    id: theme

    // ---- Grid -------------------------------------------------------------

    // Side of one small (1 x 1) tile.
    readonly property int unit: 70
    // Gap between tiles inside a group.
    readonly property int gap: 10
    // Gap between neighbouring groups.
    readonly property int groupGap: 60
    // Left margin of the page; the title and the first group start here.
    readonly property int pageMargin: 120
    // Top of the tile area, measured from the top of the window.
    readonly property int tileAreaTop: 180
    // A group is this many units wide and tall.
    readonly property int groupUnits: 8
    // Distance from one grid cell to the next.
    readonly property int cell: unit + gap

    // Pixel length of something that spans `units` grid units.
    function span(units: int): int {
        return units * theme.unit + (units - 1) * theme.gap
    }

    // ---- Tile sizes -------------------------------------------------------

    // Columns x rows (in units) and the size of the centred mark, per size.
    readonly property var tileSizes: ({
        "small":  { "columns": 1, "rows": 1, "markSize": 34 },
        "medium": { "columns": 2, "rows": 2, "markSize": 64 },
        "wide":   { "columns": 4, "rows": 2, "markSize": 64 },
        "large":  { "columns": 4, "rows": 4, "markSize": 128 }
    })

    function tileColumns(size: string): int {
        return theme.tileSizes[size] ? theme.tileSizes[size].columns : 1
    }

    function tileRows(size: string): int {
        return theme.tileSizes[size] ? theme.tileSizes[size].rows : 1
    }

    function tileMarkSize(size: string): int {
        return theme.tileSizes[size] ? theme.tileSizes[size].markSize : theme.tileSizes.small.markSize
    }

    // ---- Looks ------------------------------------------------------------

    // The colours of one look. A tile, group, or panel is given its look by
    // whoever places it, and reads every colour from that look.
    component Look: QtObject {
        // Behind the page.
        required property color background
        // Fill of every tile, unless the look is tinted.
        required property color tileFill
        // A tinted look fills each tile with its own colour from the tile data.
        required property bool tinted
        // Primary text, tile marks and labels, and the tile outline on hover.
        required property color textPrimary
        // Group labels, the date in the clock.
        required property color textSecondary
        // Placeholder lines.
        required property color textDimmed
        // Tabs that are not current. They are large text, so they may be dimmer.
        required property color tabDimmed
        // A list row under the pointer.
        required property color rowHover
        // A small control (mini, enlarge, close) under the pointer.
        required property color controlHover
    }

    // The OS look: Home and the bar. Every surface is a shade of one blue.
    readonly property Look home: Look {
        background: "#3A6EA5"
        tileFill: "#4A7FB8"
        tinted: false
        textPrimary: "#FFFFFF"
        textSecondary: "#EEF4FB"
        textDimmed: "#E6EEF8"
        tabDimmed: "#B4CBE5"
        rowHover: "#33649A"
        controlHover: "#4A7FB8"
    }

    // Inside an app sitting on Home in mini size: one shade darker than
    // Home's background, so the block reads as a region of the same surface.
    readonly property Look homeBlock: Look {
        background: "#33649A"
        tileFill: "#4A7FB8"
        tinted: false
        textPrimary: "#FFFFFF"
        textSecondary: "#EEF4FB"
        textDimmed: "#E6EEF8"
        tabDimmed: "#B4CBE5"
        rowHover: "#3A6EA5"
        controlHover: "#4A7FB8"
    }

    // The look of the Metro Start reference page: dark, with tinted tiles.
    readonly property Look reference: Look {
        background: "#15171B"
        tileFill: theme.tileColors.cobalt
        tinted: true
        textPrimary: "#FFFFFF"
        textSecondary: "#A9AFB8"
        textDimmed: "#6B717B"
        tabDimmed: "#6B717B"
        rowHover: "#22252B"
        controlHover: "#2A2E35"
    }

    readonly property color userPlaceholder: "#3C4250"
    readonly property color transparent: "transparent"

    // Flat tile colours for tinted looks, referred to by name from the tile data.
    readonly property var tileColors: ({
        "cobalt":  "#2456C7",
        "teal":    "#00897B",
        "green":   "#3B8F3A",
        "orange":  "#D35400",
        "red":     "#C0392B",
        "magenta": "#AD1F6F",
        "violet":  "#5E35B1",
        "slate":   "#455A73"
    })

    function tileColor(tint: string): color {
        return theme.tileColors[tint] ? theme.tileColors[tint] : theme.tileColors.cobalt
    }

    // ---- Type -------------------------------------------------------------

    readonly property string fontFamily: Constants.font.family
    readonly property int titleSize: 72
    readonly property int userNameSize: 22
    readonly property int groupLabelSize: 20
    readonly property int tileLabelSize: 14

    // ---- Header -----------------------------------------------------------

    readonly property int headerTop: 44
    readonly property int userSquareSize: 40
    readonly property int userSpacing: 12

    // ---- Groups and tiles -------------------------------------------------

    // Space above a group's tiles, holding the group's label.
    readonly property int groupHeaderHeight: 44
    // Inner margin of a tile's label.
    readonly property int tileLabelMargin: 8
    // Width of the hover outline, drawn inside the tile's edge.
    readonly property int tileOutlineWidth: 2

    // ---- Bar --------------------------------------------------------------

    // Height of the bar, and the side of each square bar button.
    readonly property int barHeight: 48
    // The bar is always in the OS look; its text uses Theme.home.
    readonly property color barBackground: "#2B5482"
    readonly property color barButtonHover: "#4A7FB8"
    readonly property color barButtonPressed: "#5A8FC8"
    readonly property color barButtonActive: "#346299"
    // Line along a bar button's bottom edge: the active page, or the app in front.
    readonly property color barIndicator: "#FFFFFF"
    readonly property int barIndicatorHeight: 2
    // A short centred line instead: the app sits on Home in mini size.
    readonly property int barIndicatorShortWidth: 16
    // Space between items in the bar's right-hand group.
    readonly property int barSpacing: 8
    // Right margin of the clock.
    readonly property int barClockMargin: 16
    // Side padding of a bar button that shows text.
    readonly property int barTextPadding: 16
    readonly property int barTextSize: 15
    // First letter on a running app's button.
    readonly property int barLetterSize: 20
    // Small solid square on the Home button.
    readonly property int barHomeMarkSize: 14
    // The three short lines on the quick settings button.
    readonly property int barLineWidth: 18
    readonly property int barLineHeight: 2
    readonly property int barLineSpacing: 4
    readonly property int clockTimeSize: 15
    readonly property int clockDateSize: 12

    // ---- Home panels ------------------------------------------------------

    // How much of the next panel stays visible beside the current one.
    readonly property int panelPeek: 160
    // Top of the panels, measured from the top of the page area.
    readonly property int panelTop: 140
    // Space left below the last row of groups in the Apps panel.
    readonly property int panelBottomMargin: 60
    readonly property int tabSize: 48
    readonly property int tabSpacing: 40
    readonly property int panelTextSize: 20

    // ---- App content ------------------------------------------------------

    // Space between an app's tiles and the rows below them.
    readonly property int tilesRowsGap: 40
    readonly property int rowHeight: 40
    // Inner left and right margin of a row.
    readonly property int rowPadding: 12
    readonly property int rowNameSize: 16
    readonly property int rowDetailSize: 14
    // Widths of a row's two detail columns, right-aligned.
    readonly property int rowDetailWidth: 180
    readonly property int rowSecondDetailWidth: 140

    // ---- App sizes --------------------------------------------------------

    // The square controls that change an app's size or close it.
    readonly property int controlSize: 32
    readonly property int controlSpacing: 4
    // Lines drawn in a control, and the marks they make: a small solid
    // square (mini), a larger square outline (enlarge), a cross (close).
    readonly property int controlLineWidth: 2
    readonly property int controlMiniMarkSize: 8
    readonly property int controlEnlargeMarkSize: 14
    readonly property int controlCrossLength: 18
    // Inside an app's mini block: the inner margin, and its compact headings.
    readonly property int miniMargin: 16
    readonly property int miniTabSize: 24
    readonly property int miniTabSpacing: 24
    readonly property int miniTabsGap: 16

    // ---- Motion -----------------------------------------------------------

    // Duration of the move from one home panel to another, in milliseconds.
    readonly property int panelMoveDuration: 250
    // A drag released faster than this (pixels per second) moves to the
    // next panel even if it covered less than half a panel.
    readonly property real panelFlickVelocity: 400

    // The move between Home and an app: the app's content grows out of a
    // tile or bar button while the other tiles move aside. At most 300 ms.
    readonly property int contextMoveDuration: 250
    readonly property int contextMoveEasing: Easing.OutCubic
    // Tile groups moving to their new places when a slot on the Apps panel
    // opens or closes. At most 300 ms.
    readonly property int slotMoveDuration: 250
    readonly property int slotMoveEasing: Easing.OutCubic

    // Scale of a tile while it is held down.
    readonly property real tilePressedScale: 0.97
    // Duration of the press and release animation, in milliseconds.
    readonly property int pressDuration: 90
    // Pixels scrolled per wheel step of 1/8 degree (120 per notch).
    readonly property real wheelScrollFactor: 1.5
}
