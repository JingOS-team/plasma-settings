/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Rui Wang <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2

Item {
    id: legal_sub

    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale

    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 18  * appScale
    property int marginLeftAndRight : 14  * appScale
    property int marginItem2Top : 24  * appScale

    // width: screenWidth * 0.7
    // height: screenHeight

    Rectangle {
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
                source: Qt.resolvedUrl("../image/icon_left.png")
                color: Kirigami.JTheme.iconForeground
                // sourceSize.width: width
                // sourceSize.height: width
                onClicked: {
                    system_info_root.popView()
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9  * appScale
                }

                width: 359 * appScale
                height: 14 * appScale
                text: i18n("Legal Information")
                // font.pointSize: appFontSize + 11
                font.pixelSize: 20 * appFontSize
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

            height: legal_content.height + 50  * appScale
            radius: 10 * appScale
            color:"transparent"

            Text {
                id: legal_content
                
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    leftMargin: marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    topMargin: marginLeftAndRight
                    bottomMargin: marginLeftAndRight
                }

                width: parent.width - marginLeftAndRight * 2
                wrapMode: Text.WordWrap
                // font.pointSize: appFontSize + 6
                font.pixelSize: 16 * appFontSize
                lineHeight: 1.5
                maximumLineCount: 10
                color: Kirigami.JTheme.majorForeground
                text: i18nd("settings","Legal Notices:\nCopyright @ 2020 Jingling Inc. All rights reserved. \nJingling, the Jingling logo, Jing Pad, other cache objects have configurable update settings, and their update frequency is set by the Document Manager administrator. The objects with configurable update settings are controlled vocabulary lists ( CVLs), library property definitions, library property values lists, native folder lists, and user and group lists.If you issue a ROLLBACK after invoking these procedures, policy settings will not be updated. ")
            }
        }
    }
}
