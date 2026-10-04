import QtQuick
import qs.theme

Text {
    id: root

    font.family: Theme.font.family
    font.pixelSize: Theme.font.bodySize
    font.weight: Font.DemiBold
    color: Theme.colors.fg

    // Optional shortcut for style variants
    property bool muted: false
    opacity: muted ? 0.6 : 1.0
}
