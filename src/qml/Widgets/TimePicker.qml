/**********************************************************************************************
    Copyright (C) 2022 Oliver Eichler <oliver.eichler@gmx.de>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.


    This is more or less the work of:
    https://www.ics.com/blog/creating-qml-controls-scratch-timepicker

**********************************************************************************************/
import QtQuick 2.0
import QtQuick.Controls.Material 2.12

Item {
    id: root

    // public
    function set(date) {
        // e.g. new Date(0, 0, 0,  0, 0)) // 12:00 AM
        repeater.itemAt(0).positionViewAtIndex(
                    24 * (repetitions - 1) / 2 + date.getHours() - 1,
                    ListView.Center) // hour
        repeater.itemAt(1).positionViewAtIndex(
                    60 / interval * (repetitions - 1) / 2 + date.getMinutes(
                        ) / interval, ListView.Center) // minute

        for (var column = 0; column < repeater.count; column++)
            select(repeater.itemAt(column))
    }

    signal clicked(date date)

    //onClicked: print('onClicked', date.toTimeString())
    property int interval: 5 // 30 20 15 10 5 2 1 minutes

    // private
    width: 500
    height: 200 // default size
    clip: true

    onHeightChanged: resizeTimer.start() // resize
    Timer {
        id: resizeTimer
        interval: 1000
        onTriggered: set(get())
    } // ensure same value is selected after resize

    property int rows: 3 // number of rows on the screen     (must be odd). Also change model ''
    property int repetitions: 5 // number of times data is repeated (must be odd)

    Row {
        Repeater {
            id: repeater

            model: [24 * repetitions, 60 / interval * repetitions] // 1-24 hour, 0-59 minute, am/pm

            delegate: ListView {
                // hours minutes am/pm
                id: view

                property int column: index // outer index
                width: root.width / 3
                height: root.height
                snapMode: ListView.SnapToItem

                model: modelData

                delegate: Item {
                    width: root.width / 3
                    height: root.height / rows

                    Text {
                        text: view.get(index)
                        font.pixelSize: Math.min(0.5 * parent.width,
                                                 parent.height)
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: column == 0 ? parent.right : undefined
                            horizontalCenter: column == 1 ? parent.horizontalCenter : undefined
                            left: column == 2 ? parent.left : undefined
                            rightMargin: 0.2 * parent.width
                        }
                        opacity: view.currentIndex == index ? 1 : 0.3
                        color: Material.foreground
                    }
                }

                onMovementEnded: {
                    select(view)
                    timer.restart()
                }
                onFlickEnded: {
                    select(view)
                    timer.restart()
                }
                Timer {
                    id: timer
                    interval: 1
                    onTriggered: clicked(root.get())
                } // emit only once

                function get(index) {
                    // returns e.g. '00' given row
                    if (column == 0)
                        return index % 24 + 1 // hour
                    else if (column == 1)
                        return ('0' + (index * interval) % 60).slice(
                                    -2) // minute
                    else
                        return model[index] // AM/PM
                }
            }
        }
    }

    Text {
        // colon
        text: ':'
        font.pixelSize: Math.min(0.5 * root.width / 3, root.height / rows)
        anchors {
            verticalCenter: parent.verticalCenter
        }
        x: root.width / 3 - width / 4
    }

    function select(view) {
        view.currentIndex = view.indexAt(0, view.contentY + 0.5 * view.height)
    } // index at vertical center

    function get() {
        // returns e.g. '12:00 AM'
        var hour = repeater.itemAt(0).get(repeater.itemAt(0).currentIndex)
        var minute = repeater.itemAt(1).get(repeater.itemAt(1).currentIndex)
        return new Date(0, 0, 0, hour, minute)
    }

    // Component.onCompleted: set(new Date(0, 0, 0,  0, 0)) // 12:00 AM otherwise defaults to index 0 selected
}
