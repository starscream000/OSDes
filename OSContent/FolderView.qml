pragma ComponentBehavior: Bound
import QtQuick
import OS

// One heading of Files: its folders as medium tiles on the home grid, and
// below them its files as rows. Scrolls up and down when they do not fit.
Flickable {
    id: folderView

    // Set by whoever places the view: the heading's folders and files (see
    // FilesModel), and the look.
    required property var folders
    required property var files
    required property Theme.Look look
    // Space at the sides and below the last row. Smaller inside a mini block.
    property int sideMargin: Theme.pageMargin
    property int bottomMargin: Theme.panelBottomMargin

    contentWidth: folderView.width
    contentHeight: folderColumn.height + folderView.bottomMargin
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    Column {
        id: folderColumn
        x: folderView.sideMargin
        width: folderView.width - 2 * folderView.sideMargin
        spacing: Theme.folderFilesGap

        Flow {
            id: folderTiles
            width: parent.width
            spacing: Theme.gap

            Repeater {
                id: folderRepeater
                model: folderView.folders

                delegate: Tile {
                    size: "medium"
                    tint: ""
                    look: folderView.look
                }
            }
        }

        Column {
            id: fileRows
            width: parent.width

            Repeater {
                id: fileRepeater
                model: folderView.files

                delegate: FileRow {
                    width: fileRows.width
                    look: folderView.look
                }
            }
        }
    }
}
