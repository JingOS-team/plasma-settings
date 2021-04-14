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


Item {
    id: time_root

    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property real appScale: 1.3 * screenWidth / 1920
    property int appFontSize: theme.defaultFont.pointSize

    property string currentTime : Qt.formatTime(kcm.currentTime, Locale.ShortFormat)

    // width: screenWidth * 0.7
    // height: screenHeight

    width: parent.width
    height: parent.height
    Component.onCompleted: {
    }

    Rectangle {
        anchors.fill:parent
        color: "#FFF6F9FF"

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
            text: "Date & Time"
            font.pointSize: appFontSize + 11
            font.weight: Font.Bold
        }

        Rectangle {
            id: time_format_area

            anchors {
                left: parent.left
                top: title.bottom
                leftMargin: 72 * appScale
                topMargin: 44 * appScale
            }

            width: parent.width - 144 * appScale
            height: 69 * appScale
            color: "#fff"
            radius: 15 * appScale

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 32 * appScale
                }

                text: "24-Hour Time"
                font.pointSize: appFontSize + 2
            }

            Kirigami.JSwitch {
                // Switch{
                    id: time_format_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 34 * appScale
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
                leftMargin: 72 * appScale
                topMargin: 36 * appScale
            }

            width: parent.width - 144 * appScale
            height: 69 * 2 * appScale

            color: "#fff"
            radius: 15 * appScale

            Rectangle {
                id: time_auto_area

                anchors {
                    left: parent.left
                    top : parent.top
                }

                width: parent.width
                height: 69 * appScale
                color: "transparent"

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 32 * appScale
                    }

                    text: "Set Automatically"
                    font.pointSize: appFontSize + 2
                }

                Kirigami.JSwitch {
                    // Switch{
                    id: time_auto_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 34 * appScale
                    }
                    checked: kcm.useNtp
                    onCheckedChanged: {
                        kcm.useNtp = checked;
                        if (!checked) {
                            kcm.ntpServer = ""
                            kcm.saveTime()
                        }
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 31 * appScale
                    anchors.rightMargin: 31 * appScale
                    height: 1 * appScale
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
                height: 69 * appScale
                color: "transparent"

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 32 * appScale
                    }

                    text: "Time Zone"
                    font.pointSize: appFontSize + 2
                }

               Image {
                    id: item_arrow

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 34 * appScale
                    }

                    sourceSize.width: 34 * appScale
                    sourceSize.height: 34 * appScale
                    source: "../image/icon_right.png"
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: item_arrow.left
                        leftMargin: 8 * appScale
                    }
                    color:"#99000000"
                    text: kcm.timeZone
                    font.pointSize: appFontSize + 2
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked:{
                        console.log("..TimeZone.. Clicked")
                        // timeZonePickerSheet.open()
                        main.gotoPage("timezone_view")
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 31 * appScale
                    anchors.rightMargin: 31 * appScale
                    height: 1 * appScale
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
                height: 69 * appScale
                color: "transparent"

                Text {
                    id: date_txt
                    width: 312 * appScale
                    height: 26 * appScale
                    font.pointSize: appFontSize + 2
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
                    width: 312 * appScale
                    height: 26 * appScale
                    font.pointSize: appFontSize + 2
                    anchors.right: parent.right
                    anchors.rightMargin: 34 * appScale
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

            // PopupEventEditor {
            //     id:popupEventEditor
            // }
        }
    }

/*     Kirigami.OverlaySheet {
        id: timeZonePickerSheet
       

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
            // enabled: !time_auto_switch.checked
            enabled: true

            twentyFour: time_format_switch.checked

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
            enabled: !time_auto_switch.checked

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
    } */
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
