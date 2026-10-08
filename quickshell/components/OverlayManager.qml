pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    property string current: ""

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

    function open(name: string): void {
        current = name;
    }

    function close(): void {
        current = "";
    }

    function toggle(name: string): void {
        current = current === name ? "" : name;
    }
}
