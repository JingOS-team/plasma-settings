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
import org.kde.kirigami 2.13 as Kirigami
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Rectangle {
    id: menuItem_root

    property bool isSelect: false
    property int menuType: 0 // 0 : normal  ; 1 : switch ; 2 : text
    property string menuIconSource: ""
    property string menuIconSourceHighlight: ""
    property string menuTitle: ""
    property string menuContent: ""
    property bool menuChecked: false

    signal swichChanged
    signal menuClicked

    width: 369 * appScale
    height: 60 * appScale
    radius: 15 * appScale
    color: isSelect ? "#FF3C4BE8" : "transparent"

    MouseArea {
        anchors.fill: parent
        onClicked: {
            menuClicked()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Image {
            id: menu_icon

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 20 * appScale
            }
            width: 25 * appScale
            height: width
            source: isSelect ? menuIconSourceHighlight : menuIconSource
            sourceSize.width: 25 * appScale
            sourceSize.height: 25 * appScale

        }

        Text {
            id: menu_title

            anchors {
                verticalCenter: parent.verticalCenter
                left: menu_icon.right
                leftMargin: 15 * appScale
            }
            width: 229 * appScale
            height: 25 * appScale
            font.pointSize: appFontSize + 2
            verticalAlignment: Text.AlignVCenter
            text: menuTitle
            color: isSelect ? "#fff" : "#000"
        }

        Rectangle {

            anchors {
                right: parent.right
                rightMargin: 20 * appScale
            }
            width: 150 * appScale
            height: parent.height
            color: "transparent"
            visible: menuType != 0

            Text {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 25 * appScale
                font.pointSize: appFontSize + 2
                horizontalAlignment: Text.AlignRight
                color: isSelect ? "#fff" : "#993C3C43"
                text: menuContent
                visible: menuType == 2
                wrapMode: Text.WrapAnywhere
                maximumLineCount: 1
                elide: Text.ElideRight
            }

            Switch {
                anchors.centerIn: parent
                Layout.columnSpan: 1
                visible: menuType == 1
                checked: menuChecked
                checkable: true
                
                onCheckedChanged: {
                    swichChanged()
                }
            }
        }
    }
}
