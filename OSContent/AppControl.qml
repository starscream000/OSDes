pragma ComponentBehavior: Bound
import QtQuick
import OS

// A small square control that changes an app's size or closes it. Its mark
// is drawn from plain shapes: a small solid square (mini), a larger square
// outline (enlarge), or a cross (close). It fills on hover.
Rectangle {
    id: control

    // "mini", "enlarge", or "close".
    required property string kind
    // Set by whoever places the control.
    required property Theme.Look look

    signal clicked()

    width: Theme.controlSize
    height: Theme.controlSize
    color: mouseArea.containsMouse ? control.look.controlHover : Theme.transparent

    Rectangle {
        id: miniMark
        anchors.centerIn: parent
        visible: control.kind === "mini"
        width: Theme.controlMiniMarkSize
        height: Theme.controlMiniMarkSize
        color: control.look.textPrimary
    }

    Rectangle {
        id: enlargeMark
        anchors.centerIn: parent
        visible: control.kind === "enlarge"
        width: Theme.controlEnlargeMarkSize
        height: Theme.controlEnlargeMarkSize
        color: Theme.transparent
        border.color: control.look.textPrimary
        border.width: Theme.controlLineWidth
    }

    Repeater {
        id: crossLines
        model: control.kind === "close" ? [45, -45] : []

        delegate: Rectangle {
            id: crossLine

            required property int modelData

            anchors.centerIn: control
            width: Theme.controlCrossLength
            height: Theme.controlLineWidth
            rotation: crossLine.modelData
            antialiasing: true
            color: control.look.textPrimary
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: control.clicked()
    }
}
