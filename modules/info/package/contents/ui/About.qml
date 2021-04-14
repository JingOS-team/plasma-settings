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

    property real appScale: system_info_root.appScale
    property int appFontSize: system_info_root.appFontSize
    property double storageTotal: 0
    property string storageTotalValue: ""

    width: parent.width
    height: parent.height

    UpdateTool {
        id: updateTool
    }

    Component.onCompleted :{
        storageTotal = updateTool.getStorageTotalSize()
        storageTotalValue = (storageTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: 34 * system_info_root.appScale
                topMargin: 68 * system_info_root.appScale
            }

            width: 400
            height: 41 * appScale
            color: "transparent"

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: 34 * appScale
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
                    leftMargin: 9 * appScale
                }

                width: 500
                height: 50

                text: i18n("About")
                font.pointSize: appFontSize + 11
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }
        }

        Image {
            id: system_logo

            anchors {
                top: page_statusbar.bottom
                topMargin: 36 * appScale
                horizontalCenter: parent.horizontalCenter
            }

            width: 152 * appScale
            height: 152 * appScale
            Layout.alignment: Qt.AlignHCenter
            source: "../image/jingos_logo.png"
        }

        Rectangle {

            anchors {
                left: parent.left
                right: parent.right
                top: system_logo.bottom
                leftMargin: 72 * system_info_root.appScale
                rightMargin: 72 * system_info_root.appScale
                topMargin: 47 * system_info_root.appScale
            }

            width: 923 * appScale
            height: 69 * 7 * appScale
            radius: 15 * appScale
            
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
                mContent: "0.8.0" //kcm.softwareInfo.frameworksVersion
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
                mContent: ""
                withArrow: false
                withContent: true
                withSeparator: true
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
    }
}
