import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.theme

Rectangle {
    id: bar

    property var panelWindow

    width: parent.width
    implicitHeight: Theme.bar.height
    color: Theme.colors.bg

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 0

        RowLayout {
            id: leftSection
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.preferredWidth: 1
            spacing: 10

            Workspaces {}

            Rectangle {
                Layout.preferredWidth: 2
                Layout.preferredHeight: 18
                Layout.alignment: Qt.AlignVCenter
                color: Theme.colors.active
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                elide: Text.ElideRight
                padding: 5

                text: Hyprland.activeToplevel?.title ?? `Workspace ${Hyprland.focusedWorkspace?.name ?? "?"}`
                font.family: Theme.font.family
                font.pixelSize: 12
                color: Theme.colors.fg
            }
        }

        RowLayout {
            id: centerSection
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 8

            Clock {}
        }

        RowLayout {
            id: rightSection
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.preferredWidth: 1
            spacing: 12

            Item {
                Layout.fillWidth: true
            }

            AudioButton {
                Layout.alignment: Qt.AlignVCenter
            }

            Performance {
                Layout.alignment: Qt.AlignVCenter
            }

            Battery {
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
