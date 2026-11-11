import QtQuick

// Mock content of the Music app. Nothing plays. Every album, artist,
// playlist, and track name is invented.
//
// Each element is one heading. Its tiles are albums, artists, or
// playlists, medium or wide; its rows are tracks: name, artist (detail),
// and length (secondDetail). Albums and Artists have tiles only.
ListModel {
    ListElement {
        heading: qsTr("Listen now")
        tiles: [
            ListElement { name: "Harbour Lights";      size: "wide" },
            ListElement { name: "Paper Satellites";    size: "medium" },
            ListElement { name: "Slow Morning Mix";    size: "medium" },
            ListElement { name: "The Quiet Engines";   size: "wide" },
            ListElement { name: "Copper Rain";         size: "medium" },
            ListElement { name: "Late Tram Home";      size: "medium" }
        ]
        rows: [
            ListElement { name: "Lanterns on the Pier"; detail: "Marrow & Finch";    secondDetail: "3:42" },
            ListElement { name: "Static Bloom";         detail: "The Quiet Engines"; secondDetail: "4:15" },
            ListElement { name: "Northbound";           detail: "Ilse Varga";        secondDetail: "2:58" },
            ListElement { name: "Glass Orchard";        detail: "Copper Rain";       secondDetail: "5:01" },
            ListElement { name: "Tin Roof Waltz";       detail: "Odd Harbour";       secondDetail: "3:27" },
            ListElement { name: "Small Hours";          detail: "Marrow & Finch";    secondDetail: "4:44" },
            ListElement { name: "Kite Season";          detail: "Juno Pell";         secondDetail: "3:09" },
            ListElement { name: "Under the Overpass";   detail: "The Quiet Engines"; secondDetail: "6:12" }
        ]
    }

    ListElement {
        heading: qsTr("Albums")
        tiles: [
            ListElement { name: "Harbour Lights";     size: "wide" },
            ListElement { name: "Paper Satellites";   size: "medium" },
            ListElement { name: "Glass Orchard";      size: "medium" },
            ListElement { name: "Northbound";         size: "wide" },
            ListElement { name: "Tin Roof Stories";   size: "medium" },
            ListElement { name: "Static Bloom";       size: "medium" },
            ListElement { name: "Kite Season";        size: "wide" },
            ListElement { name: "Small Hours";        size: "medium" }
        ]
        rows: []
    }

    ListElement {
        heading: qsTr("Artists")
        tiles: [
            ListElement { name: "Marrow & Finch";     size: "medium" },
            ListElement { name: "The Quiet Engines";  size: "wide" },
            ListElement { name: "Ilse Varga";         size: "medium" },
            ListElement { name: "Copper Rain";        size: "medium" },
            ListElement { name: "Odd Harbour";        size: "wide" },
            ListElement { name: "Juno Pell";          size: "medium" },
            ListElement { name: "Velvet Antenna";     size: "medium" }
        ]
        rows: []
    }

    ListElement {
        heading: qsTr("Playlists")
        tiles: [
            ListElement { name: "Slow Morning Mix";   size: "wide" },
            ListElement { name: "Late Tram Home";     size: "medium" },
            ListElement { name: "Rainy Desk";         size: "medium" },
            ListElement { name: "Long Drive North";   size: "wide" },
            ListElement { name: "Kitchen Radio";      size: "medium" },
            ListElement { name: "Focus Hours";        size: "medium" }
        ]
        rows: [
            ListElement { name: "Morning Static";       detail: "Velvet Antenna";    secondDetail: "3:33" },
            ListElement { name: "Lanterns on the Pier"; detail: "Marrow & Finch";    secondDetail: "3:42" },
            ListElement { name: "Cardboard Moon";       detail: "Juno Pell";         secondDetail: "2:51" },
            ListElement { name: "Ferry Lights";         detail: "Odd Harbour";       secondDetail: "4:08" },
            ListElement { name: "Pocket Weather";       detail: "Ilse Varga";        secondDetail: "3:16" },
            ListElement { name: "Glass Orchard";        detail: "Copper Rain";       secondDetail: "5:01" },
            ListElement { name: "Engine Hymn";          detail: "The Quiet Engines"; secondDetail: "7:20" },
            ListElement { name: "Last Tram";            detail: "Velvet Antenna";    secondDetail: "3:58" }
        ]
    }
}
