import QtQuick

// Mock content of the Files app. Nothing here reads the real disk.
//
// Each element is one heading of Files. It lists the folders shown under
// that heading (as tiles) and the files (as rows), in display order.
ListModel {
    ListElement {
        heading: qsTr("Recent")
        folders: [
            ListElement { name: qsTr("Projects") },
            ListElement { name: qsTr("Screenshots") },
            ListElement { name: qsTr("Invoices") },
            ListElement { name: qsTr("Holiday") }
        ]
        files: [
            ListElement { name: "Budget 2026.ods";        size: "48 KB";  modified: "11 Nov 2026" },
            ListElement { name: "Meeting notes.txt";      size: "3 KB";   modified: "11 Nov 2026" },
            ListElement { name: "Tile sketch.png";        size: "1.2 MB"; modified: "10 Nov 2026" },
            ListElement { name: "Letter to landlord.odt"; size: "22 KB";  modified: "9 Nov 2026" },
            ListElement { name: "Train tickets.pdf";      size: "180 KB"; modified: "8 Nov 2026" },
            ListElement { name: "Shopping list.txt";      size: "1 KB";   modified: "7 Nov 2026" },
            ListElement { name: "Beach.jpg";              size: "3.4 MB"; modified: "5 Nov 2026" },
            ListElement { name: "Release plan.md";        size: "6 KB";   modified: "3 Nov 2026" }
        ]
    }

    ListElement {
        heading: qsTr("Home")
        folders: [
            ListElement { name: qsTr("Documents") },
            ListElement { name: qsTr("Downloads") },
            ListElement { name: qsTr("Music") },
            ListElement { name: qsTr("Pictures") },
            ListElement { name: qsTr("Videos") },
            ListElement { name: qsTr("Desktop") }
        ]
        files: [
            ListElement { name: "notes.txt";         size: "2 KB";   modified: "11 Nov 2026" },
            ListElement { name: "todo.md";           size: "1 KB";   modified: "10 Nov 2026" },
            ListElement { name: "avatar.png";        size: "96 KB";  modified: "2 Oct 2026" },
            ListElement { name: "backup.tar.gz";     size: "820 MB"; modified: "30 Sep 2026" },
            ListElement { name: "passwords.kdbx";    size: "64 KB";  modified: "28 Sep 2026" },
            ListElement { name: "resume.pdf";        size: "210 KB"; modified: "14 Aug 2026" },
            ListElement { name: "wallpaper.jpg";     size: "2.8 MB"; modified: "1 Aug 2026" },
            ListElement { name: "readme.txt";        size: "1 KB";   modified: "3 Jun 2026" }
        ]
    }

    ListElement {
        heading: qsTr("Documents")
        folders: [
            ListElement { name: qsTr("Work") },
            ListElement { name: qsTr("Taxes") },
            ListElement { name: qsTr("Letters") },
            ListElement { name: qsTr("Manuals") }
        ]
        files: [
            ListElement { name: "Budget 2026.ods";        size: "48 KB";  modified: "11 Nov 2026" },
            ListElement { name: "Letter to landlord.odt"; size: "22 KB";  modified: "9 Nov 2026" },
            ListElement { name: "Release plan.md";        size: "6 KB";   modified: "3 Nov 2026" },
            ListElement { name: "Car insurance.pdf";      size: "340 KB"; modified: "21 Oct 2026" },
            ListElement { name: "Recipes.odt";            size: "75 KB";  modified: "12 Oct 2026" },
            ListElement { name: "Reading list.txt";       size: "2 KB";   modified: "30 Sep 2026" },
            ListElement { name: "Lease agreement.pdf";    size: "1.1 MB"; modified: "2 Sep 2026" },
            ListElement { name: "Thesis draft.odt";       size: "640 KB"; modified: "18 Jul 2026" }
        ]
    }

    ListElement {
        heading: qsTr("Downloads")
        folders: [
            ListElement { name: qsTr("Installers") },
            ListElement { name: qsTr("Fonts") },
            ListElement { name: qsTr("Papers") },
            ListElement { name: qsTr("Archives") }
        ]
        files: [
            ListElement { name: "Train tickets.pdf";      size: "180 KB"; modified: "8 Nov 2026" },
            ListElement { name: "qt-design-studio.exe";   size: "1.9 GB"; modified: "6 Nov 2026" },
            ListElement { name: "Bank statement.pdf";     size: "95 KB";  modified: "1 Nov 2026" },
            ListElement { name: "photos.zip";             size: "410 MB"; modified: "29 Oct 2026" },
            ListElement { name: "map-offline.pbf";        size: "260 MB"; modified: "20 Oct 2026" },
            ListElement { name: "concert-ticket.pdf";     size: "120 KB"; modified: "11 Oct 2026" },
            ListElement { name: "driver-update.tar.xz";   size: "38 MB";  modified: "4 Oct 2026" },
            ListElement { name: "podcast-episode-42.mp3"; size: "54 MB";  modified: "27 Sep 2026" }
        ]
    }
}
