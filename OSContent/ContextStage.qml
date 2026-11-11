pragma ComponentBehavior: Bound
import QtQuick
import OS

// The home page: Home, or the app in front, and the moves between them.
// Home and every app in the catalogue are drawn by ContextView. Opening an
// app does not put a new screen on top: the headings swap along their line,
// the app's content grows out of the tile or bar button it was opened from,
// and whatever was in front moves aside. Going back plays the move in
// reverse.
//
// Apps in mini size sit on Home as blocks in the first slots of the Apps
// panel. Going between full and mini is the same move, growing out of or
// shrinking into the block.
FocusScope {
    id: stage

    // Set by whoever places the stage: the bar, whose app buttons moves
    // start from and return to, and the watcher that reports every press.
    property Bar bar: null
    property PressWatcher pressWatcher: null

    // Home's Apps panel, where apps sit in mini size.
    readonly property int appsPanelIndex: 1

    // The move between two contexts: `leaving` goes from in front to gone
    // while `arriving` comes in, as `progress` runs from 0 to 1. At rest,
    // `arriving` is the context showing and `progress` is 1.
    property string leaving: Shell.homeContext
    property string arriving: Shell.homeContext
    property real progress: 1
    // For each of the two: which way its headings go (-1 left, 1 right),
    // and whether its content grows out of, or shrinks into, the origin.
    // They change places with the contexts when a move is reversed.
    property int leavingSide: 1
    property int arrivingSide: -1
    property bool leavingGrows: false
    property bool arrivingGrows: false
    // Whether the move's origin is a mini block.
    property bool fromBlock: false
    // Leaving and arriving headings move together along one line, the
    // arriving names just behind the leaving ones.
    property real headingTravel: 0

    // What each app last grew out of to become full, by id: its Home tile
    // or its bar button, or null when it grew out of its block.
    property var grownFrom: ({})
    // The block last pressed and the block under the pointer, by app id.
    property string pickedBlock: ""
    property string hoveredBlock: ""

    // How far a context is in front: 0 (gone) to 1.
    function presenceOf(context: string): real {
        if (context === stage.arriving)
            return stage.progress
        if (context === stage.leaving)
            return 1 - stage.progress
        return 0
    }

    function sideOf(context: string): int {
        if (context === stage.arriving)
            return stage.arrivingSide
        if (context === stage.leaving)
            return stage.leavingSide
        return context === Shell.homeContext ? -1 : 1
    }

    function growsOf(context: string): bool {
        if (context === stage.arriving)
            return stage.arrivingGrows
        if (context === stage.leaving)
            return stage.leavingGrows
        return false
    }

    function shows(context: string): bool {
        return context === stage.arriving || (context === stage.leaving && stage.progress < 1)
    }

    // The heading names of a model whose elements have a `heading`.
    function headingsOf(model: ListModel): list<string> {
        let names = []
        for (let i = 0; i < model.count; ++i)
            names.push(model.get(i).heading)
        return names
    }

    function viewFor(context: string): ContextView {
        if (context === Shell.homeContext)
            return homeView
        for (let i = 0; i < appViews.count; ++i) {
            if (Shell.catalogue.apps[i].context === context)
                return appViews.itemAt(i) as ContextView
        }
        return null
    }

    function slotOf(context: string): int {
        for (let i = 0; i < blocks.count; ++i) {
            if (blocks.get(i).context === context)
                return i
        }
        return -1
    }

    function blockFor(context: string): MiniApp {
        const i = stage.slotOf(context)
        return i < 0 ? null : appsPanel.slotItems()[i] as MiniApp
    }

    // The block under a press, by app id, or "".
    function blockAt(scenePoint: point): string {
        if (!stage.visible || !stage.shows(Shell.homeContext))
            return ""
        const items = appsPanel.slotItems()
        for (let i = 0; i < items.length; ++i) {
            const block = items[i] as MiniApp
            if (block && block.contains(block.mapFromItem(null, scenePoint.x, scenePoint.y)))
                return block.context
        }
        return ""
    }

    // The block keys apply to: the one under the pointer, or else the one
    // last pressed, while Home is in front.
    function targetBlock(): string {
        if (Shell.front !== Shell.homeContext)
            return ""
        const context = stage.hoveredBlock !== "" ? stage.hoveredBlock : stage.pickedBlock
        return context !== "" && Shell.placeOf(context) === Shell.miniSize ? context : ""
    }

    // Remove the blocks of apps that are no longer mini, except one a
    // running move grows out of or shrinks into.
    function dropBlocks() {
        for (let i = blocks.count - 1; i >= 0; --i) {
            const context = blocks.get(i).context
            const block = stage.blockFor(context)
            const inUse = moveAnimation.running && stage.fromBlock && block && move.originItem === block.body
            if (Shell.placeOf(context) !== Shell.miniSize && !inUse)
                blocks.remove(i)
        }
    }

    // Where a full app shrinks into when it goes back to Home without
    // becoming mini: its Home tile if it grew out of it, else its bar button.
    function returnPoint(context: string): Item {
        const tile = appsPanel.launcherFor(context)
        if (tile && stage.grownFrom[context] === tile)
            return tile
        return stage.bar ? stage.bar.buttonFor(context) : null
    }

    // Play an app's change of place (see Shell.arranged).
    function playArrange(context: string, was: string, now: string, from: Item) {
        if (now === Shell.fullSize) {
            stage.viewFor(context).jumpTo(Shell.headingOf(context))
            if (was === Shell.miniSize) {
                stage.grownFrom[context] = null
                stage.playMove(context, stage.blockFor(context).body, true)
            } else {
                stage.grownFrom[context] = from
                stage.playMove(context, from, false)
            }
        } else if (was === Shell.fullSize) {
            if (now === Shell.miniSize) {
                if (stage.slotOf(context) < 0)
                    blocks.append({ "context": context })
                // Home comes back on the Apps panel with the block in view.
                homeView.jumpTo(stage.appsPanelIndex)
                appsPanel.bringIntoView(appsPanel.slotRect(stage.slotOf(context)), false)
                stage.playMove(Shell.homeContext, stage.blockFor(context).body, true)
            } else {
                stage.playMove(Shell.homeContext, stage.returnPoint(context), false)
            }
        } else if (now === Shell.miniSize) {
            // Straight into mini from its tile, with Home in front.
            blocks.append({ "context": context })
            appsPanel.bringIntoView(appsPanel.slotRect(stage.slotOf(context)), true)
        } else {
            stage.dropBlocks()
        }
    }

    // Move `to` into front, growing out of or shrinking into `origin`.
    function playMove(to: string, origin: Item, originIsBlock: bool) {
        if (moveAnimation.running && to === stage.leaving) {
            // The reverse of the move under way: the same picture, played
            // back from where it is.
            const back = stage.leaving
            stage.leaving = stage.arriving
            stage.arriving = back
            const side = stage.leavingSide
            stage.leavingSide = stage.arrivingSide
            stage.arrivingSide = side
            const grows = stage.leavingGrows
            stage.leavingGrows = stage.arrivingGrows
            stage.arrivingGrows = grows
            stage.progress = 1 - stage.progress
            stage.runMove(Theme.contextMoveDuration * (1 - stage.progress))
            return
        }
        if (moveAnimation.running) {
            // Any other move first finishes the one under way.
            moveAnimation.stop()
            stage.progress = 1
            stage.dropBlocks()
        }
        const from = stage.arriving
        const toHome = to === Shell.homeContext
        stage.leaving = from
        stage.arriving = to
        stage.leavingSide = toHome ? 1 : -1
        stage.arrivingSide = toHome ? -1 : 1
        stage.leavingGrows = toHome && from !== Shell.homeContext
        stage.arrivingGrows = !toHome
        stage.fromBlock = originIsBlock
        stage.headingTravel = Math.max(stage.viewFor(from).headingsWidth, stage.viewFor(to).headingsWidth) + Theme.tabSpacing
        appsPanel.layoutNow()
        move.start(origin)
        stage.progress = 0
        stage.runMove(Theme.contextMoveDuration)
    }

    function runMove(duration: real) {
        moveAnimation.stop()
        moveAnimation.duration = duration
        moveAnimation.to = 1
        moveAnimation.start()
    }

    focus: true
    onVisibleChanged: {
        if (stage.visible)
            stage.forceActiveFocus()
    }

    Keys.onEscapePressed: Shell.goHome()
    Keys.onPressed: event => {
        if (!(event.modifiers & Qt.ControlModifier))
            return
        const inApp = Shell.front !== Shell.homeContext
        const block = stage.targetBlock()
        if (event.key === Qt.Key_Down && inApp) {
            Shell.shrink(Shell.front)
            event.accepted = true
        } else if (event.key === Qt.Key_Up && block !== "") {
            Shell.enlarge(block)
            event.accepted = true
        } else if (event.key === Qt.Key_W && (inApp || block !== "")) {
            Shell.close(inApp ? Shell.front : block)
            event.accepted = true
        }
    }

    Connections {
        target: Shell
        function onStarted(context: string) {
            const view = stage.viewFor(context)
            if (view)
                view.reset()
        }
        function onArranged(context: string, was: string, now: string, from: Item) {
            stage.playArrange(context, was, now, from)
        }
    }

    Connections {
        target: stage.pressWatcher
        function onPressedAt(scenePoint: point) {
            stage.pickedBlock = stage.blockAt(scenePoint)
        }
    }

    Rearrangement {
        id: move
        area: contentArea
        progress: 1 - stage.presenceOf(Shell.homeContext)
    }

    NumberAnimation {
        id: moveAnimation
        target: stage
        property: "progress"
        easing.type: Theme.contextMoveEasing
        onFinished: stage.dropBlocks()
    }

    // The apps sitting on Home in mini size, in the order they became mini.
    // Each element has `context`.
    ListModel {
        id: blocks
    }

    // The content area every context shares, below the headings.
    Item {
        id: contentArea
        anchors.fill: parent
        anchors.topMargin: Theme.panelTop
    }

    ContextView {
        id: homeView
        anchors.fill: parent
        visible: stage.shows(Shell.homeContext)
        focus: Shell.front === Shell.homeContext
        look: Theme.home
        headings: [qsTr("Now"), qsTr("Apps"), qsTr("All apps")]
        // Home opens on Apps.
        currentIndex: stage.appsPanelIndex
        presence: stage.presenceOf(Shell.homeContext)
        headingSide: stage.sideOf(Shell.homeContext)
        headingTravel: stage.headingTravel

        NowPanel {
            width: homeView.panelWidth
            height: homeView.panelHeight
            look: Theme.home
        }

        AppsPanel {
            id: appsPanel
            width: homeView.panelWidth
            height: homeView.panelHeight
            look: Theme.home
            move: move
            slots: blocks
            slotDelegate: MiniApp {
                id: block

                readonly property AppEntry app: Shell.catalogue.find(block.context)

                title: block.app.name
                look: Theme.home
                bodyLook: Theme.homeBlock
                headings: stage.headingsOf(block.app.content)
                move: move

                Component.onCompleted: block.currentIndex = Shell.headingOf(block.context)
                Component.onDestruction: {
                    if (stage.hoveredBlock === block.context)
                        stage.hoveredBlock = ""
                }
                onCurrentIndexChanged: Shell.setHeading(block.context, block.currentIndex)
                onHoveredChanged: {
                    if (block.hovered)
                        stage.hoveredBlock = block.context
                    else if (stage.hoveredBlock === block.context)
                        stage.hoveredBlock = ""
                }

                ContentView {
                    anchors.fill: parent
                    tiles: block.app.content.get(block.currentIndex).tiles
                    rows: block.app.content.get(block.currentIndex).rows
                    look: Theme.homeBlock
                    sideMargin: 0
                    bottomMargin: Theme.miniMargin
                }
            }
        }

        AllAppsPanel {
            width: homeView.panelWidth
            height: homeView.panelHeight
            look: Theme.home
        }
    }

    // One full view per app in the catalogue. The one growing or shrinking
    // is drawn above the others.
    Repeater {
        id: appViews
        model: Shell.catalogue.apps

        delegate: ContextView {
            id: appView

            required property AppEntry modelData
            readonly property string context: appView.modelData.context

            anchors.fill: parent
            z: stage.growsOf(appView.context) ? 2 : 1
            visible: stage.shows(appView.context)
            focus: Shell.front === appView.context
            look: Theme.home
            headings: stage.headingsOf(appView.modelData.content)
            presence: stage.presenceOf(appView.context)
            headingSide: stage.sideOf(appView.context)
            headingTravel: stage.headingTravel
            grows: stage.growsOf(appView.context)
            growFrom: move.origin
            growColor: stage.fromBlock ? Theme.homeBlock.background : Theme.home.tileFill
            controls: [
                AppControl {
                    kind: "mini"
                    look: Theme.home
                    onClicked: Shell.shrink(appView.context)
                },
                AppControl {
                    kind: "close"
                    look: Theme.home
                    onClicked: Shell.close(appView.context)
                }
            ]
            onCurrentIndexChanged: Shell.setHeading(appView.context, appView.currentIndex)

            Repeater {
                model: appView.modelData.content

                delegate: ContentView {
                    required property var model

                    width: appView.panelWidth
                    height: appView.panelHeight
                    tiles: model.tiles
                    rows: model.rows
                    look: Theme.home
                }
            }
        }
    }
}
