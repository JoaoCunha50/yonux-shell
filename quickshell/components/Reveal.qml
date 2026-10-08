import QtQuick
import qs.theme

Item {
    id: root

    property bool shown: false
    property real hiddenScale: Motion.revealScale
    property real hiddenOffset: Motion.revealOffset
    readonly property bool active: shown || opacity > 0

    opacity: 0
    scale: hiddenScale
    transform: Translate {
        id: slide
        y: root.hiddenOffset
    }

    states: State {
        name: "shown"
        when: root.shown
        PropertyChanges {
            root.opacity: 1
            root.scale: 1
            slide.y: 0
        }
    }

    transitions: [
        Transition {
            to: "shown"
            ParallelAnimation {
                NumberAnimation {
                    target: root
                    properties: "opacity,scale"
                    duration: Motion.enter
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.emphasizedDecelerate
                }
                NumberAnimation {
                    target: slide
                    property: "y"
                    duration: Motion.enter
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.emphasizedDecelerate
                }
            }
        },
        Transition {
            from: "shown"
            ParallelAnimation {
                NumberAnimation {
                    target: root
                    properties: "opacity,scale"
                    duration: Motion.exit
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.emphasizedAccelerate
                }
                NumberAnimation {
                    target: slide
                    property: "y"
                    duration: Motion.exit
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Motion.emphasizedAccelerate
                }
            }
        }
    ]
}
