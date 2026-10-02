import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.theme

RowLayout {
    id: root
    spacing: 0

    property int maxWorkspaces: 10

    Repeater {
        model: root.maxWorkspaces

        delegate: Rectangle {
            id: wsButton

            required property int index
            readonly property int wsId: index + 1

            property HyprlandWorkspace modelData: {
                for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                    let ws = Hyprland.workspaces.values[i];
                    if (ws && ws.id === wsId) {
                        return ws;
                    }
                }
                return null;
            }

            readonly property bool isFocused: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id === wsId : false
            readonly property bool exists: modelData !== null
            readonly property bool shouldShow: exists || isFocused

            Layout.preferredWidth: shouldShow ? 26 : 0
            Layout.preferredHeight: 26
            clip: true

            Behavior on Layout.preferredWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InCurve
                }
            }

            opacity: shouldShow ? 1.0 : 0.0
            visible: opacity > 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            implicitWidth: 26
            implicitHeight: 26
            radius: 6
            color: 'transparent'

            Text {
                anchors.centerIn: parent
                text: wsButton.wsId
                font.family: Theme.font.family
                font.pixelSize: 14
                font.bold: wsButton.isFocused
                color: wsButton.isFocused ? Theme.colors.active : Theme.colors.fg
            }

            MouseArea {
                anchors.fill: parent
                enabled: wsButton.shouldShow && wsButton.modelData !== null
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (wsButton.modelData) {
                        wsButton.modelData.activate();
                    }
                }
            }
        }
    }
}
