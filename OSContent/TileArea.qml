import QtQuick
import OS

// The sideways-scrolling area that holds the tile groups. It scrolls by
// dragging and by the mouse wheel; a vertical wheel scrolls sideways.
Flickable {
    id: tileArea

    // A model of groups, such as HomeModel.
    property alias groups: groupRepeater.model

    readonly property real maxContentX: Math.max(0, tileArea.contentWidth - tileArea.width)

    contentWidth: groupRow.width + 2 * Theme.pageMargin
    contentHeight: height
    flickableDirection: Flickable.HorizontalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    Row {
        id: groupRow
        x: Theme.pageMargin
        spacing: Theme.groupGap

        Repeater {
            id: groupRepeater

            delegate: TileGroup {}
        }
    }

    WheelHandler {
        id: wheelHandler
        target: null
        orientation: Qt.Vertical | Qt.Horizontal
        onWheel: function (event) {
            // Prefer the larger axis so both a normal wheel and a sideways
            // touchpad swipe move the area sideways.
            const dx = event.pixelDelta.x !== 0 ? event.pixelDelta.x : event.angleDelta.x
            const dy = event.pixelDelta.y !== 0 ? event.pixelDelta.y : event.angleDelta.y
            const delta = Math.abs(dy) >= Math.abs(dx) ? dy : dx
            const next = tileArea.contentX - delta * Theme.wheelScrollFactor
            tileArea.contentX = Math.min(Math.max(next, 0), tileArea.maxContentX)
        }
    }
}
