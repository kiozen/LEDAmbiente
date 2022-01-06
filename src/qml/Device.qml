import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

Page {
    title: deviceManager.name

    Settings {
        id: idSettings
        property string devicePage: "PageDeviceLight.qml"
    }

    ButtonGroup {
        buttons: idButtonLayout.children
    }

    ColumnLayout {
        anchors.fill: parent

        Loader {
            id: idLoader
            Layout.fillWidth: true
            Layout.fillHeight: true

            source: idSettings.devicePage

            onSourceChanged: {
                if (source == "qrc:/PageDeviceLight.qml") {
                    idButtonLight.checked = true
                } else if (source == "qrc:/PageDeviceAnimation.qml") {
                    idButtonAnimation.checked = true
                } else if (source == "qrc:/PageDeviceAlarm.qml") {
                    idButtonAlarm.checked = true
                }
            }
        }

        RowLayout {
            id: idButtonLayout
            Layout.fillWidth: true

            Button {
                id: idButtonLight
                Layout.fillWidth: true
                text: qsTr("light")
                onClicked: idSettings.devicePage = "PageDeviceLight.qml"
                flat: true
                checkable: true
                highlighted: checked
            }
            Button {
                id: idButtonAnimation
                Layout.fillWidth: true
                text: qsTr("anim.")
                onClicked: idSettings.devicePage = "PageDeviceAnimation.qml"
                flat: true
                checkable: true
                highlighted: checked
            }
            Button {
                id: idButtonAlarm
                Layout.fillWidth: true
                text: qsTr("alarm")
                onClicked: idSettings.devicePage = "PageDeviceAlarm.qml"
                flat: true
                checkable: true
                highlighted: checked
            }
        }
    }
}
