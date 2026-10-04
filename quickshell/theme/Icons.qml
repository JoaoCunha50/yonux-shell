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
    readonly property string disk: "hard_drive"
    readonly property string wifi: "wifi"
    readonly property string volumeUp: "volume_up"
    readonly property string search: "search"
    readonly property string close: "close"
    readonly property string mic: "mic"
    readonly property string micOff: "mic_off"
    readonly property string check: "check"
    readonly property string apps: "apps"
    readonly property string power: "power_settings_new"
    readonly property string lock: "lock"
    readonly property string sleep: "bedtime"
    readonly property string logout: "logout"
    readonly property string reboot: "restart_alt"
    readonly property string chevronLeft: "chevron_left"
    readonly property string chevronRight: "chevron_right"
    readonly property string radioOn: "radio_button_checked"
    readonly property string radioOff: "radio_button_unchecked"
}
