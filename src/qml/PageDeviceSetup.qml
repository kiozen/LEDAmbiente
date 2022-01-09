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

Page {
    title: qsTr("Device Setup")

    GridLayout {
        anchors.fill: parent
        anchors.margins: 10

        columns: 2

        Label {
            text: qsTr("name")
            Layout.fillWidth: true
        }

        TextField {
            id: idName
            Layout.fillWidth: true
            text: deviceManager.name

            onEditingFinished: deviceManager.system.name = text
        }

        Label {
            text: qsTr("number LEDs")
            Layout.fillWidth: true
        }

        TextField {
            id: idLedCount
            Layout.fillWidth: true
            validator: IntValidator {
                bottom: 1
                top: 10000
            }

            text: deviceManager.system.led_count
            inputMethodHints: Qt.ImhDigitsOnly
            onEditingFinished: deviceManager.system.led_count = text
        }

        Label {
            text: qsTr("max. brightness")
            Layout.fillWidth: true
        }

        TextField {
            id: idMaxBrightness
            Layout.fillWidth: true
            validator: IntValidator {
                bottom: 1
                top: 255
            }

            text: deviceManager.system.max_brightness
            inputMethodHints: Qt.ImhDigitsOnly
            onEditingFinished: deviceManager.system.max_brightness = text
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }
}
