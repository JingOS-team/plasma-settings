/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import QtQml 2.2
import org.kde.kcm 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import display 1.0

Item {
    id: display_root

    property real brightnessValue: -1
    property real scaleValue: 0
    property real initScale: -1
    property int maxScale: 200
    property bool disableBrightnessUpdate: true
    property int maxBrightness: 0
    property int screenDim: 0
    property string dimTime: "2 Minutes"
    property bool positiveChange: false
    property bool isDarkTheme: false 

    // property int screenWidth: 888
    // property int screenHeight: 648
    property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45
    property int default_inner_title_height: 30 

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property int radiusCommon: 10 
    property int fontNormal: 14

    // width: screenWidth * 0.7
    // height: screenHeight

    

    // property real appScale: 1.3 * parent.width / (1920 * 0.7)
    // property int appFontSize: theme.defaultFont.pointSize
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        getCurrentBright.start()
        isDarkTheme: false 
    }

    DisplayModel {
        id: displayModel

        Component.onCompleted: {
            dimTime = getIdleTime()
            scaleValue = displayModel.getApplicationScale()
            
        }
    }

    Timer {
        id: getCurrentBright

        interval: 200
        repeat: false
        
        onTriggered: {
            brightnessValue = pmSource.data["PowerDevil"]["Screen Brightness"]
            brightness_slider.value = brightnessValue
        }
    }

    onScaleValueChanged: {
        if (initScale == -1) {
            initScale = 1
            return
        }
        displayModel.setApplicationScale(scaleValue)
    }

    PlasmaCore.DataSource {
        id: pmSource

        engine: "powermanagement"
        connectedSources: ["PowerDevil"]

        onSourceAdded: {
            if (source === "PowerDevil") {
                disconnectSource(source)
                connectSource(source)
            }
        }

        onDataChanged: {
            disableBrightnessUpdate = true
            if (maxBrightness == 0) {
                maxBrightness = pmSource.data["PowerDevil"] ? pmSource.data["PowerDevil"]["Maximum Screen Brightness"]
                                                              || 0 : 7500
            }
            brightnessValue = pmSource.data["PowerDevil"]["Screen Brightness"]
            if (positiveChange) {
                positiveChange = false
            } else {
                brightness_slider.value = brightnessValue
            }
            disableBrightnessUpdate = false
        }
    }

    onBrightnessValueChanged: {
        if (!disableBrightnessUpdate) {
            var service = pmSource.serviceForSource("PowerDevil")
            var operation = service.operationDescription("setBrightness")
            operation.brightness = brightnessValue
            operation.silent = true
            service.startOperationCall(operation)
        }
    }

    PlasmaCore.DataSource {
        id: pmSource2

        engine: "powermanagement"
        connectedSources: ["UserActivity"]

        onSourceAdded: {
            if (source === "UserActivity") {
                disconnectSource(source)
                connectSource(source)
            }
        }

        onDataChanged: {
            screenDim = pmSource2.data["UserActivity"]["IdleTime"]
        }
    }

    function setBrightness(value) {
        brightnessValue = value
        positiveChange = true
    }

    function setIdleTime(value) {
        displayModel.setScreenIdleTime(value)
    }

    function getIdleTime() {
        var time = displayModel.getScreenIdleTime()
        console.log("getSystemIdleTime: ",time)
        switch (time) {
        case 2 * 60:
            return i18n("2 Minutes")
        case 5 * 60:
            return i18n("5 Minutes")
        case 10 * 60:
            return i18n("10 Minutes")
        case 15 * 60:
            return i18n("15 Minutes")
        case 30 * 60 * 60:
            return i18n("Never")
        default:
            return i18n("2 Minutes")
        }
    }

    function getIndex(dimTime) {
        switch (dimTime) {
        case i18n("2 Minutes"):
            return 0
        case i18n("5 Minutes"):
            return 1
        case i18n("10 Minutes"):
            return 2
        case i18n("15 Minutes"):
            return 3
        case i18n("Never"):
            return 4
        }
        return 0
    }

    Rectangle {
        width: parent.width
        height: parent.height
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
            text: i18n("Display & Brightness")
            font.pixelSize: 20 
            font.weight: Font.Bold
        }

        Rectangle {
            id: dark_theme_item

            anchors {
                left: parent.left
                top: title.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight* 2
            height: 189
            color: "#fff"
            radius: radiusCommon
            visible: false 

            Rectangle {
                id: light_area
                width: parent.width /2 
                height: parent.height 

                anchors {
                    left: parent.left
                    top: parent.top 
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        if(!isDarkTheme){
                            return 
                        }
                        isDarkTheme = false  
                    }
                }

                Image {
                    id: light_icon
                    width : 130
                    height : 95
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:parent.top
                    anchors.topMargin: marginItem2Top
                    sourceSize.width : width 
                    sourceSize.height : height 
                    source: "../image/light_icon.png"
                }

                Text {
                    id:light_txt
                    text:"Light"
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top:light_icon.bottom
                    anchors.topMargin: 6
                    font.pixelSize: 14

                }

                Image {
                    id: light_select
                    width : 17
                    height : 17
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:light_txt.bottom
                    anchors.topMargin:7
                    sourceSize.width : width 
                    sourceSize.height : height 
                    source: isDarkTheme ? "../image/dark_unselect.png" : "../image/dark_select.png"

                }
            }

            Rectangle {
                id: dark_area
                width: parent.width /2 
                height: parent.height 

                anchors {
                    left: light_area.right 
                    top: parent.top 
                }

                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        if(isDarkTheme){
                            return 
                        }
                        isDarkTheme = true 
                    }
                }

                Image {
                    id:  dark_icon
                    width : 130
                    height : 95
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:parent.top
                    anchors.topMargin: marginItem2Top
                    sourceSize.width : width 
                    sourceSize.height : height 
                    source: "../image/dark_icon.png"
                }

                Text {
                    id: dark_txt
                    text:"Dark"
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top:dark_icon.bottom
                    anchors.topMargin: 6
                    font.pixelSize: 14
                }

                Image {
                    id:  dark_select
                    width : 17
                    height : 17
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: dark_txt.bottom
                    anchors.topMargin:7
                    sourceSize.width : width 
                    sourceSize.height : height 
                    source: isDarkTheme ? "../image/dark_select.png" : "../image/dark_unselect.png"
                }
            }
        }
        
        Rectangle {
            id: brightness_area

            anchors {
                left: parent.left
                top: title.bottom
                leftMargin: marginLeftAndRight
                // topMargin: marginItem2Top
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height + default_inner_title_height
            color: "#fff"
            radius: 10

            Rectangle {

                id: brightness_title_item

                width: parent.width
                height: default_inner_title_height
                radius:10 

                Text {
                    id: brightness_title

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: marginLeftAndRight
                    }
                    width: 329
                    height: 14
                    text: i18n("Brightness")
                    font.pixelSize: 12
                    color: "#4D000000"
                }

            }

            Rectangle {
                id: brightness_top

                anchors.top:brightness_title_item.bottom
                width: parent.width
                height: default_setting_item_height
                color: "transparent"
                    
                Image {
                    id: ic_small

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: marginLeftAndRight
                    }

                    source: "../image/brightness_less.png"
                    sourceSize.width: 17
                    sourceSize.height: 17
                }

                Image {
                    id: ic_large

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: marginLeftAndRight
                    }

                    source: "../image/brightness_more.png"
                    sourceSize.width: 17
                    sourceSize.height: 17
                }

                Kirigami.JSlider {
                    id: brightness_slider

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: ic_small.right
                        right: ic_large.left
                        leftMargin: 17
                        rightMargin: 17
                    }

                    value: brightnessValue
                    from: 8
                    to: maxBrightness
                    onValueChanged: {
                        if (brightnessValue == -1) {
                            return
                        }
                        setBrightness(value)
                    }
                }
            }
        }

        Rectangle {
            id: sleep_area

            anchors {
                left: parent.left
                top: brightness_area.bottom
                 leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight* 2
            height: default_setting_item_height
            color: "#fff"
            radius: radiusCommon

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Sleep")
                font.pixelSize: fontNormal
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: right_icon1.left
                    rightMargin: 8
                }

                text: dimTime
                font.pixelSize: fontNormal
                color: "#99000000"
            }

            Image {
                id: right_icon1

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }
                
                source: "../image/icon_right.png"
                sourceSize.width: 17
                sourceSize.height: 17
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    selectDialog.px = sleep_area.x + sleep_area.width - selectDialog.width
                    selectDialog.py = sleep_area.y + 45
                    selectDialog.selectIndex = getIndex(dimTime)
                    selectDialog.open()
                }
            }
        }

        Rectangle {
            id: scale_area

            anchors {
                left: parent.left
                top: sleep_area.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height
            visible:false 

            color: "#fff"
            radius: radiusCommon

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Applications scale")
                font.pixelSize: fontNormal
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: right_icon.left
                    rightMargin: 8
                }

                text:  scaleValue + "%" 
                font.pixelSize: fontNormal
                color: "#99000000"
            }

            Image {
                id: right_icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                source: "../image/icon_right.png"
                sourceSize.width: 17
                sourceSize.height: 17
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    scaleWarningDlg.open()
                }
            }
        }

        Rectangle {
            id: fonts_area

            anchors {
                left: parent.left
                // top: scale_area.bottom
                top: sleep_area.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height

            color: "#fff"
            radius: radiusCommon


            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Fonts")
                font.pixelSize: fontNormal
            }


            Image {
                id: fonts_right_icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                source: "../image/icon_right.png"
                sourceSize.width: 17
                sourceSize.height: 17

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main.gotoPage("fonts_detail_view")
                }
            }
        }

        JrDialog {
            id: selectDialog

            onMenuSelectChanged: {
                switch (value) {
                case 0:
                    dimTime = i18n("2 Minutes")
                    setIdleTime(2 * 60)
                    break
                case 1:
                    dimTime = i18n("5 Minutes")
                    setIdleTime(5 * 60)
                    break
                case 2:
                    dimTime = i18n("10 Minutes")
                    setIdleTime(10 * 60)
                    break
                case 3:
                    dimTime = i18n("15 Minutes")
                    setIdleTime(15 * 60)
                    break
                case 4:
                    dimTime = i18n("Never")
                    setIdleTime(10 * 24 * 60 * 60)
                    break
                }
            }
        }

        JrScaleDialog {
            id: selectScaleDialog

            onMenuSelectChanged: {
                if (scaleValue != value) {
                    console.log("Change Application Scale")
                    scaleValue = value
                }
            }
        }

        Kirigami.JDialog {
            id: scaleWarningDlg

            anchors.centerIn: parent
            title: i18n("Set scale ")
            text: i18n("Attention, the running apps will be closed to fit new configuration.")
            leftButtonText: i18n("Cancel")
            rightButtonText: i18n("Set")
            dim: true
            focus: true

            onLeftButtonClicked: {
                scaleWarningDlg.close()
            }

            onRightButtonClicked: {
                selectScaleDialog.px = scale_area.x + scale_area.width - selectScaleDialog.width
                selectScaleDialog.py = scale_area.y + 45
                selectScaleDialog.mScaleValue = scaleValue
                selectScaleDialog.open()
                scaleWarningDlg.close()
            }
        }
    }
}
