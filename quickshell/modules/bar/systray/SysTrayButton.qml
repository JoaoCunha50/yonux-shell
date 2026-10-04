pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.theme
import qs.modules.bar.tray

Rectangle {
    id: root

    required property SystemTrayItem modelData

    property TrayMenu _menu: null
    property TrayHover _hover: null
    readonly property bool menuOpen: _menu ? _menu.open : false

    implicitWidth: 26
    implicitHeight: 26
    radius: width / 1.5

    color: {
        if (menuOpen)
            return Theme.colors.controlNormalFill;
        if (mouseArea.pressed)
            return Theme.colors.controlPressedFill;
        if (mouseArea.containsMouse)
            return Theme.colors.controlNormalFill;
        return "transparent";
    }

    function toggleMenu(): void {
        if (!modelData.hasMenu)
            return;
        if (!_menu)
            _menu = menuComponent.createObject(root, {
                anchorItem: root,
                handle: modelData.menu
            });
        hideHover();
        _menu.open = !_menu.open;
    }

    function showHover(): void {
        if (menuOpen)
            return;
        if (!_hover)
            _hover = hoverComponent.createObject(root, {
                anchorItem: root
            });
        _hover.open = true;
    }

    function hideHover(): void {
        hoverTimer.stop();
        if (_hover)
            _hover.open = false;
    }

    Component {
        id: menuComponent
        TrayMenu {}
    }

    Component {
        id: hoverComponent
        TrayHover {
            text: root.modelData.tooltipTitle || root.modelData.title || root.modelData.id
        }
    }

    Timer {
        id: hoverTimer
        interval: 400
        onTriggered: root.showHover()
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

        onContainsMouseChanged: containsMouse ? hoverTimer.restart() : root.hideHover()

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton)
                root.modelData.secondaryActivate();
            else if (mouse.button === Qt.LeftButton || root.modelData.onlyMenu)
                root.toggleMenu();
            else
                root.modelData.activate();
        }
    }
}
