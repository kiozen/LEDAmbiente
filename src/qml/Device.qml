import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import Widgets 1.0

Page {
    title: deviceManager.name

    ColumnLayout {
        anchors.fill: parent

        ColorPicker {
            id: idColorPicker
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.minimumHeight: 3 * 60 + 10 + 3 * 5
            colorIn: deviceManager.color
            onColorChanged: deviceManager.color = color
        }

        Button {
            id: idButton

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            checkable: true
            icon.source: "icons/power-sharp.png"
            icon.height: 100
            icon.width: 100
            icon.color: checked ? "green" : Material.foreground

            background: Rectangle {
                border.width: idButton.checked ? 2 : 1
                border.color: idButton.checked ? "green" : Material.foreground
                radius: 4
                color: Material.background
            }

            checked: deviceManager.power
            onCheckedChanged: deviceManager.power = checked
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }
}
