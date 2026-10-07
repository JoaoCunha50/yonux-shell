pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire
import qs.theme
import qs.components
import qs.modules.bar.tray

TrayPopup {
    id: audioPopup

    property var audioNodes: Pipewire.nodes.values
    readonly property var outputs: audioNodes.filter(node => isOutput(node))
    readonly property var inputs: audioNodes.filter(node => isInput(node))

    implicitWidth: 360
    implicitHeight: 480
    grabFocus: true

    PwObjectTracker {
        objects: audioPopup.audioNodes
    }

    function isOutput(node) {
        return node && node.audio && node.isSink && !node.isStream;
    }

    function isInput(node) {
        return node && node.audio && !node.isSink && !node.isStream;
    }

    function isDefault(node, output) {
        let current = output ? Pipewire.defaultAudioSink : Pipewire.defaultAudioSource;
        return current && node && current.id === node.id;
    }

    function selectDefault(node, output) {
        if (output)
            Pipewire.preferredDefaultAudioSink = node;
        else
            Pipewire.preferredDefaultAudioSource = node;
    }

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentLayout.implicitHeight
        clip: true

        ColumnLayout {
            id: contentLayout
            width: parent.width
            spacing: 10

            UIText {
                text: "Output devices"
                font.bold: true
                color: Theme.colors.active
            }

            Repeater {
                model: audioPopup.outputs

                delegate: Rectangle {
                    id: sinkRow
                    required property PwNode modelData
                    readonly property bool selected: audioPopup.isDefault(modelData, true)

                    Layout.fillWidth: true
                    implicitHeight: 68
                    color: Theme.colors.controlNormalFill
                    radius: Theme.control.radius
                    border.color: selected ? Theme.colors.active : "transparent"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true

                            UIText {
                                Layout.fillWidth: true
                                text: sinkRow.modelData.description || sinkRow.modelData.name
                                elide: Text.ElideRight
                            }

                            IconButton {
                                icon.name: Icons.check
                                tooltip: "Select output"
                                active: sinkRow.selected
                                enabled: !sinkRow.selected
                                onClicked: audioPopup.selectDefault(sinkRow.modelData, true)
                            }
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: 0.0
                            to: 1.0
                            value: sinkRow.modelData.audio ? sinkRow.modelData.audio.volume : 0
                            onMoved: {
                                if (sinkRow.modelData.audio)
                                    sinkRow.modelData.audio.volume = value;
                            }
                        }
                    }
                }
            }

            UIText {
                visible: audioPopup.outputs.length === 0
                text: "No outputs available"
                muted: true
            }

            UIText {
                text: "Microphone"
                font.bold: true
                color: Theme.colors.active
            }

            Repeater {
                model: audioPopup.inputs

                delegate: Rectangle {
                    id: sourceRow
                    required property PwNode modelData
                    readonly property bool selected: audioPopup.isDefault(modelData, false)

                    Layout.fillWidth: true
                    implicitHeight: 68
                    color: Theme.colors.controlNormalFill
                    radius: Theme.control.radius
                    border.color: selected ? Theme.colors.active : "transparent"
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true

                            UIText {
                                Layout.fillWidth: true
                                text: sourceRow.modelData.description || sourceRow.modelData.name
                                elide: Text.ElideRight
                            }

                            IconButton {
                                icon.name: sourceRow.modelData.audio && sourceRow.modelData.audio.muted ? Icons.micOff : Icons.mic
                                tooltip: "Toggle microphone"
                                enabled: !!sourceRow.modelData.audio
                                onClicked: sourceRow.modelData.audio.muted = !sourceRow.modelData.audio.muted
                            }

                            IconButton {
                                icon.name: Icons.check
                                tooltip: "Select microphone"
                                active: sourceRow.selected
                                enabled: !sourceRow.selected
                                onClicked: audioPopup.selectDefault(sourceRow.modelData, false)
                            }
                        }

                        Slider {
                            Layout.fillWidth: true
                            from: 0.0
                            to: 1.0
                            value: sourceRow.modelData.audio ? sourceRow.modelData.audio.volume : 0
                            onMoved: {
                                if (sourceRow.modelData.audio)
                                    sourceRow.modelData.audio.volume = value;
                            }
                        }
                    }
                }
            }

            UIText {
                visible: audioPopup.inputs.length === 0
                text: "No microphones available"
                muted: true
            }
        }
    }
}
