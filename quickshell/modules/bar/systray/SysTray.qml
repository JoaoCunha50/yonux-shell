import QtQuick
import Quickshell.Services.SystemTray
import qs.theme

Rectangle {
    id: root

    implicitWidth: row.implicitWidth + 2 * Theme.spacing.sm
    implicitHeight: 30
    radius: height / 1.5
    color: Theme.colors.controlHoverFill
    clip: true

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Motion.small
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Motion.standard
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacing.xs

        Repeater {
            model: SystemTray.items
            delegate: SysTrayButton {}
        }
    }
}
