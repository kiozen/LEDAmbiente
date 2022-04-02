
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
import QtQuick 2.0
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.5

Button {
    id: root

    signal timeout(int minutes)

    property bool timeout_active: false

    checkable: true
    icon.source: "/icons/power-sharp.png"
    icon.height: 100
    icon.width: 100
    icon.color: root.enabled ? checked ? "green" : Material.foreground : Material.buttonDisabledColor

    background: Rectangle {
        border.width: root.checked ? 2 : 1
        border.color: root.enabled ? root.checked ? "green" : Material.foreground : Material.buttonDisabledColor
        radius: 4
        color: Material.background
    }

    Button {
        id: idTimoutButton
        anchors.top: root.top
        anchors.right: root.right
        anchors.margins: 10
        icon.source: "/icons/time-sharp.png"
        width: root.width / 5
        icon.color: root.enabled ? root.timeout_active ? "#A00000" : Material.foreground : Material.buttonDisabledColor
        onClicked: idMenu.popup()

        background: Rectangle {
            border.width: root.checked ? 2 : 1
            border.color: root.enabled ? root.timeout_active ? "#A00000" : Material.foreground : Material.buttonDisabledColor
            radius: 4
            color: Material.background
        }
    }

    Menu {
        id: idMenu

        MenuItem {
            text: qsTr("2 minutes")
            onClicked: root.timeout(2)
        }
        MenuItem {
            text: qsTr("5 minutes")
            onClicked: root.timeout(5)
        }
        MenuItem {
            text: qsTr("10 minutes")
            onClicked: root.timeout(10)
        }
        MenuItem {
            text: qsTr("20 minutes")
            onClicked: root.timeout(20)
        }
        MenuItem {
            text: qsTr("30 minutes")
            onClicked: root.timeout(30)
        }
    }
}
