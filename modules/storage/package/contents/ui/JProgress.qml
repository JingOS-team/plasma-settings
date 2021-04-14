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

    property int totalValue
    property int usedPower
    color: "transparent"

    function getPowerLeft() {
        return totalValue - usedPower
    }

    Slider {
        id: sliderArea
        
        leftPadding: 0
        rightPadding: 0
        width: parent.width
        height: parent.height
        from: totalValue
        to: 0

        handle: Item {
            x: 0
            y: 0

            width: 1
            height: 1
            visible: true

            Rectangle {
                anchors.centerIn: parent
                width: 1
                height: 1
                visible: false
            }
        }

        background: Rectangle {
            id: progressBarBackground

            color: "#FFD6D9FF"
            radius: 15 * battery_root.appScale
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: progressBarBackground.width
                    height: progressBarBackground.height

                    radius: progressBarBackground.radius
                }
            }

            Rectangle {
                width: (usedPower / totalValue) * parent.width
                height: parent.height
                
                color: "#FF6F82F5"
            }
        }
    }
}
