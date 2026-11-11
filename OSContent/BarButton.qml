import QtQuick
import OS

// A flat square button in the bar. Children are centred inside it.
// It highlights on hover and press. `active` marks the page showing;
// `marked` draws a thin line along the bottom edge (the app in front), and
// `markedShort` a short centred one (the app sitting on Home in mini size).
Rectangle {
    id: button

    property bool active: false
    property bool marked: false
    property bool markedShort: false
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

        readonly property bool full: button.active || button.marked

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: indicator.full ? button.width : Theme.barIndicatorShortWidth
        height: Theme.barIndicatorHeight
        visible: indicator.full || button.markedShort
        color: Theme.barIndicator
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
    }
}
