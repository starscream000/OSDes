import QtQuick
import OS

// One context drawn in the shell: its headings at the top and, below them,
// one panel per heading side by side. Home and every app use this same
// component. Heading clicks, sideways drags, and the Left and Right keys
// all move between panels, and the headings always show the current one.
//
// While a move between contexts runs, `presence` goes between 0 (gone) and
// 1 (in front). The headings slide along their line from `headingSide`, and
// a growing context's content grows out of `growFrom` to fill its area.
FocusScope {
    id: view

    // Set by whoever places the view.
    required property Theme.Look look
    required property list<string> headings
    // The panels, one per heading. Size them to panelWidth x panelHeight.
    default property alias panels: panelRow.data

    // Index of the panel showing.
    property alias currentIndex: pager.currentIndex
    readonly property int panelWidth: pager.panelWidth
    readonly property int panelHeight: pager.height

    property real presence: 1
    // -1: the headings leave and return on the left; 1: on the right.
    property int headingSide: -1
    // How far the headings travel between gone and in front. Set it to more
    // than the widest heading row, so leaving and arriving names never meet.
    property real headingTravel: 0
    // Width of this context's heading names.
    readonly property real headingsWidth: tabs.width
    // Whether the content grows out of `growFrom` (content area coordinates).
    property bool grows: false
    property rect growFrom: Qt.rect(0, 0, 0, 0)

    function showPanel(index: int) {
        pager.currentIndex = Math.max(0, Math.min(index, view.headings.length - 1))
    }

    function between(from: real, to: real): real {
        return from + (to - from) * view.presence
    }

    Keys.onLeftPressed: view.showPanel(pager.currentIndex - 1)
    Keys.onRightPressed: view.showPanel(pager.currentIndex + 1)

    // The line the headings sit on. Names that leave slide out past its
    // left end, at the page margin.
    Item {
        id: headingLine
        x: Theme.pageMargin
        y: Theme.headerTop
        width: view.width - Theme.pageMargin
        height: tabs.height
        clip: view.presence < 1

        PanelTabs {
            id: tabs
            x: view.headingSide * (1 - view.presence) * view.headingTravel
            look: view.look
            headings: view.headings
            currentIndex: pager.currentIndex
            onTabClicked: index => view.showPanel(index)
        }
    }

    // Where the content sits once it is in front.
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.topMargin: Theme.panelTop

        // The part of the content area showing. A growing context starts at
        // `growFrom` in the colour of a tile and ends filling the area.
        Item {
            id: contentBox
            x: view.grows ? view.between(view.growFrom.x, 0) : 0
            y: view.grows ? view.between(view.growFrom.y, 0) : 0
            width: view.grows ? view.between(view.growFrom.width, contentArea.width) : contentArea.width
            height: view.grows ? view.between(view.growFrom.height, contentArea.height) : contentArea.height
            clip: view.grows

            Rectangle {
                id: growFill
                anchors.fill: parent
                visible: view.grows
                color: Qt.rgba(view.between(view.look.tileFill.r, view.look.background.r),
                               view.between(view.look.tileFill.g, view.look.background.g),
                               view.between(view.look.tileFill.b, view.look.background.b), 1)
            }

            // A sideways pager. It always comes to rest with one panel at its
            // left edge; a drag settles on the nearest panel, or the next one
            // when the drag ends with a quick flick.
            Flickable {
                id: pager

                property int currentIndex: 0
                readonly property int count: view.headings.length
                // Each panel leaves room for the edge of the next one.
                readonly property int panelWidth: Math.max(0, pager.width - Theme.panelPeek)
                function snapTo(index: int) {
                    snapAnimation.stop()
                    snapAnimation.to = index * pager.panelWidth
                    snapAnimation.start()
                }

                function settleAfterDrag() {
                    // A flick only starts when the pointer was still moving at release.
                    const velocity = pager.flicking ? pager.horizontalVelocity : 0
                    pager.cancelFlick()
                    let target = Math.round(pager.contentX / Math.max(1, pager.panelWidth))
                    if (target === pager.currentIndex && Math.abs(velocity) > Theme.panelFlickVelocity)
                        target += velocity > 0 ? 1 : -1
                    target = Math.max(0, Math.min(target, pager.count - 1))
                    if (target === pager.currentIndex)
                        pager.snapTo(target)
                    else
                        pager.currentIndex = target
                }

                // The content stays where it will be at full size; the box
                // around it only decides how much of it shows.
                x: -contentBox.x
                y: -contentBox.y
                width: contentArea.width
                height: contentArea.height

                // The last panel can also rest at the left edge.
                contentWidth: (pager.count - 1) * pager.panelWidth + pager.width
                contentHeight: pager.height
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                onCurrentIndexChanged: pager.snapTo(pager.currentIndex)
                // Keep the current panel in place when the size changes (and at start).
                onPanelWidthChanged: {
                    snapAnimation.stop()
                    pager.contentX = pager.currentIndex * pager.panelWidth
                }
                onMovementStarted: snapAnimation.stop()
                // Settle once the release has been handled, replacing any free flick.
                onDragEnded: Qt.callLater(pager.settleAfterDrag)

                NumberAnimation {
                    id: snapAnimation
                    target: pager
                    property: "contentX"
                    duration: Theme.panelMoveDuration
                    easing.type: Easing.OutCubic
                }

                Row {
                    id: panelRow
                    height: pager.height
                }

                // The wheel never moves between panels, so the pager cannot stop
                // between two of them. Wheel movement a panel does not use
                // ends here.
                WheelHandler {
                    id: swallowWheel
                    target: null
                }
            }
        }
    }
}
