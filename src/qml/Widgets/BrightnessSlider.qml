import QtQuick 2.12
import QtQuick.Controls.Material 2.12

Item {
    id: root
    property real value: 1.0
    property real hue: 0

    signal clicked

    Rectangle {
        id: idColorBar

        anchors.fill: parent
        border.color: "dimgray"
        border.width: 1

        gradient: Gradient {
            orientation: Gradient.Horizontal
            stops: [
                GradientStop {
                    position: 0.0
                    color: "black"
                },
                GradientStop {
                    position: 1.0
                    color: Qt.hsva(root.hue, 1.0, 1.0, 1)
                }
            ]
        }

        MouseArea {
            id: idMouseArea
            anchors.fill: parent

            function handleMouse(mouse) {
                if (mouse.buttons & Qt.LeftButton) {
                    root.value = Math.max(0, Math.min(width, mouse.x)) / width
                    root.clicked()
                }
            }

            onPositionChanged: {
                handleMouse(mouse)
            }
            onPressed: {
                handleMouse(mouse)
            }
        }
    }

    Rectangle {
        id: idCursor
        property int center: root.value * idMouseArea.width
        height: parent.height
        width: 5
        border.color: "dimgray"
        border.width: 2
        color: "transparent"
        y: 0
        x: -width / 2
        radius: 2

        onCenterChanged: {
            x = center - width / 2
        }
    }
}
