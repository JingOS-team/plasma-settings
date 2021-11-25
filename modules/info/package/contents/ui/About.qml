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
import jingos.display 1.0

Item {
    id: display_sub

    property double storageTotal: 0
    property string storageTotalValue: ""

    property int statusbar_height : 30 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 18  * appScale
    property int marginLeftAndRight : 14  * appScale
    property int marginItem2Top : 24  * appScale

    property int ramMem: 0

    UpdateTool {
        id: updateTool
    }

    Component.onCompleted :{
        storageTotal = updateTool.getStorageTotalSize()
        var storage = storageTotal / 1000 / 1000 / 1000;
        storage = parseInt(storage);
        if(storage <= 0) {
            storage = 0;
        } else if (storage <= 8) {
            storage = 8
        } else if (storage <= 16) {
            storage = 16
        } else if (storage <= 32) {
            storage = 32
        } else if (storage <= 64) {
            storage = 64
        } else if (storage <= 128) {
            storage = 128
        } else if (storage <= 256) {
            storage = 256
        } else if (storage <= 512) {
            storage = 512
        } else if (storage <= 1024) {
            storage = 1024
        }

        storageTotalValue = storage + " GB";

        var intMem = parseInt(kcm.hardwareInfo.memory)
        intMem = intMem / 1000 / 1000 / 1000
        if (intMem <= 0) {
            intMem = 0;
        }
        ramMem = intMem;
    }

    Rectangle {
        id: info_parent

        width: parent.width
        height: parent.height
        color: Kirigami.JTheme.settingMinorBackground

        Item {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }
            width: parent.width - marginLeftAndRight * 2
            height: statusbar_height

            Kirigami.JIconButton {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: (22 + 8) * appScale
                height: width
                source: "qrc:/image/icon_left.png"
                color: Kirigami.JTheme.iconForeground
                onClicked: {
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
                verticalAlignment: Text.AlignVCenter
                width: 359 * appScale
                height: 14 * appScale

                text: i18n("About")
                font.pixelSize: 20 * appFontSize
                font.weight: Font.Bold
                color: Kirigami.JTheme.majorForeground
            }
        }

        Image {
            id: system_logo

            anchors {
                top: page_statusbar.bottom
                topMargin: 35 * appScale
                horizontalCenter: parent.horizontalCenter
            }
            width: JDisplay.dp(55)
            height: JDisplay.dp(60)
            Layout.alignment: Qt.AlignHCenter

            source: "../image/jingos_logo_update.svg"
        }

        Item {
            id: device_name_area

            height: 22 * appScale
            width: childrenRect.width
            anchors {
                horizontalCenter: info_parent.horizontalCenter
                top: system_logo.bottom
                topMargin: marginItem2Title
            }

            Text {
                id: device_name_txt

                font.pixelSize: 20 * appFontSize
                color: Kirigami.JTheme.majorForeground//"black"
                verticalAlignment: Text.AlignVCenter
                anchors.verticalCenter:parent.verticalCenter
                anchors.left:parent.left
                horizontalAlignment: Text.AlignRight

                text: deviceName.length > 12 ? (deviceName.substring(0,12) + "...") : deviceName
            }

            Kirigami.Icon {
                id: device_name_icon

                width : 22 * appScale
                height : 22 * appScale
                anchors{
                    left: device_name_txt.right
                    leftMargin: 12 * appScale
                    verticalCenter: parent.verticalCenter
                }

                source: "qrc:/image/device_name_modify.svg"
                color: Kirigami.JTheme.minorForeground

                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        editDialog.inputText = deviceName
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
            height: (default_setting_item_height + 1) * 6
            radius: 10  * appScale

            color: Kirigami.JTheme.cardBackground

            SettingsItem {
                id: model_name

                mTitle: i18n("Model Name")
                mContent: updateTool.readModelName()
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: software_version

                anchors.top: model_name.bottom

                mTitle: i18n("Software Version")
                mContent: kcm.distroInfo.name + " "+ updateTool.readLocalVersion()
                withArrow: false
                withContent: true
                withSeparator: true
            }

            SettingsItem {
                id: ram

                anchors.top: software_version.bottom

                mTitle: i18n("RAM")
                withArrow: false
                withContent: true
                withSeparator: true
                mContent: {
                    if(ramMem == 0){
                        return i18nc("Unknown amount of RAM", "Unknown")
                    } else {
                        return ramMem + " GB";
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

            // SettingsItem {
            //     id: serial_number

            //     anchors.top: kernel_version.bottom

            //     mTitle: i18n("Serial Number")
            //     mContent: kcm.softwareInfo.frameworksVersion
            //     withArrow: false
            //     withContent: true
            //     withSeparator: true
            // }

            SettingsItem {
                id: status

                anchors.top: kernel_version.bottom

                mTitle: i18n("Status")
                withArrow: true
                withContent: false
                withSeparator: false

                onItemClicked:{
                    system_info_root.gotoPage("status_view")
                }
            }
        }

        Kirigami.JDialog {
            id: editDialog

            title: i18n("Device Name")
            text: i18n("Other devices will see this name when you use Bluetooth and USB.")
            inputEnable: true
            showPassword: false
            leftButtonText: i18n("Cancel")
            rightButtonText: i18n("OK")
            onRightButtonClicked: {
                if (!rightButtonEnable) {
                    return;
                }
                if (editDialog.inputText.length != 0) {
                    kcm.setLocalDeviceName(editDialog.inputText)
                }
                editDialog.visible = false
            }
            onLeftButtonClicked: {
                editDialog.visible = false
                editDialog.InputText = ""
            }
            onInputTextChanged: {
                if (inputText.length > 32) {
                    editDialog.inputText = inputText.substring(0,32)
                }
                if (inputText.length < 1) {
                    rightButtonEnable = false
                } else {
                    rightButtonEnable = true
                }
            }

        }
    }
}
