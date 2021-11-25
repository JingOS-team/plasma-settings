/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.jingos.info 1.0
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Item {
    id: display_sub

    property double storageTotal: 0
    property string storageTotalValue: ""
    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale

    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 18  * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale
    
    property var currentIpAddress
    property var currentHardwareAddress

    // width: screenWidth * 0.7
    // height: screenHeight
    

    PlasmaNM.KcmIdentityModel {
        id: connectionModel
    }

    PlasmaNM.EditorProxyModel {
        id: editorProxyModel

        sourceModel: connectionModel
    }

    Repeater{
        model:editorProxyModel

        Item{
            visible:false
            Component.onCompleted:{
                if(model.ConnectionState == PlasmaNM.Enums.Activated){
                    currentIpAddress = model.IpAddress
                    currentHardwareAddress = model.HardwareAddress
                }
            }
        }
    }

    UpdateTool {
        id: updateTool
    }

    Component.onCompleted :{
        storageTotal = updateTool.getStorageTotalSize()
        //deviceName = updateTool.getLocalDeviceName()
        storageTotalValue = (storageTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
    }

    Rectangle {
        id: info_parent
        width: parent.width
        height: parent.height
        color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: statusbar_height
            color: "transparent"

            Kirigami.JIconButton {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: (22 + 8) * appScale
                height: width
                source: "qrc:/image/icon_left.png"
                // sourceSize.width: width
                // sourceSize.height: width
                color: Kirigami.JTheme.majorForeground
                onClicked : {
                    system_info_root.popView()
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 
                }

                width: 359 * appScale
                height: 14 * appScale
                text: i18n("Status")
                // font.pointSize: appFontSize + 11
                font.pixelSize: 20  * appFontSize
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                color: Kirigami.JTheme.majorForeground
            }
        }


        Rectangle {

            anchors {
                left: parent.left
                right: parent.right
                top: page_statusbar.bottom
                leftMargin: marginLeftAndRight
                rightMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight * 2
            height: (default_setting_item_height + 1) * 5
            radius: 10  * appScale
            color: Kirigami.JTheme.cardBackground
            
            SettingsItem {
                id: network

                mTitle: i18n("Network")
                mContent: editorProxyModel.currentConnectedName
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: ip_address

                anchors.top: network.bottom

                mTitle: i18n("IP Address")
                mContent: currentIpAddress
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: wlan_address

                anchors.top: ip_address.bottom

                mTitle: i18n("WLAN Address")
                mContent: currentHardwareAddress
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: imei

                anchors.top: wlan_address.bottom

                mTitle: i18n("IMEI")
                withArrow: false
                withContent: true
                withSeparator: true
                mContent: kcm.getDeviceIMEI()
            }

            SettingsItem {
                id: bt_address

                anchors.top: imei.bottom

                mTitle: i18n("Bluetooth Address")
                withArrow: false
                withContent: true
                withSeparator: false 
                mContent: kcm.getLocalDeviceAdress()
            }
        }
    }
}
