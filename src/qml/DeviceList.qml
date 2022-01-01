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
}
