/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

// The Metro Start screen from task 001, kept as a reference to compare our
// own home against. It fills the page area it is given.

import QtQuick
import OS

Rectangle {
    id: metroStartReference
    implicitWidth: Constants.width
    implicitHeight: Constants.height

    color: Theme.reference.background

    HomeModel {
        id: homeModel
    }

    Text {
        id: pageTitle
        x: Theme.pageMargin
        y: Theme.headerTop
        text: qsTr("Start")
        color: Theme.reference.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.titleSize
        font.weight: Font.Light
    }

    Row {
        id: userArea
        anchors.right: parent.right
        anchors.rightMargin: Theme.pageMargin
        anchors.verticalCenter: pageTitle.verticalCenter
        spacing: Theme.userSpacing

        Text {
            id: userName
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("User")
            color: Theme.reference.textPrimary
            font.family: Theme.fontFamily
            font.pixelSize: Theme.userNameSize
            font.weight: Font.Light
        }

        Rectangle {
            id: userSquare
            width: Theme.userSquareSize
            height: Theme.userSquareSize
            color: Theme.userPlaceholder
        }
    }

    TileArea {
        id: tileArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: Theme.tileAreaTop
        groups: homeModel
        look: Theme.reference
    }
}
