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

Item {
    id: display_sub

    property double storageTotal: 0
    property string storageTotalValue: ""
    property int screenWidth: 888
    property int screenHeight: 648
    property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 18 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property string deviceName : kcm.localDeviceName

    UpdateTool {
        id: updateTool
    }

    Connections {
        target: kcm
        onLocalDeviceNameChanged: {
            deviceName = localDeviceName 
        }
    }

    Component.onCompleted :{
        storageTotal = updateTool.getStorageTotalSize()
        storageTotalValue = (storageTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
    }

    Rectangle {
        id: info_parent
        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

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

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: statusbar_icon_size
                height: width
                source: "../image/icon_left.png"
                sourceSize.width: width
                sourceSize.height: width

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        system_info_root.popView()
                    }
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 
                }

                width: 359
                height: 14
                text: i18n("About")
                font.pixelSize: 20
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }
        }

        Image {
            id: system_logo

            anchors {
                top: page_statusbar.bottom
                topMargin: 35
                horizontalCenter: parent.horizontalCenter
            }

            width: 60
            height: 60
            Layout.alignment: Qt.AlignHCenter
            source: "../image/jingos_logo_update.svg"
        }

        Rectangle {
            id: device_name_area
            height: 22
            width: childrenRect.width
            color:"transparent"

            anchors {
                horizontalCenter: info_parent.horizontalCenter
                top: system_logo.bottom
                topMargin: marginItem2Title
            }

            Text {
                id: device_name_txt
                font.pixelSize: 20
                color: "black"
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter:parent.verticalCenter
                anchors.left:parent.left 
                text: deviceName
            }

            Image {
                id:device_name_icon
                anchors{
                    left: device_name_txt.right
                    leftMargin: 12
                    verticalCenter: parent.verticalCenter
                }

                width : 22
                height : 22
                sourceSize.width : 22
                sourceSize.height : 22
                source: "../image/device_name_modify.svg"

                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        editDialog.open()
                    }
                }
            }
        }

        Rectangle {

            anchors {
                left: parent.left
                right: parent.right
                top: device_name_area.bottom
                leftMargin: marginLeftAndRight
                rightMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height * 7
            radius: 10 
            
            SettingsItem {
                id: model_name

                mTitle: i18n("Model Name")
                mContent: kcm.distroInfo.name
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: software_version

                anchors.top: model_name.bottom

                mTitle: i18n("Software Version")
                mContent: updateTool.readLocalVersion()
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: processor

                anchors.top: software_version.bottom

                mTitle: i18n("Processor")
                mContent: kcm.hardwareInfo.processors
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: ram

                anchors.top: processor.bottom

                mTitle: i18n("RAM")
                withArrow: false
                withContent: true
                withSeparator: true
                mContent: {
                    if (kcm.hardwareInfo.memory !== "0 B") {
                        return i18nc("@label %1 is the formatted amount of system memory (e.g. 7,7 GiB)",
                                     "%1 of RAM", kcm.hardwareInfo.memory)
                    } else {
                        return i18nc("Unknown amount of RAM", "Unknown")
                    }
                }
            }

            SettingsItem {
                id: internal_storage

                anchors.top: ram.bottom

                mTitle: i18n("Internal Storage")
                mContent: storageTotalValue
                withArrow: false 
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: kernel_version

                anchors.top: internal_storage.bottom

                mTitle: i18n("Kernel Version")
                mContent: kcm.softwareInfo.kernelRelease
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: serial_number

                anchors.top: kernel_version.bottom

                mTitle: i18n("Serial Number")
                mContent: kcm.softwareInfo.frameworksVersion
                withArrow: false
                withContent: true
                withSeparator: false
            }

      /*       SettingsItem {
                id: status

                anchors.top: serial_number.bottom
                
                mTitle: i18n("Status")
                withArrow: true
                withContent: false
                withSeparator: false
            } */
        }

        Kirigami.JDialog {
            id: editDialog

            title:i18n("Device Name")
            text: i18n("Other devices will see this name when you use Bluetooth,WLAN Direct,Personal hotspot and USB.")
            inputEnable: true
            showPassword: false
            leftButtonText: i18n("Cancel")
            rightButtonText: i18n("Ok")
            onRightButtonClicked: {
                if(editDialog.inputText.length != 0){
                    kcm.setLocalDeviceName(editDialog.inputText)
                }
                editDialog.visible = false
            }
            onLeftButtonClicked: {
                editDialog.visible = false
            }
        }
    }
}
