pragma Singleton
import QtQuick

QtObject {
    id: root

    readonly property FontLoader _loader: FontLoader {
        source: Qt.resolvedUrl("../assets/fonts/MaterialSymbolsRounded.ttf")
    }

    readonly property string family: _loader.name

    readonly property string memory: "memory"
    readonly property string cpu: "developer_board"
    readonly property string temperature: "device_thermostat"
    readonly property string wifi: "wifi"
    readonly property string volumeUp: "volume_up"
    readonly property string search: "search"
    readonly property string close: "close"
    readonly property string mic: "mic"
    readonly property string micOff: "mic_off"
    readonly property string check: "check"
}
