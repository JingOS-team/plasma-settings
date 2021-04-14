/*
 * Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2

Rectangle {
    id: settings_item_root

    property alias mTitle: item_title.text
    property alias withSeparator: my_separator.visible
    property alias mContent: item_content.text
    property bool withContent: false
    property bool withArrow: true
    property bool withNew: false


    width: parent.width
    height: 69 * system_info_root.appScale
    color: "transparent"

    signal itemClicked

    MouseArea {
        anchors.fill: parent

        onClicked: {
            itemClicked()
        }
    }

    Text {
        id: item_title

        anchors {
            left: parent.left
            leftMargin: 31 * system_info_root.appScale
            verticalCenter: parent.verticalCenter
        }

        width: 331 * appScale
        height: 26 * appScale

        font.pointSize: system_info_root.appFontSize + 2
    }

    Text {
        id: item_content

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 34 * appScale
        }

        visible: withContent
        text: mContent
        color: "#99000000"
        font.pointSize: appFontSize + 2
    }

    Image {
        id: item_new

        anchors {
            verticalCenter: parent.verticalCenter
            right: item_arrow.right
            rightMargin: 34 * appScale
        }

        sourceSize.width: 25 * system_info_root.appScale
        sourceSize.height: 25 * system_info_root.appScale

        visible: withNew
        source: "../image/new.png"
    }

    Image {
        id: item_arrow

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 34 * appScale
        }

        sourceSize.width: 25 * system_info_root.appScale
        sourceSize.height: 25 * system_info_root.appScale

        visible: withArrow
        source: "../image/icon_right.png"
    }

    Kirigami.Separator {
        id: my_separator

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 31 * system_info_root.appScale
        anchors.rightMargin: 31 * system_info_root.appScale

        height: 1 * system_info_root.appScale
        color: "#f0f0f0"
    }
}
