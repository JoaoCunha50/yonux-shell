pragma Singleton
import QtQuick

QtObject {
    readonly property int enter: 350
    readonly property int exit: 200
    readonly property int small: 200

    readonly property list<real> emphasizedDecelerate: [0.05, 0.7, 0.1, 1, 1, 1]
    readonly property list<real> emphasizedAccelerate: [0.3, 0, 0.8, 0.15, 1, 1]
    readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
}
