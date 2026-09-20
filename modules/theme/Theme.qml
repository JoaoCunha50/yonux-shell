pragma Singleton
import QtQuick

QtObject {
    readonly property color bg: "#1e1e2e"
    readonly property color fg: "#cdd6f4"
    readonly property color active: "#89b4fa"
    readonly property color inactive: "#45475a"
    readonly property color border: "#313244"
    readonly property int titleFontSize: 15
    readonly property int bodyFontSize: 13
    readonly property int rounding: 8
    // Single source of truth for the bar height. The panel, its surface
    // reservation and the bar content all derive from this, so the window
    // can never silently hijack more space than the visible bar.
    readonly property int barHeight: 46
}
