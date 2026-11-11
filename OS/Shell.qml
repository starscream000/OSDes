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

    // The context in front. Change it with open() or goHome().
    property string front: shell.homeContext
    // What the last move into an app started from: a tile or a bar button.
    property Item origin: null

    // App contexts opened so far. They stay listed after going back home.
    readonly property RunningAppsModel runningApps: RunningAppsModel {}

    // The name an app context is shown under. Empty for an unknown id.
    function contextName(context: string): string {
        return context === shell.filesContext ? qsTr("Files") : ""
    }

    // The app context a tile with this name opens, or "" if it opens none.
    function contextFor(name: string): string {
        return name === shell.contextName(shell.filesContext) ? shell.filesContext : ""
    }

    // Bring an app context to the front, growing it out of `from`.
    function open(context: string, from: Item) {
        let listed = false
        for (let i = 0; i < shell.runningApps.count; ++i)
            listed = listed || shell.runningApps.get(i).context === context
        if (!listed)
            shell.runningApps.append({ "context": context, "name": shell.contextName(context) })
        if (shell.front !== context)
            shell.origin = from
        shell.page = shell.homePage
        shell.front = context
    }

    // Go back to Home, on the panel it was left on.
    function goHome() {
        shell.page = shell.homePage
        shell.front = shell.homeContext
    }
}
