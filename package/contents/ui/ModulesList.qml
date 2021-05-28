

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

import org.kde.kirigami 2.15 as Kirigami
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

import org.kde.plasma.settings 0.1
import org.kde.bluezqt 1.0 as BluezQt

Kirigami.Page {
    id: settingsRoot

    property string titleColor: "#4D000000"
    property string selectMenu: "wifi"
    property string wifiConnectedName: editorProxyModel != null ? editorProxyModel.currentConnectedName : "Not connected"
    property bool isBluetoothOn: !BluezQt.Manager.bluetoothBlocked
    property bool isVpnConnected: vpnProxyModel.vpnConnectedName != "" ?  true : false

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

    PlasmaNM.VpnProxyModel {
       id: vpnProxyModel

        sourceModel: connectionModel

        onConnectedNameChanged:{
            isVpnConnected = name != "" ? true : false
        }
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
                leftMargin: 25
                topMargin: 40
            }
            width: parent.width
            height: 30
            color: "transparent"

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                text: i18n("Settings")
                font.bold: true
                // font.pointSize: appFontSize + 16
                font.pixelSize: 25
            }
        }

        Rectangle {

            anchors {
                left: parent.left
                top: settings_title.bottom
                leftMargin: 12
                topMargin: 28
            }

            width: parent.width
            height: parent.height
            color: "transparent"

            Controls.ScrollView {
                id: scrollView
                width: 888* 0.3 -12-13
                height: parent.height -  (40+ 30+28)
                Controls.ScrollBar.horizontal.policy: Controls.ScrollBar.AlwaysOff
                // Controls.ScrollBar.vertical.policy: Controls.ScrollBar.AlwaysOff
                contentWidth: -1

                Controls.ScrollBar.vertical: Controls.ScrollBar {
                    parent: scrollView
                    x: scrollView.mirrored ? 0 : scrollView.width - width
                    y: scrollView.topPadding
                    policy: Controls.ScrollBar.AsNeeded
                    height: scrollView.availableHeight
                    active: scrollView.ScrollBar.horizontal.active
                    contentItem: Rectangle {
                        implicitWidth: 4
                        implicitHeight: 80
                        radius: width/2
                        // color: scrollView.pressed ? "orange" : "green"
                        color: "transparent"
                    }
                }

                Column {
                    spacing: 2

                    Item {
                        width: parent.width
                        height: 2 
                    }

                    Text {
                        id: network_title

                        text: i18n("Network and connectivity")
                        color: titleColor
                        width: 175
                        height: 12
                        font.pixelSize: 12
                        anchors {
                            left: parent.left
                            leftMargin: 12
                        }
                    }

                    Item {
                        width: parent.width
                        height: 6
                    }

                    MenuItem {
                        id: wifiMenu

                        menuTitle: i18n("WLAN")
                        menuType: 2
                        menuContent: !enabledConnections.wirelessEnabled ? i18n("Off") : networkStatus.networkStatus == "Connecting" ? i18n("On connection") : networkStatus.networkStatus == "Connected" ? wifiConnectedName : i18n("Not connected")
                        menuIconSource: "../image/icon_wifi.svg"
                        menuIconSourceHighlight: "../image/icon_wifi.svg"
                        isSelect: selectMenu == "wifi"

                        onMenuClicked: {
                            selectMenu = "wifi"
                            openModule("wifi")
                        }
                    }

		            MenuItem {
                        id: btMenu
                        menuTitle: i18n("Bluetooth")
                        menuType : 2
                        menuContent : isBluetoothOn ? i18n("On") : i18n("Off")
                        menuIconSource: "../image/icon_bt.svg"
                        menuIconSourceHighlight: "../image/icon_bt.svg"
                        isSelect: selectMenu == "bluetooth"
                        onMenuClicked : {
                            selectMenu = "bluetooth"
                            openModule("bluetooth")
                        }
                    }

                    MenuItem {
                        id: vpnMenu
                        menuTitle: "VPN"
                        menuType : 2
                        menuContent: isVpnConnected ? i18n("On") : i18n("Not connected")
                        menuIconSource: "../image/icon_vpn.svg"
                        menuIconSourceHighlight: "../image/icon_vpn.svg"
                        isSelect: selectMenu == "vpn"
                        onMenuClicked : {
                            selectMenu = "vpn"
                             openModule("vpn")
                        }
                    }

                    /*
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
                        height: 28 
                    }

                    Text {
                        id: display_title

                        anchors {
                            left: parent.left
                            leftMargin: 18 
                            bottomMargin: 6 
                        }
                        width: 269 
                        height: 18 
                        text: i18n("Display and sound")
                        color: titleColor
                        font.pixelSize: 12
                    }

                    Item {
                        width: parent.width
                        height: 6 
                    }

                    MenuItem {
                        id: displayMenu

                        menuTitle: i18n("Display & Brightness")
                        menuType: 0
                        menuIconSource: "../image/icon_display.svg"
                        menuIconSourceHighlight: "../image/icon_display.svg"
                        isSelect: selectMenu == "display"

                        onMenuClicked: {
                            selectMenu = "display"
                            openModule("display")
                        }
                    }
                    MenuItem {
                        id: wallpaperMenu
                        menuTitle: i18n("Wallpaper")
                        menuType : 0
                        menuIconSource: "../image/icon_wallpaper.svg"
                        menuIconSourceHighlight: "../image/icon_wallpaper.svg"
                        isSelect: selectMenu == "wallpaper"
                        onMenuClicked : {
                            selectMenu = "wallpaper"
                            openModule("wallpaper")
                        }
                    }


                    MenuItem {
                        id: soundMenu

                        menuTitle: i18n("Sounds")
                        menuType: 0
                        menuIconSource: "../image/icon_sound.svg"
                        menuIconSourceHighlight: "../image/icon_sound.svg"
                        isSelect: selectMenu == "sound"

                        onMenuClicked: {
                            selectMenu = "sound"
                            openModule("sound")
                        }
                    }

                    Item {
                        width: parent.width
                        height: 28
                    }

                    Text {
                        id: security_title

                        anchors {
                            left: parent.left
                            leftMargin: 18 
                            bottomMargin: 6 
                        }
                        width: 269 
                        height: 18 
                        text: i18n("Security and privacy")
                        color: titleColor
                        font.pixelSize: 12
                    }

                    Item {
                        width: parent.width
                        height: 6 
                    }

                    MenuItem {
                        id: passwordMenu

                        menuTitle: i18n("Password")
                        menuType: 0
                        menuIconSource: "../image/icon_password.svg"
                        menuIconSourceHighlight: "../image/icon_password.svg"
                        isSelect: selectMenu == "password"

                        onMenuClicked: {
                            selectMenu = "password"
                            openModule("password")
                        }
                    }

                    MenuItem {
                        id: locationMenu
                        menuTitle: i18n("Location Service")
                        menuType : 0
                        menuIconSource: "../image/icon_location.svg"
                        menuIconSourceHighlight: "../image/icon_location.svg"
                        isSelect: selectMenu == "location"
                        onMenuClicked : {
                            selectMenu = "location"
                            openModule("location")
                        }
                    }

                    Item {
                        width: parent.width
                        height: 28 
                    }

                    Text {
                        id: system_title
                        
                        anchors {
                            left: parent.left
                            leftMargin: 18 
                        }
                        width: 269 
                        height: 18 
                        text: i18n("System")
                        color: titleColor
                        font.pixelSize: 12
                    }

                    Item {
                        width: parent.width
                        height: 6 
                    }

                    MenuItem {
                        id: systemMenu

                        menuTitle: i18n("System & Update")
                        menuType: 0
                        menuIconSource: "../image/icon_about.svg"
                        menuIconSourceHighlight: "../image/icon_about.svg"
                        isSelect: selectMenu == "mobile_info"

                        onMenuClicked: {
                            selectMenu = "mobile_info"
                            openModule("mobile_info")
                        }
                    }

                    MenuItem {
                        id: languageMenu
                        menuTitle: i18n("Language")
                        menuType : 0
                        menuIconSource: "../image/icon_language.svg"
                        menuIconSourceHighlight: "../image/icon_language.svg"
                        isSelect: selectMenu == "language"
                        onMenuClicked : {
                            selectMenu = "language"
                            openModule("translations")
                        }
                    }
                    
                    MenuItem {
                        id: timeMenu
                        menuTitle: i18n("Date & Time")
                        menuType : 0
                        menuIconSource: "../image/icon_time.svg"
                        menuIconSourceHighlight: "../image/icon_time.svg"
                        isSelect: selectMenu == "Time"
                        onMenuClicked : {
                            selectMenu = "Time"
                            openModule("mobile_time")

                        }
                    }

                    MenuItem {
                        id: batteryMenu

                        menuTitle: i18n("Battery")
                        menuType: 0
                        menuIconSource: "../image/icon_battery.svg"
                        menuIconSourceHighlight: "../image/icon_battery.svg"
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
                        menuIconSource: "../image/icon_storage.svg"
                        menuIconSourceHighlight: "../image/icon_storage.svg"
                        isSelect: selectMenu == "storage"

                        onMenuClicked: {
                            selectMenu = "storage"
                            openModule("storage")
                        }
                    }
		
                    MenuItem {
                        id: keyboardMenu

                        menuTitle: i18n("Keyboard")
                        menuType: 0
                        menuIconSource: "../image/icon_keyboard.svg"
                        menuIconSourceHighlight: "../image/icon_keyboard.svg"
                        isSelect: selectMenu == "keyboard"

                        onMenuClicked: {
                            selectMenu = "keyboard"
                            openModule("keyboard")
                        }
                    }

                    MenuItem {
                        id: trackpadMenu

                        menuTitle: i18n("Trackpad")
                        menuType: 0
                        menuIconSource: "../image/icon_touch.svg"
                        menuIconSourceHighlight: "../image/icon_touch.svg"
                        isSelect: selectMenu == "trackpad"

                        onMenuClicked: {
                            selectMenu = "trackpad"
                            openModule("trackpad")
                        }
                    }

                    MenuItem {
                        id: pointerMenu

                        menuTitle: i18n("Mouse")
                        menuType: 0
                        menuIconSource: "../image/icon_mouse.svg"
                        menuIconSourceHighlight: "../image/icon_mouse.svg"
                        isSelect: selectMenu == "pointer"

                        onMenuClicked: {
                            selectMenu = "pointer"
                            openModule("pointer")
                        }
                    }

                    Item {
                        width: parent.width
                        height: 10 
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
