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
    readonly property string wifi3: "network_wifi_3_bar"
    readonly property string wifi2: "network_wifi_2_bar"
    readonly property string wifi1: "network_wifi_1_bar"
    readonly property string wifi0: "signal_wifi_0_bar"
    readonly property string wifiOff: "wifi_off"
    readonly property string wifiBad: "signal_wifi_bad"
    readonly property string ethernet: "lan"
    readonly property string volumeUp: "volume_up"
    readonly property string volumeDown: "volume_down"
    readonly property string volumeOff: "volume_off"
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
    readonly property string batteryCharging: "battery_charging_full"
    readonly property string batteryAlert: "battery_alert"
    readonly property string battery1: "battery_1_bar"
    readonly property string battery2: "battery_2_bar"
    readonly property string battery3: "battery_3_bar"
    readonly property string battery4: "battery_4_bar"
    readonly property string batteryFull: "battery_full"
}
