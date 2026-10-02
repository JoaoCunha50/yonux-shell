pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs.theme
import qs.services
import qs.components
import qs.modules.bar.tray
import qs.modules.bar.widgets
import qs.modules.bar.popups

Singleton {
    id: root

    readonly property string configPath: (Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config") + "/yonux/bar.json"

    readonly property var defaults: ({
            left: ["workspaces", "separator"],
            center: ["clock"],
            right: ["audio", "cpu", "memory", "disk", "temperature", "battery"]
        })

    property var layout: defaults

    readonly property list<Component> left: resolve(layout.left)
    readonly property list<Component> center: resolve(layout.center)
    readonly property list<Component> right: resolve(layout.right)

    readonly property var items: ({
            workspaces: workspaces,
            separator: separator,
            title: title,
            clock: clock,
            audio: audio,
            cpu: cpu,
            memory: memory,
            disk: disk,
            temperature: temperature,
            battery: battery
        })

    function resolve(ids: var): var {
        return ids.filter(id => {
            if (items[id])
                return true;
            console.warn(`bar.json: unknown item "${id}"`);
            return false;
        }).map(id => items[id]);
    }

    function apply(json: string): void {
        let parsed;
        try {
            parsed = JSON.parse(json);
        } catch (e) {
            console.warn(`bar.json: ${e}`);
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
            if (error === FileViewError.FileNotFound)
                createConfig.running = true;
        }
    }

    // Seed the user file with the defaults so there is something to edit
    Process {
        id: createConfig
        command: ["sh", "-c", "mkdir -p \"$(dirname \"$1\")\" && printf '%s\\n' \"$2\" > \"$1\"", "sh", root.configPath, JSON.stringify(root.defaults, null, 2)]
        onExited: configFile.reload()
    }

    Component {
        id: workspaces
        TrayItem {
            Workspaces {
                anchors.fill: parent
            }
        }
    }

    Component {
        id: separator
        TrayItem {
            Rectangle {
                anchors.fill: parent
                implicitWidth: 2
                implicitHeight: 18
                color: Theme.colors.active
            }
        }
    }

    Component {
        id: title
        TrayItem {
            fillWidth: true

            UIText {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                padding: 5
                font.pixelSize: 12
                text: Hyprland.activeToplevel?.title ?? `Workspace ${Hyprland.focusedWorkspace?.name ?? "?"}`
            }
        }
    }

    Component {
        id: clock
        TrayItem {
            id: clockIcon
            property date now: new Date()

            text: Qt.formatDateTime(now, "ddd, dd MMM  hh:mm:ss")
            textSize: Theme.font.bodySize
            hoverText: Qt.formatDate(now, "dddd, d MMMM yyyy")

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clockIcon.now = new Date()
            }
        }
    }

    Component {
        id: audio
        TrayItem {
            icon: Icons.volumeUp
            popup: Component {
                AudioPopup {}
            }
        }
    }

    Component {
        id: cpu
        TrayItem {
            icon: Icons.cpu
            text: `${SystemStats.cpuPercent}%`
            alert: SystemStats.cpuPercent > 80
            hoverText: `Carga média: ${SystemStats.loadAverage}`
        }
    }

    Component {
        id: memory
        TrayItem {
            icon: Icons.memory
            text: `${SystemStats.memoryPercent}%`
            alert: SystemStats.memoryPercent > 85
            hoverText: `${SystemStats.memoryUsedGiB.toFixed(1)} / ${SystemStats.memoryTotalGiB.toFixed(1)} GiB em uso`
        }
    }

    Component {
        id: disk
        TrayItem {
            icon: Icons.disk
            text: `${SystemStats.diskPercent}%`
            alert: SystemStats.diskPercent > 90
            hoverText: `${SystemStats.diskUsedGiB.toFixed(0)} / ${SystemStats.diskTotalGiB.toFixed(0)} GiB em uso em /`
        }
    }

    Component {
        id: temperature
        TrayItem {
            icon: Icons.temperature
            text: `${SystemStats.temperature}°C`
            alert: SystemStats.temperature > 80
        }
    }

    Component {
        id: battery
        TrayItem {
            readonly property int pct: SystemStats.batteryPercent
            readonly property bool charging: SystemStats.batteryStatus === "Charging"

            shown: pct >= 0
            alert: pct >= 0 && pct <= 15
            text: `${pct}%`
            icon: {
                if (charging)
                    return "battery_charging_full";
                if (pct <= 10)
                    return "battery_alert";
                if (pct <= 20)
                    return "battery_1_bar";
                if (pct <= 40)
                    return "battery_2_bar";
                if (pct <= 60)
                    return "battery_3_bar";
                if (pct <= 80)
                    return "battery_4_bar";
                return "battery_full";
            }
            hoverText: ({
                    Charging: "A carregar",
                    Discharging: "A descarregar",
                    Full: "Carregada",
                    "Not charging": "Ligada, sem carregar"
                })[SystemStats.batteryStatus] ?? SystemStats.batteryStatus
        }
    }
}
