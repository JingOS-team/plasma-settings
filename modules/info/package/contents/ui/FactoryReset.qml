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

Item {
    id: display_sub

    property real appScale: 1.3 * parent.width / (1920)
    property int appFontSize: theme.defaultFont.pointSize

    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent

        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            width: 400 * appScale

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 34 * system_info_root.appScale
                topMargin: 47 * system_info_root.appScale
            }

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
                text: i18n("Factory Reset")
                font.pointSize: appFontSize + 11
                font.weight: Font.Bold
            }
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                top: page_statusbar.bottom
                leftMargin: 72 * system_info_root.appScale
                rightMargin: 72 * system_info_root.appScale
                topMargin: 47 * system_info_root.appScale
            }

            height: 200
            radius: 15 * appScale
        }
    }
}
