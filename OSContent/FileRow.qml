import QtQuick
import OS

// One file as a plain row: its name on the left, its size and date on the
// right in secondary text. The row turns a shade darker under the pointer.
Rectangle {
    id: fileRow

    required property string name
    required property string size
    required property string modified
    // Set by whoever places the row.
    required property Theme.Look look

    height: Theme.fileRowHeight
    color: mouseArea.containsMouse ? fileRow.look.rowHover : Theme.transparent

    Text {
        id: nameText
        anchors.left: parent.left
        anchors.right: sizeText.left
        anchors.leftMargin: Theme.fileRowPadding
        anchors.verticalCenter: parent.verticalCenter
        text: fileRow.name
        elide: Text.ElideRight
        color: fileRow.look.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fileNameSize
    }

    Text {
        id: sizeText
        anchors.right: dateText.left
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.fileSizeWidth
        horizontalAlignment: Text.AlignRight
        text: fileRow.size
        color: fileRow.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fileDetailSize
    }

    Text {
        id: dateText
        anchors.right: parent.right
        anchors.rightMargin: Theme.fileRowPadding
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.fileDateWidth
        horizontalAlignment: Text.AlignRight
        text: fileRow.modified
        color: fileRow.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fileDetailSize
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: console.log("File clicked:", fileRow.name)
    }
}
