pragma ComponentBehavior: Bound
import QtQuick
import OS

// One heading of an app: its tiles on the home grid, wrapping, and below
// them its rows. Either part may be empty. Scrolls up and down when they
// do not fit. Every app's content is drawn by this view.
Flickable {
    id: contentView

    // Set by whoever places the view: the heading's tiles and rows (see
    // AppEntry), and the look.
    required property var tiles
    required property var rows
    required property Theme.Look look
    // Space at the sides and below the last row. Smaller inside a mini block.
    property int sideMargin: Theme.pageMargin
    property int bottomMargin: Theme.panelBottomMargin

    contentWidth: contentView.width
    contentHeight: contentColumn.height + contentView.bottomMargin
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    Column {
        id: contentColumn
        x: contentView.sideMargin
        width: contentView.width - 2 * contentView.sideMargin
        spacing: Theme.tilesRowsGap

        Flow {
            id: tileFlow
            width: parent.width
            visible: tileRepeater.count > 0
            spacing: Theme.gap

            Repeater {
                id: tileRepeater
                model: contentView.tiles

                delegate: Tile {
                    // Tiles that give no size have no `size` role at all.
                    required property var model

                    size: model.size !== undefined ? model.size : ""
                    tint: ""
                    look: contentView.look
                }
            }
        }

        Column {
            id: rowColumn
            width: parent.width
            visible: rowRepeater.count > 0

            Repeater {
                id: rowRepeater
                model: contentView.rows

                delegate: ContentRow {
                    width: rowColumn.width
                    look: contentView.look
                }
            }
        }
    }
}
