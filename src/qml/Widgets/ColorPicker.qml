import QtQuick 2.12
import Widgets 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

Item {
    id: root
    property color color: "transparent"
    property color colorIn: "transparent"

    signal clicked()

    onColorInChanged: {
        idHueSlider.value = colorIn.hsvHue
        idSaturationSlider.value = colorIn.hsvSaturation
        idBrightnessSlider.value = colorIn.hsvValue

        color = Qt.binding(function () {
            return Qt.hsva(idHueSlider.value, idSaturationSlider.value,
                           idBrightnessSlider.value, 1)
        })
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
            height: 60
            onClicked: root.clicked()
        }

        Label {
            Layout.fillWidth: true
            text: "color: " + root.color + " saturation: " + Math.round(
                      root.color.hsvSaturation * 255) + "  brightness: " + Math.round(
                      root.color.hsvValue * 255)
            height: 20
        }
    }
}
