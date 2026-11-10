import QtQuick

// Groups and tiles of the home screen.
//
// Each group lists its tiles. A tile gives its name, its size (small,
// medium, wide, or large; see Theme.tileSizes), its colour (a name from
// Theme.tileColors), and the column and row of its top-left corner inside
// the group, in grid units counted from 0. A group is 8 x 8 units.
// The screen places tiles exactly where this data says.
ListModel {
    ListElement {
        title: qsTr("Everyday")
        tiles: [
            ListElement { name: qsTr("Mail");      size: "wide";   tint: "cobalt";  column: 0; row: 0 },
            ListElement { name: qsTr("Calendar");  size: "medium"; tint: "violet";  column: 4; row: 0 },
            ListElement { name: qsTr("Notes");     size: "small";  tint: "orange";  column: 6; row: 0 },
            ListElement { name: qsTr("Contacts");  size: "small";  tint: "teal";    column: 7; row: 0 },
            ListElement { name: qsTr("Messages");  size: "small";  tint: "green";   column: 6; row: 1 },
            ListElement { name: qsTr("Reminders"); size: "small";  tint: "red";     column: 7; row: 1 },
            ListElement { name: qsTr("Weather");   size: "large";  tint: "teal";    column: 0; row: 2 },
            ListElement { name: qsTr("Photos");    size: "medium"; tint: "magenta"; column: 4; row: 2 },
            ListElement { name: qsTr("Music");     size: "medium"; tint: "orange";  column: 6; row: 2 },
            ListElement { name: qsTr("News");      size: "wide";   tint: "red";     column: 4; row: 4 }
        ]
    }

    ListElement {
        title: qsTr("Work")
        tiles: [
            ListElement { name: qsTr("Files");      size: "medium"; tint: "slate";   column: 0; row: 0 },
            ListElement { name: qsTr("Terminal");   size: "medium"; tint: "green";   column: 2; row: 0 },
            ListElement { name: qsTr("Browser");    size: "wide";   tint: "cobalt";  column: 4; row: 0 },
            ListElement { name: qsTr("Editor");     size: "wide";   tint: "violet";  column: 0; row: 2 },
            ListElement { name: qsTr("Calculator"); size: "small";  tint: "slate";   column: 4; row: 2 },
            ListElement { name: qsTr("Camera");     size: "small";  tint: "magenta"; column: 5; row: 2 },
            ListElement { name: qsTr("Maps");       size: "small";  tint: "teal";    column: 4; row: 3 },
            ListElement { name: qsTr("Store");      size: "small";  tint: "orange";  column: 5; row: 3 },
            ListElement { name: qsTr("Settings");   size: "medium"; tint: "slate";   column: 6; row: 2 }
        ]
    }

    ListElement {
        title: qsTr("Play")
        tiles: [
            ListElement { name: qsTr("Videos");   size: "large";  tint: "red";     column: 0; row: 0 },
            ListElement { name: qsTr("Podcasts"); size: "medium"; tint: "violet";  column: 4; row: 0 },
            ListElement { name: qsTr("Games");    size: "medium"; tint: "green";   column: 6; row: 0 },
            ListElement { name: qsTr("Radio");    size: "wide";   tint: "orange";  column: 4; row: 2 },
            ListElement { name: qsTr("Books");    size: "wide";   tint: "teal";    column: 0; row: 4 },
            ListElement { name: qsTr("Recorder"); size: "small";  tint: "magenta"; column: 4; row: 4 },
            ListElement { name: qsTr("Scanner");  size: "small";  tint: "cobalt";  column: 5; row: 4 }
        ]
    }
}
