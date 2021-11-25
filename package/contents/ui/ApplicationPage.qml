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
import org.kde.kirigami 2.15 as Kirigami
import org.kde.plasma.settings 0.1

Kirigami.Page {
    id: initialPage

    property bool isResult: false
    property string startModuleName: ""

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

    function loadModule(moduleName) {
        module.name = moduleName

        kcmContainer.incubateObject(pageStack, {
                                                     "kcm": module.kcm,
                                                     "internalPage": module.kcm.mainUi
                                                 })
    }

    Module {
        id: module
    }
        Item {
            id: menuLayout

            width: 265 * appScaleSize
            height: parent.height
            ModulesList {
                id: modulesList
                anchors.fill: menuLayout
            }
        }

        Rectangle {
            id: contentLayout
            width: 623 * appScaleSize
            height: parent.height
            color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"
            anchors {
                left: menuLayout.right
                right: parent.right
            }

            Component {
                id: kcmContainer

                KCMContainer {
                    id:container
                    Connections{
                        target:SettingsApp

                        onPause: {

                            container.settingPaused()
                        }

                        onResume: {

                            container.settingResume()
                        }
                    }}


            }

            Component.onCompleted: {
                //openModule("loading")
                if (SettingsApp.startModule == "") {
                    startModuleName = "wifi"

                    modulesList.selectMenu = "wifi"

                } else {
                    startModuleName = SettingsApp.startModule
                    //openModule(SettingsApp.startModule)
                    modulesList.selectMenu = SettingsApp.startModule
                }
                loadTimer.start()
                module.loadWallpaperCache()

            }
        }

    Timer{
        id:loadTimer
        interval:10
        running: false
        onTriggered:{
            console.log("[liubangguo]timer send message before,module:"+module);
//            var msg = {'module': module, 'kcmContainer': kcmContainer, 'pageStack':pageStack,'test':"test"};
//            loadmodules.sendMessage(msg);
//            loadModule("pointer");
//            loadModule("trackpad");
//            loadModule("keyboard");
//            loadModule("storage");
//            loadModule("battery");
//            loadModule("mobile_time");
//            loadModule("translations");
//            loadModule("mobile_info");
//            loadModule("sound");
//            loadModule("wallpaper");
//            loadModule("display");
//            loadModule("password");
//            loadModule("vpn");
//            loadModule("cellular");
//            loadModule("bluetooth");
//            loadModule("wifi");
            openModule(startModuleName)
        }
    }
}
