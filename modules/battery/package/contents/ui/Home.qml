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
import BatteryUtil 1.0

Rectangle {

    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale
    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36  * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale
    property int radiusCommon: 10  * appScale
    property int fontNormal: 14 *appFontSize
    property double precent : pmSource.data["Battery"]["Percent"]
    property int remainingTime: pmSource.data["Battery"]["Remaining msec"]
    property int fullTime: pmSource.data["Battery"]["Full msec"]
    property bool chargingStatus : isPlugInsert()

    anchors.fill: parent

    color: Kirigami.JTheme.settingMinorBackground




    function isPlugInsert() {
        if(!pmSource.data["AC Adapter"])
            return false;
        return pmSource.data["AC Adapter"]["Plugged in"];
    }

    function getRemainTimeString() {
        var msec = 0
        var totalMins = 0
        var hours = 0
        var mins = 0
        var info = ""

        if (isPlugInsert()) {
            //msec = batteryUtil.getFullTime() * 1000;

            msec = fullTime * 1000;
            totalMins = Math.floor(msec / (60 * 1000))
            hours = Math.floor(totalMins / 60)
            mins = totalMins % 60

            if (hours > 0 && mins > 0) {
                info = i18n("%1h %2m until fully charged", hours, mins)
            } else if (hours > 0 && mins === 0) {
                info = i18n("%1h until fully charged", hours)
            } else if (mins > 0) {
                info = i18n("%1m until fully charged", mins)
            } else {
                if (precent !== 100) { // Ignore invalid values
                    info = i18n("Computing...")
                    battery_progress.remainingString = info
                    return
                }
                info = i18n("Already full")
            }
        } else {
            //msec = batteryUtil.getRemainTime() * 1000;
            msec = remainingTime * 1000
            totalMins = Math.floor(msec / (60 * 1000))
            hours = Math.floor(totalMins / 60)
            mins = totalMins % 60
            if (hours > 0 && mins > 0) {
                info = i18n("%1h %2m remaining", hours, mins)
            } else if (hours > 0 && mins === 0) {
                info = i18n("%1h remaining", hours)
            } else {
                if(msec == 0)
                {
                    info = i18n("Computing...")
                    battery_progress.remainingString = info
                    return
                }

                info = i18n("%1m remaining", mins)
            }
        }
        battery_progress.remainingString = info
    }

    onPrecentChanged: {
          getRemainTimeString()
    }

    onRemainingTimeChanged: {
        getRemainTimeString()
    }

    onFullTimeChanged: {
        getRemainTimeString()
    }

    Text {
        id: title

        anchors {
            left: parent.left
            top: parent.top
            leftMargin: marginLeftAndRight
            topMargin: marginTitle2Top
        }

        width: 329 * appScale
        height: 14 * appScale
        text: i18n("Battery")
        font.pixelSize: 20 *appFontSize
        font.weight: Font.Bold
        color: Kirigami.JTheme.majorForeground
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
        widgetHeight: 133  * appScale
        totalPower: 100
        leftPower: precent
        isCharging: isPlugInsert()
    }
}
