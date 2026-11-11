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
    // Set by whoever places a group on Home; passed on to its tiles.
    property Rearrangement move: null

    width: Theme.span(Theme.groupUnits)
    height: Theme.groupHeaderHeight + Theme.span(Theme.groupUnits)

    Text {
        id: groupLabel

        // Where the label goes when an app is fully in front.
        property point away: Qt.point(0, 0)

        anchors.left: parent.left
        anchors.top: parent.top
        transform: Translate {
            x: group.move ? groupLabel.away.x * group.move.progress : 0
            y: group.move ? groupLabel.away.y * group.move.progress : 0
        }
        text: group.title
        color: group.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.groupLabelSize
    }

    Connections {
        target: group.move
        function onStarted() {
            groupLabel.away = group.move.offsetFor(groupLabel)
        }
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
                move: group.move
                required property int column
                required property int row

                x: column * Theme.cell
                y: row * Theme.cell
            }
        }
    }
}
