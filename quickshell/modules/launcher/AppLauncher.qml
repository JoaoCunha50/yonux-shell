import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.theme
import qs.components

PanelWindow {
    id: launcherWindow

    property var targetScreen
    property bool open: false
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

    property string searchQuery: ""
    onFilteredAppsChanged: navigation.reset()

    onOpenChanged: {
        if (open) {
            navigation.reset();
            visible = true;
            searchField.forceActiveFocus();
        }
    }

    readonly property var filteredApps: {
        let query = searchQuery.trim().toLowerCase();
        let entries = DesktopEntries.applications.values;

        if (entries.length === 0)
            return [];

        return entries.filter(app => {
            if (app.noDisplay)
                return false;

            let name = app.name?.toLowerCase() ?? "";
            let comment = app.comment?.toLowerCase() ?? "";
            let command = app.command?.join(" ").toLowerCase() ?? "";

            return name.includes(query) || comment.includes(query) || command.includes(query);
        });
    }

    // Resolves absolute paths, theme names, or falls back to empty string
    function iconSource(icon: string): string {
        if (!icon)
            return "";
        if (icon.startsWith("/"))
            return "file://" + icon;
        return Quickshell.iconPath(icon, true) ?? "";
    }

    function toggleVisibility(): void {
        launcherWindow.open = !launcherWindow.open;
    }

    function launch(entry: DesktopEntry): void {
        if (entry.runInTerminal) {
            Quickshell.execDetached(["xdg-terminal-exec"].concat(entry.command));
        } else {
            entry.execute();
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            launcherWindow.toggleVisibility();
        }
    }

    KeyboardNavigation {
        id: navigation
        enabled: launcherWindow.open
        count: launcherWindow.filteredApps.length
        onActivated: index => {
            launcherWindow.launch(launcherWindow.filteredApps[index]);
            launcherWindow.open = false;
        }
        onCancelled: launcherWindow.open = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: launcherWindow.toggleVisibility()
    }

    Reveal {
        id: reveal
        width: 560
        height: 460
        anchors.centerIn: parent
        shown: launcherWindow.open
        onActiveChanged: {
            if (!active) {
                launcherWindow.visible = false;
                launcherWindow.searchQuery = "";
                searchField.text = "";
            }
        }

        Rectangle {
            id: surface
            anchors.fill: parent

            color: Theme.colors.surface
            radius: 12
            border.color: Theme.colors.border
            border.width: 1

            MouseArea {
                anchors.fill: parent
                preventStealing: true
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 22
                spacing: 14

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48
                    placeholderText: "Search apps..."
                    font.pixelSize: 16
                    color: Theme.colors.fg
                    placeholderTextColor: Theme.colors.fgMuted
                    leftPadding: 16
                    rightPadding: 16
                    background: Rectangle {
                        radius: 8
                        color: Theme.colors.field
                        border.color: searchField.activeFocus ? Theme.colors.active : Theme.colors.border
                        border.width: 1
                    }
                    onTextChanged: launcherWindow.searchQuery = text

                    Keys.forwardTo: [navigation]
                }

                ListView {
                    id: appList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: launcherWindow.filteredApps
                    currentIndex: navigation.currentIndex
                    onCurrentIndexChanged: {
                        if (currentIndex >= 0)
                            positionViewAtIndex(currentIndex, ListView.Contain);
                    }
                    spacing: 5

                    delegate: ItemDelegate {
                        id: delegateRoot
                        required property DesktopEntry modelData
                        required property int index
                        readonly property bool selected: index === navigation.currentIndex
                        focusPolicy: Qt.NoFocus

                        width: ListView.view.width
                        height: 44
                        leftPadding: 10
                        rightPadding: 10
                        topPadding: 0
                        bottomPadding: 0

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        contentItem: RowLayout {
                            spacing: 14

                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                Layout.alignment: Qt.AlignVCenter

                                Image {
                                    id: appIcon
                                    anchors.centerIn: parent
                                    width: 24
                                    height: 24
                                    fillMode: Image.PreserveAspectFit
                                    source: launcherWindow.iconSource(modelData.icon)
                                    asynchronous: true

                                    // Graceful fallback when an icon is absent or not yet indexed by Qt
                                    ShellIcon {
                                        anchors.centerIn: parent
                                        visible: appIcon.status !== Image.Ready
                                        icon.name: Icons.apps
                                        icon.size: 20
                                    }
                                }
                            }

                            Text {
                                text: modelData.name
                                font.pixelSize: 14
                                font.family: Theme.font.family
                                color: delegateRoot.selected || delegateRoot.hovered ? Theme.colors.active : Theme.colors.fg
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.fillWidth: true
                            }
                        }

                        background: Rectangle {
                            radius: 8
                            color: delegateRoot.selected || delegateRoot.hovered ? Theme.colors.controlHoverFill : "transparent"
                        }

                        onClicked: {
                            launcherWindow.launch(modelData);
                            launcherWindow.toggleVisibility();
                        }
                    }
                }
            }
        }
    }
}
