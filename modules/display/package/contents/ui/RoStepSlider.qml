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

    value: 0.5

    background: Rectangle {
        width: control.availableWidth
        height: implicitHeight
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2

        implicitWidth: units.gridUnit * 11
        implicitHeight: units.gridUnit * 0.29
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
                    leftMargin: 8 * appScale
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag11

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag12

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 2
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag13

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 3
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag14

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 4
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag15

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 5
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag16

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 6
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag17

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 7
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag18

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 8
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag19

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 9
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }

            Rectangle {
                id: tag20

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 70 * appScale * 10
                }

                height: parent.height - 4 * appScale
                width: height
                color: "white"
            }
        }
    }

    handle: Rectangle {
        id: handler

        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2

        implicitHeight: units.gridUnit * 1.32
        implicitWidth: units.gridUnit * 1.54

        color: control.pressed ? "#EF9F9FAA" : "#FFFFFFFF"
        radius: 11
        layer.enabled: true
        layer.effect: DropShadow {
            id: rectShadow

            anchors.fill: handler
            color: "#80C3C9D9"
            source: handler
            samples: 9
            radius: 11
            horizontalOffset: 0
            verticalOffset: 0
            spread: 0
        }
    }
}
