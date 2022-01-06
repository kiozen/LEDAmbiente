import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import Widgets 1.0

Page {
    title: qsTr("Alarm Clock")
    ColumnLayout {
        anchors.fill: parent

        Switch {
            id: idSwitch
            text: qsTr("enable")

            checked: deviceManager.alarm.active

            onClicked: {
                deviceManager.alarm.active = checked
            }
        }

        TimePicker {
            id: idTimePicker
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 200
            Layout.preferredHeight: 100
            Layout.topMargin: 30
            Layout.bottomMargin: 30

            enabled: idSwitch.checked

            onClicked: {
                var date = get()
                deviceManager.alarm.hour = date.getHours()
                deviceManager.alarm.minute = date.getMinutes()
            }

            Connections {
                target: deviceManager
                function onAlarmChanged() {
                    var hour = Math.max(0, deviceManager.alarm.hour)
                    var minute = Math.max(0, deviceManager.alarm.minute)
                    idTimePicker.set(new Date(0, 0, 0, hour, minute))
                }
            }

            Component.onCompleted: {
                var hour = Math.max(0, deviceManager.alarm.hour)
                var minute = Math.max(0, deviceManager.alarm.minute)
                idTimePicker.set(new Date(0, 0, 0, hour, minute))
            }
        }

        Item {
            enabled: idSwitch.checked
            Layout.fillWidth: true
            Layout.preferredHeight: idGridDays.height

            GridLayout {
                id: idGridDays
                anchors.horizontalCenter: parent.horizontalCenter
                columns: 7

                CheckBox {
                    id: idCheckMon
                    checked: deviceManager.alarm.mon
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckMon.checked = deviceManager.alarm.mon
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.mon = checked
                    }
                    Layout.alignment: Qt.AlignCenter
                }
                CheckBox {
                    id: idCheckTue
                    checked: deviceManager.alarm.tue
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckTue.checked = deviceManager.alarm.tue
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.tue = checked
                    }
                    Layout.alignment: Qt.AlignCenter
                }
                CheckBox {
                    id: idCheckWed
                    checked: deviceManager.alarm.wed
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckWed.checked = deviceManager.alarm.wed
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.wed = checked
                    }
                    Layout.alignment: Qt.AlignCenter
                }
                CheckBox {
                    id: idCheckThu
                    checked: deviceManager.alarm.thu
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckThu.checked = deviceManager.alarm.thu
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.thu = checked
                    }

                    Layout.alignment: Qt.AlignCenter
                }
                CheckBox {
                    id: idCheckFri
                    checked: deviceManager.alarm.fri
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckFri.checked = deviceManager.alarm.fri
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.fri = checked
                    }

                    Layout.alignment: Qt.AlignCenter
                }
                CheckBox {
                    id: idCheckSat
                    checked: deviceManager.alarm.sat
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckSat.checked = deviceManager.alarm.sat
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.sat = checked
                    }

                    Layout.alignment: Qt.AlignCenter
                }
                CheckBox {
                    id: idCheckSun
                    checked: deviceManager.alarm.sun
                    Connections {
                        target: deviceManager
                        function onAlarmChanged() {
                            idCheckSun.checked = deviceManager.alarm.sun
                        }
                    }
                    onClicked: {
                        deviceManager.alarm.sun = checked
                    }

                    Layout.alignment: Qt.AlignCenter
                }

                Label {
                    text: qsTr("Mon")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Tue")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Wed")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Thu")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Fri")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Sat")
                    Layout.alignment: Qt.AlignCenter
                }
                Label {
                    text: qsTr("Sun")
                    Layout.alignment: Qt.AlignCenter
                }
            }
        }

        Label {
            enabled: idSwitch.checked
            Layout.preferredWidth: idGridDays.width
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            text: qsTr("start animation:")
        }

        ComboBox {
            id: idComboBox
            enabled: idSwitch.checked

            Layout.preferredWidth: idGridDays.width
            Layout.alignment: Qt.AlignHCenter

            model: deviceManager.animations

            displayText: deviceManager.animations.resolveHash(
                             deviceManager.alarm.animationHash)

            delegate: ItemDelegate {
                width: parent.width
                text: animationName
                onClicked: {
                    deviceManager.alarm.animationHash = animationHash
                    idComboBox.displayText = deviceManager.animations.resolveHash(
                                animationHash)
                }
            }
        }

        Label {
            id: idWarning
            Layout.fillWidth: true
            Layout.margins: 10
            text: qsTr(
                      "Warning: You have to choose an animation and a weekday.")
            visible: !deviceManager.alarm.animationHash
                     || !(deviceManager.alarm.mon | deviceManager.alarm.tue
                          | deviceManager.alarm.wed | deviceManager.alarm.thu
                          | deviceManager.alarm.fri | deviceManager.alarm.sat
                          | deviceManager.alarm.sun)

            wrapMode: Text.Wrap
            font.bold: true
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
        }
    }
}
