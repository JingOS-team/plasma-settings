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
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

import org.kde.plasma.settings 0.1

Kirigami.ApplicationWindow {
    id: main

    property int screenWidth: Screen.width 
    property int screenHeight: Screen.height

    width: screenWidth
    height: screenHeight

    pageStack.initialPage: appPage
    pageStack.interactive: false
    // property real appScale: 1.3 * screenWidth / 1920
    // property int appFontSize: theme.defaultFont.pointSize
    pageStack.separatorVisible: false
    pageStack.defaultColumnWidth: 888 * 0.3

    Component.onCompleted: {
        main.fullScreenWindow()
    }

    onVisibleChanged: {
        main.globalToolBarStyle = Kirigami.ApplicationHeaderStyle.None
    }

    ApplicationPage {
        id: appPage
    }

    PlasmaNM.Handler {
        id: handler

        onPasswordErrorChanged: {
            errorDialog.visible = true
            errorDialog.text = i18n("Incorrect password for \"%1\"",name)

            handler.removeConnection(connectionPath)
        }
    }

    Kirigami.JDialog {
        id: errorDialog

        title: i18n("Failed to join")
        inputEnable: false
        centerButtonText: i18n("Ok")
        onCenterButtonClicked: {
            errorDialog.visible = false
        }
    }
}
