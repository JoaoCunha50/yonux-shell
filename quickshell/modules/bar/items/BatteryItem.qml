import QtQuick
import Quickshell.Services.UPower
import qs.services
import qs.modules.bar.tray

TrayItem {
    readonly property int pct: SystemStats.batteryPercent
    readonly property bool charging: SystemStats.batteryState === UPowerDeviceState.Charging

    shown: pct >= 0
    alert: pct >= 0 && pct <= 15
    text: `${pct}%`
    icon.name: {
        if (charging)
            return "battery_charging_full";
        if (pct <= 10)
            return "battery_alert";
        if (pct <= 20)
            return "battery_1_bar";
        if (pct <= 40)
            return "battery_2_bar";
        if (pct <= 60)
            return "battery_3_bar";
        if (pct <= 80)
            return "battery_4_bar";
        return "battery_full";
    }
    hoverText: {
        switch (SystemStats.batteryState) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.FullyCharged:
            return "Full";
        case UPowerDeviceState.PendingCharge:
            return "Plugged in, not charging";
        default:
            return "";
        }
    }
}
