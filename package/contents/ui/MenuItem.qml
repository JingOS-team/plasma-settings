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
import QtQuick.Controls 2.12
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0

Item {
    id: menuItem_root

    property bool isSelect: false
    property int menuType: 0 // 0 : normal  ; 1 : switch ; 2 : text
    property string menuIconSource: ""
    property string menuTitle: ""
    property string menuContent: ""
    property bool menuChecked: false

    signal toggleChanged(bool checked)
    signal menuClicked

    implicitWidth : 240 * appScaleSize
    implicitHeight: 39 * appScaleSize

    //color: isSelect ? "transparent" : "#FF3C4BE8"
    MouseArea {
        id:bkmouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            menuClicked()
        }
    }

    Rectangle{
        anchors.fill: parent
        radius: JDisplay.dp(10)
        visible:bkmouse.containsMouse || menuItem_root.isSelect
        color: menuItem_root.isSelect ? "#FF3C4BE8" : (bkmouse.pressed ? "#4D9F9FAA" : bkmouse.containsMouse ? "#339F9FAA" : "#ffffff")
    }

    Kirigami.Icon {
        id: menu_icon

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 13 * appScaleSize
        }
        width: 22 * appScaleSize
        height: width
        source:menuIconSource
    }

    Text {
        id: menu_title

        anchors {
            verticalCenter: parent.verticalCenter
            left: menu_icon.right
            leftMargin: 7 * appScaleSize
        }
        width: 128 * appScaleSize
        height: 17 * appScaleSize
        font.pixelSize: 14 * appFontSize
        verticalAlignment: Text.AlignVCenter
        text: menuTitle
        color: isSelect ? "#fff" : Kirigami.JTheme.majorForeground//"#000"
    }

    Item {
        anchors {
            right: parent.right
            rightMargin: 13 * appScaleSize
        }
        width: 102 * appScaleSize
        height: parent.height
        visible: menuType != 0

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 25 * appScaleSize
            font.pixelSize: 14 * appScaleSize
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: isSelect ? "#fff" : Kirigami.JTheme.minorForeground//"#993C3C43"
            text: menuContent
            visible: menuType == 2
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 1
            elide: Text.ElideRight
        }

        Kirigami.JSwitch {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            width: 43 * appScaleSize
            height:26 * appScaleSize

            visible: menuType == 1
            checked: menuChecked
            checkable: true

            onToggled: {
                toggleChanged(checked)
            }
        }
    }
}
