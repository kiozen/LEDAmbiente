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
import QtQuick.Controls.Material 2.12

Item {
    id: root
    property real value: 1.0
    property real hue: 0

    signal clicked

    Rectangle {
        id: idColorBar

        anchors.fill: parent
        border.color: "dimgray"
        border.width: 1

        gradient: Gradient {
            orientation: Gradient.Horizontal
            stops: [
                GradientStop {
                    position: 0.0
                    color: "white"
                },
                GradientStop {
                    position: 1.0
                    color: Qt.hsva(root.hue, 1.0, 1.0, 1)
                }
            ]
        }

        MouseArea {
            id: idMouseArea
            anchors.fill: parent

            function handleMouse(mouse) {
                if (mouse.buttons & Qt.LeftButton) {
                    root.value = Math.max(0, Math.min(width, mouse.x)) / width
                    root.clicked()
                }
            }

            onPositionChanged: {
                handleMouse(mouse)
            }
            onPressed: {
                handleMouse(mouse)
            }
        }
    }

    Rectangle {
        id: idCursor
        property int center: root.value * idMouseArea.width
        height: parent.height
        width: 5
        border.color: "dimgray"
        border.width: 2
        color: "transparent"
        y: 0
        x: -width / 2
        radius: 2

        onCenterChanged: {
            x = center - width / 2
        }
    }
}
