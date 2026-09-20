import QtQuick
import Quickshell
import "modules/theme"
import "modules/bar"
import "modules/launcher"
import "modules/background"

ShellRoot {
    id: root

    Wallpaper {}

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: panel
            required property var modelData

            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }
            color: "transparent"

            implicitHeight: Theme.barHeight
            exclusiveZone: Theme.barHeight

            Bar {}

            AppLauncher {
                anchorWindow: panel
            }
        }
    }
}
