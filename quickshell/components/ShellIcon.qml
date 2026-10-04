import QtQuick
import qs.theme

Text {
    property string icon
    property color iconColor: Theme.colors.fg
    property int size: 16
    property int iconWidth
    property int iconHeight
    property int iconWeight: Font.Normal

    font.family: Icons.family
    font.pixelSize: size
    font.weight: iconWeight
    font.variableAxes: ({ "wght": iconWeight })
    text: icon
    color: iconColor

    width: iconWidth > 0 ? iconWidth : implicitWidth
    height: iconHeight > 0 ? iconHeight : implicitHeight
}
