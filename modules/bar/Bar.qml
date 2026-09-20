import QtQuick.Layouts
import QtQuick
import Quickshell.Hyprland
import "widgets"
import "../theme"

Rectangle {
    id: bar

    width: parent.width
    implicitHeight: Theme.barHeight
    color: Theme.bg

    RowLayout {
        anchors {
            left: parent.left
            right: parent.right
            leftMargin: 15
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }

        Workspaces {
            id: leftWidgets
        }
        Item {
            Layout.fillWidth: true
        }
        Clock {
            id: rightWidgets
        }
    }

    Text {
        anchors.centerIn: parent
        width: Math.max(0, parent.width - 2 * Math.max(leftWidgets.width, rightWidgets.width) - 16)
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight

        text: Hyprland.activeToplevel?.title ?? `Workspace ${Hyprland.focusedWorkspace?.name ?? "?"}`
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: Theme.titleFontSize
        color: Theme.fg
    }
}
