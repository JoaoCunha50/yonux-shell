pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.theme
import qs.services

Scope {
    id: root

    FileReader {
        id: stateReader
        path: Theme.config.wallpaperStateFile
    }

    // Trimmed path from the state file ("" when unset).
    readonly property string wallpaperPath: stateReader.text.trim()

    IpcHandler {
        target: "wallpaper"

        function set(path: string): void {
            stateReader.write(path + "\n");
        }

        function get(): string {
            return root.wallpaperPath;
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: wallpaperWindow
            required property var modelData
            screen: modelData

            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.exclusiveZone: -1

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            color: Theme.colors.bg

            Image {
                anchors.fill: parent
                source: root.wallpaperPath !== "" ? "file://" + root.wallpaperPath : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true
            }
        }
    }
}
