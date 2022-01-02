import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3
import Widgets 1.0

Page {
    title: deviceManager.name

    ColorPicker {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        colorIn: deviceManager.color
        onColorChanged: deviceManager.color = color
    }
}
