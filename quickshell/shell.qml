import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.theme
import qs.modules.bar
import qs.modules.launcher
import qs.modules.wallpaper
import qs.services

ShellRoot {
    id: root

    readonly property var focusedScreen: {
        let monitor = Hyprland.focusedMonitor;
        if (monitor) {
            for (let screen of Quickshell.screens) {
                if (screen.name === monitor.name)
                    return screen;
            }
        }
        return Quickshell.screens.length > 0 ? Quickshell.screens[0] : null;
    }

    Wallpaper {}

    Matugen {
        id: matugen
        onColorsChanged: Theme.palette = matugen.colors
    }

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

            implicitHeight: Theme.bar.height
            exclusiveZone: Theme.bar.height

            Bar {}
        }
    }

    AppLauncher {
        id: launcher
        targetScreen: root.focusedScreen
    }
}
