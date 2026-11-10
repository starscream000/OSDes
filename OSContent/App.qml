import QtQuick
import OS

Window {
    width: mainScreen.width
    height: mainScreen.height

    visible: true
    title: "OS"

    Screen01 {
        id: mainScreen

        anchors.centerIn: parent
    }

}

