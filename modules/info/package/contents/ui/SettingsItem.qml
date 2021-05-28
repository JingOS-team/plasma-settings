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

    property int radiusCommon: 10 
    property int fontNormal: 14

    width: parent.width
    height: default_setting_item_height + 1
    color: "transparent"
    // color : "#aa00ff00"

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
            leftMargin: marginLeftAndRight
            verticalCenter: settings_item_root.verticalCenter
        }

        width: 331 
        height: 17

        // font.pointSize: system_info_root.appFontSize + 2
        font.pixelSize: fontNormal
    }

    Text {
        id: item_content

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: marginLeftAndRight
        }

        visible: withContent
        text: mContent
        color: "#99000000"
        // font.pointSize: appFontSize + 2
        font.pixelSize: fontNormal
    }

    Image {
        id: item_new

        anchors {
            verticalCenter: parent.verticalCenter
            right: item_arrow.right
            rightMargin: marginLeftAndRight
        }

        sourceSize.width: 17
        sourceSize.height: 17

        visible: withNew
        source: "../image/new.png"
    }

    Image {
        id: item_arrow

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: marginLeftAndRight
        }

        sourceSize.width: 17
        sourceSize.height: 17

        visible: withArrow
        source: "../image/icon_right.png"
    }

    Kirigami.Separator {
        id: my_separator

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: marginLeftAndRight
        anchors.rightMargin: marginLeftAndRight

        height: 1
        color: "#f0f0f0"
    }
}
