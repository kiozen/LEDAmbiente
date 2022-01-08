/**********************************************************************************************
    Copyright (C) 2022 Oliver Eichler <oliver.eichler@gmx.de>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

**********************************************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    title: qsTr("Select Device")

    ListView {
        id: idListDevice
        model: modelDevices
        anchors.fill: parent
        anchors.margins: 6

        delegate: Button {
            width: idListDevice.width
            height: idGrid.height + 2

            onClicked: {
                deviceManager.connectToDevice(deviceAddr, deviceName)
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

    Label {
        anchors.fill: parent
        visible: idListDevice.count == 0
        text: qsTr("<p>No devices found. Make sure the controller is switched on, connected to the Wifi and is running LEDControl.</p>")
        wrapMode: Text.Wrap
        verticalAlignment: "AlignVCenter"
        horizontalAlignment: "AlignHCenter"
    }
}
