pragma ComponentBehavior: Bound
import QtQuick
import OS

// The Apps panel: the tile groups from HomeModel, laid out left to right
// and wrapping onto new rows. Scrolls up and down when the rows do not fit.
// The first slots can hold apps in mini size, one per slot; the groups
// then follow them.
Flickable {
    id: appsPanel

    // Set by whoever places the panel; passed on to its groups.
    required property Theme.Look look
    // Set by whoever places the panel on Home; passed on to its groups.
    property Rearrangement move: null
    // What sits in the first slots, before the groups: one item from
    // `slotDelegate` per element of `slots`, in order.
    property alias slots: slotRepeater.model
    property alias slotDelegate: slotRepeater.delegate

    // The items in the first slots, in order.
    function slotItems(): list<Item> {
        let items = []
        for (let i = 0; i < slotRepeater.count; ++i)
            items.push(slotRepeater.itemAt(i))
        return items
    }

    // Where slot `index` is once the groups have settled, in the panel's
    // content coordinates. Every slot has a group's footprint.
    function slotRect(index: int): rect {
        const width = Theme.span(Theme.groupUnits)
        const height = Theme.groupHeaderHeight + Theme.span(Theme.groupUnits)
        const columns = Math.max(1, Math.floor((groupFlow.width + Theme.groupGap) / (width + Theme.groupGap)))
        return Qt.rect(groupFlow.x + (index % columns) * (width + Theme.groupGap),
                       Math.floor(index / columns) * (height + Theme.groupGap), width, height)
    }

    // Scroll so `area` (content coordinates) is in view, moving as little
    // as possible; with a short move if `animated`.
    function bringIntoView(area: rect, animated: bool) {
        groupFlow.forceLayout()
        let target = appsPanel.contentY
        if (area.y + area.height > target + appsPanel.height)
            target = area.y + area.height - appsPanel.height
        if (area.y < target)
            target = area.y
        target = Math.max(0, Math.min(target, appsPanel.contentHeight - appsPanel.height))
        scrollAnimation.stop()
        appsPanel.cancelFlick()
        if (animated) {
            scrollAnimation.to = target
            scrollAnimation.start()
        } else {
            appsPanel.contentY = target
        }
    }

    // Place everything where it belongs now, without animation, so a move
    // can measure where things are.
    function layoutNow() {
        groupFlow.forceLayout()
    }

    // The tile on this panel that opens `context`, or null.
    function launcherFor(context: string): Item {
        for (let i = 0; i < groupRepeater.count; ++i) {
            const group = groupRepeater.itemAt(i) as TileGroup
            const tile = group ? group.launcherFor(context) : null
            if (tile)
                return tile
        }
        return null
    }

    contentWidth: appsPanel.width
    contentHeight: groupFlow.height + Theme.panelBottomMargin
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    NumberAnimation {
        id: scrollAnimation
        target: appsPanel
        property: "contentY"
        duration: Theme.slotMoveDuration
        easing.type: Theme.slotMoveEasing
    }

    HomeModel {
        id: homeModel
    }

    Flow {
        id: groupFlow

        // Whether the next layout animates. Set when a slot opens or closes.
        property bool animates: false

        x: Theme.pageMargin
        width: appsPanel.width - 2 * Theme.pageMargin
        spacing: Theme.groupGap
        onPositioningComplete: groupFlow.animates = false

        move: Transition {
            enabled: groupFlow.animates

            NumberAnimation {
                properties: "x,y"
                duration: Theme.slotMoveDuration
                easing.type: Theme.slotMoveEasing
            }
        }

        add: Transition {
            enabled: groupFlow.animates

            NumberAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: Theme.slotMoveDuration
                easing.type: Theme.slotMoveEasing
            }
        }

        Repeater {
            id: slotRepeater

            // The groups move to their new places when a slot opens or
            // closes, but only while Home is at rest; during a move into or
            // out of an app, Home is not in view. Nothing else, such as the
            // first layout, animates.
            onCountChanged: groupFlow.animates = !appsPanel.move || appsPanel.move.progress === 0
        }

        Repeater {
            id: groupRepeater
            model: homeModel

            delegate: TileGroup {
                look: appsPanel.look
                move: appsPanel.move
            }
        }
    }
}
