/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/

// The All apps panel: the full list of apps. Empty for now.

import QtQuick
import OS

Item {
    id: allAppsPanel

    // Set by whoever places the panel. The default lets the visual editor
    // preview this file on its own.
    property Theme.Look look: Theme.home

    Text {
        id: placeholder
        x: Theme.pageMargin
        text: qsTr("All your apps will be listed here.")
        color: allAppsPanel.look.textDimmed
        font.family: Theme.fontFamily
        font.pixelSize: Theme.panelTextSize
    }
}
