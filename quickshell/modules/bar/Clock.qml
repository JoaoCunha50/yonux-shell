import QtQuick
import qs.theme

Text {
    id: clock
    color: Theme.colors.fg
    font.pixelSize: Theme.font.bodySize
    font.family: Theme.font.family
    horizontalAlignment: Text.AlignRight

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, dd MMM  hh:mm:ss")
    }
}
