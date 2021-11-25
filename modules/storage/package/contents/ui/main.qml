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
import jingos.storage 1.0

import "./StringUtils.js" as StringUtils
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
    property int marginItem2Title : 18  * appScale
    property int marginLeftAndRight : 20 * appScale
    property int marginItem2Top : 24  * appScale

    property string storageName: "Storage space:"
    property string homeName: ""
    property string storageType: ""
    property double storageTotal: 0
    property string storageTotalValue: ""
    property double storageAvailable: 0
    property string storageAvailableValue: ""

    property double homeTotal: 0
    property string homeTotalValue: ""
    property double homeAvailable: 0
    property string homeAvailableValue: ""

    property string totalAllSize: ""

    width: screenWidth * 0.7
    height: screenHeight

    Component.onCompleted: {
        // storageName = sm.getStorageName()
        storageName = i18n("System Storage")
        homeName = i18n("User Storage")
        storageType = sm.getStorageType()
        storageTotal = sm.getStorageTotalSize()
        storageTotalValue = (storageTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
        storageAvailable = sm.getStorageAvailableSize()
        storageAvailableValue = ((storageTotal - storageAvailable) / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"

        homeTotal = sm.getHomeTotalSize()
        homeTotalValue = (homeTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
        homeAvailable = sm.getHomeAvailableSize()
        homeAvailableValue = ((homeTotal - homeAvailable) / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"





        var storage = (homeTotal+storageTotal ) / 1000 / 1000 / 1000;
        storage = parseInt(storage);
        console.log("about storage is " + storage);
        if(storage <= 0){
            storage = 0;
        } else if(storage <= 8){
            storage = 8
        } else if(storage <= 16){
            storage = 16
        } else if(storage <= 32){
            storage = 32
        } else if(storage <= 64){
            storage = 64
        } else if(storage <= 128){
            storage = 128
        } else if(storage <= 256){
            storage = 256
        } else if(storage <= 512){
            storage = 512
        } else if(storage <= 1024){
            storage = 1024
        }

        totalAllSize = storage + "GB";
//        totalAllSize = ((homeTotal+storageTotal ) / 1000 / 1000 / 1000).toFixed(
//                    1) + "GB"

        console.log("storageName: ", storageName)
        if (storageName == "") {
            storageName = i18n("Storage Info")
        }
        console.log("storageType: ", storageType)
        console.log("storageTotal: ", storageTotal)
        console.log("storageAvailable: ", storageAvailable)
    }

    StorageModel {
        id: sm

        onRefreshListView :{
            device_list.model = null
            device_list.model = sm.subPixelOptionsModel
        }
    }

    function getStorageDeviceName(display){
        var b = StringUtils.splitString(display , ",");
        console.log("getStorageDeviceName:" , b[0])
        console.log("[wupengbo][settings-main][storage] getStorageDeviceName:" , display)
        return b[0]
    }

    function getStorageDeviceTotal(display){
        var b = StringUtils.splitString(display , ",");
        console.log("getStorageDeviceName:" , b[1])
        return b[1]
    }

    function getStorageDeviceAvail(display){
        var b = StringUtils.splitString(display , ",");
        console.log("getStorageDeviceName:" , b[2])
        return b[2]
    }

    function getStorageDeviceFree(display){
        var b = StringUtils.splitString(display , ",");
        console.log("getStorageDeviceFree:" , b[3])
        return b[3]
    }

    Rectangle {
        anchors.fill: parent

        color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"

        Text {
            id: storage_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }

            width: 329 * appScale
            height: 14 * appScale
            text: i18n("Storage")
            font.pixelSize: 20 *appFontSize
            font.weight: Font.Bold
            color: Kirigami.JTheme.majorForeground
        }

        Rectangle {
            id: storage1_area

            anchors {
                top: storage_title.bottom
                left: parent.left
                topMargin: 36   * appScale
                leftMargin: marginLeftAndRight
                right: parent.right
                rightMargin: marginLeftAndRight
            }
            height: (180 + 31)* appScale
            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: 10 * appScale

            Rectangle {
                id: storage_all
                width:parent.width
                height: 31 * appScale
                radius: 10 * appScale
                color: "transparent"

                Text {
                    anchors {
                        verticalCenter : parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }
                    text:i18n("Storage %1" , totalAllSize)
                    font.pixelSize: 12 * appFontSize
                    color: Kirigami.JTheme.minorForeground
                    horizontalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                id: s1_top

                anchors.top : storage_all.bottom
                width: parent.width
                height: 45 * appScale
                radius: 10 * appScale
                color: "transparent"

                Text {
                    id: auto_title

                    anchors {
                        left: parent.left
                        leftMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    width: 331 * appScale
                    height: 17 * appScale
                    text: homeName
                    font.pixelSize: 17 * appFontSize
                    color: Kirigami.JTheme.majorForeground
                }

                Text {
                    id: auto_value

                    anchors {
                        right: parent.right
                        rightMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    height: 17 * appScale

                     text: i18n("%1 of %2 Used" , homeAvailableValue , homeTotalValue)
                    color: Kirigami.JTheme.minorForeground//"#993C3C43"
                    font.pixelSize: 17 *appFontSize
                }
            }

            JProgress {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    top: s1_top.bottom
                    topMargin: 3 * appScale
                }

                height: 18 * appScale
                totalValue: 100
                usedPower: (1 - (homeAvailable / homeTotal).toFixed(2)) * 100
            }

            Rectangle {
                id: s2_top

                anchors.top : parent.top
                anchors.topMargin : (90 + 31)* appScale
                width: parent.width
                height: 45 * appScale
                radius: 10 * appScale
                color: "transparent"

                Text {
                    id: auto_title2

                    anchors {
                        left: parent.left
                        leftMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    width: 331 * appScale
                    height: 17 * appScale
                    text: storageName
                    font.pixelSize: 17 * appFontSize
                    color: Kirigami.JTheme.majorForeground
                }

                Text {
                    id: auto_value2

                    anchors {
                        right: parent.right
                        rightMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    height: 17 * appScale
                    text: i18n("%1 of %2 Used" , storageAvailableValue , storageTotalValue)
                    color: Kirigami.JTheme.minorForeground//"#993C3C43"
                    font.pixelSize: 17 *appFontSize
                }
            }

            JProgress {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    top: s2_top.bottom
                    topMargin: 3 * appScale
                }

                height: 18 * appScale
                totalValue: 100
                progressColor: "#8C000000"
                usedPower: (1 - (storageAvailable / storageTotal).toFixed(2)) * 100
            }
        }

        Rectangle {
            anchors {
                top: storage1_area.bottom
                left: parent.left
                topMargin: 36 * appScale
                leftMargin: marginLeftAndRight
                right: parent.right
                rightMargin: marginLeftAndRight
            }

             ListView {
                id: device_list

                width: parent.width
                height: storage_root.height - 200 * appScale
                model: sm.subPixelOptionsModel
                spacing: 36 * appScale

                delegate: Rectangle {
                    width:parent.width
                    height: 90 * appScale
                    color: Kirigami.JTheme.cardBackground//"#fff"
                    radius: 10 * appScale

                    Rectangle {
                        id: s2_top
                        width: parent.width
                        height: 45 * appScale
                        radius: 10 * appScale
                        color: "transparent"

                        Text {
                            id: auto_title

                            anchors {
                                left: parent.left
                                leftMargin: marginLeftAndRight
                                verticalCenter: parent.verticalCenter
                            }

                            width: 331 * appScale
                            height: 17 * appScale
                            text: getStorageDeviceName(display)
                            font.pixelSize: 17 *appFontSize
                            color: Kirigami.JTheme.majorForeground
                        }

                        Text {
                            id: auto_value2

                            anchors {
                                right: parent.right
                                rightMargin: marginLeftAndRight
                                verticalCenter: parent.verticalCenter
                            }

                            height: 17 * appScale
                            text: i18n("%1 of %2 Used" , getStorageDeviceAvail(display), getStorageDeviceTotal(display))
                            color: Kirigami.JTheme.minorForeground//"#993C3C43"
                            font.pixelSize: 17 * appFontSize
                        }
                    }

                    JProgress {
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: marginLeftAndRight
                            rightMargin: marginLeftAndRight
                            top: s2_top.bottom
                            topMargin: 3 * appScale
                        }

                        height: 18 * appScale
                        totalValue: 100
                        usedPower: (1 - Number(getStorageDeviceFree(display)))* 100
                    }
                }
            }
        }
    }
}
