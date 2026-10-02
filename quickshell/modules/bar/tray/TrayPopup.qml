import QtQuick
import Quickshell
import qs.theme
import qs.components

PopupWindow {
    id: root

    property bool open: false
    property Item anchorItem: null
    property int gap: 6
    property int padding: 12
    property real _offset: 0

    default property alias content: body.data
    readonly property Item body: body

    color: "transparent"
    visible: false

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom // qmllint disable missing-type
    anchor.gravity: Edges.Bottom // qmllint disable missing-type
    anchor.rect.width: anchorItem ? anchorItem.width : 0
    anchor.rect.height: anchorItem ? anchorItem.height + _offset : 0

    onOpenChanged: {
        if (!open)
            return;
        if (anchorItem)
            _offset = Theme.bar.height - anchorItem.mapToItem(null, 0, 0).y - anchorItem.height + gap;
        visible = true;
    }

    onVisibleChanged: if (!visible)
        open = false

    Reveal {
        anchors.fill: parent
        shown: root.open
        transformOrigin: Item.Top
        onActiveChanged: if (!active)
            root.visible = false

        Rectangle {
            anchors.fill: parent
            color: Theme.colors.bg
            radius: Theme.bar.radius
        }

        Item {
            id: body
            anchors.fill: parent
            anchors.margins: root.padding
        }
    }
}
