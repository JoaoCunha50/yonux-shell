import QtQuick
import qs.theme

Text {
    property string icon
    property color iconColor: Theme.colors.fg
    property int size: 16
    property int iconWidth
    property int iconHeight

    font.family: Icons.family
    font.pixelSize: size
    text: icon
    color: iconColor

    width: iconWidth > 0 ? iconWidth : implicitWidth
    height: iconHeight > 0 ? iconHeight : implicitHeight
}
