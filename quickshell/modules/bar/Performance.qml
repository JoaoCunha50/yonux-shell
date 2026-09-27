import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.theme

RowLayout {
    id: performance

    spacing: 12

    property int cpuPercent: 0
    property int memoryPercent: 0
    property int temperature: 0
    property var lastCpuTimes: null

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuFile.reload();
            memoryFile.reload();
            tempProcess.running = true;
        }
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"

        onLoaded: {
            let content = cpuFile.text();
            if (!content)
                return;

            let firstLine = content.split("\n")[0];
            if (!firstLine.startsWith("cpu "))
                return;

            let parts = firstLine.trim().split(/\s+/).slice(1).map(Number);
            if (parts.length < 5)
                return;

            let idleTime = parts[3] + (parts[4] || 0); // idle + iowait
            let totalTime = parts.reduce((acc, val) => acc + val, 0);

            if (performance.lastCpuTimes) {
                let idleDelta = idleTime - performance.lastCpuTimes.idle;
                let totalDelta = totalTime - performance.lastCpuTimes.total;

                if (totalDelta > 0) {
                    let usage = Math.round(100 * (1 - (idleDelta / totalDelta)));
                    performance.cpuPercent = Math.max(0, Math.min(100, usage));
                }
            }

            performance.lastCpuTimes = {
                idle: idleTime,
                total: totalTime
            };
        }
    }

    FileView {
        id: memoryFile
        path: "/proc/meminfo"

        onLoaded: {
            let text = memoryFile.text();
            if (!text)
                return;

            let totalMatch = text.match(/^MemTotal:\s+(\d+)\s+kB/m);
            let availMatch = text.match(/^MemAvailable:\s+(\d+)\s+kB/m);

            if (totalMatch && availMatch) {
                let total = parseInt(totalMatch[1], 10);
                let available = parseInt(availMatch[1], 10);

                if (total > 0) {
                    let used = total - available;
                    let pct = Math.round((used / total) * 100);
                    performance.memoryPercent = Math.max(0, Math.min(100, pct));
                }
            }
        }
    }

    Process {
        id: tempProcess
        command: ["sh", "-c", "sensors | awk -F'[:+°]' ' " + "  /Tccd[0-9]/        { val = int($3); found = 1; exit } " + "  /Tdie/             { val = int($3); found = 1; exit } " + "  /Package id [0-9]/ { val = int($3); found = 1; exit } " + "  /Core 0/           { val = int($3); found = 1; exit } " + "  /(CPU Temp|CPU)/   { val = int($3); found = 1; exit } " + "  /Tctl/             { if (!fallback) fallback = int($3) } " + "  END { " + "    if (found) print val; " + "    else if (fallback) print fallback; " + "  }'"]

        stdout: SplitParser {
            onRead: data => {
                let raw = parseFloat(data.trim());
                if (!isNaN(raw) && raw > 0) {
                    performance.temperature = Math.round(raw);
                }
            }
        }
    }

    RowLayout {
        spacing: 5

        Text {
            text: Icons.cpu
            color: performance.cpuPercent > 80 ? Theme.colors.danger : Theme.colors.fg
            font.family: Icons.family
            font.pixelSize: 18
        }

        Text {
            text: `${performance.cpuPercent}%`
            color: performance.cpuPercent > 80 ? Theme.colors.danger : Theme.colors.fg
            font.family: Theme.font.family
            font.pixelSize: 12
        }
    }

    RowLayout {
        spacing: 5

        Text {
            text: Icons.memory
            color: performance.memoryPercent > 85 ? Theme.colors.danger : Theme.colors.fg
            font.family: Icons.family
            font.pixelSize: 18
        }

        Text {
            text: `${performance.memoryPercent}%`
            color: performance.memoryPercent > 85 ? Theme.colors.danger : Theme.colors.fg
            font.family: Theme.font.family
            font.pixelSize: 12
        }
    }

    RowLayout {
        spacing: 5

        Text {
            text: Icons.temperature
            color: performance.temperature > 80 ? Theme.colors.danger : Theme.colors.fg
            font.family: Icons.family
            font.pixelSize: 18
        }

        Text {
            text: `${performance.temperature}°C`
            color: performance.temperature > 80 ? Theme.colors.danger : Theme.colors.fg
            font.family: Theme.font.family
            font.pixelSize: 12
        }
    }
}
