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
import Widgets 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Item {
    id: root
    property color color: "transparent"
    property color colorIn: "transparent"

    signal clicked

    onColorInChanged: {
        idHueSlider.value = colorIn.hsvHue
        idSaturationSlider.value = colorIn.hsvSaturation
        idBrightnessSlider.value = colorIn.hsvValue

        color = Qt.binding(function () {
            return Qt.hsva(idHueSlider.value, idSaturationSlider.value,
                           idBrightnessSlider.value, 1)
        })
    }

    function updateFromRGB() {
        root.colorIn = Qt.rgba(idColorRed.value, idColorGreen.value,
                               idColorBlue.value, 1.0)
        root.clicked()
    }

    ColumnLayout {
        anchors.fill: parent

        HueSlider {
            id: idHueSlider
            Layout.fillWidth: true
            height: 60
            onClicked: root.clicked()
        }

        SaturationSlider {
            id: idSaturationSlider
            Layout.fillWidth: true
            hue: idHueSlider.value
            height: 60
            onClicked: root.clicked()
        }

        BrightnessSlider {
            id: idBrightnessSlider
            Layout.fillWidth: true
            hue: idHueSlider.value
            saturation: idSaturationSlider.value
            height: 60
            onClicked: root.clicked()
        }

        RowLayout {
            Layout.fillWidth: true

            ColorEdit {
                id: idColorRed
                labelText: "red:"
                text: Math.round(root.color.r * 255)

                onEditingFinished: updateFromRGB()
            }

            ColorEdit {
                id: idColorGreen
                labelText: "green:"
                text: Math.round(root.color.g * 255)

                onEditingFinished: updateFromRGB()
            }

            ColorEdit {
                id: idColorBlue
                labelText: "blue:"
                text: Math.round(root.color.b * 255)

                onEditingFinished: updateFromRGB()
            }

            Rectangle {
                Layout.fillWidth: true
                color: "transparent"
            }
        }
    }
}
