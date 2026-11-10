/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/

// The All apps panel: the full list of apps. Empty for now.

import QtQuick
import OS

Item {
    id: allAppsPanel

    Text {
        id: placeholder
        x: Theme.pageMargin
        text: qsTr("All your apps will be listed here.")
        color: Theme.textDimmed
        font.family: Theme.fontFamily
        font.pixelSize: Theme.panelTextSize
    }
}
