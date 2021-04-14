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
        var totalMins = Math.floor(msec / (60 * 1000))
        var hours = Math.floor(totalMins / 60)
        var mins = totalMins % 60
        return hours + "h " + mins + "m "
    }

    Text {
        id: title

        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 72 * appScale
            topMargin: 68 * appScale
        }

        width: 500
        height: 50
        text: i18n("Battery")
        font.pointSize: appFontSize + 11
        font.weight: Font.Bold
    }

    JProgress {
        id: battery_progress

        anchors {
            top: title.bottom
            left: parent.left
            topMargin: 42 * appScale
            leftMargin: 72 * appScale
            right: parent.right
            rightMargin: 72 * appScale
        }
        
        widgetWidth: parent.width - 72 * 2 * appScale
        widgetHeight: 205 * appScale

        totalPower: 100
        leftPower: getBatteryData("Percent", 50)
        remainingString: getRemainTimeString()
        isCharging: currentBatteryState == "Charging"
    }
}
