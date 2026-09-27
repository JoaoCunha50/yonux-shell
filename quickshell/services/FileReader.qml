import QtQuick
import Quickshell.Io

Item {
    id: root

    property string path: ""
    property string text: ""
    property bool loaded: false

    function reload(): void {
        fileView.reload();
    }

    function write(text: string): void {
        fileView.setText(text);
    }

    FileView {
        id: fileView
        path: root.path
        watchChanges: true

        onFileChanged: fileView.reload()
        onTextChanged: {
            root.text = fileView.text();
            root.loaded = true;
        }
    }
}
