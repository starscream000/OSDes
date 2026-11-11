import QtQuick
import OS

// One flat tile: a solid rectangle with a centred mark (the first letter of
// its name) and, unless it is small, its name at the bottom left.
// Hover draws a thin outline inside the edge; press shrinks it slightly.
Rectangle {
    id: tile

    required property string name
    required property string size
    required property string tint
    // Set by whoever places the tile. A tinted look uses `tint`; others
    // give every tile the look's one fill.
    required property Theme.Look look

    readonly property bool showsLabel: tile.size !== "small"

    width: Theme.span(Theme.tileColumns(tile.size))
    height: Theme.span(Theme.tileRows(tile.size))
    color: tile.look.tinted ? Theme.tileColor(tile.tint) : tile.look.tileFill

    scale: mouseArea.pressed ? Theme.tilePressedScale : 1.0

    Behavior on scale {
        NumberAnimation {
            duration: Theme.pressDuration
            easing.type: Easing.OutQuad
        }
    }

    Text {
        id: mark
        anchors.centerIn: parent
        text: tile.name.charAt(0)
        color: tile.look.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.tileMarkSize(tile.size)
        font.weight: Font.Light
    }

    Text {
        id: label
        visible: tile.showsLabel
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.tileLabelMargin
        text: tile.name
        elide: Text.ElideRight
        color: tile.look.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.tileLabelSize
    }

    Rectangle {
        id: hoverOutline
        anchors.fill: parent
        visible: mouseArea.containsMouse
        color: Theme.transparent
        border.color: tile.look.textPrimary
        border.width: Theme.tileOutlineWidth
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: console.log("Tile clicked:", tile.name)
    }
}
