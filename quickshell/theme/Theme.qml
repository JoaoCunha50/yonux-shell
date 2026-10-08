pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import qs.services

QtObject {
    id: root

    readonly property var palette: Matugen.colors

    component FontTokens: QtObject {
        readonly property string family: "JetBrainsMono Nerd Font"
        readonly property int titleSize: 15
        readonly property int bodySize: 13
    }

    readonly property FontTokens font: FontTokens {}

    component ColorTokens: QtObject {
        readonly property color active: root.palette?.primary?.dark?.color ?? "#89b4fa"
        readonly property color bg: root.palette?.surface_container_low?.dark?.color ?? "#1e1e2e"
        readonly property color fg: root.palette?.on_surface?.dark?.color ?? "#cdd6f4"
        readonly property color fgMuted: root.palette?.on_surface_variant?.dark?.color ?? "#a6adc8"
        readonly property color onActive: root.palette?.on_primary?.dark?.color ?? "#11111b"
        readonly property color alert: root.palette?.error?.dark?.color ?? "#f38ba8"
        readonly property color surface: root.palette?.surface_container?.dark?.color ?? "#181825"
        readonly property color field: root.palette?.surface_container_highest?.dark?.color ?? "#313244"
        readonly property color border: root.palette?.outline_variant?.dark?.color ?? "#313244"
        readonly property color controlNormalFill: root.palette?.surface_container?.dark?.color ?? "#313244"
        readonly property color controlHoverFill: root.palette?.surface_container_high?.dark?.color ?? "#45475a"
        readonly property color controlPressedFill: root.palette?.primary_container?.dark?.color ?? "#585b70"
        readonly property color controlDisabledFill: root.palette?.surface_container_lowest?.dark?.color ?? "#2a2b3d"
    }

    readonly property ColorTokens colors: ColorTokens {}

    component SpacingTokens: QtObject {
        readonly property int xs: 4
        readonly property int sm: 8
        readonly property int md: 12
        readonly property int lg: 16
    }

    readonly property SpacingTokens spacing: SpacingTokens {}

    component RadiusTokens: QtObject {
        readonly property int sm: 6
        readonly property int md: 8
        readonly property int lg: 10
        readonly property int xl: 12
    }

    readonly property RadiusTokens radius: RadiusTokens {}

    component BarTokens: QtObject {
        readonly property int height: 40
    }

    readonly property BarTokens bar: BarTokens {}

    component OverlayTokens: QtObject {
        readonly property int padding: 22
    }

    readonly property OverlayTokens overlay: OverlayTokens {}
}
