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

    // width: screenWidth * 0.7
    // height: screenHeight

    Rectangle {
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
                text: i18n("Legal Information")
                // font.pointSize: appFontSize + 11
                font.pixelSize: 20
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
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

            height: legal_content.height + 50 
            radius: 10
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
                font.pixelSize: 16
                maximumLineCount: 10
                text: i18n("Legal Notices:\nCopyright @ 2020 Jingling Inc. All rights reserved. \nJingling, the Jingling logo, Jing Pad, other cache objects have configurable update settings, and their update frequency is set by the Document Manager administrator. The objects with configurable update settings are controlled vocabulary lists ( CVLs), library property definitions, library property values lists, native folder lists, and user and group lists.If you issue a ROLLBACK after invoking these procedures, policy settings will not be updated. ")
            }
        }
    }
}
/*
Rectangle {
    id: page_statusbar

    anchors {
        left: parent.left
        top: parent.top
        leftMargin: 34 * appScale
        topMargin: 68 * appScale
    }

    width: parent.width
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
                popView()
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
        text: i18n("Legal Information")
        font.pointSize: appFontSize + 11
        font.weight: Font.Bold
        verticalAlignment: Text.AlignVCenter
    }
}
*/