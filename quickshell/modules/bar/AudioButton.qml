import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.theme
import qs.components
import "popouts"

RowLayout {
    id: root

    readonly property bool open: audioPopup.open
    signal toggled(bool open)
    spacing: 4

    IconButton {
        icon: Icons.volumeUp
        tooltip: "Abrir controlos de áudio"
        active: root.open
        onClicked: {
            audioPopup.open = !audioPopup.open;
            root.toggled(audioPopup.open);
        }
    }

    UIText {
        text: "Áudio"
        color: root.open ? Theme.colors.active : Theme.colors.fg
    }

    AudioPopout {
        id: audioPopup
        anchor.item: root
        anchor.margins.top: Theme.bar.height + 2
        grabFocus: true
    }
}
