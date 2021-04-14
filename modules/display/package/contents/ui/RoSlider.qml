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

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.11 as Kirigami
import QtGraphicalEffects 1.0

Rectangle {
    id: root

    property real currentValue
    property real maxValue
    width: 640 * appScale
    height: 6 * appScale
    color: "transparent"

    signal sliderValueChanged(int value)

    Slider {
        id: sliderArea

        width: parent.width
        height: parent.height

        leftPadding: 0
        rightPadding: 0
        from: 0
        to: maxValue
        value: currentValue

        onValueChanged: {
            if (currentValue != value) {
                currentValue = value
                sliderValueChanged(value)
            }
        }

        handle: Item {
            id: m_Handle
            
            x: (currentValue / maxValue) * parent.width
            y: 5

            Rectangle {
                anchors.centerIn: parent

                width: 34
                height: 34
                radius: 17
                color: control.pressed ? "blue" : "white"
                border.color: "gray"
                border.width: 1
            }
        }

        background: Rectangle {
            id: progressBarBackground

            radius: 6 * appScale
            color: "#d8000000"
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: progressBarBackground.width
                    height: progressBarBackground.height
                    
                    radius: progressBarBackground.radius
                }
            }

            Rectangle {
                width: (currentValue / maxValue) * parent.width
                height: parent.height

                color: "#FF3C4BE8"
            }
        }
    }
}
