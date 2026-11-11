import QtQuick
import OS

// One item of an app as a plain row: its name on the left, up to two short
// details on the right in secondary text. The row changes shade under the
// pointer.
Rectangle {
    id: contentRow

    required property string name
    required property string detail
    required property string secondDetail
    // Set by whoever places the row.
    required property Theme.Look look

    height: Theme.rowHeight
    color: mouseArea.containsMouse ? contentRow.look.rowHover : Theme.transparent

    Text {
        id: nameText
        anchors.left: parent.left
        anchors.right: detailText.left
        anchors.leftMargin: Theme.rowPadding
        anchors.verticalCenter: parent.verticalCenter
        text: contentRow.name
        elide: Text.ElideRight
        color: contentRow.look.textPrimary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.rowNameSize
    }

    Text {
        id: detailText
        anchors.right: secondDetailText.left
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.rowDetailWidth
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        text: contentRow.detail
        color: contentRow.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.rowDetailSize
    }

    Text {
        id: secondDetailText
        anchors.right: parent.right
        anchors.rightMargin: Theme.rowPadding
        anchors.verticalCenter: parent.verticalCenter
        width: Theme.rowSecondDetailWidth
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
        text: contentRow.secondDetail
        color: contentRow.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.rowDetailSize
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: console.log("Row clicked:", contentRow.name)
    }
}
