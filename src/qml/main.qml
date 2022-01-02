import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("LED Ambiente")

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    deviceManager.disconnectFromDevice()
                } else {

                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }
    }

    StackView {
        id: stackView
        initialItem: "DeviceList.qml"
        anchors.fill: parent

        Connections {
            target: deviceManager
            function onConnectedChanged() {
                if (deviceManager.connected) {
                    stackView.push("Device.qml")
                } else {
                    if (stackView.depth > 1) {
                        stackView.pop()
                    }
                }
            }
        }
    }
}
