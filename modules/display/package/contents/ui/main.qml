/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Rui Wang <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import org.kde.kcm 1.2 as KCM
import QtQuick.Layouts 1.2
import QtQuick.Window 2.2
import QtQuick 2.7
import QtQuick.Controls 2.2
import org.kde.kirigami 2.15 as Kirigami
import jingos.display 1.0

Item {
    id: main

    property real appScaleSize: JDisplay.dp(1.0)
    property real appFontSize: JDisplay.sp(1.0)
    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    anchors.fill:parent 

    Connections {
        target: kcm

        onCurrentIndexChanged:{
            if(index == 1){
                popAllView()
            }
        }
    }

    StackView {
        id: stack

        anchors.fill: parent

        Component.onCompleted: {
            stack.push(display_view)
        }
    }

    Component {
        id: display_view

        Display {}
    }

    Component {
        id: fonts_detail_view

        Submenu {}
    }

    function gotoPage(name) {
        
        console.log("display gotoPage : ", name)

        if (name == "display_view") {
            stack.push(time_view)
        } else if (name == "fonts_detail_view") {
            stack.push(fonts_detail_view)
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

