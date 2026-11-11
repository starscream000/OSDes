import QtQuick
import OS

// The current time above the current date, right-aligned. Updates itself.
Column {
    id: clock

    property date now: new Date()

    Text {
        id: timeText
        anchors.right: parent.right
        text: clock.now.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
        color: Theme.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.clockTimeSize
    }

    Text {
        id: dateText
        anchors.right: parent.right
        text: clock.now.toLocaleDateString(Qt.locale(), "ddd d MMM")
        color: Theme.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.clockDateSize
    }

    Timer {
        id: tick
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.now = new Date()
    }
}
