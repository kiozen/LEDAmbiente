
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
import QtQuick.Layouts 1.12

GridLayout {
    id: root

    property string labelText: ""
    property real value: idText.text / 255.0
    property alias text: idText.text

    signal editingFinished

    columns: 2

    Label {
        id: idLabel
        text: root.labelText
    }

    TextInput {
        id: idText
        Layout.preferredWidth: font.pixelSize * 3

        validator: IntValidator {
            bottom: 0
            top: 255
        }
        text: Math.round(root.value * 255)
        inputMethodHints: Qt.ImhDigitsOnly
        color: Material.foreground
        onEditingFinished: {
            focus = false
            root.editingFinished()
        }
    }

    Rectangle {
        color: "transparent"
        Layout.preferredWidth: idLabel.width
    }

    Rectangle {
        color: idText.focus ? Material.highlightedButtonColor : Material.foreground
        height: idText.focus ? 2 : 1
        Layout.preferredWidth: idText.width
    }
}
