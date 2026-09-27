pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import qs.theme
import qs.components

PopupWindow {
    id: audioPopup

    property bool open: false
    property var audioNodes: Pipewire.nodes.values

    implicitWidth: 360
    implicitHeight: 480
    color: "transparent"
    visible: false

    onOpenChanged: if (open)
        visible = true

    onVisibleChanged: if (!visible)
        open = false

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

    Reveal {
        id: reveal
        anchors.fill: parent
        shown: audioPopup.open
        transformOrigin: Item.Top
        onActiveChanged: if (!active)
            audioPopup.visible = false

        Rectangle {
            anchors.fill: parent
            color: Theme.colors.bg
            radius: Theme.bar.radius
        }

        Flickable {
            anchors.fill: parent
            anchors.margins: 12
            contentWidth: width
            contentHeight: contentLayout.implicitHeight
            clip: true

            ColumnLayout {
                id: contentLayout
                width: parent.width
                spacing: 10

                UIText {
                    text: "Dispositivos de saída"
                    font.bold: true
                    color: Theme.colors.active
                }

                Repeater {
                    model: audioPopup.audioNodes

                    delegate: Rectangle {
                        id: sinkRow
                        required property PwNode modelData
                        readonly property bool eligible: audioPopup.isOutput(modelData)
                        readonly property bool selected: audioPopup.isDefault(modelData, true)

                        Layout.fillWidth: true
                        implicitHeight: eligible ? 68 : 0
                        visible: eligible
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
                                    icon: Icons.check
                                    tooltip: "Selecionar saída"
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
                    visible: audioPopup.audioNodes.length === 0
                    text: "Nenhuma saída disponível"
                    muted: true
                }

                UIText {
                    text: "Microfone"
                    font.bold: true
                    color: Theme.colors.active
                }

                Repeater {
                    model: audioPopup.audioNodes

                    delegate: Rectangle {
                        id: sourceRow
                        required property PwNode modelData
                        readonly property bool eligible: audioPopup.isInput(modelData)
                        readonly property bool selected: audioPopup.isDefault(modelData, false)

                        Layout.fillWidth: true
                        implicitHeight: eligible ? 68 : 0
                        visible: eligible
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
                                    icon: sourceRow.modelData.audio && sourceRow.modelData.audio.muted ? Icons.micOff : Icons.mic
                                    tooltip: "Alternar microfone"
                                    enabled: !!sourceRow.modelData.audio
                                    onClicked: sourceRow.modelData.audio.muted = !sourceRow.modelData.audio.muted
                                }

                                IconButton {
                                    icon: Icons.check
                                    tooltip: "Selecionar microfone"
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
                    visible: audioPopup.audioNodes.length === 0
                    text: "Nenhum microfone disponível"
                    muted: true
                }
            }
        }
    }
}
