/***************************************************************************
 *                                                                         *
 *   Copyright 2021 Wang Rui <wangrui@jingos.com>     
 *   Copyright 2017 Marco Martin <mart@kde.org>                            *
 *   Copyright 2011-2014 Sebastian Kügler <sebas@kde.org>                  *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/
import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.2 as Controls
import org.kde.kirigami 2.15 as Kirigami
//import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

import org.kde.plasma.settings 0.1
import jingos.display 1.0

Kirigami.ApplicationWindow {
    id: main

    property real appScaleSize: JDisplay.dp(1.0)
    property real appFontSize: JDisplay.sp(1.0)
    property int screenWidth: Screen.width 
    property int screenHeight: Screen.height
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"
    property string wifiConnectedName

    width: screenWidth
    height: screenHeight

    pageStack.initialPage: appPage
    pageStack.interactive: false
    pageStack.separatorVisible: false
    pageStack.defaultColumnWidth: 888 * appScaleSize * 0.3
    color: Kirigami.JTheme.settingMinorBackground

    Component.onCompleted: {
        main.fullScreenWindow()
    }


    ApplicationPage {
        id: appPage
    }
}
