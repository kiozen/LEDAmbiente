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
import Qt.labs.settings 1.0

Page {
    title: deviceManager.name

    Settings {
        id: idSettings
        property string devicePage: "PageDeviceLight.qml"
    }

    ButtonGroup {
        buttons: idButtonLayout.children
    }

    ColumnLayout {
        anchors.fill: parent

        Loader {
            id: idLoader
            Layout.fillWidth: true
            Layout.fillHeight: true

            source: idSettings.devicePage

            onSourceChanged: {
                if (source == "qrc:/PageDeviceLight.qml") {
                    idButtonLight.checked = true
                } else if (source == "qrc:/PageDeviceAnimation.qml") {
                    idButtonAnimation.checked = true
                } else if (source == "qrc:/PageDeviceAlarm.qml") {
                    idButtonAlarm.checked = true
                }
            }
        }

        RowLayout {
            id: idButtonLayout
            Layout.fillWidth: true

            Button {
                id: idButtonLight
                Layout.fillWidth: true
                text: qsTr("light")
                onClicked: idSettings.devicePage = "PageDeviceLight.qml"
                flat: true
                checkable: true
                highlighted: checked
            }
            Button {
                id: idButtonAnimation
                Layout.fillWidth: true
                text: qsTr("anim.")
                onClicked: idSettings.devicePage = "PageDeviceAnimation.qml"
                flat: true
                checkable: true
                highlighted: checked
            }
            Button {
                id: idButtonAlarm
                Layout.fillWidth: true
                text: qsTr("alarm")
                onClicked: idSettings.devicePage = "PageDeviceAlarm.qml"
                flat: true
                checkable: true
                highlighted: checked
            }
        }
    }
}
