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

    // ---- Colours ----------------------------------------------------------

    readonly property color background: "#15171B"
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#A9AFB8"
    readonly property color tileText: "#FFFFFF"
    readonly property color tileOutline: "#FFFFFF"
    readonly property color userPlaceholder: "#3C4250"
    readonly property color transparent: "transparent"

    // Flat tile colours, referred to by name from the tile data.
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
    readonly property color barBackground: "#22252B"
    readonly property color barButtonHover: "#30343C"
    readonly property color barButtonPressed: "#3E434D"
    readonly property color barButtonActive: "#2B2F37"
    // Line along a bar button's bottom edge: the active page, or the app in front.
    readonly property color barIndicatorActive: "#4C8DFF"
    readonly property color barIndicatorFront: "#FFFFFF"
    readonly property int barIndicatorHeight: 2
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

    // Dimmed text: tabs that are not current, and placeholder lines.
    readonly property color textDimmed: "#6B717B"
    // How much of the next panel stays visible beside the current one.
    readonly property int panelPeek: 160
    // Top of the panels, measured from the top of the page area.
    readonly property int panelTop: 140
    // Space left below the last row of groups in the Apps panel.
    readonly property int panelBottomMargin: 60
    readonly property int tabSize: 48
    readonly property int tabSpacing: 40
    readonly property int panelTextSize: 20

    // ---- Motion -----------------------------------------------------------

    // Duration of the move from one home panel to another, in milliseconds.
    readonly property int panelMoveDuration: 250
    // A drag released faster than this (pixels per second) moves to the
    // next panel even if it covered less than half a panel.
    readonly property real panelFlickVelocity: 400

    // Scale of a tile while it is held down.
    readonly property real tilePressedScale: 0.97
    // Duration of the press and release animation, in milliseconds.
    readonly property int pressDuration: 90
    // Pixels scrolled per wheel step of 1/8 degree (120 per notch).
    readonly property real wheelScrollFactor: 1.5
}
