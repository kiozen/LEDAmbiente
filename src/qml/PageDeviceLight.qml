
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
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import Widgets 1.0

Page {
    ColumnLayout {
        id: idColumnLayout
        property int marginSize: 10

        anchors.fill: parent

        ColorPicker {
            id: idColorPicker
            Layout.fillWidth: true
            Layout.leftMargin: idColumnLayout.marginSize
            Layout.rightMargin: idColumnLayout.marginSize
            Layout.topMargin: idColumnLayout.marginSize
            Layout.minimumHeight: 3 * 60 + 10 + 3 * 5
            colorIn: deviceManager.light.color
            onClicked: {
                deviceManager.light.color = color
                idColors.currentIndex = -1
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }

        Label {
            id: idColorHint
            Layout.fillWidth: true
            Layout.leftMargin: idColumnLayout.marginSize
            Layout.rightMargin: idColumnLayout.marginSize
            text: qsTr("Long press color for options.")
            visible: false
            wrapMode: Text.Wrap

            Timer {
                id: idTimerHint
                interval: 5000
                repeat: false
                onTriggered: {
                    idColorHint.visible = false
                }
            }
        }

        GridView {
            id: idColors

            Layout.fillWidth: true
            Layout.fillHeight: true

            Layout.leftMargin: idColumnLayout.marginSize
            Layout.rightMargin: idColumnLayout.marginSize
            Layout.topMargin: idColumnLayout.marginSize

            cellWidth: width / 5
            cellHeight: width / 10

            currentIndex: -1

            model: deviceManager.colors

            delegate: Rectangle {
                width: idColors.cellWidth
                height: idColors.cellHeight
                color: colorValue
                radius: 5

                border.width: 2
                border.color: Material.background

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        idColors.currentIndex = index
                        idColorPicker.colorIn = colorValue
                        deviceManager.light.color = colorValue
                    }

                    onPressAndHold: {
                        idMenuColorOptions.index = index
                        idMenuColorOptions.popup()
                    }
                }
            }
        }

        PowerButton {
            id: idButton

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: idColumnLayout.marginSize
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            checked: deviceManager.light.power
            onClicked: deviceManager.light.power = checked
        }
    }

    Rectangle {
        width: idColors.cellWidth - 2
        height: idColors.cellHeight - 4
        color: "transparent"
        border.width: 2
        border.color: Material.foreground
        radius: 5

        x: idColors.x + (deviceManager.colors.rowCount % 5) * idColors.cellWidth + 2
        y: idColors.y + Math.floor(
               deviceManager.colors.rowCount / 5) * idColors.cellHeight + 2

        Label {
            anchors.centerIn: parent
            text: "+"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                deviceManager.colors.add(idColorPicker.color)
                idColorHint.visible = true
                idTimerHint.start()
            }
        }
    }

    Menu {
        id: idMenuColorOptions
        property int index: -1
        MenuItem {
            text: qsTr("replace")
            onClicked: {
                deviceManager.colors.replace(idMenuColorOptions.index,
                                             idColorPicker.color)
            }
        }
        MenuItem {
            text: qsTr("delete")
            onClicked: {
                deviceManager.colors.remove(idMenuColorOptions.index,
                                            idColors.currentIndex)
            }
        }
    }
}
