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
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.10
import jingos.storage 1.0

import "./StringUtils.js" as StringUtils

Rectangle {
    id: storage_root

    property int screenWidth: 888
    property int screenHeight: 648
    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45
    property int marginTitle2Top : 44 
    property int marginItem2Title : 18 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 

    property string storageName: "Storage space:"
    property string storageType: ""
    property double storageTotal: 0
    property string storageTotalValue: ""
    property double storageAvailable: 0
    property string storageAvailableValue: ""

    width: screenWidth * 0.7
    height: screenHeight

    Component.onCompleted: {
        storageName = sm.getStorageName()
        storageType = sm.getStorageType()
        storageTotal = sm.getStorageTotalSize()
        storageTotalValue = (storageTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
        storageAvailable = sm.getStorageAvailableSize()
        storageAvailableValue = ((storageTotal - storageAvailable) / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
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

        color: "#FFF6F9FF"

        Text {
            id: storage_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight  
                topMargin: marginTitle2Top  
            }

            width: 329
            height: 14
            text: i18n("Storage")
            font.pixelSize: 20 
            font.weight: Font.Bold
        }

        Rectangle {
            id: storage1_area

            anchors {
                top: storage_title.bottom
                left: parent.left
                topMargin: 36  
                leftMargin: marginLeftAndRight  
                right: parent.right
                rightMargin: marginLeftAndRight  
            }
            height: 90
            color: "#fff"
            radius: 10

            Rectangle {
                id: s1_top

                width: parent.width
                height: 45
                radius: 10

                Text {
                    id: auto_title

                    anchors {
                        left: parent.left
                        leftMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    width: 331
                    height: 17
                    text: storageName
                    font.pixelSize: 17
                }

                Text {
                    id: auto_value

                    anchors {
                        right: parent.right
                        rightMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    height: 17
                    text: i18n("%1 of %2 Used" , storageAvailableValue , storageTotalValue)
                    color: "#993C3C43"
                    font.pixelSize: 17
                }
            }

            JProgress {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    top: s1_top.bottom
                    topMargin: 3
                }

                height: 18
                totalValue: 100
                usedPower: (1 - (storageAvailable / storageTotal).toFixed(2)) * 100
            }
        }

        Rectangle {
            anchors {
                top: storage1_area.bottom
                left: parent.left
                topMargin: 36  
                leftMargin: marginLeftAndRight  
                right: parent.right
                rightMargin: marginLeftAndRight  
            }

             ListView {
                id: device_list

                width: parent.width
                height: storage_root.height - 200
                model: sm.subPixelOptionsModel


                delegate: Rectangle {
                    width:parent.width
                    height: 90
                    color: "#fff"
                    radius: 10

                    Rectangle {
                        id: s2_top
                        width: parent.width
                        height: 45
                        radius: 10

                        Text {
                            id: auto_title

                            anchors {
                                left: parent.left
                                leftMargin: marginLeftAndRight
                                verticalCenter: parent.verticalCenter
                            }

                            width: 331
                            height: 17
                            text: getStorageDeviceName(display)
                            font.pixelSize: 17
                        }

                        Text {
                            id: auto_value2

                            anchors {
                                right: parent.right
                                rightMargin: marginLeftAndRight
                                verticalCenter: parent.verticalCenter
                            }

                            height: 17
                            text: i18n("%1 of %2 Used" , getStorageDeviceAvail(display), getStorageDeviceTotal(display))
                            color: "#993C3C43"
                            font.pixelSize: 17
                        }
                    }

                    JProgress {
                        anchors {
                            left: parent.left
                            right: parent.right
                            leftMargin: marginLeftAndRight
                            rightMargin: marginLeftAndRight
                            top: s2_top.bottom
                            topMargin: 3
                        }

                        height: 18
                        totalValue: 100
                        usedPower: (1 - Number(getStorageDeviceFree(display)))* 100 
                    }
                }
            }
        }
    }
}
