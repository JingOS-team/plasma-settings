
/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0
import org.kde.kirigami 2.15 as Kirigami

Rectangle {
    property alias timerRun: animLoader.active
    property int updateIndex

    color: Kirigami.JTheme.background//"#E8EFFF"

    Component {
        id: animComponment
        AnimatedImage {
            width: 25 * 2
            height: 25 * 2
            source: "../image/loadanim.gif" //main.isDarkTheme ? "../image/black_load.gif" : "../image/loadanim.gif"
        }
    }

    Loader {
        id: animLoader
        sourceComponent: animComponment
        anchors.centerIn: parent
    }
}

