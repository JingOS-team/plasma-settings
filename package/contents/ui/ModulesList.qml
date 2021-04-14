

/***************************************************************************
 *                                                                         *
 *   Copyright 2011-2014 Sebastian Kügler <sebas@kde.org>                  *
 *             2021      Wang Rui <wangrui@jingos.com>
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
import QtQuick 2.12
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.2 as Controls

import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

import org.kde.plasma.settings 0.1

Kirigami.Page {
    id: settingsRoot

    property string titleColor: "#4D000000"
    property string selectMenu: "wifi"
    property string wifiConnectedName: editorProxyModel != null ? editorProxyModel.currentConnectedName : "Not connected"
    
    width: parent.width
    height: parent.height
    title: i18n("Settings")
    topPadding: 0
    leftPadding: 0
    rightPadding: 0
    bottomPadding: 0

    PlasmaNM.KcmIdentityModel {
        id: connectionModel
    }

    PlasmaNM.EditorProxyModel {
        id: editorProxyModel

        sourceModel: connectionModel
    }

    PlasmaNM.EnabledConnections {
        id: enabledConnections
    }

    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    Repeater {
        model: editorProxyModel
        Item {
            Component.onCompleted: {
                if (ConnectionState == PlasmaNM.Enums.Activated) {

                    //editorProxyModel.currentConnectedName = Name
                }
            }
        }
    }

    background: Rectangle {
        anchors.fill: parent
        color: "#FFE8EFFF"
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            id: settings_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 38 * appScale
                topMargin: 62 * appScale
            }
            width: parent.width
            height: 46 * appScale
            color: "transparent"

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                text: "Settings"
                font.bold: true
                font.pointSize: appFontSize + 16
            }
        }

        Rectangle {

            anchors {
                left: parent.left
                top: settings_title.bottom
                leftMargin: 18 * appScale
                topMargin: 26 * appScale
            }

            width: parent.width
            height: parent.height
            color: "transparent"

            Controls.ScrollView {
                width: 380 * appScale
                height: parent.height - (52 + 59 + 55) * appScale
                Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
                Controls.ScrollBar.vertical.policy: Controls.ScrollBar.AlwaysOff
                contentWidth: -1

                Column {
                    spacing: 2

                    Item {
                        width: parent.width
                        height: 10 * appScale
                    }

                    Text {
                        id: network_title

                        text: i18n("Network and connectivity")
                        color: titleColor
                        width: 269 * appScale
                        height: 18 * appScale
                        font.pointSize: appFontSize - 2
                        anchors {
                            left: parent.left
                            leftMargin: 18 * appScale
                        }
                    }

                    Item {
                        width: parent.width
                        height: 8 * appScale
                    }

                    MenuItem {
                        id: wifiMenu

                        menuTitle: "WLAN"
                        menuType: 2
                        menuContent: !enabledConnections.wirelessEnabled ? "Off" : networkStatus.networkStatus == "Connecting" ? "On connection" : networkStatus.networkStatus == "Connected" ? wifiConnectedName : "Not connected"
                        menuIconSource: "../image/icon_wifi.png"
                        menuIconSourceHighlight: "../image/icon_wifi_hi.png"
                        isSelect: selectMenu == "wifi"

                        onMenuClicked: {
                            selectMenu = "wifi"
                            openModule("wifi")
                        }
                    }
                    /*
                    MenuItem {
                        id: btMenu
                        menuTitle: "Bluetooth"
                        menuType : 2
                        menuContent : ""
                        menuIconSource: "../image/icon_bt.png"
                        menuIconSourceHighlight: "../image/icon_bt_hi.png"
                        isSelect: selectMenu == "bluetooth"
                        onMenuClicked : {
                            selectMenu = "bluetooth"
                            openModule("bluetooth")
                        }
                    }

                    MenuItem {
                        id: cellMenu
                        menuTitle: "Cellular"
                        menuType : 0
                        menuIconSource: "../image/icon_cell.png"
                        isSelect: selectMenu == "cell"

                        onMenuClicked : {
                            selectMenu = "cell"
                            openModule("mobile_cellularnetwork")
                        }
                    }

                    MenuItem {
                        id: vpnMenu
                        menuTitle: "VPN"
                        menuType : 2
                        menuContent : "333"
                        menuIconSource: "../image/icon_cell.png"
                        isSelect: selectMenu == "vpn"
                        onMenuClicked : {
                            selectMenu = "vpn"
                             openModule("mobile_theme")
                        }
                    }

                    MenuItem {
                        id: hotspotMenu
                        menuTitle: "Personal Hotspot"
                        menuType : 0
                        menuIconSource: "../image/icon_cell.png"
                        isSelect: selectMenu == "hotspot"
                        onMenuClicked : {
                            selectMenu = "hotspot"
                            openModule("mobile_power")
                        }
                    }*/

                    Item {
                        width: parent.width
                        height: 43 * appScale
                    }

                    Text {
                        id: display_title

                        anchors {
                            left: parent.left
                            leftMargin: 18 * appScale
                            bottomMargin: 8 * appScale
                        }
                        width: 269 * appScale
                        height: 18 * appScale
                        text: i18n("Display and sound")
                        color: titleColor
                        font.pointSize: appFontSize - 2
                    }

                    Item {
                        width: parent.width
                        height: 8 * appScale
                    }

                    MenuItem {
                        id: displayMenu

                        menuTitle: i18n("Display & Brightness")
                        menuType: 0
                        menuIconSource: "../image/icon_display.png"
                        menuIconSourceHighlight: "../image/icon_display_hi.png"
                        isSelect: selectMenu == "display"

                        onMenuClicked: {
                            selectMenu = "display"
                            openModule("display")
                        }
                    }

                    /*
                    MenuItem {
                        id: wallpaperMenu
                        menuTitle: "Wallpaper"
                        menuType : 0
                        menuIconSource: "../image/icon_cell.png"
                        isSelect: selectMenu == "wallpaper"
                        onMenuClicked : {
                            selectMenu = "wallpaper"
                            penModule("wallpaper")
                        }
                    }
                    */

                    MenuItem {
                        id: soundMenu

                        menuTitle: i18n("Sound")
                        menuType: 0
                        menuIconSource: "../image/icon_sound.png"
                        menuIconSourceHighlight: "../image/icon_sound_hi.png"
                        isSelect: selectMenu == "sound"

                        onMenuClicked: {
                            selectMenu = "sound"
                            openModule("sound")
                        }
                    }

                    Item {
                        width: parent.width
                        height: 43 * appScale
                    }

                    Text {
                        id: security_title

                        anchors {
                            left: parent.left
                            leftMargin: 18 * appScale
                            bottomMargin: 8 * appScale
                        }
                        width: 269 * appScale
                        height: 18 * appScale
                        text: i18n("Security and privacy")
                        color: titleColor
                        font.pointSize: appFontSize - 2
                    }

                    Item {
                        width: parent.width
                        height: 8 * appScale
                    }

                    MenuItem {
                        id: passwordMenu

                        menuTitle: i18n("Password")
                        menuType: 0
                        menuIconSource: "../image/icon_password.png"
                        menuIconSourceHighlight: "../image/icon_password_hi.png"
                        isSelect: selectMenu == "password"

                        onMenuClicked: {
                            selectMenu = "password"
                            openModule("password")
                        }
                    }

                    // MenuItem {
                    //     id: locationMenu
                    //     menuTitle: "Location"
                    //     menuType : 0
                    //     menuIconSource: "../image/icon_cell.png"
                    //     isSelect: selectMenu == "location"
                    //     onMenuClicked : {
                    //         selectMenu = "location"
                    //     }
                    // }

                    Item {
                        width: parent.width
                        height: 43 * appScale
                    }

                    Text {
                        id: system_title
                        
                        anchors {
                            left: parent.left
                            leftMargin: 18 * appScale
                        }
                        width: 269 * appScale
                        height: 18 * appScale
                        text: i18n("System")
                        color: titleColor
                        font.pointSize: appFontSize - 2
                    }

                    Item {
                        width: parent.width
                        height: 8 * appScale
                    }
                   /*  
                    MenuItem {
                        id: timeMenu
                        menuTitle: "Date & Time"
                        menuType : 0
                        menuIconSource: "../image/icon_time.png"
                        menuIconSourceHighlight: "../image/icon_time_hi.png"
                        isSelect: selectMenu == "Time"
                        onMenuClicked : {
                            selectMenu = "Time"
                            openModule("mobile_time")

                        }
                    } */
                    
                    MenuItem {
                        id: batteryMenu

                        menuTitle: i18n("Battery")
                        menuType: 0
                        menuIconSource: "../image/icon_battery.png"
                        menuIconSourceHighlight: "../image/icon_battery_hi.png"
                        isSelect: selectMenu == "battery"

                        onMenuClicked: {
                            selectMenu = "battery"
                            openModule("battery")
                        }
                    }

                    MenuItem {
                        id: storageMenu

                        menuTitle: i18n("Storage")
                        menuType: 0
                        menuIconSource: "../image/icon_storage.png"
                        menuIconSourceHighlight: "../image/icon_storage_hi.png"
                        isSelect: selectMenu == "storage"

                        onMenuClicked: {
                            selectMenu = "storage"
                            openModule("storage")
                        }
                    }

                    MenuItem {
                        id: systemMenu

                        menuTitle: i18n("System & Update")
                        menuType: 0
                        menuIconSource: "../image/icon_about.png"
                        menuIconSourceHighlight: "../image/icon_about_hi.png"
                        isSelect: selectMenu == "mobile_info"

                        onMenuClicked: {
                            selectMenu = "mobile_info"
                            openModule("mobile_info")
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
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
}
