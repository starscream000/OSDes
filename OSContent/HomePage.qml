import QtQuick
import OS

// Our home: tabs at the top and three side-by-side panels (Now, Apps,
// All apps). Tab clicks, sideways drags, and the Left and Right keys all
// move between panels, and the tabs always show the current one.
FocusScope {
    id: homePage

    // Index of the panel showing: 0 Now, 1 Apps, 2 All apps.
    readonly property alias currentPanel: panels.currentIndex

    function showPanel(index: int) {
        panels.currentIndex = Math.max(0, Math.min(index, panels.count - 1))
    }

    focus: true
    onVisibleChanged: {
        if (homePage.visible)
            homePage.forceActiveFocus()
    }

    Keys.onLeftPressed: homePage.showPanel(panels.currentIndex - 1)
    Keys.onRightPressed: homePage.showPanel(panels.currentIndex + 1)

    PanelTabs {
        id: tabs
        x: Theme.pageMargin
        y: Theme.headerTop
        look: Theme.home
        currentIndex: panels.currentIndex
        onTabClicked: index => homePage.showPanel(index)
    }

    // A sideways pager. It always comes to rest with one panel at its left
    // edge; a drag settles on the nearest panel, or the next one when the
    // drag ends with a quick flick.
    Flickable {
        id: panels

        property int currentIndex: 1
        readonly property int count: panelRow.children.length
        // Each panel leaves room for the edge of the next one.
        readonly property int panelWidth: Math.max(0, panels.width - Theme.panelPeek)
        function snapTo(index: int) {
            snapAnimation.stop()
            snapAnimation.to = index * panels.panelWidth
            snapAnimation.start()
        }

        function settleAfterDrag() {
            // A flick only starts when the pointer was still moving at release.
            const velocity = panels.flicking ? panels.horizontalVelocity : 0
            panels.cancelFlick()
            let target = Math.round(panels.contentX / Math.max(1, panels.panelWidth))
            if (target === panels.currentIndex && Math.abs(velocity) > Theme.panelFlickVelocity)
                target += velocity > 0 ? 1 : -1
            target = Math.max(0, Math.min(target, panels.count - 1))
            if (target === panels.currentIndex)
                panels.snapTo(target)
            else
                panels.currentIndex = target
        }

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: Theme.panelTop

        // The last panel can also rest at the left edge.
        contentWidth: (panels.count - 1) * panels.panelWidth + panels.width
        contentHeight: panels.height
        flickableDirection: Flickable.HorizontalFlick
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        onCurrentIndexChanged: panels.snapTo(panels.currentIndex)
        // Keep the current panel in place when the size changes (and at start).
        onPanelWidthChanged: {
            snapAnimation.stop()
            panels.contentX = panels.currentIndex * panels.panelWidth
        }
        onMovementStarted: snapAnimation.stop()
        // Settle once the release has been handled, replacing any free flick.
        onDragEnded: Qt.callLater(panels.settleAfterDrag)

        NumberAnimation {
            id: snapAnimation
            target: panels
            property: "contentX"
            duration: Theme.panelMoveDuration
            easing.type: Easing.OutCubic
        }

        Row {
            id: panelRow
            height: panels.height

            NowPanel {
                width: panels.panelWidth
                height: panels.height
                look: Theme.home
            }

            AppsPanel {
                width: panels.panelWidth
                height: panels.height
                look: Theme.home
            }

            AllAppsPanel {
                width: panels.panelWidth
                height: panels.height
                look: Theme.home
            }
        }

        // The wheel never moves between panels, so the pager cannot stop
        // between two of them. Wheel movement the Apps panel does not use
        // ends here.
        WheelHandler {
            id: swallowWheel
            target: null
        }
    }
}
