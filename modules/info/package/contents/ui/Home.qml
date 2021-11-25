/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
 */
import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.jingos.info 1.0

Item {
    id: info_root

    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale

    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36 * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale
    property bool hasNewVersion: false
    property int rootHas: rootHasNewVersion
    property bool hasUpdating: system_info_root.rootHasupdating

    width: screenWidth * 0.7
    height: screenHeight

    UpdateTool {
        id: updateTool

        onUpdatingChanged: {
            info_root.reflashVersion();
        }
    }

    function reflashVersion() {
        hasNewVersion = updateTool.hasNewVersion()
    }

    onRootHasChanged:{
        hasNewVersion = updateTool.hasNewVersion()
    }

    Component.onCompleted: {
        hasNewVersion = updateTool.hasNewVersion()
    }

    Rectangle {
        width: parent.width
        height: parent.height

        color: Kirigami.JTheme.settingMinorBackground

        onVisibleChanged: {
            if (visible) {
                hasNewVersion = updateTool.hasNewVersion()
            }
        }

        Text {
            id: info_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }

            width: 329 * appScale
            height: 14 * appScale
            text: i18n("System & Update")
            font.pixelSize: 20 * appFontSize
            font.weight: Font.Bold
            color: Kirigami.JTheme.majorForeground
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
            color: Kirigami.JTheme.cardBackground
            radius: 10 * appScale

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

                mTitle: i18n("Software Update")
                withSeparator: false
                withNew: hasNewVersion
                updating: hasUpdating
                updateMode: true
                mContent: i18n("Updating...")
                withContent: hasUpdating ? true : false

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
            color: Kirigami.JTheme.cardBackground
            radius: 10 * appScale

            SettingsItem {
                id: item_legal

                mTitle: i18n("Legal Information")
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
            color: Kirigami.JTheme.cardBackground
            radius: 10 * appScale

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
