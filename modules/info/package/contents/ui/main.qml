/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import org.kde.kcm 1.2 as KCM
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import org.kde.kirigami 2.10 as Kirigami

Item {
    id: system_info_root

    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property real appScale: 1.3 * screenWidth / 1920
    property int appFontSize: theme.defaultFont.pointSize

    width: parent.width
    height: parent.height

    StackView {
        id: stack

        anchors.fill: parent

        Component.onCompleted: {
            stack.push(home_view)
        }
    }

    Component {
        id: home_view

        Home {}
    }

    Component {
        id: about_view

        About {}
    }

    Component {
        id: legal_view

        Legal {}
    }

    Component {
        id: update_view

        SystemUpdate {}
    }

    Component {
        id: update_setting_view

        SystemUpdateSettings {}
    }

    Component {
        id: reset_view

        FactoryReset {}
    }

    function gotoPage(name) {
        if (name == "about_view") {
            stack.push(about_view)
        } else if (name == "legal_view") {
            stack.push(legal_view)
        } else if (name == "update_view") {
            stack.push(update_view)
        } else if (name == "reset_view") {
            stack.push(reset_view)
        } else if (name == "update_setting_view") {
            stack.push(update_setting_view)
        }
    }

    function popView() {
        stack.pop()
    }
}

