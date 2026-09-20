import QtQuick
import Quickshell
import Quickshell.Wayland
import "../theme"

Variants {
    id: root
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

        color: Theme.bg

        Image {
            anchors.fill: parent
            source: "/home/joaocunha50/Pictures/Wallpapers/2.png"
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true

            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                }
            }
        }
    }
}
