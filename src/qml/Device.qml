import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import Widgets 1.0
import Qt.labs.settings 1.0

Page {
    title: deviceManager.name

    Settings {
        id: idSettings
        property string devicePage: "PageDeviceLight.qml"
    }

    ColumnLayout {
        anchors.fill: parent

        Loader {
            id: idLoader
            Layout.fillWidth: true
            Layout.fillHeight: true

            source: idSettings.devicePage
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: qsTr("light")
                onClicked: idSettings.devicePage = "PageDeviceLight.qml"
                flat: true
            }
            Button {
                Layout.fillWidth: true
                text: qsTr("alarm")
                onClicked: idSettings.devicePage = "PageDeviceAlarm.qml"
                flat: true
            }
            Button {
                Layout.fillWidth: true
                text: qsTr("anim.")
                onClicked: idSettings.devicePage = "PageDeviceAnimation.qml"
                flat: true
            }
        }
    }
}
