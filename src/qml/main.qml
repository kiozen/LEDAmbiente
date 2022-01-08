
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
import QtQuick.Controls.Material 2.12

ApplicationWindow {
    id: window
    width: 640
    height: 600
    visible: true
    title: qsTr("LED Ambiente")

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            visible: stackView.depth > 1
            icon.source: "icons/back-sharp.png"
            icon.color: Material.foreground
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
