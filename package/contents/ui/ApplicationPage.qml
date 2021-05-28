/*
 * Copyright 2021 Rui Wang <wangrui@jingos.com>
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
import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1 as Controls
import org.kde.kirigami 2.13 as Kirigami
import org.kde.plasma.settings 0.1

Kirigami.Page {
    id: initialPage

    property bool isResult: false

    title: i18n("Settings")
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None

    Connections {
        target: SettingsApp
        onModuleRequested: {
            modulesList.selectMenu = moduleName
            openModule(moduleName)
            main.hide()
            main.show()
        }
    }

    function openModule(moduleName) {
        module.name = moduleName
        while (pageStack.depth > 1) {
            pageStack.pop()
        }
        pageStack.push(kcmContainer.createObject(pageStack, {
                                                     "kcm": module.kcm,
                                                     "internalPage": module.kcm.mainUi
                                                 }))
    }

    Module {
        id: module
    }

    Rectangle {
        id: app_layout
        anchors.fill: parent
        width: parent.width
        height: parent.height
        color: "transparent"

        Rectangle {
            id: menuLayout

            width: 265
            height: parent.height
            visible: true
            color: "transparent"

            anchors {
                left: app_layout.left
                top: app_layout.top
            }

            ModulesList {
                id: modulesList
                anchors.fill: menuLayout
            }
        }

        Rectangle {
            id: contentLayout

            visible: true
            width: 623
            height: parent.height
            color: "#FFF6F9FF"
            anchors {
                left: menuLayout.right
                top: parent.top
                right: parent.right
            }

            Component {
                id: kcmContainer
                KCMContainer {}
            }

            Component.onCompleted: {
                if (SettingsApp.startModule == "") {
                    openModule("wifi")
                    modulesList.selectMenu = "wifi"
                } else {
                    openModule(SettingsApp.startModule)
                    modulesList.selectMenu = SettingsApp.startModule
                }
            }
        }
    }
}
