pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.theme
import qs.components
import qs.modules.power

PanelWindow {
    id: root

    property var targetScreen
    property alias selected: navigation.currentIndex
    property int holding: -1
    property real progress: 0
    readonly property int holdDuration: 1000
    readonly property bool open: Power.open

    screen: targetScreen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusiveZone: 0

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    visible: false

    onOpenChanged: {
        if (open) {
            navigation.reset();
            visible = true;
            navigation.forceActiveFocus();
        } else {
            reset();
        }
    }

    function press(index: int): void {
        selected = index;
        if (!Power.actions[index].confirm)
            return;
        if (holding !== index)
            progress = 0;

        holding = index;
        drain.stop();
        charge.duration = holdDuration * (1 - progress);
        charge.restart();
    }

    function release(): void {
        if (holding < 0 || !charge.running)
            return;

        charge.stop();
        drain.restart();
    }

    function trigger(index: int): void {
        let action = Power.actions[index];
        if (!action.confirm)
            Power.run(action);
    }

    function reset(): void {
        charge.stop();
        drain.stop();
        progress = 0;
        holding = -1;
    }

    NumberAnimation {
        id: charge
        target: root
        property: "progress"
        to: 1
        onFinished: {
            let action = Power.actions[root.holding];
            root.reset();
            Power.run(action);
        }
    }

    NumberAnimation {
        id: drain
        target: root
        property: "progress"
        to: 0
        duration: Motion.exit
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Motion.standard
        onFinished: root.holding = -1
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.5)
        opacity: reveal.opacity
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Power.close()
    }

    KeyboardNavigation {
        id: navigation
        enabled: root.open
        count: Power.actions.length
        orientation: Qt.Horizontal
        spaceActivates: true
        repeatNavigation: false
        navigationEnabled: !charge.running
        onActivationPressed: index => root.press(index)
        onActivated: index => root.trigger(index)
        onActivationReleased: root.release()
        onCancelled: {
            if (charge.running)
                root.release();
            else
                Power.close();
        }
    }

    Reveal {
        id: reveal
        anchors.centerIn: parent
        width: surface.width
        height: surface.height
        shown: root.open
        onActiveChanged: if (!active)
            root.visible = false

        Rectangle {
            id: surface
            width: content.implicitWidth + 44
            height: content.implicitHeight + 44

            color: Theme.colors.surface
            radius: 12
            border.color: Theme.colors.border
            border.width: 1

            MouseArea {
                anchors.fill: parent
                preventStealing: true
            }

            Column {
                id: content
                anchors.centerIn: parent
                spacing: Theme.spacing.lg

                Row {
                    spacing: Theme.spacing.md

                    Repeater {
                        model: Power.actions

                        delegate: Rectangle {
                            id: button
                            required property var modelData
                            required property int index
                            readonly property bool isHolding: root.holding === index
                            readonly property bool isSelected: root.selected === index

                            width: 120
                            height: 120
                            radius: 10
                            color: Theme.colors.controlNormalFill

                            Item {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                height: button.height * (button.isHolding ? root.progress : 0)
                                clip: true

                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.bottom: parent.bottom
                                    height: button.height
                                    radius: button.radius
                                    color: Qt.rgba(Theme.colors.active.r, Theme.colors.active.g, Theme.colors.active.b, 0.35)
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: button.radius
                                color: "transparent"
                                border.width: 2
                                border.color: {
                                    if (button.isHolding || button.isSelected)
                                        return Theme.colors.active;
                                    return "transparent";
                                }

                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: Motion.small
                                    }
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: Theme.spacing.sm

                                ShellIcon {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    icon.name: button.modelData.icon
                                    icon.size: 40
                                    icon.color: button.isSelected ? Theme.colors.active : Theme.colors.fg
                                }

                                UIText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: button.modelData.label
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: if (!charge.running)
                                    root.selected = button.index
                                onPressed: root.press(button.index)
                                onReleased: root.release()
                                onCanceled: root.release()
                                onClicked: root.trigger(button.index)
                            }
                        }
                    }
                }

                UIText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    muted: true
                    text: Power.actions[root.selected].confirm ? `Hold to ${Power.actions[root.selected].label.toLowerCase()}` : "← → to choose · Enter to confirm"
                }
            }
        }
    }
}
