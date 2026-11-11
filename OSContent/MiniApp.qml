import QtQuick
import OS

// An app sitting on Home in mini size: a block with the footprint of one
// tile group. Its header line shows the app's name, where a group shows its
// label, with enlarge and close controls on the right. Below it, a flat
// body holds compact headings and the current heading's content.
Item {
    id: miniApp

    required property string context
    required property string title
    // Set by whoever places the block: the look of the page it sits on (the
    // header line), and the look inside the body.
    required property Theme.Look look
    required property Theme.Look bodyLook
    required property list<string> headings
    // The current heading's content. It fills the space below the headings.
    default property alias content: contentArea.data

    property int currentIndex: 0
    // The app's content area; a move into full size grows out of it.
    readonly property alias body: body
    readonly property alias hovered: hoverHandler.hovered

    width: Theme.span(Theme.groupUnits)
    height: Theme.groupHeaderHeight + Theme.span(Theme.groupUnits)

    HoverHandler {
        id: hoverHandler
    }

    Text {
        id: titleText
        anchors.left: parent.left
        anchors.top: parent.top
        text: miniApp.title
        color: miniApp.look.textSecondary
        font.family: Theme.fontFamily
        font.pixelSize: Theme.groupLabelSize
    }

    Row {
        id: controls
        anchors.right: parent.right
        anchors.verticalCenter: titleText.verticalCenter
        spacing: Theme.controlSpacing

        AppControl {
            id: enlargeControl
            kind: "enlarge"
            look: miniApp.look
            onClicked: Shell.enlarge(miniApp.context)
        }

        AppControl {
            id: closeControl
            kind: "close"
            look: miniApp.look
            onClicked: Shell.close(miniApp.context)
        }
    }

    Rectangle {
        id: body
        y: Theme.groupHeaderHeight
        width: Theme.span(Theme.groupUnits)
        height: Theme.span(Theme.groupUnits)
        color: miniApp.bodyLook.background

        PanelTabs {
            id: tabs
            x: Theme.miniMargin
            y: Theme.miniMargin
            look: miniApp.bodyLook
            headings: miniApp.headings
            currentIndex: miniApp.currentIndex
            textSize: Theme.miniTabSize
            spacing: Theme.miniTabSpacing
            onTabClicked: index => miniApp.currentIndex = index
        }

        Item {
            id: contentArea
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: tabs.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: Theme.miniMargin
            anchors.rightMargin: Theme.miniMargin
            anchors.topMargin: Theme.miniTabsGap
        }
    }
}
