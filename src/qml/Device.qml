import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

Page {

    //    width: 600
    //    height: 400
    title: qsTr("Page 1")

    ColorDialog {
        Component.onCompleted: visible = true
    }
}
