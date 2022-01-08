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

        ColorPicker {
            id: idColorPicker
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.minimumHeight: 3 * 60 + 10 + 3 * 5
            colorIn: deviceManager.light.color
            onClicked: deviceManager.light.color = color
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }

        PowerButton {
            id: idButton

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            checked: deviceManager.light.power
            onClicked: deviceManager.light.power = checked
        }
    }
}
