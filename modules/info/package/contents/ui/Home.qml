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

    property real appScale: 1.3 * parent.width / (1920 * 0.7)
    property int appFontSize: theme.defaultFont.pointSize
    property bool hasNewVersion: false

    width: parent.width
    height: parent.height

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
                leftMargin: 72 * appScale
                topMargin: 68 * appScale
            }

            width: 500
            height: 50
            text: i18n("System & Update")
            font.pointSize: appFontSize + 11
            font.weight: Font.Bold
        }

        Rectangle {
            id: info_top

            anchors {
                left: parent.left
                top: info_title.bottom
                leftMargin: 72 * appScale
                topMargin: 42 * appScale
            }

            width: parent.width - 144 * appScale
            height: 138 * appScale
            color: "#fff"
            radius: 15 * appScale

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
                leftMargin: 72 * appScale
                topMargin: 36 * appScale
            }

            width: parent.width - 144 * appScale
            height: 69 * appScale
            color: "#fff"
            radius: 15 * appScale

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
                leftMargin: 72 * appScale
                topMargin: 36 * appScale
            }

            width: parent.width - 144 * appScale
            height: 69 * appScale
            visible: false
            color: "#fff"
            radius: 15 * appScale

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
