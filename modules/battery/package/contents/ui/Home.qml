/*
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
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls 2.10
import org.kde.plasma.core 2.0 as PlasmaCore

Rectangle {

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45
    property int marginTitle2Top : 44 
    property int marginItem2Title : 36 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property int radiusCommon: 10 
    property int fontNormal: 14
    property bool hasBattery: getBatteryData('Has Battery', false)
    property string currentBatteryState: getBatteryData('State', false)
    property int remainingTime: getBatteryData('Remaining msec', 0)


    anchors.fill: parent

    color: "#FFF6F9FF"

    PlasmaCore.DataSource {
        id: pmSource

        engine: "powermanagement"
        connectedSources: ["Battery"]

        onSourceAdded: {
            disconnectSource(source)
            connectSource(source)
        }

        onSourceRemoved: {
            disconnectSource(source)
        }
    }
     
    function getBatteryData(key, def) {
        var value = pmSource.data.Battery[key]
        if (typeof value === 'undefined') {
            return def
        } else {
            return value
        }
    }

    function getRemainTimeString() {
        var msec = getBatteryData("Remaining msec", 0)

        if(msec == 0){
            return i18n(" %1h %2m " , 0 , 52)
        }
        var totalMins = Math.floor(msec / (60 * 1000))
        var hours = Math.floor(totalMins / 60)
        var mins = totalMins % 60
        return i18n(" %1h %2m " , hours , mins)
    }

    onVisibleChanged: {
        if(!visible){
            if(pmSource != null){
                console.log("visible change : disconnect battery connect")
                pmSource.connectSource("Battery")
            }

            syncTimer.stop()
        }
    }

    Component.onCompleted: {
        syncTimer.start()
    }

    Component.onDestruction: {
        console.log("onDestruction")
    }

    Timer {
        id: syncTimer
        interval: 10*1000 
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var info = getRemainTimeString()
            var precent0 = getBatteryData("Percent", -1)
            console.log("getCurrentPrecent....."+ precent0 )
        }
    }

    Text {
        id: title

        anchors {
            left: parent.left
            top: parent.top
            leftMargin: marginLeftAndRight  
            topMargin: marginTitle2Top  
        }

        width: 329
        height: 14
        text: i18n("Battery")
        font.pixelSize: 20 
        font.weight: Font.Bold
    }

    JProgress {
        id: battery_progress

        anchors {
            top: title.bottom
            left: parent.left
            topMargin: marginItem2Title  
            leftMargin: marginLeftAndRight  
            right: parent.right
            rightMargin: marginLeftAndRight  
        }
        
        widgetWidth: parent.width - marginLeftAndRight * 2  
        widgetHeight: 133  
        totalPower: 100
        leftPower: pmSource2.data["Battery"]["Percent"]
        remainingString: getRemainTimeString()
        isCharging: currentBatteryState == "Charging"

        PlasmaCore.DataSource {
            id: pmSource2
            engine: "powermanagement"
            connectedSources: ["Battery", "AC Adapter"]
        }
    }
}
