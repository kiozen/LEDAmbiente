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
    property real value: 0

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
                    position: 1.0
                    color: "#FF0000"
                },
                GradientStop {
                    position: 0.85
                    color: "#FFFF00"
                },
                GradientStop {
                    position: 0.76
                    color: "#00FF00"
                },
                GradientStop {
                    position: 0.5
                    color: "#00FFFF"
                },
                GradientStop {
                    position: 0.33
                    color: "#0000FF"
                },
                GradientStop {
                    position: 0.16
                    color: "#FF00FF"
                },
                GradientStop {
                    position: 0.0
                    color: "#FF0000"
                }
            ]
        }

        MouseArea {
            id: idMouseArea
            anchors.fill: parent

            function handleMouse(mouse) {
                if (mouse.buttons & Qt.LeftButton) {
                    root.value = 1.0 - Math.max(0, Math.min(width,
                                                            mouse.x)) / width
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
        property int center: (1.0 - Math.max(0, root.value)) * idMouseArea.width
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
