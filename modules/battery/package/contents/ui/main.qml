
/*
 *   Copyright 2020 Dimitris Kardarakos <dimkard@posteo.net>
 *   Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import org.kde.kcm 1.2 as KCM
import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.10
import jingos.display 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

Rectangle {
    id: battery_root

    property real appScale: JDisplay.dp(1.0)
    property real appFontSize: JDisplay.sp(1.0)
    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale

    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 18  * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale

    PlasmaCore.DataSource {
        id: pmSource

        engine: "powermanagement"
        connectedSources: ["Battery", "AC Adapter"]

        onSourceAdded: {
            disconnectSource(source);
            connectSource(source);
        }
        onSourceRemoved: {
            disconnectSource(source);
        }
    }

    StackView {
        id: stack

        anchors.fill: parent

    }

    Component.onCompleted: {
        stack.push(home_view)
    }


    Component {
        id: home_view

        Home {}
    }

    Component {
        id: modems_view

        Modems {}
    }

    function gotoPage(num) {
        if (num == 1) {
            stack.push(modems_view)
        }
    }

    function popView() {
        stack.pop()
    }
}
