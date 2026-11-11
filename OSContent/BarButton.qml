import QtQuick
import OS

// A flat square button in the bar. Children are centred inside it.
// It highlights on hover and press. `active` marks the page showing;
// `marked` draws a thin line along the bottom edge (the app in front).
Rectangle {
    id: button

    property bool active: false
    property bool marked: false
    readonly property alias hovered: mouseArea.containsMouse
    readonly property alias pressed: mouseArea.pressed
    default property alias content: contentArea.data

    signal clicked()

    width: Theme.barHeight
    height: Theme.barHeight
    color: button.pressed ? Theme.barButtonPressed
         : button.hovered ? Theme.barButtonHover
         : button.active ? Theme.barButtonActive
         : Theme.transparent

    Item {
        id: contentArea
        anchors.fill: parent
    }

    Rectangle {
        id: indicator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Theme.barIndicatorHeight
        visible: button.active || button.marked
        color: Theme.barIndicator
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
