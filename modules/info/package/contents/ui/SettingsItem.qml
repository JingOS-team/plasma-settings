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
import jingos.display 1.0

Rectangle {
    id: settings_item_root

    property alias mTitle: item_title.text
    property alias withSeparator: my_separator.visible
    property alias mContent: item_content.text
    property bool withContent: false
    property bool withArrow: true
    property bool withNew: false

    property int radiusCommon: 10  * appScale
    property int fontNormal: 14 * appScale
    property bool updating: false
    property bool updateMode: false

    width: parent.width
    height: default_setting_item_height + 1
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
            leftMargin: marginLeftAndRight
            verticalCenter: settings_item_root.verticalCenter
        }

        width: 331  * appScale
        height: 17 * appScale

        font.pixelSize: fontNormal
        color: Kirigami.JTheme.majorForeground
    }

    Text {
        id: item_content

        anchors {
            verticalCenter: parent.verticalCenter

            right: updateMode ?  item_new.left : parent.right
            rightMargin: updateMode ? JDisplay.dp(5) : marginLeftAndRight
        }

        visible: withContent
        text: mContent
        color: Kirigami.JTheme.minorForeground
        font.pixelSize: fontNormal
    }

    Image {
        id: item_new

        anchors {
            verticalCenter: parent.verticalCenter
            right: item_arrow.left
            rightMargin: 0 * appScale
        }

        sourceSize.width: 17 * appScale
        sourceSize.height: 17 * appScale

        visible: updating ? false : (withNew ? true : false)
        source: "../image/new.png"
    }

    Image {
        id: item_updating

        anchors {
            verticalCenter: parent.verticalCenter
            right: item_arrow.left
            rightMargin: 0 * appScale
        }

        sourceSize.width: 17 * appScale
        sourceSize.height: 17 * appScale

        visible: updating
        source: "../image/update_loading.svg"

        RotationAnimation {
            id: scanAnim

            target: item_updating
            loops: Animation.Infinite
            running: true
            from: 0
            to: 360
            duration: 3000
        }
    }

    Kirigami.JIconButton {
        id: item_arrow

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10 * appScale
        }

        width: 30 * appScale
        height: 30 * appScale

        visible: withArrow
        source: Qt.resolvedUrl("../image/icon_right.png")
        color: Kirigami.JTheme.iconMinorForeground
        MouseArea {
            anchors.fill: parent

            onClicked: {
                itemClicked()
            }
        }
    }

    Kirigami.Separator {
        id: my_separator

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: marginLeftAndRight
        anchors.rightMargin: marginLeftAndRight

        height: 1
        color: Kirigami.JTheme.dividerForeground
    }
}
