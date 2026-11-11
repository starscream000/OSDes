pragma Singleton
import QtQuick

// Shared shell state. Components change it; the shell root only reads it.
QtObject {
    id: shell

    // The pages the page area can show.
    readonly property string homePage: "home"
    readonly property string referencePage: "reference"

    // The page showing now. Home is the default.
    property string page: shell.homePage

    // The contexts the home page can show. Home is one; each app is another.
    readonly property string homeContext: "home"
    readonly property string filesContext: "files"

    // Where a running app is: filling the content area (full), sitting on
    // Home as a block (mini), or running but not shown (hidden). Full and
    // mini are also the app's sizes.
    readonly property string fullSize: "full"
    readonly property string miniSize: "mini"
    readonly property string hidden: "hidden"

    // The context in front. Change it with open(), goHome(), and the size
    // functions below.
    property string front: shell.homeContext
    // What the last move into an app started from: a tile or a bar button.
    // Null when the app grew out of its own mini block.
    property Item origin: null

    // App contexts opened so far, with each one's size and whether it is
    // shown. They stay listed after going back home, until closed.
    readonly property RunningAppsModel runningApps: RunningAppsModel {}
    // The size each app was last in, by context. Kept after the app closes,
    // so it reopens in that size.
    property var lastSizes: ({})

    // An app moved from one place to another (fullSize, miniSize, or hidden).
    // Emitted after the state above has changed.
    signal arranged(string context, string was, string now)

    // The name an app context is shown under. Empty for an unknown id.
    function contextName(context: string): string {
        return context === shell.filesContext ? qsTr("Files") : ""
    }

    // The app context a tile with this name opens, or "" if it opens none.
    function contextFor(name: string): string {
        return name === shell.contextName(shell.filesContext) ? shell.filesContext : ""
    }

    // Row of a running app in runningApps, or -1.
    function indexOf(context: string): int {
        for (let i = 0; i < shell.runningApps.count; ++i) {
            if (shell.runningApps.get(i).context === context)
                return i
        }
        return -1
    }

    // Where an app is now: fullSize, miniSize, or hidden (also when closed).
    function placeOf(context: string): string {
        const i = shell.indexOf(context)
        if (i < 0)
            return shell.hidden
        const app = shell.runningApps.get(i)
        return app.shown ? app.size : shell.hidden
    }

    // Put an app in a place, listing it if it is not running yet.
    function arrange(context: string, now: string) {
        const was = shell.placeOf(context)
        let i = shell.indexOf(context)
        if (i < 0) {
            shell.runningApps.append({ "context": context, "name": shell.contextName(context),
                                       "size": shell.fullSize, "shown": false })
            i = shell.runningApps.count - 1
        }
        if (now !== shell.hidden) {
            shell.runningApps.setProperty(i, "size", now)
            shell.lastSizes[context] = now
        }
        shell.runningApps.setProperty(i, "shown", now !== shell.hidden)
        shell.page = shell.homePage
        if (now === shell.fullSize)
            shell.front = context
        else if (shell.front === context)
            shell.front = shell.homeContext
        if (was !== now)
            shell.arranged(context, was, now)
    }

    // Show an app, growing it out of `from`. It opens in the size it was
    // last in; an app sitting on Home in mini size becomes full.
    function open(context: string, from: Item) {
        const place = shell.placeOf(context)
        if (place === shell.miniSize) {
            shell.enlarge(context)
        } else if (place === shell.fullSize) {
            shell.page = shell.homePage
        } else {
            const i = shell.indexOf(context)
            const size = i >= 0 ? shell.runningApps.get(i).size
                       : shell.lastSizes[context] === shell.miniSize ? shell.miniSize : shell.fullSize
            if (size === shell.fullSize)
                shell.origin = from
            shell.arrange(context, size)
        }
    }

    // Full to mini: the app moves onto Home as a block.
    function shrink(context: string) {
        shell.arrange(context, shell.miniSize)
    }

    // Mini to full: the app grows out of its block on Home.
    function enlarge(context: string) {
        shell.origin = null
        shell.arrange(context, shell.fullSize)
    }

    // Close an app: it leaves Home and the bar. From full size it first goes
    // back home with the reverse move.
    function close(context: string) {
        if (shell.indexOf(context) < 0)
            return
        shell.arrange(context, shell.hidden)
        shell.runningApps.remove(shell.indexOf(context))
    }

    // Go back to Home, on the panel it was left on. An app in front stays
    // running in full size, not shown.
    function goHome() {
        shell.page = shell.homePage
        if (shell.front !== shell.homeContext)
            shell.arrange(shell.front, shell.hidden)
    }
}
