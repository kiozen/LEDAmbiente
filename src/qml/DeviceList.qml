import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    title: qsTr("Select Device")

    ListView {
        id: idListDevice
        model: modelDevices
        anchors.fill: parent
        anchors.margins: 6

        delegate: ItemDelegate {
            width: idListDevice.width
            height: idRectangle.height + 2

            Button {
                id: idRectangle
                width: parent.width
                height: idGrid.height

                onClicked: {
                    deviceManager.connectToDevice(deviceAddr)
                }

                Grid {
                    id: idGrid
                    columns: 2
                    columnSpacing: 6
                    rowSpacing: 2
                    padding: 6

                    Label {
                        text: qsTr("Name")
                    }

                    Label {
                        text: deviceName
                    }

                    Label {
                        text: qsTr("IP")
                    }

                    Label {
                        text: deviceAddr
                    }

                    Label {
                        text: qsTr("MAC")
                    }

                    Label {
                        text: deviceMac
                    }
                }
            }
        }
    }

    Label {
        anchors.fill: parent
        visible: idListDevice.count == 0
        text: qsTr("<p>No devices found. Make sure the controller is switched on, connected to the Wifi and is running LEDControl.</p>")
        wrapMode: Text.Wrap
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignHCenter"
    }
}
