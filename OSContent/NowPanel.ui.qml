/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/

// The Now panel: the place for the owner's widgets. Empty for now.

import QtQuick
import OS

Item {
    id: nowPanel

    // Set by whoever places the panel. The default lets the visual editor
    // preview this file on its own.
    property Theme.Look look: Theme.home

    Text {
        id: placeholder
        x: Theme.pageMargin
        text: qsTr("Your widgets will live here.")
        color: nowPanel.look.textDimmed
        font.family: Theme.fontFamily
        font.pixelSize: Theme.panelTextSize
    }
}
