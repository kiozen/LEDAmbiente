
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
        anchors.fill: parent

        ListView {
            id: idListAnimations
            model: deviceManager.animations
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.fillHeight: true

            currentIndex: deviceManager.animations.currentIndex

            delegate: ItemDelegate {
                width: idListAnimations.width
                height: idLabelName.height * 3 + 12
                Column {
                    id: idAnimDesc
                    anchors.margins: 6
                    anchors.fill: parent

                    Label {
                        id: idLabelName
                        width: parent.width
                        text: animationName
                        font.bold: true
                    }

                    Label {
                        id: idLabelDesc
                        width: parent.width
                        text: animationDescription
                        wrapMode: Text.Wrap
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        deviceManager.animations.currentIndex = index
                        deviceManager.animation.hash = animationHash
                    }
                }
            }
            highlightResizeDuration: 300
            highlight: Rectangle {
                color: "transparent"
                radius: 5
                border.color: Material.highlightedButtonColor
                border.width: 1
            }
        }

        PowerButton {
            id: idPowerButton

            enabled: deviceManager.animations.currentIndex !== -1
            timeout_active: deviceManager.timeout.active

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            checked: deviceManager.animation.power
            onClicked: deviceManager.animation.power = checked

            onTimeout: {
                deviceManager.timeout.target = "animation"
                deviceManager.timeout.minutes = minutes
                deviceManager.timeout.activate = true
            }
        }
    }
}
