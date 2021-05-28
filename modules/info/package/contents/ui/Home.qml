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
    id: info_root

    property int screenWidth: 888
    property int screenHeight: 648
    property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property bool hasNewVersion: false

    width: screenWidth * 0.7
    height: screenHeight

    UpdateTool {
        id: updateTool
    }

    Component.onCompleted: {
        hasNewVersion = updateTool.hasNewVersion()
    }

    Rectangle {
        width: parent.width
        height: parent.height

        color: "#FFF6F9FF"

        Text {
            id: info_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight  
                topMargin: marginTitle2Top  
            }

            width: 329
            height: 14
            text: i18n("System & Update")
            // font.pointSize: appFontSize + 11
            font.pixelSize: 20 
            font.weight: Font.Bold
        }

        Rectangle {
            id: info_top

            anchors {
                left: parent.left
                top: info_title.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height * 2
            color: "#fff"
            radius: 10

            SettingsItem {
                id: item_about

                mTitle: i18n("About")
                withSeparator: true

                onItemClicked: {
                    system_info_root.gotoPage("about_view")
                }
            }

            SettingsItem {
                id: item_update

                anchors.top: item_about.bottom

                mTitle: i18n("System Update")
                withSeparator: false
                withNew: hasNewVersion

                onItemClicked: {
                    system_info_root.gotoPage("update_view")
                }
            }
        }

        Rectangle {
            id: info_mid

            anchors {
                left: parent.left
                top: info_top.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height
            color: "#fff"
            radius: 10

            SettingsItem {
                id: item_legal

                mTitle: i18n("Legal information")
                withSeparator: false

                onItemClicked: {
                    system_info_root.gotoPage("legal_view")
                }
            }
        }

        Rectangle {
            id: info_bottom

            anchors {
                left: parent.left
                top: info_mid.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height
            visible: false
            color: "#fff"
            radius: 10

            SettingsItem {
                id: update_about

                mTitle: i18n("Factory Reset")
                withSeparator: false

                onItemClicked: {
                    system_info_root.gotoPage("reset_view")
                }
            }
        }
    }
}
