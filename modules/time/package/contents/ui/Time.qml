// -*- coding: iso-8859-1 -*-
/*
 *   Copyright 2011 Sebastian Kügler <sebas@kde.org>
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

import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls 2.3 as Controls

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.kde.timesettings 1.0
import org.jingos.settings.time 1.0


Item {
    id: time_root

    property int screenWidth: 888
    property int screenHeight: 648
    // property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36
    property int marginLeftAndRight : 20
    property int marginItem2Top : 24
    property int radiusCommon: 10 
    property int fontNormal: 14


    // property int screenWidth: Screen.width
    // property int screenHeight: Screen.height
    // property real appScale: 1.3 * screenWidth / 1920
    // property int appFontSize: theme.defaultFont.pointSize

    property string currentTime : Qt.formatTime(kcm.currentTime, Locale.ShortFormat)
    property bool isShown : true 
    property bool isAutoTimeZone : false 
    property bool hasPermission: false 
    property bool isFirstTime : true 
    width: screenWidth * 0.7
    height: screenHeight

    onVisibleChanged: {
        console.log("------onVisibleChanged--------",  visible);
        isShown = visible
    }

    TimeTool {
        id: timeTool1 
        onDlgConfirm : {
            console.log("click confirm ......")
            time_auto_switch.checked = kcm.useNtp
            hasPermission = true 
            console.log("----switch ....hasPermission--1111111111")

            isAutoTimeZone = kcm.useNtp
            if(!isAutoTimeZone){
                kcm.ntpServer = ""
                kcm.saveTime()
            }
        }

        onDlgCancel : {
            console.log("click cancel ......")
            // time_auto_switch.checked = isAutoTimeZone
            hasPermission = false  
        }

    }

    Component.onCompleted: {
        isAutoTimeZone = kcm.useNtp
        // isOrignValue = kcm.useNtp 
        time_auto_switch.checked = isAutoTimeZone
    }

    Rectangle {
        anchors.fill:parent
        color: "#FFF6F9FF"

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
            text: i18n("Date & Time")
            // font.pointSize: appFontSize + 11
            font.pixelSize: 20 
            font.weight: Font.Bold
        }

        Rectangle {
            id: time_format_area

            anchors {
                left: parent.left
                top: title.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height
            color: "#fff"
            radius: 10

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("24-Hour Time")
                // font.pointSize: appFontSize + 2
                font.pixelSize: fontNormal

            }

            Kirigami.JSwitch {
                // Switch{
                    id: time_format_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    checked: kcm.twentyFour
                    onCheckedChanged: {
                        kcm.twentyFour = checked
                        print(kcm.timeZone);
                    }
                }
        }


        Rectangle {
            id: time_settings_area

            anchors {
                left: parent.left
                top: time_format_area.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height * 2

            color: "#fff"
            radius: 10

            Rectangle {
                id: time_auto_area

                anchors {
                    left: parent.left
                    top : parent.top
                }

                width: parent.width
                height: default_setting_item_height
                color: "transparent"

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Set Automatically")
                    // font.pointSize: appFontSize + 2
                    font.pixelSize: fontNormal
                }

                Kirigami.JSwitch {
                    id: time_auto_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }

                    MouseArea {
                        anchors.fill :parent
                        onClicked :{
                            kcm.useNtp = !kcm.useNtp

                            if(hasPermission){
                                console.log("----switch ....hasPermission--")
                                time_auto_switch.checked = kcm.useNtp
                                isAutoTimeZone = kcm.useNtp
                                if(!isAutoTimeZone){
                                    kcm.ntpServer = ""
                                    kcm.saveTime()
                                }
                            } else {
                                 console.log("----switch ....has not Permission--")
                            }
                        }
                    }
                    // checked: kcm.useNtp
                    onCheckedChanged: {
                        console.log("----onCheckedChanged--")
                        // 记录怎么获取当前是否有系统权限
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: marginLeftAndRight
                    anchors.rightMargin: marginLeftAndRight
                    height: 1 
                    color: "#f0f0f0"
                }
            }

            Rectangle {
                id: time_zonearea

                anchors {
                    left: parent.left
                    top: time_auto_area.bottom
                }

                width: parent.width
                height: default_setting_item_height
                color: "transparent"

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Time Zone")
                    // font.pointSize: appFontSize + 2
                    font.pixelSize: fontNormal
                    color: kcm.useNtp ? "#99000000":"black"
                }

               Image {
                    id: item_arrow

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }

                    sourceSize.width: 17
                    sourceSize.height: 17
                    source: "../image/icon_right.png"
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: item_arrow.left
                        leftMargin: 9
                    }
                    color:kcm.useNtp ? "#77000000":"#99000000"
                    text: kcm.timeZone
                    // font.pointSize: appFontSize + 2
                    font.pixelSize: fontNormal
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:{
                        if(kcm.useNtp){
                          return   
                        }
                        console.log("..TimeZone.. Clicked")
                        // timeZonePickerSheet.open()
                        main.gotoPage("timezone_view")
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: marginLeftAndRight
                    anchors.rightMargin: marginLeftAndRight
                    height: 1 
                    color: "#f0f0f0"
                }
            }

            Rectangle {
                id: time_date_area
                visible:false

                anchors {
                    left: parent.left
                    top: time_zonearea.bottom
                }

                width: parent.width
                height: default_setting_item_height
                color: "transparent"

                Text {
                    id: date_txt
                    width: 312 
                    height: 17
                    // font.pointSize: appFontSize + 2
                    font.pixelSize :17
                    anchors.centerIn: parent 
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(kcm.currentDate, Locale.ShortFormat);
                    color: "#FF3C4BE8"

                    MouseArea {
                        anchors.fill:parent
                        onClicked:{
                            console.log("..Date.. Clicked")
                            // datePickerSheet.open()
                        }
                    }
                }

                Text {
                    id: time_txt
                    width: 312 
                    height: 17
                    // font.pointSize: appFontSize + 2
                    font.pixelSize: fontNormal
                    anchors.right: parent.right
                    anchors.rightMargin: marginLeftAndRight
                    anchors.verticalCenter:parent.verticalCenter
                    horizontalAlignment: Text.AlignRight
                    text: currentTime
                    color: "#FF3C4BE8"

                     MouseArea {
                        anchors.fill:parent
                        onClicked:{
                            console.log("..Time.. Clicked")
                            // timePickerSheet.open()
                            popupEventEditor.open()
                        }
                    }
                }
            }
        }
    }
}

/*  SimpleKCM {
    id: timeModule

    Component {
        id: listDelegateComponent

        Kirigami.BasicListItem {
            text: {
                if (model) {
                    if (model.region) {
                        return "%1 / %2".arg(model.region).arg(model.city)
                    } else {
                        return model.city
                    }
                }
                return ""
            }
            onClicked: {
                timeZonePickerSheet.close()
                kcm.saveTimeZone(model.timeZoneId)
            }
        }
    }

    ColumnLayout {
        width: parent.width
        spacing: 0
        id: formLayout

        Kirigami.ListSectionHeader {
            label: i18n("Time Display")
        }

        Kirigami.BasicListItem {
            label: i18n("Use 24-hour clock:")
            icon: "clock"
            onClicked: {
                twentyFourSwitch.checked = !twentyFourSwitch.checked
                twentyFourSwitch.clicked()
            }
            Controls.Switch {
                id: twentyFourSwitch
                checked: kcm.twentyFour
                onClicked: {
                    kcm.twentyFour = checked
                    print(kcm.timeZone);
                }
            }
        }

        Kirigami.BasicListItem {
            label: i18n("Timezone:")
            onClicked: timeZonePickerSheet.open()
            Controls.Label {
                id: timeZoneButton
                text: kcm.timeZone
            }
        }

        Kirigami.ListSectionHeader {
            label: i18n("Set Time and Date")
        }

        Kirigami.BasicListItem {
            label: i18n("Set time automatically:")
            onClicked: {
                ntpCheckBox.checked = !ntpCheckBox.checked
                ntpCheckBox.clicked()
            }

            Controls.Switch {
                id: ntpCheckBox
                checked: kcm.useNtp
                onClicked: {
                    kcm.useNtp = checked;
                    if (!checked) {
                        kcm.ntpServer = ""
                        kcm.saveTime()
                    }
                }
            }
        }

        Kirigami.BasicListItem {
            label: i18n("Time")
            icon: "clock"
            onClicked: timePickerSheet.open()
            Controls.Label {
                text: {
                    Qt.formatTime(kcm.currentTime, Locale.LongFormat)
                }
            }
        }

        Kirigami.BasicListItem {
            label: i18n("Date")
            icon: "view-calendar"
            onClicked: datePickerSheet.open()

            Controls.Label {
                text: {
                    Qt.formatDate(kcm.currentDate, Locale.LongFormat);
                }
            }
        }
    }

    Kirigami.OverlaySheet {
        id: timeZonePickerSheet
        header: ColumnLayout {
            Kirigami.Heading {
                text: i18nc("@title:window", "Pick Timezone")
            }
            Kirigami.SearchField {
                Layout.fillWidth: true
                width: parent.width
                onTextChanged: {
                    kcm.timeZonesModel.filterString = text
                }
            }
        }

        footer: RowLayout {
            Controls.Button {
                Layout.alignment: Qt.AlignHCenter

                text: i18nc("@action:button", "Close")

                onClicked: timeZonePickerSheet.close()
            }
        }
        ListView {
            clip: true
            anchors.fill: parent
            implicitWidth: 18 * Kirigami.Units.gridUnit
            model: kcm.timeZonesModel
            delegate: Kirigami.DelegateRecycler {
                width: parent.width

                sourceComponent: listDelegateComponent
            }
        }
    }

    Kirigami.OverlaySheet {
        id: timePickerSheet
        header:  Kirigami.Heading { text: i18n("Pick Time") }
        TimePicker {
            id: timePicker
            enabled: !ntpCheckBox.checked
            twentyFour: twentyFourSwitch.checked

            implicitWidth: width > Kirigami.Units.gridUnit * 15 ? width : Kirigami.Units.gridUnit * 15

            Component.onCompleted: {
                var date = new Date(kcm.currentTime);
                timePicker.hours = date.getHours();
                timePicker.minutes = date.getMinutes();
                timePicker.seconds = date.getSeconds();
            }
            Connections {
                target: kcm
                onCurrentTimeChanged: {
                    if (timePicker.userConfiguring) {
                        return;
                    }

                    var date = new Date(kcm.currentTime);
                    timePicker.hours = date.getHours();
                    timePicker.minutes = date.getMinutes();
                    timePicker.seconds = date.getSeconds();
                }
            }
            onUserConfiguringChanged: {
                kcm.currentTime = timeString
                kcm.saveTime()
            }
        }
        footer: RowLayout {
            Controls.Button {
                Layout.alignment: Qt.AlignRight

                text: i18nc("@action:button", "Close")

                onClicked: timePickerSheet.close()
            }
        }
    }

    Kirigami.OverlaySheet {
        id: datePickerSheet
        header: Kirigami.Heading { text: i18n("Pick Date") }
        DatePicker {
            id: datePicker
            enabled: !ntpCheckBox.checked

            implicitWidth: width > Kirigami.Units.gridUnit * 15 ? width : Kirigami.Units.gridUnit * 15

            Component.onCompleted: {
                var date = new Date(kcm.currentDate)
                datePicker.day = date.getDate()
                datePicker.month = date.getMonth()+1
                datePicker.year = date.getFullYear()
            }
            Connections {
                target: kcm
                onCurrentDateChanged: {
                    if (datePicker.userConfiguring) {
                        return
                    }

                    var date = new Date(kcm.currentDate)

                    datePicker.day = date.getDate()
                    datePicker.month = date.getMonth()+1
                    datePicker.year = date.getFullYear()
                }
            }
            onUserConfiguringChanged: {
                kcm.currentDate = isoDate
                kcm.saveTime()
            }
        }
        footer: RowLayout {
            Controls.Button {
                Layout.alignment: Qt.AlignRight

                text: i18nc("@action:button", "Close")

                onClicked: datePickerSheet.close()
            }
        }
    }
}  */
