import QtQuick
import Quickshell.Io

Item {
    id: root

    property string path: ""
    property bool loaded: false
    property string error: ""

    FileView {
        id: fileView
        path: root.path

        onLoaded: {
            try {
                root.data = JSON.parse(text());
                root.loaded = true;
                root.error = "";
            } catch (err) {
                root.error = err.toString();
                console.error(`Erro ao processar JSON em ${root.path}:`, err);
            }
        }
    }
}
