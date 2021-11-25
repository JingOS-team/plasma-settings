// -*- coding: iso-8859-1 -*-
/*
 *   Copyright 2011 Sebastian Kügler <sebas@kde.org>
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

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.3 as Controls

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.kde.timesettings 1.0
import org.jingos.settings.time 1.0


Item {
    id: time_root

    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale

    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36 * appScale
    property int marginLeftAndRight : 20 * appScale
    property int marginItem2Top : 24 * appScale
    property int radiusCommon: 10  * appScale
    property int fontNormal: 14 * appFontSize

    property string currentTime : Qt.formatTime(kcm.currentTime, Locale.ShortFormat)
    property bool isShown : true
    property bool isAutoTimeZone : false
    property bool hasPermission: false
    property bool isFirstTime : true
    width: screenWidth * 0.7
    height: screenHeight

    onVisibleChanged: {
        isShown = visible
    }

    TimeTool {
        id: timeTool1

        onDlgConfirm : {
            time_auto_switch.checked = kcm.useNtp
            hasPermission = true

            isAutoTimeZone = kcm.useNtp
            if(!isAutoTimeZone){
                kcm.ntpServer = ""
                kcm.saveTime()
            }
        }

        onDlgCancel : {
            hasPermission = false
        }
    }

    Component.onCompleted: {
        isAutoTimeZone = kcm.useNtp
        time_auto_switch.checked = isAutoTimeZone
    }

    Rectangle {
        anchors.fill:parent
        color: Kirigami.JTheme.settingMinorBackground

        Text {
            id: title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }
            width: 329 * appScale
            height: 14 * appScale

            text: i18n("Date & Time")
            font.pixelSize: 20 * appFontSize
            font.weight: Font.Bold
            color: Kirigami.JTheme.majorForeground
        }

        Rectangle {
            id: time_format_area

            anchors {
                left: parent.left
                top: title.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }
            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height

            color: Kirigami.JTheme.cardBackground
            radius: 10 * appScale

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("24-Hour Time")
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.majorForeground
            }

            Kirigami.JSwitch {
                id: time_format_switch

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                checked: kcm.twentyFour
                onCheckedChanged: {
                    kcm.twentyFour = checked
                    print(kcm.timeZone);
                }
            }
        }

        Rectangle {
            id: time_settings_area

            anchors {
                left: parent.left
                top: time_format_area.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }
            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height * 2
            radius: 10 * appScale

            color: Kirigami.JTheme.cardBackground
            Rectangle {
                id: time_auto_area

                anchors {
                    left: parent.left
                    top : parent.top
                }
                width: parent.width
                height: default_setting_item_height

                color: "transparent"
                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }
                    text: i18n("Set Automatically")
                    font.pixelSize: fontNormal
                    color: Kirigami.JTheme.majorForeground
                }

                Kirigami.JSwitch {
                    id: time_auto_switch

                    property bool isSetting: false

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }

                    MouseArea {
                        anchors.fill :parent
                        onClicked: {
                            if(time_auto_switch.isSetting){
                                return
                            }
                            time_auto_switch.isSetting = true
                            kcm.useNtp = !kcm.useNtp

                            time_auto_switch.checked = kcm.useNtp
                            isAutoTimeZone = kcm.useNtp
                            if(!isAutoTimeZone){
                                kcm.ntpServer = ""
                                kcm.saveTime()
                            }
                            time_auto_switch.isSetting = false
                        }
                    }
                }

                Kirigami.JMenuSeparator {
                    width: parent.width
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: marginLeftAndRight
                    anchors.rightMargin: marginLeftAndRight
                }
            }

            Rectangle {
                id: time_zonearea

                anchors {
                    left: parent.left
                    top: time_auto_area.bottom
                }

                width: parent.width
                height: default_setting_item_height
                color: "transparent"

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Time Zone")
                    font.pixelSize: fontNormal
                    color: kcm.useNtp ? Kirigami.JTheme.minorForeground : Kirigami.JTheme.majorForeground
                }

               Kirigami.JIconButton {
                    id: item_arrow

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    width: 30 * appScale
                    height: 30 * appScale

                    source: Qt.resolvedUrl("../image/icon_right.png")
                    color: Kirigami.JTheme.iconMinorForeground
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: item_arrow.left
                        leftMargin: 9 * appScale
                    }
                    color:kcm.useNtp ? Kirigami.JTheme.disableForeground : Kirigami.JTheme.minorForeground
                    text: kcm.timeZone
                    font.pixelSize: fontNormal
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:{
                        if(kcm.useNtp){
                          return
                        }
                        main.gotoPage("timezone_view")
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: marginLeftAndRight
                    anchors.rightMargin: marginLeftAndRight
                    height: 1

                    color: "#00f0f0f0"
                }
            }

            Rectangle {
                id: time_date_area
                visible:false

                anchors {
                    left: parent.left
                    top: time_zonearea.bottom
                }

                width: parent.width
                height: default_setting_item_height
                color: "transparent"

                Text {
                    id: date_txt

                    width: 312  * appScale
                    height: 17 * appScale
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter

                    font.pixelSize :17 * appFontSize
                    text: Qt.formatDate(kcm.currentDate, Locale.ShortFormat)
                    color: "#FF3C4BE8"

                    MouseArea {
                        anchors.fill:parent
                        onClicked:{
                        }
                    }
                }

                Text {
                    id: time_txt

                    width: 312  * appScale
                    height: 17 * appScale
                    anchors.right: parent.right
                    anchors.rightMargin: marginLeftAndRight
                    anchors.verticalCenter:parent.verticalCenter
                    horizontalAlignment: Text.AlignRight

                    font.pixelSize: fontNormal
                    text: currentTime
                    color: "#FF3C4BE8"

                     MouseArea {
                        anchors.fill:parent
                        onClicked:{
                            popupEventEditor.open()
                        }
                    }
                }
            }
        }
    }
}