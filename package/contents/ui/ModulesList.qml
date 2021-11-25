

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

import org.kde.plasma.settings 0.1
import org.kde.bluezqt 1.0 as BluezQt
import MeeGo.QOfono 0.2 as QOfono
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM
import org.kde.plasma.core 2.0 as PlasmaCore

Kirigami.Page {
    id: settingsRoot

    property string titleColor: Kirigami.JTheme.minorForeground//"#4D000000"
    property string selectMenu: "wifi"
    property string wifiConnectedName: networkStatus.connectedWifiName
    property bool isBluetoothOn: !BluezQt.Manager.bluetoothBlocked  && isAdapterPowered()
    property bool isVpnConnected:networkStatus.connectedVpnName != "" ? true : false
    property var curentModemPath: ofonoManager.modems.length ? ofonoManager.modems[0] : ""
    property bool isSimExits: simListModel.count > 0
    property bool isCellularOn: ofonoContextConnection.active
    property bool airplaneModeEnabled: stSource.data["StatusPanel"]["flight mode"]

    padding: 0

    PlasmaNM.Handler {
        id: handler
    }

    QOfono.OfonoManager {
        id: ofonoManager
    }

    QOfono.OfonoContextConnection{
        id: ofonoContextConnection

        contextPath: connectionManager.contexts[0]
    }

    QOfono.OfonoConnMan {
        id:connectionManager

        modemPath: curentModemPath
    }

    QOfono.OfonoSimListModel {
        id: simListModel
    }

    NetworkStatus {
        id: networkStatus

        onWirelessEnabledChanged: {
            setWifiContent();
        }

        onNetworkStatusChanged: {
            setWifiContent();
        }

        onConnectedWifiNameChanged: {
            setWifiContent();
        }

        onConnectedVpnNameChanged:{
            setVpnContent();
        }
    }

    PlasmaCore.DataSource {
        id: stSource

        engine: "statuspanel"
        connectedSources: ["StatusPanel"]
    }

    function isAdapterPowered() {
        var adapter = BluezQt.Manager.adapters[0]
        var isPowered = adapter.powered
        return isPowered;
    }

    background: Rectangle {
        anchors.fill: parent
        color: Kirigami.JTheme.settingMajorBackground
    }

    Text {
        id: settings_title

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: 25 * appScaleSize
            topMargin: 40 * appScaleSize
        }
        text: i18nd("settings", "Settings")
        font.bold: true
        font.pixelSize: 25 * appFontSize
        color: Kirigami.JTheme.majorForeground
    }

    ListView {
        id: tagListview

        anchors {
            left: parent.left
            top: settings_title.bottom
            bottom: parent.bottom
            bottomMargin: 10 * appScaleSize
            right: parent.right
            leftMargin: 12 * appScaleSize
        }
        clip: true
        section.property: "group"
        section.criteria: ViewSection.FullString
        section.delegate: Item {
            width: tagListview.width
            height: 46 * appScaleSize

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 13 * appScaleSize
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6 * appScaleSize
                font.pixelSize: 12 * appFontSize
                color:titleColor
                text: section
            }
        }

        model: settingsModel
        delegate: MenuItem {
            menuChecked: model.type === "airplaneMode" ? airplaneModeEnabled : false
            menuType: model.menuType
            menuTitle: model.title
            menuContent: model.menuContent
            menuIconSource: model.icon
            isSelect : settingsRoot.selectMenu === model.type

            onToggleChanged: {
                if (model.type === "airplaneMode") {
                    handler.enableAirplaneMode(checked)
                }
            }
            onMenuClicked: {
                if (menuType !== 1) {
                    settingsRoot.selectMenu = model.type
                    openModule(type)
                }
            }
        }
    }

    onIsBluetoothOnChanged: {
        setBluetoothContent();
    }

    onIsCellularOnChanged: {
        setWifiContent();
        setCellularContent();
    }

    onAirplaneModeEnabledChanged: {
        setCellularContent();
    }

    onIsSimExitsChanged: {
        setCellularContent();
    }

    function getWifiContent() {
        var content = "";
        if(networkStatus.wirelessEnabled === false){
            content = i18nd("settings","Off");
        } else {
            if (isCellularOn === false && networkStatus.networkStatus === "Connecting") {
                content = i18nd("settings","On Connection")
            } else {
                if (networkStatus.networkStatus === "Connected") {
                    if(networkStatus.connectedWifiName != "") {
                        content = networkStatus.connectedWifiName;
                    } else {
                        content = i18nd("settings","Not Connected");
                    }
                } else {
                    content =  i18nd("settings","Not Connected");
                }
            }
        }
        return content;
    }

    function getBluetoothContent() {
        var content = isBluetoothOn ? i18nd("settings","On") : i18nd("settings","Off")
        return content;
    }

    function getCellularContent() {
        var content = "";
        if (airplaneModeEnabled === true) {
            content =  i18nd("settings","Airplane Mode");
        } else {
            if (isSimExits === true){
                if (isCellularOn === true) {
                    content = i18nd("settings","On")
                } else {
                    content = i18nd("settings","Off")
                }
            } else {
                content = i18nd("settings","No SIM")
            }
        }
        return content;
    }

    function getVpnContent() {
        var content = isVpnConnected ? i18nd("settings","On") : i18nd("settings","Not Connected");
        return content;
    }

    function setWifiContent() {
        var content = getWifiContent();
        for(var i = 0; i < settingsModel.count; i++) {
            if(settingsModel.get(i).type === "wifi") {
                settingsModel.get(i).menuContent = content;
                break;
            }
        }
    }

    function setBluetoothContent() {
        var content = getBluetoothContent();
        for(var i = 0; i < settingsModel.count; i++){
            if(settingsModel.get(i).type === "bluetooth"){
                settingsModel.get(i).menuContent = content;
                break;
            }
        }
    }

    function setCellularContent(){
        var content = getCellularContent();
        for(var i = 0; i < settingsModel.count; i++){
            if(settingsModel.get(i).type === "cellular"){
                settingsModel.get(i).menuContent = content;
                break;
            }
        }
    }

    function setVpnContent() {
        var content = getVpnContent();
        for(var i = 0; i < settingsModel.count; i++){
            if(settingsModel.get(i).type === "vpn"){
                settingsModel.get(i).menuContent = content;
                break;
            }
        }
    }

    ListModel {
        id: settingsModel

        Component.onCompleted: {

            settingsModel.append({"group" : i18nd("settings", "Network and connectivity"), "title" : i18nd("settings", "Airplane Mode"),
                                     "type" : "airplaneMode", "menuType" : 1, "menuContent" : "", "icon" : Qt.resolvedUrl("../image/icon_ap.svg") });

            settingsModel.append({"group" : i18nd("settings", "Network and connectivity"), "title" : i18nd("settings", "WLAN"),
                                     "type" : "wifi", "menuType" : 2, "menuContent" : getWifiContent(), "icon" :  Qt.resolvedUrl("../image/icon_wifi.svg")});

            settingsModel.append({"group" : i18nd("settings", "Network and connectivity"), "title" : i18nd("settings", "Bluetooth"),
                                     "type" : "bluetooth", "menuType" : 2, "menuContent" : getBluetoothContent(), "icon" :  Qt.resolvedUrl("../image/icon_bt.svg")});
//[liubangguo]canceled for V1.0
//            settingsModel.append({"group" : i18nd("settings", "Network and connectivity"), "title" : i18nd("settings", "Cellular"),
//                                     "type" : "cellular", "menuType" : 2, "menuContent" : getCellularContent(), "icon" :  Qt.resolvedUrl("../image/icon_cell.svg")});

            settingsModel.append({"group" : i18nd("settings", "Network and connectivity"), "title" : i18nd("settings", "VPN"),
                                     "type" : "vpn", "menuType" : 2, "menuContent" : getVpnContent(), "icon" :  Qt.resolvedUrl("../image/icon_vpn.svg")});

            settingsModel.append({"group" : i18nd("settings", "Security and privacy"), "title" : i18nd("settings", "Password"),
                                     "type" : "password", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_password.svg")});

            settingsModel.append({"group" : i18nd("settings", "Display and sound"), "title" : i18nd("settings", "Display & Brightness"),
                                     "type" : "display", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_display.svg")});

            settingsModel.append({"group" : i18nd("settings", "Display and sound"), "title" : i18nd("settings", "Wallpaper"),
                                     "type" : "wallpaper", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_wallpaper.svg")});

            settingsModel.append({"group" : i18nd("settings", "Display and sound"), "title" : i18nd("settings", "Sounds"),
                                     "type" : "sound", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_sound.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "System & Update"),
                                     "type" : "mobile_info", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_about.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Language & Region"),
                                     "type" : "translations", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_language.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Date & Time"),
                                     "type" : "mobile_time", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_time.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Battery"),
                                     "type" : "battery", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_battery.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Storage"),
                                     "type" : "storage", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_storage.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Keyboard"),
                                     "type" : "keyboard", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_keyboard.svg")});

            // settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Trackpad"),
            //                          "type" : "trackpad", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_touch.svg")});

            settingsModel.append({"group" : i18nd("settings", "System"), "title" : i18nd("settings", "Mouse"),
                                     "type" : "pointer", "menuType" : 0, "menuContent" : "", "icon" :  Qt.resolvedUrl("../image/icon_mouse.svg")});
        }
    }

    function openModule(moduleName) {
        module.name = moduleName

        while (pageStack.depth > 1) {
            pageStack.pop()
        }
        pageStack.push(kcmContainer.createObject(pageStack, { "kcm": module.kcm, "internalPage": module.kcm.mainUi }))
    }
}