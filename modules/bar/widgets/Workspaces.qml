import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import "../../theme"

RowLayout {
    spacing: 8

    Repeater {
        model: 10

        delegate: Rectangle {
            id: wsButton

            required property int index
            property int wsId: index + 1
            property bool isFocused: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === wsId : false

            implicitWidth: 26
            implicitHeight: 26
            radius: 5
            color: isFocused ? Theme.active : Theme.inactive

            Text {
                anchors.centerIn: parent
                text: wsButton.wsId.toString()
                color: wsButton.isFocused ? "#11111b" : Theme.fg
                font.bold: wsButton.isFocused
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                Process {
                    id: changeWorkspace
                    command: ["hyprctl", "eval", "hl.dispatch(hl.dsp.focus({ workspace = \"" + wsButton.wsId + "\" }))"]
                }
                onClicked: {
                    changeWorkspace.running = true;
                }
            }
        }
    }
}
