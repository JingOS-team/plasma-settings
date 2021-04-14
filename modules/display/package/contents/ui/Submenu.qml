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

    property real appScale: 1.3 * parent.width / (1920 * 0.7)
    property int appFontSize: theme.defaultFont.pointSize

    width: parent.width
    height: parent.height

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

        Text {
            id: title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 72 * appScale
                topMargin: 47 * appScale
            }

            width: 500
            height: 50
            text: i18n("Display & Brightness")
            font.pointSize: appFontSize + 11
        }
    }
}
