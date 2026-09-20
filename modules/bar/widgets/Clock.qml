import QtQuick
import "../../theme"

Text {
    id: clock
    color: Theme.fg
    font.pixelSize: Theme.bodyFontSize
    font.family: "JetBrainsMono Nerd Font"
    horizontalAlignment: Text.AlignRight

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, dd MMM  hh:mm:ss")
    }
}
