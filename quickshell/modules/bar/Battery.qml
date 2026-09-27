import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.theme

RowLayout {
    id: battery

    spacing: 5

    property int percentage: -1
    property string status: ""

    // Not letting desktops see an empty battery bar
    visible: percentage >= 0

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityFile.reload();
            statusFile.reload();
        }
    }

    FileView {
        id: capacityFile
        path: "/sys/class/power_supply/BAT0/capacity"

        onLoaded: {
            let value = parseInt(capacityFile.text().trim());
            battery.percentage = isNaN(value) ? -1 : value;
        }
    }

    FileView {
        id: statusFile
        path: "/sys/class/power_supply/BAT0/status"

        onLoaded: battery.status = statusFile.text().trim()
    }

    Text {
        text: {
            if (battery.percentage < 0)
                return "battery_1_bar";
            if (battery.status === "Charging")
                return "battery_charging_full";
            if (battery.percentage <= 10)
                return "battery_alert";
            if (battery.percentage <= 20)
                return "battery_1_bar";
            if (battery.percentage <= 40)
                return "battery_2_bar";
            if (battery.percentage <= 60)
                return "battery_3_bar";
            if (battery.percentage <= 80)
                return "battery_4_bar";
            return "battery_full";
        }
        color: battery.percentage >= 0 && battery.percentage <= 15 ? Theme.colors.danger : Theme.colors.fg
        font.family: Icons.family
        font.pixelSize: 18
    }

    Text {
        text: battery.percentage < 0 ? "--" : `${battery.percentage}%`
        color: battery.percentage >= 0 && battery.percentage <= 15 ? Theme.colors.danger : Theme.colors.fg
        font.family: Theme.font.family
        font.pixelSize: 12
    }
}
