import QtQuick

// Sample running apps shown in the bar. `front` marks the app in front.
ListModel {
    ListElement { name: qsTr("Browser");  front: true }
    ListElement { name: qsTr("Terminal"); front: false }
    ListElement { name: qsTr("Files");    front: false }
}
