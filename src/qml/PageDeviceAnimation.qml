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

            delegate: ItemDelegate {
                width: idListAnimations.width
                height: idButton.height + 2

                Button {
                    id: idButton
                    width: parent.width
                    height: idGrid.height

                    onClicked: deviceManager.animation.hash = animationHash

                    Grid {
                        id: idGrid
                        columns: 1
                        columnSpacing: 6
                        rowSpacing: 2
                        padding: 6

                        Label {
                            text: animationName
                            font.bold: true
                        }

                        Label {
                            text: animationDescription
                        }
                    }
                }
            }
        }

        PowerButton {
            id: idPowerButton

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 10
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200

            checked: deviceManager.animation.power
            onClicked: deviceManager.animation.power = checked
        }
    }
}
