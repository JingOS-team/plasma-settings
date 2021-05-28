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

Item {
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

    width: 240
    height: 35

    //color: isSelect ? "transparent" : "#FF3C4BE8"
    MouseArea {
        id:bkmouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            menuClicked()
        }
//        onEntered: {
//            if(!menuItem_root.isSelect){
//                menuItem_root.color = "#339F9FAA"
//            }
//        }

//        onExited: {
//            menuItem_root.color = menuItem_root.isSelect ?  "transparent" : "#FF3C4BE8"

//        }

//        onPressed: {
//            if(!menuItem_root.isSelect){
//                menuItem_root.color = "#4D9F9FAA"
//            }
//        }

//        onReleased: {
//            menuItem_root.color = menuItem_root.isSelect ?  "transparent" : "#FF3C4BE8"
//        }
    }

    Rectangle{
        anchors.fill: parent
        radius: 10
        visible:bkmouse.containsMouse || menuItem_root.isSelect
        color: menuItem_root.isSelect ? "#FF3C4BE8" : (bkmouse.pressed ? "#4D9F9FAA" : bkmouse.containsMouse ? "#339F9FAA" : "#ffffff")
    }

//    onIsSelectChanged: {
//        console.log("----------isSelect------------" , isSelect)
//        menuItem_root.color = menuItem_root.isSelect ?  "transparent" : "#FF3C4BE8"
//    }

    Image {
        id: menu_icon

        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 13
        }
        width: 17
        height: width
        // source: isSelect ? menuIconSourceHighlight : menuIconSource
        source:menuIconSource
        sourceSize.width: 17
        sourceSize.height: 17

    }

    Text {
        id: menu_title

        anchors {
            verticalCenter: parent.verticalCenter
            left: menu_icon.right
            leftMargin: 7
        }
        width: 128
        height: 17
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        text: menuTitle
        color: isSelect ? "#fff" : "#000"
    }

    Item {
        anchors {
            right: parent.right
            rightMargin: 13
        }
        width: 102
        height: parent.height
        visible: menuType != 0

        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 25
            font.pixelSize: 14
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: isSelect ? "#fff" : "#993C3C43"
            text: menuContent
            visible: menuType == 2
            wrapMode: Text.WrapAnywhere
            maximumLineCount: 1
            elide: Text.ElideRight
        }

        Switch {
            anchors.centerIn: parent
//            Layout.columnSpan: 1
            visible: menuType == 1
            checked: menuChecked
            checkable: true

            onCheckedChanged: {
                swichChanged()
            }
        }
    }
}
