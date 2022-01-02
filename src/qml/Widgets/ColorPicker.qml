import QtQuick 2.12
import Widgets 1.0
import QtQuick.Controls 2.5

Item {
    id: root
    property color color: "black"
    property color colorIn: "black"

    onColorInChanged: {
        idHueSlider.value = colorIn.hsvHue
        idSaturationSlider.value = colorIn.hsvSaturation
        idBrightnessSlider.value = colorIn.hsvValue
    }

    HueSlider {
        id: idHueSlider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        height: 60

        onValueChanged: {
            root.color = Qt.hsva(value, idSaturationSlider.value,
                                 idBrightnessSlider.value, 1)
        }
    }

    SaturationSlider {
        id: idSaturationSlider

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: idHueSlider.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        hue: idHueSlider.value

        height: 60

        onValueChanged: {
            root.color = Qt.hsva(idHueSlider.value, value,
                                 idBrightnessSlider.value, 1)
        }
    }

    BrightnessSlider {
        id: idBrightnessSlider

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: idSaturationSlider.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10

        hue: idHueSlider.value

        height: 60

        onValueChanged: {
            root.color = Qt.hsva(idHueSlider.value,
                                 idSaturationSlider.value, value, 1)
        }
    }

    Label {

        anchors.top: idBrightnessSlider.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: 10
        anchors.rightMargin: 10
        text: "color: " + root.color + " saturation: " + Math.round(
                  root.color.hsvSaturation * 255) + "  brightness: " + Math.round(
                  root.color.hsvValue * 255)
    }
}
