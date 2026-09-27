import QtQuick
import qs.theme

Text {
    id: root

    font.family: Theme.font.family
    font.pixelSize: Theme.font.bodySize
    color: Theme.colors.fg

    // Atalho opcional para variantes de estilo
    property bool muted: false
    opacity: muted ? 0.6 : 1.0
}
