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
}
