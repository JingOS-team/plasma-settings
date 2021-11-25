/*
 * Copyright 2021 Rui Wang <wangrui@jingos.com>
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

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.15 as Kirigami
import QtGraphicalEffects 1.0

Rectangle {
    id: root

    property int totalPower
    property int leftPower
    property bool isCharging
    property int fontSize: 80
    property real widgetWidth: 888 * appScale * 0.7 -   40 * appScale
    property real widgetHeight: 133 * appScale
    property string remainingString: ""
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

    width: widgetWidth
    height: widgetHeight
    color: "transparent"

    Slider {
        id: sliderArea

        width: parent.width
        height: parent.height
        leftPadding: 0
        rightPadding: 0
        from: totalPower
        to: 0

        handle: Item {
            visible: true
            width: 1 * appScale
            height: 1 * appScale
            x: 0
            y: 0

            Rectangle {
                anchors.centerIn: parent
                width: 1
                height: 1
                visible: false
            }
        }

        background: Rectangle {
            id: progressBarBackground

            color: isDarkTheme ? "#4DD6D9FF" : "#FFD6D9FF"
            radius: 12 * appScale

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: progressBarBackground.width
                    height: progressBarBackground.height
                    radius: progressBarBackground.radius
                }
            }

            Rectangle {
                width: (leftPower / totalPower) * parent.width
                height: parent.height
                color: "transparent"

                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point(0, 0)
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "#FF6F82F5"
                        }
                        GradientStop {
                            position: 1.0
                            color: "#FF3C4BE8"
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: 480 * appScale
        color: "transparent"

        Text {
            id: battery_left

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 31 * appScale
                topMargin: 25 * appScale
            }

            text: {
                if (leftPower == -1) {
                    return i18n("Synchronizing...")
                } else {
                    return leftPower
                }
            }

            font.pixelSize: 36 * appFontSize
            color: "white"
        }

        Text {
            id: battery_pa

            anchors {
                left: battery_left.right
                bottom: battery_left.bottom
                bottomMargin: 5 * appScale
                leftMargin: 5 * appScale
            }

            text: "%"
            visible: leftPower != -1
            font.pixelSize: 17 *appFontSize
            color: "white"
        }

        Image {
            id: battery_charging

            anchors {
                left: battery_pa.right
                leftMargin: 18  * appScale
                bottom: battery_pa.bottom
            }

            width: 24 * appScale
            height: width
            visible: isCharging
            source: "../image/battery_charging.png"
        }

        Text {
            id: time_left

            anchors {
                left: parent.left
                top: battery_left.bottom
                leftMargin: 31  * appScale
                topMargin: 11 * appScale
            }
            text: remainingString
            font.pixelSize: 17 * appFontSize
            color: "white"
        }
    }
}
