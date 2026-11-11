import QtQuick

// One app in the catalogue: its id, the name its Home tile and bar button
// show, and its content.
//
// `content` is a ListModel with one element per heading, in order. Each
// element has `heading` (the name), `tiles` (each with `name` and an
// optional `size`: small, medium, wide, or large; medium when not given),
// and `rows` (each with `name`, `detail`, and `secondDetail`). Either list
// may be empty.
QtObject {
    required property string context
    required property string name
    required property ListModel content
}
