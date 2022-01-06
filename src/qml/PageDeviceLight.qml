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
