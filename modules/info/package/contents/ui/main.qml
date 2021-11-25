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
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0
import org.jingos.info 1.0

Item {
    id: system_info_root

    property real appScale: JDisplay.dp(1.0)
    property real appFontSize: JDisplay.sp(1.0)
    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property string deviceName : kcm.getLocalDeviceName()
    property string systemBackground: Kirigami.JTheme.settingMinorBackground
    property string systemTextColor: Kirigami.JTheme.majorForeground
    property string systemItemBackground: Kirigami.JTheme.cardBackground
    property int rootHasNewVersion: 0
    property bool rootHasupdating: false

    width: parent.width
    height: parent.height

    Connections {
        target: kcm
        onLocalDeviceNameChanged: {
            deviceName = localDeviceName
        }
        onCurrentIndexChanged:{
            if(index == 1){
                popAllView()
            }
            deviceName = kcm.getLocalDeviceName()
        }
    }

    UpdateTool {
        id: updateTool

        onUpdatingChanged: {
            if (updating) {
                system_info_root.rootHasupdating = true
                return;
            }
            system_info_root.rootHasupdating = false
        }
        Component.onCompleted: {
            if (getQaptupdatorUpdateStatus() === 1) {
                system_info_root.rootHasupdating = true
            }
        }
    }

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

    Component {
        id: status_view

        Status {}
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
        } else if (name == "status_view") {
            stack.push(status_view)
        }
    }

    function popView() {
        stack.pop()
    }

    function popAllView() {
        while (stack.depth > 1) {
            stack.pop()
        }
    }
}

