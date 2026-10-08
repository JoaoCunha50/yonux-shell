pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    readonly property string configPath: (Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config") + "/yonux/bar.json"

    readonly property var defaults: ({
            left: ["workspaces", "separator"],
            center: ["clock"],
            right: ["tray", "cpu", "memory", "disk", "temperature", "battery", "network", "audio", "power"]
        })

    property var layout: defaults

    readonly property list<string> left: layout.left
    readonly property list<string> center: layout.center
    readonly property list<string> right: layout.right

    function apply(json: string): void {
        let parsed;
        try {
            parsed = JSON.parse(json);
        } catch (e) {
            Alerts.error("bar.json is invalid", `${e}`);
            return;
        }

        let next = {};
        for (let section of ["left", "center", "right"])
            next[section] = Array.isArray(parsed?.[section]) ? parsed[section] : defaults[section];
        layout = next;
    }

    FileView {
        id: configFile
        path: root.configPath
        watchChanges: true
        printErrors: false

        onFileChanged: reload()
        onLoaded: root.apply(text())
        onLoadFailed: error => {
            // Seed the user file with the defaults so there is something to edit
            if (error === FileViewError.FileNotFound)
                setText(JSON.stringify(root.defaults, null, 2) + "\n");
        }
    }
}
