import QtQuick

// Mock content of the Files app. Nothing here reads the real disk.
//
// Each element is one heading. Its tiles are folders, all medium (no size
// given), and its rows are files: name, size (detail), and date
// (secondDetail). See AppCatalogue for the shape every app's content has.
ListModel {
    ListElement {
        heading: qsTr("Recent")
        tiles: [
            ListElement { name: qsTr("Projects") },
            ListElement { name: qsTr("Screenshots") },
            ListElement { name: qsTr("Invoices") },
            ListElement { name: qsTr("Holiday") },
            ListElement { name: qsTr("Sketches") },
            ListElement { name: qsTr("Recipes") }
        ]
        rows: [
            ListElement { name: "Budget 2026.ods";        detail: "48 KB";  secondDetail: "11 Nov 2026" },
            ListElement { name: "Meeting notes.txt";      detail: "3 KB";   secondDetail: "11 Nov 2026" },
            ListElement { name: "Tile sketch.png";        detail: "1.2 MB"; secondDetail: "10 Nov 2026" },
            ListElement { name: "Letter to landlord.odt"; detail: "22 KB";  secondDetail: "9 Nov 2026" },
            ListElement { name: "Train tickets.pdf";      detail: "180 KB"; secondDetail: "8 Nov 2026" },
            ListElement { name: "Shopping list.txt";      detail: "1 KB";   secondDetail: "7 Nov 2026" },
            ListElement { name: "Beach.jpg";              detail: "3.4 MB"; secondDetail: "5 Nov 2026" },
            ListElement { name: "Release plan.md";        detail: "6 KB";   secondDetail: "3 Nov 2026" }
        ]
    }

    ListElement {
        heading: qsTr("Home")
        tiles: [
            ListElement { name: qsTr("Documents") },
            ListElement { name: qsTr("Downloads") },
            ListElement { name: qsTr("Music") },
            ListElement { name: qsTr("Pictures") },
            ListElement { name: qsTr("Videos") },
            ListElement { name: qsTr("Desktop") }
        ]
        rows: [
            ListElement { name: "notes.txt";         detail: "2 KB";   secondDetail: "11 Nov 2026" },
            ListElement { name: "todo.md";           detail: "1 KB";   secondDetail: "10 Nov 2026" },
            ListElement { name: "avatar.png";        detail: "96 KB";  secondDetail: "2 Oct 2026" },
            ListElement { name: "backup.tar.gz";     detail: "820 MB"; secondDetail: "30 Sep 2026" },
            ListElement { name: "passwords.kdbx";    detail: "64 KB";  secondDetail: "28 Sep 2026" },
            ListElement { name: "resume.pdf";        detail: "210 KB"; secondDetail: "14 Aug 2026" },
            ListElement { name: "wallpaper.jpg";     detail: "2.8 MB"; secondDetail: "1 Aug 2026" },
            ListElement { name: "readme.txt";        detail: "1 KB";   secondDetail: "3 Jun 2026" }
        ]
    }

    ListElement {
        heading: qsTr("Documents")
        tiles: [
            ListElement { name: qsTr("Work") },
            ListElement { name: qsTr("Taxes") },
            ListElement { name: qsTr("Letters") },
            ListElement { name: qsTr("Manuals") },
            ListElement { name: qsTr("Contracts") },
            ListElement { name: qsTr("School") }
        ]
        rows: [
            ListElement { name: "Budget 2026.ods";        detail: "48 KB";  secondDetail: "11 Nov 2026" },
            ListElement { name: "Letter to landlord.odt"; detail: "22 KB";  secondDetail: "9 Nov 2026" },
            ListElement { name: "Release plan.md";        detail: "6 KB";   secondDetail: "3 Nov 2026" },
            ListElement { name: "Car insurance.pdf";      detail: "340 KB"; secondDetail: "21 Oct 2026" },
            ListElement { name: "Recipes.odt";            detail: "75 KB";  secondDetail: "12 Oct 2026" },
            ListElement { name: "Reading list.txt";       detail: "2 KB";   secondDetail: "30 Sep 2026" },
            ListElement { name: "Lease agreement.pdf";    detail: "1.1 MB"; secondDetail: "2 Sep 2026" },
            ListElement { name: "Thesis draft.odt";       detail: "640 KB"; secondDetail: "18 Jul 2026" }
        ]
    }

    ListElement {
        heading: qsTr("Downloads")
        tiles: [
            ListElement { name: qsTr("Installers") },
            ListElement { name: qsTr("Fonts") },
            ListElement { name: qsTr("Papers") },
            ListElement { name: qsTr("Archives") },
            ListElement { name: qsTr("Wallpapers") },
            ListElement { name: qsTr("Drivers") }
        ]
        rows: [
            ListElement { name: "Train tickets.pdf";      detail: "180 KB"; secondDetail: "8 Nov 2026" },
            ListElement { name: "qt-design-studio.exe";   detail: "1.9 GB"; secondDetail: "6 Nov 2026" },
            ListElement { name: "Bank statement.pdf";     detail: "95 KB";  secondDetail: "1 Nov 2026" },
            ListElement { name: "photos.zip";             detail: "410 MB"; secondDetail: "29 Oct 2026" },
            ListElement { name: "map-offline.pbf";        detail: "260 MB"; secondDetail: "20 Oct 2026" },
            ListElement { name: "concert-ticket.pdf";     detail: "120 KB"; secondDetail: "11 Oct 2026" },
            ListElement { name: "driver-update.tar.xz";   detail: "38 MB";  secondDetail: "4 Oct 2026" },
            ListElement { name: "podcast-episode-42.mp3"; detail: "54 MB";  secondDetail: "27 Sep 2026" }
        ]
    }
}
