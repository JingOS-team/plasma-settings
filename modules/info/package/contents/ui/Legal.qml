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

    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property real appScale: 1.3 * screenWidth / 1920
    property int appFontSize: theme.defaultFont.pointSize

    width: parent.width
    height: parent.height

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

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

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                top: page_statusbar.bottom
                leftMargin: 72 * appScale
                rightMargin: 72 * appScale
                topMargin: 47 * appScale
            }

            height: legal_content.height + 50 * appScale
            radius: 15 * appScale

            Text {
                id: legal_content
                
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    leftMargin: 25 * appScale
                    rightMargin: 25 * appScale
                    topMargin: 25 * appScale
                    bottomMargin: 25 * appScale
                }

                width: parent.width - 50 * appScale
                wrapMode: Text.WordWrap
                font.pointSize: appFontSize + 6
                maximumLineCount: 10
                text: i18n("Legal Notices:\nCopyright @ 2020 Jingling Inc. All rights reserved. \nJingling, the Jingling logo, Jing Pad, other cache objects have configurable update settings, and their update frequency is set by the Document Manager administrator. The objects with configurable update settings are controlled vocabulary lists ( CVLs), library property definitions, library property values lists, native folder lists, and user and group lists.If you issue a ROLLBACK after invoking these procedures, policy settings will not be updated. ")
            }
        }
    }
}
