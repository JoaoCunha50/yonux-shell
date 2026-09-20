import QtQuick
import "../theme"

Rectangle {
    id: content

    radius: 12
    color: Theme.bg
    border.color: Theme.border
    border.width: 1

    implicitWidth: 500
    implicitHeight: 400

    Text {
        anchors.centerIn: parent
        text: "Launcher vivo!"
        color: Theme.fg
        font.pixelSize: Theme.bodyFontSize
    }
}
