import QtQuick
import qs.theme

Rectangle {
    id: root

    property alias icon: iconItem.icon

    property bool active: false
    property bool checkable: false
    property string tooltip: ""

    readonly property bool hovered: mouseArea.containsMouse
    readonly property bool pressed: mouseArea.pressed

    signal clicked

    implicitWidth: 30
    implicitHeight: 30
    radius: Theme.control.radius
    color: {
        if (!root.enabled)
            return Theme.colors.controlDisabledFill;
        if (root.pressed)
            return Theme.colors.controlPressedFill;
        if (root.active)
            return Theme.colors.active;
        if (root.hovered)
            return Theme.colors.controlHoverFill;
        return "transparent";
    }

    ShellIcon {
        id: iconItem
        anchors.centerIn: parent
        icon.size: 18
        icon.color: root.enabled && root.active ? Theme.colors.onActive : Theme.colors.fg
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (root.checkable)
                root.active = !root.active;
            root.clicked();
        }
    }
}
