import QtQuick
import Quickshell

PopupWindow {
    id: launcherWindow

    required property var anchorWindow

    anchor.window: anchorWindow
    anchor.rect.x: (anchorWindow.width - implicitWidth) / 2
    anchor.rect.y: anchorWindow.height + 8

    implicitWidth: 500
    implicitHeight: 400
    visible: false
    color: "transparent"

    LauncherContent {
        anchors.fill: parent
    }
}
