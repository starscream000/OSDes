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

    // ---- Motion -----------------------------------------------------------

    // Scale of a tile while it is held down.
    readonly property real tilePressedScale: 0.97
    // Duration of the press and release animation, in milliseconds.
    readonly property int pressDuration: 90
    // Pixels scrolled per wheel step of 1/8 degree (120 per notch).
    readonly property real wheelScrollFactor: 1.5
}
