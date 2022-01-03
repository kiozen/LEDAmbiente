import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import Widgets 1.0

Page {
    title: deviceManager.name

    ColumnLayout {
        anchors.fill: parent

        Loader {
            id: idLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: qsTr("light")
                onClicked: idLoader.source = "PageDeviceLight.qml"
                flat: true
            }
            Button {
                Layout.fillWidth: true
                text: qsTr("alarm")
                onClicked: idLoader.source = "PageDeviceAlarm.qml"
                flat: true
            }
            Button {
                Layout.fillWidth: true
                text: qsTr("anim.")
                onClicked: idLoader.source = "PageDeviceAnimation.qml"
                flat: true
            }
        }
    }
}
