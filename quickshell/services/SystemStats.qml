pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root

    property int cpuPercent: 0
    property string loadAverage: ""
    property int memoryPercent: 0
    property real memoryUsedGiB: 0
    property real memoryTotalGiB: 0
    property int diskPercent: 0
    property real diskUsedGiB: 0
    property real diskTotalGiB: 0
    property int temperature: -1

    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property bool hasBattery: battery?.isLaptopBattery ?? false
    readonly property int batteryPercent: hasBattery ? Math.round(battery.percentage * 100) : -1
    readonly property int batteryState: battery?.state ?? UPowerDeviceState.Unknown

    property var _lastCpuTimes: null
    property string _temperaturePath: ""

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuFile.reload();
            loadFile.reload();
            memoryFile.reload();
            diskProcess.running = true;
            if (root._temperaturePath !== "")
                temperatureFile.reload();
        }
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"

        onLoaded: {
            let firstLine = text().split("\n")[0];
            if (!firstLine.startsWith("cpu "))
                return;

            let parts = firstLine.trim().split(/\s+/).slice(1).map(Number);
            if (parts.length < 5)
                return;

            let idleTime = parts[3] + (parts[4] || 0); // idle + iowait
            let totalTime = parts.reduce((acc, val) => acc + val, 0);

            if (root._lastCpuTimes) {
                let idleDelta = idleTime - root._lastCpuTimes.idle;
                let totalDelta = totalTime - root._lastCpuTimes.total;
                if (totalDelta > 0)
                    root.cpuPercent = Math.max(0, Math.min(100, Math.round(100 * (1 - idleDelta / totalDelta))));
            }

            root._lastCpuTimes = {
                idle: idleTime,
                total: totalTime
            };
        }
    }

    FileView {
        id: loadFile
        path: "/proc/loadavg"

        onLoaded: root.loadAverage = text().trim().split(/\s+/).slice(0, 3).join(" ")
    }

    FileView {
        id: memoryFile
        path: "/proc/meminfo"

        onLoaded: {
            let content = text();
            let totalMatch = content.match(/^MemTotal:\s+(\d+)\s+kB/m);
            let availMatch = content.match(/^MemAvailable:\s+(\d+)\s+kB/m);
            if (!totalMatch || !availMatch)
                return;

            let total = parseInt(totalMatch[1], 10);
            let used = total - parseInt(availMatch[1], 10);
            if (total <= 0)
                return;

            root.memoryPercent = Math.max(0, Math.min(100, Math.round(used / total * 100)));
            root.memoryUsedGiB = used / 1048576;
            root.memoryTotalGiB = total / 1048576;
        }
    }

    Process {
        id: diskProcess
        command: ["df", "-B1", "--output=size,used,pcent", "/"]

        stdout: StdioCollector {
            onStreamFinished: {
                let fields = (text.split("\n")[1] ?? "").trim().split(/\s+/);
                let pct = parseInt(fields[2]);
                if (isNaN(pct))
                    return;

                root.diskPercent = pct;
                root.diskTotalGiB = Number(fields[0]) / 1073741824;
                root.diskUsedGiB = Number(fields[1]) / 1073741824;
            }
        }
    }

    // Picks the CPU sensor once, preferring Package id 0 / Tdie over Tctl (same order as libsensors-based shells)
    Process {
        running: true
        command: ["sh", "-c", `
            best=""; fallback=""; first=""
            for h in /sys/class/hwmon/hwmon*; do
                case "$(cat "$h/name" 2>/dev/null)" in coretemp|k10temp|zenpower) ;; *) continue ;; esac
                [ -z "$first" ] && [ -r "$h/temp1_input" ] && first="$h/temp1_input"
                for l in "$h"/temp*_label; do
                    [ -r "$l" ] || continue
                    case "$(cat "$l")" in
                        "Package id 0"|Tdie) [ -z "$best" ] && best="\${l%_label}_input" ;;
                        Tctl) [ -z "$fallback" ] && fallback="\${l%_label}_input" ;;
                    esac
                done
            done
            echo "\${best:-\${fallback:-$first}}"
        `]

        stdout: StdioCollector {
            onStreamFinished: root._temperaturePath = this.text.trim()
        }
    }

    FileView {
        id: temperatureFile
        path: root._temperaturePath

        onLoaded: {
            let milli = parseInt(text(), 10);
            if (!isNaN(milli))
                root.temperature = Math.round(milli / 1000);
        }
    }
}
