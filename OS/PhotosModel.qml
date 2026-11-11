import QtQuick

// Mock content of the Photos app. There are no images: each photo is a
// plain tile, named by where or when it was taken, in one of the four tile
// sizes. Photos has no rows.
ListModel {
    ListElement {
        heading: qsTr("Recent")
        tiles: [
            ListElement { name: "Harbour at dusk";    size: "large" },
            ListElement { name: "Market, Saturday";   size: "medium" },
            ListElement { name: "Rooftops";           size: "small" },
            ListElement { name: "Tram stop";          size: "small" },
            ListElement { name: "Coast road";         size: "wide" },
            ListElement { name: "Garden, 9 Nov";      size: "medium" },
            ListElement { name: "Bridge in fog";      size: "medium" },
            ListElement { name: "Window light";       size: "small" }
        ]
        rows: []
    }

    ListElement {
        heading: qsTr("Albums")
        tiles: [
            ListElement { name: "Lisbon, May";        size: "wide" },
            ListElement { name: "Mountains 2026";     size: "large" },
            ListElement { name: "Birthday";           size: "medium" },
            ListElement { name: "Allotment";          size: "medium" },
            ListElement { name: "Night walks";        size: "wide" },
            ListElement { name: "Snow day";           size: "small" },
            ListElement { name: "Old prints";         size: "small" }
        ]
        rows: []
    }

    ListElement {
        heading: qsTr("Favourites")
        tiles: [
            ListElement { name: "First swim";         size: "medium" },
            ListElement { name: "Lighthouse";         size: "large" },
            ListElement { name: "Cat on the stairs";  size: "small" },
            ListElement { name: "Sunrise, 2 Aug";     size: "wide" },
            ListElement { name: "Picnic";             size: "medium" },
            ListElement { name: "Station clock";      size: "small" }
        ]
        rows: []
    }
}
