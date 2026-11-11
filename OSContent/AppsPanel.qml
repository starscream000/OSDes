pragma ComponentBehavior: Bound
import QtQuick
import OS

// The Apps panel: the tile groups from HomeModel, laid out left to right
// and wrapping onto new rows. Scrolls up and down when the rows do not fit.
// The first slot can hold an app in mini size; the groups then follow it.
Flickable {
    id: appsPanel

    // Set by whoever places the panel; passed on to its groups.
    required property Theme.Look look
    // Set by whoever places the panel on Home; passed on to its groups.
    property Rearrangement move: null
    // What sits in the first slot, before the groups.
    default property alias firstSlot: firstSlot.data
    // Whether the first slot is taken. When it is not, the groups start there.
    property bool firstSlotTaken: false

    // The groups move to their new places when the slot opens or closes,
    // but only while Home is at rest; during a move into or out of an app,
    // Home is not in view. Nothing else, such as the first layout, animates.
    onFirstSlotTakenChanged: groupFlow.animates = !appsPanel.move || appsPanel.move.progress === 0

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

    HomeModel {
        id: homeModel
    }

    Flow {
        id: groupFlow

        // Whether the next layout animates. Set when the slot changes.
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

        Item {
            id: firstSlot
            width: Theme.span(Theme.groupUnits)
            height: Theme.groupHeaderHeight + Theme.span(Theme.groupUnits)
            visible: appsPanel.firstSlotTaken
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
