import QtQuick
import qs.theme
import qs.components

Text {
    property IconProps icon: IconProps {
        size: 18
    }

    font.family: Icons.family
    font.pixelSize: icon.size
    font.weight: icon.weight
    font.variableAxes: ({
            "wght": icon.weight
        })
    text: icon.name
    color: icon.color
}
