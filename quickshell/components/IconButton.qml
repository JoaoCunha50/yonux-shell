import QtQuick
import qs.theme

Rectangle {
    id: root

    property string icon: ""
    property string iconFamily: Icons.family
    property int iconSize: 18
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

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: root.enabled && root.active ? Theme.colors.onActive : Theme.colors.fg
        font.family: root.iconFamily
        font.pixelSize: root.iconSize
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
