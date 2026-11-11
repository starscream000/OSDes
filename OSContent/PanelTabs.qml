pragma ComponentBehavior: Bound
import QtQuick
import OS

// The names of the home panels. The current one is in the primary text
// colour, the others are dimmed. Clicking a name asks for that panel.
Row {
    id: tabs

    property int currentIndex: 0
    // Set by whoever places the tabs.
    required property Theme.Look look

    signal tabClicked(int index)

    spacing: Theme.tabSpacing

    Repeater {
        id: tabRepeater
        model: [qsTr("Now"), qsTr("Apps"), qsTr("All apps")]

        delegate: Text {
            id: tab

            required property string modelData
            required property int index

            text: tab.modelData
            color: tab.index === tabs.currentIndex ? tabs.look.textPrimary : tabs.look.tabDimmed
            font.family: Theme.fontFamily
            font.pixelSize: Theme.tabSize
            font.weight: Font.Light

            MouseArea {
                id: tabMouseArea
                anchors.fill: parent
                onClicked: tabs.tabClicked(tab.index)
            }
        }
    }
}
