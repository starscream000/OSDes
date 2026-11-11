import QtQuick

// Lies over the whole shell and reports every press, in scene
// coordinates, without taking it from what is under it.
MouseArea {
    id: watcher

    signal pressedAt(point scenePoint)

    onPressed: mouse => {
        watcher.pressedAt(watcher.mapToItem(null, mouse.x, mouse.y))
        mouse.accepted = false
    }
}
