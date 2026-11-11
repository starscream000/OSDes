import QtQuick

// The move between Home and an app context. Home's tiles are given this
// object by whoever places them, and use it to move aside while the app's
// content grows out of the origin, and to come back in reverse.
QtObject {
    id: move

    // 0: Home is in front. 1: the app is in front.
    property real progress: 0
    // The content area. The origin and every offset are in its coordinates.
    property Item area: null
    // The tile or bar button the app grows out of. It does not move itself.
    property Item originItem: null
    // The origin's rectangle, taken when the move starts.
    property rect origin: Qt.rect(0, 0, 0, 0)

    // Emitted when a move into an app starts, before progress changes.
    // Movable items take their offset from offsetFor() then.
    signal started()

    // Begin a move into an app from `from`.
    function start(from: Item) {
        move.originItem = from
        if (from && from.parent && move.area) {
            // Map from the parent, so a pressed tile's shrink does not count.
            const topLeft = from.parent.mapToItem(move.area, from.x, from.y)
            move.origin = Qt.rect(topLeft.x, topLeft.y, from.width, from.height)
        }
        move.started()
    }

    // How far `item` moves when the app is fully in front: away from the
    // origin, toward the nearest content area edge on that side, and far
    // enough to be entirely outside the area. Items going the same way all
    // travel the full width or height, so they keep formation.
    function offsetFor(item: Item): point {
        if (!move.area || !item.parent || item === move.originItem)
            return Qt.point(0, 0)
        // Map from the parent, so the item's own offset does not count.
        const topLeft = item.parent.mapToItem(move.area, item.x, item.y)
        const awayX = topLeft.x + item.width / 2 - (move.origin.x + move.origin.width / 2)
        const awayY = topLeft.y + item.height / 2 - (move.origin.y + move.origin.height / 2)
        // An item already past an edge needs no distance to it, never a
        // step back toward the area.
        const toLeft = Math.min(0, -(topLeft.x + item.width))
        const toRight = Math.max(0, move.area.width - topLeft.x)
        const toTop = Math.min(0, -(topLeft.y + item.height))
        const toBottom = Math.max(0, move.area.height - topLeft.y)
        const across = awayX < 0 ? toLeft : awayX > 0 ? toRight
                     : (Math.abs(toLeft) < toRight ? toLeft : toRight)
        const down = awayY < 0 ? toTop : awayY > 0 ? toBottom
                   : (Math.abs(toTop) < toBottom ? toTop : toBottom)
        if (Math.abs(across) <= Math.abs(down))
            return Qt.point(Math.sign(across) * Math.max(Math.abs(across), move.area.width), 0)
        return Qt.point(0, Math.sign(down) * Math.max(Math.abs(down), move.area.height))
    }
}
