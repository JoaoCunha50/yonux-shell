import QtQuick
import Quickshell
import Quickshell.Io
import qs.theme

Item {
    id: root

    property string matugenBin: "matugen"
    property string configPath: Quickshell.shellPath("matugen/config.toml")
    property var colors: null
    readonly property bool ready: colors !== null
    property bool _dirty: false

    readonly property string wallpaperPath: stateReader.text.trim()

    FileReader {
        id: stateReader
        path: Theme.config.wallpaperStateFile
    }

    onWallpaperPathChanged: generate()

    function generate(): void {
        if (root.wallpaperPath === "")
            return;
        if (matugenProc.running) {
            root._dirty = true;
            return;
        }

        matugenProc.command = [root.matugenBin, "image", root.wallpaperPath, "-c", root.configPath, "-j", "hex", "--prefer", "darkness", "-m", "dark"];
        matugenProc.running = true;
    }

    Process {
        id: matugenProc

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.colors = JSON.parse(this.text).colors;
                } catch (err) {
                    console.error("matugen output is not valid JSON:", err);
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() !== "")
                    console.warn("matugen stderr:", this.text);
            }
        }
    }
}
