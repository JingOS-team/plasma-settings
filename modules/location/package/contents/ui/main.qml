/*
 *   Copyright 2020 Dimitris Kardarakos <dimkard@posteo.net>
 *   Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import org.kde.kcm 1.2 as KCM
import QtQuick 2.7
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls 2.10

Rectangle {
    id: storage_root

    // property real appScale: 1.3 * parent.width / (1920 * 0.7)
    // property int appFontSize: theme.defaultFont.pointSize

    property int screenWidth: 888
    property int screenHeight: 648
    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property int radiusCommon: 10 
    property int fontNormal: 14


    width: screenWidth * 0.7
    height: screenHeight

    function switchLocation(status){
        console.log("------location switch --------" , status)
    }


    Rectangle {
        anchors.fill: parent

        color: "#FFF6F9FF"

        Text {
            id: location_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight  
                topMargin: marginTitle2Top  
            }

            width: 329
            height: 14
            text: i18n("Location")
            // font.pointSize: appFontSize + 11
            font.pixelSize: 20 
            font.weight: Font.Bold
        }

        
         Rectangle {
            id: location_area

            anchors {
                left: parent.left
                top: location_title.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height
            color: "#fff"
            radius: 10

            Rectangle {
                id: location_item

                anchors {
                    top: parent.top
                }

                width: parent.width
                height: parent.height
                color: "transparent"

                Text {
                    id: slince_title
                    anchors {
                        left: parent.left
                        leftMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }
                    width: 331
                    height: 17
                    text: i18n("Location Status")
                    // font.pointSize: appFontSize + 2
                    font.pixelSize: fontNormal

                }

                Kirigami.JSwitch {
                    id: slince_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    checked: isMuted
                    onCheckedChanged: {
                        switchLocation(value)
                    }
                }

            }

         }

    
    }
}
