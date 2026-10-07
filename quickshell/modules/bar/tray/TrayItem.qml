pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.theme
import qs.components

Item {
    id: root

    property bool shown: true
    property bool fillWidth: false

    property alias icon: iconItem.icon
    property string text: ""
    property int textSize: 12

    property bool alert: false

    property Component popup: null
    property Component hover: null
    property TrayPopup _popup: null
    property TrayHover _hover: null

    property string hoverText: ""
    property bool clickable: popup !== null

    default property alias content: contentArea.data

    readonly property bool hasLabel: icon.name !== "" || text !== ""
    readonly property bool popupOpen: _popup ? _popup.open : false
    readonly property color contentColor: popupOpen ? Theme.colors.onActive : alert ? Theme.colors.alert : Theme.colors.fg

    signal clicked

    implicitWidth: hasLabel ? row.implicitWidth + (clickable ? 12 : 0) : contentArea.children.length > 0 ? contentArea.children[0].implicitWidth : 0
    implicitHeight: hasLabel ? 30 : contentArea.children.length > 0 ? contentArea.children[0].implicitHeight : 0

    function togglePopup(): void {
        if (!_popup)
            _popup = popup.createObject(root, {
                anchorItem: root
            });
        hideHover();
        _popup.open = !_popup.open;
    }

    function showHover(): void {
        if (popupOpen)
            return;
        if (!_hover) {
            let component = hover ?? (hoverText !== "" ? defaultHover : null);
            if (!component)
                return;
            _hover = component.createObject(root, {
                anchorItem: root
            });
        }
        _hover.open = true;
    }

    function hideHover(): void {
        hoverTimer.stop();
        if (_hover)
            _hover.open = false;
    }

    Component {
        id: defaultHover
        TrayHover {
            text: root.hoverText
        }
    }

    Timer {
        id: hoverTimer
        interval: 400
        onTriggered: root.showHover()
    }

    Rectangle {
        anchors.fill: parent
        visible: root.clickable
        radius: Theme.control.radius
        color: {
            if (root.popupOpen)
                return Theme.colors.active;
            if (tapHandler.pressed)
                return Theme.colors.controlPressedFill;
            if (hoverHandler.hovered)
                return Theme.colors.controlHoverFill;
            return "transparent";
        }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        visible: root.hasLabel
        spacing: 5

        ShellIcon {
            id: iconItem
            visible: icon.name !== ""
            icon.size: 18
            icon.color: root.contentColor
        }

        UIText {
            visible: root.text !== ""
            text: root.text
            color: root.contentColor
            font.pixelSize: root.textSize
        }
    }

    Item {
        id: contentArea
        anchors.fill: parent
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onHoveredChanged: hovered ? hoverTimer.restart() : root.hideHover()
    }

    TapHandler {
        id: tapHandler
        enabled: root.clickable
        onTapped: {
            root.clicked();
            if (root.popup)
                root.togglePopup();
        }
    }
}
