pragma ComponentBehavior: Bound
import QtQuick
import OS

// A named group of tiles on an 8 x 8 unit grid. Each tile is placed at the
// column and row given in its data; nothing is packed automatically.
Item {
    id: group

    required property string title
    required property var tiles
    // Set by whoever places the group; passed on to its tiles.
    required property Theme.Look look

    width: Theme.span(Theme.groupUnits)
    height: Theme.groupHeaderHeight + Theme.span(Theme.groupUnits)

    Text {
        id: groupLabel
        anchors.left: parent.left
        anchors.top: parent.top
        text: group.title
        color: group.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.groupLabelSize
    }

    Item {
        id: tileField
        y: Theme.groupHeaderHeight
        width: Theme.span(Theme.groupUnits)
        height: Theme.span(Theme.groupUnits)

        Repeater {
            model: group.tiles

            delegate: Tile {
                look: group.look
                required property int column
                required property int row

                x: column * Theme.cell
                y: row * Theme.cell
            }
        }
    }
}
