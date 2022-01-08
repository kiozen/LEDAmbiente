import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import Widgets 1.0

Page {
    ColumnLayout {
        anchors.fill: parent

        ListView {
            id: idListAnimations
            model: deviceManager.animations
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.fillHeight: true

            currentIndex: deviceManager.animations.currentIndex

            delegate: ItemDelegate {
                width: idListAnimations.width
                height: idLabelName.height * 3 + 12
                Column {
                    id: idAnimDesc
                    anchors.margins: 6
                    anchors.fill: parent

                    Label {
                        id: idLabelName
                        width: parent.width
                        text: animationName
                        font.bold: true
                    }

                    Label {
                        id: idLabelDesc
                        width: parent.width
                        text: animationDescription
                        wrapMode: Text.Wrap
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        deviceManager.animations.currentIndex = index
                        deviceManager.animation.hash = animationHash
                    }
                }
            }
            highlightResizeDuration: 300
            highlight: Rectangle {
                color: "transparent"
                radius: 5
                border.color: Material.highlightedButtonColor
                border.width: 1
            }
        }

        PowerButton {
            id: idPowerButton

            enabled: deviceManager.animations.currentIndex !== -1

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            checked: deviceManager.animation.power
            onClicked: deviceManager.animation.power = checked
        }
    }
}
