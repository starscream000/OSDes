/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML.
*/

// The Now panel: the place for the owner's widgets. Empty for now.

import QtQuick
import OS

Item {
    id: nowPanel

    Text {
        id: placeholder
        x: Theme.pageMargin
        text: qsTr("Your widgets will live here.")
        color: Theme.textDimmed
        font.family: Theme.fontFamily
        font.pixelSize: Theme.panelTextSize
    }
}
