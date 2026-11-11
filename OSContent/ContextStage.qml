pragma ComponentBehavior: Bound
import QtQuick
import OS

// The home page: Home, or the app context in front, and the move between
// them. Both are drawn by ContextView. Opening an app does not put a new
// screen on top: Home's headings slide out as the app's slide in, the app's
// content grows out of the tile or bar button it was opened from, and
// Home's other tiles move aside. Going back plays the same move in reverse.
FocusScope {
    id: stage

    // Leaving and arriving headings move together along one line, the
    // arriving names just behind the leaving ones.
    readonly property real headingTravel: Math.max(homeView.headingsWidth, filesView.headingsWidth) + Theme.tabSpacing

    // The heading names of a model whose elements have a `heading`.
    function headingsOf(model: ListModel): list<string> {
        let names = []
        for (let i = 0; i < model.count; ++i)
            names.push(model.get(i).heading)
        return names
    }

    // Run the move to whichever context is now in front.
    function playMove() {
        const toApp = Shell.front !== Shell.homeContext
        if (toApp)
            move.start(Shell.origin)
        moveAnimation.stop()
        moveAnimation.to = toApp ? 1 : 0
        moveAnimation.start()
    }

    focus: true
    onVisibleChanged: {
        if (stage.visible)
            stage.forceActiveFocus()
    }

    Keys.onEscapePressed: Shell.goHome()

    Connections {
        target: Shell
        function onFrontChanged() {
            stage.playMove()
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
        currentIndex: 1
        presence: 1 - move.progress
        headingSide: -1
        headingTravel: stage.headingTravel

        NowPanel {
            width: homeView.panelWidth
            height: homeView.panelHeight
            look: Theme.home
        }

        AppsPanel {
            width: homeView.panelWidth
            height: homeView.panelHeight
            look: Theme.home
            move: move
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
}
