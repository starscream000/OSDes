/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

// The shell root: the page area above, the bar along the bottom.
// Which page shows is read from Shell.page; components change it.

import QtQuick
import OS

Rectangle {
    id: shellRoot
    width: Constants.width
    height: Constants.height

    color: Theme.background

    Item {
        id: pageArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bar.top

        HomePage {
            id: homePage
            anchors.fill: parent
            visible: Shell.page === Shell.homePage
        }

        MetroStartReference {
            id: referencePage
            anchors.fill: parent
            visible: Shell.page === Shell.referencePage
        }
    }

    Bar {
        id: bar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}
