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
import jingos.keyboard 1.0
import jingos.display 1.0

Rectangle {
    id: storage_root

    property real appScale: JDisplay.dp(1.0)
    property real appFontSize: JDisplay.sp(1.0)
    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale
    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale
    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36  * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale
    property int radiusCommon: 10  * appScale
    property int fontNormal: 14 *appFontSize

    KeyboardModel {
        id: keyboardModel
    }

    function switchVKAO(status){
        keyboardModel.setVitualKeyboardStatus(status)
    }

    Component.onCompleted:{
        vkao_switch.checked = keyboardModel.getVitualKeyboardStatus()
    }

    Rectangle {
        anchors.fill: parent

        color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"

        Text {
            id: location_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }
            width: 329 * appScale
            height: 14 * appScale
            text: i18n("Keyboard")
            font.pixelSize: 20 * appFontSize
            font.weight: Font.Bold
            color: Kirigami.JTheme.majorForeground
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
            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: 10 * appScale

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
                    width: 331 * appScale
                    text: i18n("Always use virtual keyboard")
                    font.pixelSize: fontNormal
                    color: Kirigami.JTheme.majorForeground

                }

                Kirigami.JSwitch {
                    id: vkao_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    onCheckedChanged: {
                        switchVKAO(checked)
                    }
                }

            }

         }


    }
}
