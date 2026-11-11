import QtQuick
import OS

// The Apps panel: the tile groups from HomeModel, laid out left to right
// and wrapping onto new rows. Scrolls up and down when the rows do not fit.
Flickable {
    id: appsPanel

    contentWidth: appsPanel.width
    contentHeight: groupFlow.height + Theme.panelBottomMargin
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    HomeModel {
        id: homeModel
    }

    Flow {
        id: groupFlow
        x: Theme.pageMargin
        width: appsPanel.width - 2 * Theme.pageMargin
        spacing: Theme.groupGap

        Repeater {
            id: groupRepeater
            model: homeModel

            delegate: TileGroup {}
        }
    }
}
