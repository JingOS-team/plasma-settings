/*
 * Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import org.kde.kirigami 2.0
import QtQuick.Controls 2.14 as QQC2
import org.kde.kirigami 2.0 as Kirigami
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.15


QQC2.Slider {
    id: control

    // value: 2
    stepSize: 1.0
    from: 0
    to: 4
    
    background: Rectangle {
        width: control.availableWidth
        height: implicitHeight
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2

        implicitWidth: units.gridUnit * 11
        implicitHeight: units.gridUnit * 0.15
        radius: 2
        color: "#809F9FAA"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#FF5AC8FA"
            radius: 2
        }

        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"

            Rectangle {
                id: tag10

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 2
                }

                height: parent.height - 1
                width: height
                color: "white"
            }

            Rectangle {
                id: tag11

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: parent.width / 4
                }

                height: parent.height - 1
                width: height
                color: "white"
            }

            Rectangle {
                id: tag12

                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                height: parent.height - 1
                width: height
                color: "white"
            }

            Rectangle {
                id: tag13

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: parent.width / 4 * 3
                }

                height: parent.height - 1
                width: height
                color: "white"
            }

            Rectangle {
                id: tag14

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 2
                }

                height: parent.height - 1
                width: height
                color: "white"
            }
        }
    }

    handle: Rectangle {
        id: handler

        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        implicitHeight: 23
        implicitWidth: 23

        color: control.pressed ? "#EF9F9FAA" : "#FFFFFFFF"
        radius: 10

        layer.enabled: true
        layer.effect: DropShadow {
            id: rectShadow

            anchors.fill: handler
            color: "#80C3C9D9"
            source: handler
            samples: 9
            radius: 10
            horizontalOffset: 0
            verticalOffset: 0
            spread: 0
        }

    }
}

