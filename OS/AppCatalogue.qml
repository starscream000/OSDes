import QtQuick

// Every app the shell knows. Adding an app means adding an entry here and
// a model with its content; nothing else in the shell names an app.
QtObject {
    id: catalogue

    readonly property list<AppEntry> apps: [
        AppEntry {
            context: "files"
            name: qsTr("Files")
            content: FilesModel {}
        },
        AppEntry {
            context: "music"
            name: qsTr("Music")
            content: MusicModel {}
        },
        AppEntry {
            context: "photos"
            name: qsTr("Photos")
            content: PhotosModel {}
        }
    ]

    // The entry with this id, or null.
    function find(context: string): AppEntry {
        for (let i = 0; i < catalogue.apps.length; ++i) {
            if (catalogue.apps[i].context === context)
                return catalogue.apps[i]
        }
        return null
    }

    // The entry shown under this name, or null.
    function named(name: string): AppEntry {
        for (let i = 0; i < catalogue.apps.length; ++i) {
            if (catalogue.apps[i].name === name)
                return catalogue.apps[i]
        }
        return null
    }
}
