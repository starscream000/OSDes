pragma ComponentBehavior: Bound
import QtQuick
import OS

// The home page: Home, or the app context in front, and the move between
// them. Both are drawn by ContextView. Opening an app does not put a new
// screen on top: Home's headings slide out as the app's slide in, the app's
// content grows out of the tile or bar button it was opened from, and
// Home's other tiles move aside. Going back plays the same move in reverse.
//
// An app can also sit on Home in mini size, as a block in the first slot of
// the Apps panel. Going between full and mini is the same move, growing out
// of or shrinking into the block.
FocusScope {
    id: stage

    // Leaving and arriving headings move together along one line, the
    // arriving names just behind the leaving ones.
    readonly property real headingTravel: Math.max(homeView.headingsWidth, filesView.headingsWidth) + Theme.tabSpacing
    // Home's Apps panel, where an app sits in mini size.
    readonly property int appsPanelIndex: 1
    // Whether Files' block takes the first slot of the Apps panel. It stays
    // there while Files grows out of it, and leaves once Files is full.
    property bool blockShown: false
    // Whether the block was the last thing clicked on the page.
    property bool blockPicked: false
    // Whether keys meant for the block apply: it is on Home, and the pointer
    // is over it or it was the last thing clicked.
    readonly property bool blockTargeted: stage.blockShown && Shell.front === Shell.homeContext
                                          && (miniApp.hovered || stage.blockPicked)

    // The heading names of a model whose elements have a `heading`.
    function headingsOf(model: ListModel): list<string> {
        let names = []
        for (let i = 0; i < model.count; ++i)
            names.push(model.get(i).heading)
        return names
    }

    // Play an app's change of place (see Shell.arranged).
    function playArrange(was: string, now: string) {
        if (now === Shell.miniSize) {
            if (was === Shell.fullSize)
                miniApp.currentIndex = filesView.currentIndex
            stage.blockShown = true
        }
        if (now === Shell.fullSize) {
            if (was === Shell.miniSize) {
                filesView.jumpTo(miniApp.currentIndex)
                stage.playMove(1, miniApp.body)
            } else {
                stage.playMove(1, Shell.origin)
            }
        } else if (was === Shell.fullSize) {
            if (now === Shell.miniSize) {
                // Home comes back on the Apps panel with the block in view.
                homeView.jumpTo(stage.appsPanelIndex)
                appsPanel.cancelFlick()
                appsPanel.contentY = 0
                stage.playMove(0, miniApp.body)
            } else {
                stage.blockShown = false
                stage.playMove(0, stage.returnPoint())
            }
        } else if (now === Shell.hidden) {
            stage.blockShown = false
        }
    }

    // Where a full app shrinks into when it goes back to Home without
    // becoming mini: what it grew out of, or its tile if that was its block.
    function returnPoint(): Item {
        return Shell.origin ? Shell.origin : appsPanel.launcherFor(Shell.filesContext)
    }

    // Run the move to `target` progress (1: the app in front), measured
    // around `from`.
    function playMove(target: real, from: Item) {
        appsPanel.layoutNow()
        move.start(from)
        moveAnimation.stop()
        moveAnimation.to = target
        moveAnimation.start()
    }

    focus: true
    onBlockShownChanged: {
        if (!stage.blockShown)
            stage.blockPicked = false
    }
    onVisibleChanged: {
        if (stage.visible)
            stage.forceActiveFocus()
    }

    Keys.onEscapePressed: Shell.goHome()
    Keys.onPressed: event => {
        if (!(event.modifiers & Qt.ControlModifier))
            return
        const inApp = Shell.front !== Shell.homeContext
        if (event.key === Qt.Key_Down && inApp) {
            Shell.shrink(Shell.front)
            event.accepted = true
        } else if (event.key === Qt.Key_Up && stage.blockTargeted) {
            Shell.enlarge(Shell.filesContext)
            event.accepted = true
        } else if (event.key === Qt.Key_W && (inApp || stage.blockTargeted)) {
            Shell.close(inApp ? Shell.front : Shell.filesContext)
            event.accepted = true
        }
    }

    Connections {
        target: Shell
        function onArranged(context: string, was: string, now: string) {
            stage.playArrange(was, now)
        }
    }

    Rearrangement {
        id: move
        area: contentArea
    }

    NumberAnimation {
        id: moveAnimation
        target: move
        property: "progress"
        duration: Theme.contextMoveDuration
        easing.type: Theme.contextMoveEasing
        // Once Files is full, its block is no longer on Home.
        onFinished: {
            if (moveAnimation.to === 1)
                stage.blockShown = false
        }
    }

    FilesModel {
        id: filesModel
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
        visible: move.progress < 1 || Shell.front === Shell.homeContext
        focus: Shell.front === Shell.homeContext
        look: Theme.home
        headings: [qsTr("Now"), qsTr("Apps"), qsTr("All apps")]
        // Home opens on Apps.
        currentIndex: stage.appsPanelIndex
        presence: 1 - move.progress
        headingSide: -1
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
            firstSlotTaken: stage.blockShown

            MiniApp {
                id: miniApp
                context: Shell.filesContext
                title: Shell.contextName(Shell.filesContext)
                look: Theme.home
                bodyLook: Theme.homeBlock
                headings: stage.headingsOf(filesModel)

                FolderView {
                    anchors.fill: parent
                    folders: filesModel.get(miniApp.currentIndex).folders
                    files: filesModel.get(miniApp.currentIndex).files
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

    ContextView {
        id: filesView
        anchors.fill: parent
        visible: move.progress > 0 || Shell.front === Shell.filesContext
        focus: Shell.front === Shell.filesContext
        look: Theme.home
        headings: stage.headingsOf(filesModel)
        presence: move.progress
        headingSide: 1
        headingTravel: stage.headingTravel
        grows: true
        growFrom: move.origin
        growColor: move.originItem === miniApp.body ? Theme.homeBlock.background : Theme.home.tileFill
        controls: [
            AppControl {
                kind: "mini"
                look: Theme.home
                onClicked: Shell.shrink(Shell.filesContext)
            },
            AppControl {
                kind: "close"
                look: Theme.home
                onClicked: Shell.close(Shell.filesContext)
            }
        ]

        Repeater {
            id: folderRepeater
            model: filesModel

            delegate: FolderView {
                required property var model

                width: filesView.panelWidth
                height: filesView.panelHeight
                folders: model.folders
                files: model.files
                look: Theme.home
            }
        }
    }

    // Notes whether each press on the page lands in the block, without
    // taking the press from what is under it.
    MouseArea {
        id: pressWatcher
        anchors.fill: parent
        onPressed: mouse => {
            const inBlock = miniApp.mapFromItem(pressWatcher, mouse.x, mouse.y)
            stage.blockPicked = stage.blockShown && miniApp.contains(inBlock)
            mouse.accepted = false
        }
    }
}
