pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme

Singleton {
    id: root

    property bool open: false

    readonly property var actions: [
        {
            label: "Lock",
            icon: Icons.lock,
            command: ["loginctl", "lock-session"],
            confirm: false
        },
        {
            label: "Sleep",
            icon: Icons.sleep,
            command: ["systemctl", "suspend"],
            confirm: false
        },
        {
            label: "Logout",
            icon: Icons.logout,
            command: ["uwsm", "stop"],
            confirm: true
        },
        {
            label: "Reboot",
            icon: Icons.reboot,
            command: ["systemctl", "reboot"],
            confirm: true
        },
        {
            label: "Shutdown",
            icon: Icons.power,
            command: ["systemctl", "poweroff"],
            confirm: true
        }
    ]

    function toggle(): void {
        open = !open;
    }

    function close(): void {
        open = false;
    }

    function run(action: var): void {
        open = false;
        Quickshell.execDetached(action.command);
    }

    IpcHandler {
        target: "power"
        function toggle(): void {
            root.toggle();
        }
    }
}
