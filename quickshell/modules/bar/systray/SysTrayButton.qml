pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.theme
import qs.modules.bar.tray

Rectangle {
    id: root

    required property SystemTrayItem modelData

    implicitWidth: 26
    implicitHeight: 26
    radius: width / 1.5

    color: {
        if (anchor.popupOpen)
            return Theme.colors.controlNormalFill;
        if (mouseArea.pressed)
            return Theme.colors.controlPressedFill;
        if (mouseArea.containsMouse)
            return Theme.colors.controlNormalFill;
        return "transparent";
    }

    PopupAnchor {
        id: anchor
        hovered: mouseArea.containsMouse
        hoverText: root.modelData.tooltipTitle || root.modelData.title || root.modelData.id
        popup: root.modelData.hasMenu ? menuComponent : null
    }

    Component {
        id: menuComponent
        TrayMenu {
            handle: root.modelData.menu // qmllint disable unresolved-type
        }
    }

    IconImage {
        anchors.centerIn: parent
        implicitSize: 20
        source: root.modelData.icon
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton)
                root.modelData.secondaryActivate();
            else if (mouse.button === Qt.LeftButton || root.modelData.onlyMenu)
                anchor.togglePopup();
            else
                root.modelData.activate();
        }
    }
}
