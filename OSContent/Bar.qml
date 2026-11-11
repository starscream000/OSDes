import QtQuick
import OS

// The thin bar along the bottom edge, always visible. Left to right: Home,
// running apps, (space), Reference, quick settings, clock.
Rectangle {
    id: bar

    height: Theme.barHeight
    color: Theme.barBackground

    RunningAppsModel {
        id: runningApps
    }

    Row {
        id: leftItems
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        BarButton {
            id: homeButton
            active: Shell.page === Shell.homePage
            onClicked: Shell.page = Shell.homePage

            Rectangle {
                id: homeMark
                anchors.centerIn: parent
                width: Theme.barHomeMarkSize
                height: Theme.barHomeMarkSize
                color: Theme.home.textPrimary
            }
        }

        Repeater {
            id: runningAppsRepeater
            model: runningApps

            delegate: BarButton {
                id: appButton

                required property string name
                required property bool front

                marked: appButton.front
                onClicked: console.log("Running app clicked:", appButton.name)

                Text {
                    id: appLetter
                    anchors.centerIn: parent
                    text: appButton.name.charAt(0)
                    color: Theme.home.textPrimary
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.barLetterSize
                    font.weight: Font.Light
                }
            }
        }
    }

    Row {
        id: rightItems
        anchors.right: parent.right
        anchors.rightMargin: Theme.barClockMargin
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.barSpacing

        BarButton {
            id: referenceButton
            width: referenceLabel.implicitWidth + 2 * Theme.barTextPadding
            active: Shell.page === Shell.referencePage
            onClicked: Shell.page = Shell.referencePage

            Text {
                id: referenceLabel
                anchors.centerIn: parent
                text: qsTr("Reference")
                color: Theme.home.textPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.barTextSize
            }
        }

        BarButton {
            id: quickSettingsButton
            onClicked: console.log("Quick settings clicked")

            Column {
                id: quickSettingsMark
                anchors.centerIn: parent
                spacing: Theme.barLineSpacing

                Repeater {
                    model: 3

                    delegate: Rectangle {
                        width: Theme.barLineWidth
                        height: Theme.barLineHeight
                        color: Theme.home.textPrimary
                    }
                }
            }
        }

        BarClock {
            id: clock
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
