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

    property string darkThemeName: "org.jingos.dark.desktop"
    property string lightThemeName: "org.jingos.light.desktop"
    property bool isDarkTheme: jthemeManager.themeName ===  darkThemeName
    property bool autoBrightness : pmSource.data["PowerDevil"] ? pmSource.data["PowerDevil"]["Auto Brightness"] : false

    // property int screenWidth: 888
    // property int screenHeight: 648

    property int statusbar_height : 22 * appScaleSize
    property int statusbar_icon_size: 22 * appScaleSize
    property int default_setting_item_height: 45 * appScaleSize
    property int default_inner_title_height: 30  * appScaleSize

    property int marginTitle2Top : 44  * appScaleSize
    property int marginItem2Title : 36 * appScaleSize
    property int marginLeftAndRight : 20  * appScaleSize
    property int marginItem2Top : 24  * appScaleSize
    property int radiusCommon: 10  * appScaleSize
    property int fontNormal: 14 * appScaleSize

    onMaxBrightnessChanged:{
        console.log(" maxBrightness changed::" + maxBrightness)
        if(maxBrightness <= 8){
            brightness_slider.to = 255
        } else {
            brightness_slider.to = maxBrightness
        }
    }

    // width: screenWidth * 0.7
    // height: screenHeight



    width: parent.width
    height: parent.height

    Component.onCompleted: {
        getCurrentBright.start()
        console.log(" theme model:" + jthemeManager.themeName)
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
            console.log("brightness......")
            disableBrightnessUpdate = true
            if (maxBrightness == 0) {
                maxBrightness = pmSource.data["PowerDevil"] ? pmSource.data["PowerDevil"]["Maximum Screen Brightness"]
                                                              || 0 : 7500
            }
            brightnessValue = pmSource.data["PowerDevil"]["Screen Brightness"]
            console.log("change value" + brightnessValue + " positiveChange::" + positiveChange)
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
            console.log(" setbrightness::onBrightnessValueChanged:" + disableBrightnessUpdate
            + " brightnessValue::" + brightnessValue)
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
        console.log(" setbrightness::value:" + value)
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
        case -1:
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

    Kirigami.JThemeManager{
        id:jthemeManager
    }

    function setSystemTheme(themeName) {
        console.log(" system theme name:" + jthemeManager.themeName + " set theme name:" + themeName)
        if(jthemeManager.themeName != themeName) {
            jthemeManager.themeName = themeName
            scaleWarningDlg.isUpdateStyle = true
            scaleWarningDlg.open()
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"

        Text {
            id: title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }
            width: 329 * appScaleSize
            height: 14 * appScaleSize
            text: i18n("Display & Brightness")
            color: Kirigami.JTheme.majorForeground
            font.pixelSize: 20 * appFontSize
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
            height: 189 * appScaleSize
            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: radiusCommon
            // visible: false

            Rectangle {
                id: light_area
                width: parent.width /2
                height: parent.height
                color:"transparent"

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
                        setSystemTheme(lightThemeName)
                    }
                }

                Image {
                    id: light_icon
                    width : 130 * appScaleSize
                    height : 95 * appScaleSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:parent.top
                    anchors.topMargin: marginItem2Top
                    // sourceSize.width : width
                    // sourceSize.height : height
                    source: "../image/light_icon.png"
                }

                Text {
                    id:light_txt
                    text: i18n("Light")
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top:light_icon.bottom
                    anchors.topMargin: 6 * appScaleSize
                    font.pixelSize: 14 * appFontSize
                    color: Kirigami.JTheme.majorForeground
                }

                Kirigami.Icon {
                    id: light_select
                    width : 17 * appScaleSize
                    height : 17 * appScaleSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:light_txt.bottom
                    anchors.topMargin:7 * appScaleSize
                    // sourceSize.width : width
                    // sourceSize.height : height
                    source: isDarkTheme ? "qrc:/image/dark_unselect.png" : "qrc:/image/dark_select.png"
                    color: isDarkTheme ? Kirigami.JTheme.majorForeground : "transparent"

                }
            }

            Rectangle {
                id: dark_area
                width: parent.width /2
                height: parent.height
                color:"transparent"
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
                        setSystemTheme(darkThemeName)
                    }
                }

                Image {
                    id:  dark_icon
                    width : 130 * appScaleSize
                    height : 95 * appScaleSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:parent.top
                    anchors.topMargin: marginItem2Top
                    // sourceSize.width : width
                    // sourceSize.height : height
                    source: "../image/dark_icon.png"
                }

                Text {
                    id: dark_txt
                    text: i18n("Dark")
                    anchors.horizontalCenter:parent.horizontalCenter
                    anchors.top:dark_icon.bottom
                    anchors.topMargin: 6 * appScaleSize
                    font.pixelSize: 14 * appFontSize
                    color: Kirigami.JTheme.majorForeground
                }

                Kirigami.Icon {
                    id:  dark_select
                    width : 17 * appScaleSize
                    height : 17 * appScaleSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: dark_txt.bottom
                    anchors.topMargin:7 * appScaleSize
                    // sourceSize.width : width
                    // sourceSize.height : height
                    source: isDarkTheme ? "qrc:/image/dark_select.png" : "qrc:/image/dark_unselect.png"
                    color: isDarkTheme ? "transparent" : Kirigami.JTheme.majorForeground
                }
            }
        }

        Rectangle {
            id: brightness_area

            anchors {
                left: parent.left
                top: dark_theme_item.bottom
                leftMargin: marginLeftAndRight
                // topMargin: marginItem2Top
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height * 2  + default_inner_title_height
            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: 10

            Rectangle {

                id: brightness_title_item

                width: parent.width
                height: default_inner_title_height
                radius: radiusCommon
                color: "transparent"

                Text {
                    id: brightness_title

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: marginLeftAndRight
                    }
                    width: 329 * appScaleSize
                    height: 14 * appScaleSize
                    text: i18n("Brightness")
                    font.pixelSize: 12 * appFontSize
                    color: Kirigami.JTheme.minorForeground//"#4D000000"
                }
            }

            Rectangle {
                id: brightness_top

                anchors.top:brightness_title_item.bottom
                width: parent.width
                height: default_setting_item_height
                color: "transparent"

                Kirigami.Icon {
                    id: ic_small

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: marginLeftAndRight
                    }
                    width: 17 * appScaleSize
                    height: 17 * appScaleSize

                    source: "qrc:/image/brightness_less.png"
                    color: Kirigami.JTheme.minorForeground
                    // sourceSize.width: 17
                    // sourceSize.height: 17
                }

                Kirigami.Icon {
                    id: ic_large

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: marginLeftAndRight
                    }
                    width: 17 * appScaleSize
                    height: 17 * appScaleSize

                    source: "qrc:/image/brightness_more.png"
                    color: Kirigami.JTheme.minorForeground
                    // sourceSize.width: 17
                    // sourceSize.height: 17
                }

                Kirigami.JSlider {
                    id: brightness_slider

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: ic_small.right
                        right: ic_large.left
                        leftMargin: 17 * appScaleSize
                        rightMargin: 17 * appScaleSize
                    }

                    property int tmpValue
                    property bool mousePressed: false


                    value: brightnessValue
                    from: 8
                    to: 255
                    touchDragThreshold: 1

                    onValueChanged: {
                        console.log("  brightness onValueChanged::" + value)
                    }

                    onMoved: {
                        console.log("  brightness onMoved::" + value)
                        if (brightnessValue == -1) {
                            return
                        }
                        tmpValue = value
                        if (mouseEventTimer.running) {
                            mouseEventTimer.restart()
                        } else {
                            mouseEventTimer.start()
                        }
                    }

                    // onPressedChanged: {
                    //     if(pressed){
                    //         brightness_slider.mousePressed = true
                    //         mouseEventTimer.start()
                    //     }else {
                    //         brightness_slider.mousePressed = false
                    //         mouseEventTimer.restart()
                    //     }
                    // }

                     Timer {
                        id: mouseEventTimer
                        interval: 50
                        running: false
                        repeat: false
                        onTriggered: setBrightness(brightness_slider.tmpValue)
                    }
                }
            }

            Rectangle {
                id: brightness_bottom

                anchors.top:brightness_top.bottom
                width: parent.width
                height: default_setting_item_height
                color: "transparent"
                // visible:false

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Automatic")
                    font.pixelSize: fontNormal
                    color: Kirigami.JTheme.majorForeground
                }

                Kirigami.JSwitch {
                    id: auto_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    checked: autoBrightness
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                             displayModel.setAutomatic(!auto_switch.checked)
                        }
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
            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: radiusCommon

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Sleep")
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.majorForeground
            }

            Text {
                id: sleep_text
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: right_icon1.left
                    rightMargin: 8 * appScaleSize
                }

                text: dimTime
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.minorForeground//"#99000000"
            }

            Kirigami.JIconButton {
                id: right_icon1
                width: 30 * appScaleSize
                height: 30 * appScaleSize

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                source: Qt.resolvedUrl("../image/icon_right.png")
                color: Kirigami.JTheme.iconMinorForeground
                // sourceSize.width: 17
                // sourceSize.height: 17
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
//                    selectDialog.px = sleep_area.x + sleep_area.width - selectDialog.width
//                    selectDialog.py = sleep_area.y - selectDialog.height
//                    selectDialog.selectIndex = getIndex(dimTime)

                    selectDialog.popup(sleep_area.x + sleep_area.width - selectDialog.width, sleep_area.y - selectDialog.height + sleep_area.height/2 - sleep_text.contentHeight/2)
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

            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: radiusCommon

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Applications scale")
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.majorForeground
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: right_icon.left
                    rightMargin: 8 * appScaleSize
                }

                text:  scaleValue + "%"
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.minorForeground//"#99000000"
            }

            Kirigami.JIconButton {
                id: right_icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                source: Qt.resolvedUrl("../image/icon_right.png")
                width: 30 * appScaleSize
                height: 30 * appScaleSize
                color: Kirigami.JTheme.iconMinorForeground
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    scaleWarningDlg.isUpdateStyle = false
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

            color: Kirigami.JTheme.cardBackground//"#fff"
            radius: radiusCommon


            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Fonts")
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.majorForeground
            }


            Kirigami.JIconButton {
                id: fonts_right_icon
                width: 30 * appScaleSize
                height: 30 * appScaleSize

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                source: "qrc:/image/icon_right.png"//"../image/icon_right.png"
                color: Kirigami.JTheme.iconMinorForeground
                // sourceSize.width: 17
                // sourceSize.height: 17

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    main.gotoPage("fonts_detail_view")
                }
            }
        }

        Rectangle {
                id: doublueClickRect
                anchors {
                    left: parent.left
                    top: fonts_area.bottom
                    leftMargin: marginLeftAndRight
                    topMargin: marginItem2Top
                }
                width: parent.width - marginLeftAndRight * 2
                height: default_setting_item_height
                color: Kirigami.JTheme.cardBackground
                radius: radiusCommon

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Double-tap to wake")
                    font.pixelSize: fontNormal
                    color: Kirigami.JTheme.majorForeground
                }

                Kirigami.JSwitch {
                    id: double_click_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    checked: kcm.touchDoubleOn
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                             console.log(" double_click_switch:::::checked:" + double_click_switch.checked)
                             kcm.touchDoubleOn = !double_click_switch.checked
                        }
                    }
                }
            }


        Kirigami.JPopupMenu {
            id:selectDialog

            property int selectIndex : getIndex(dimTime)
            width: 240 * appScaleSize
            blurBackground.arrowX: selectDialog.width * 0.7
            blurBackground.arrowY: 0
            blurBackground.arrowWidth: 16 * appScaleSize
            blurBackground.arrowHeight: 11 * appScaleSize
            blurBackground.arrowPos: Kirigami.JRoundRectangle.ARROW_BOTTOM

            textPointSize: 14 * appScaleSize
            iconHeight: 22 * appScaleSize
            Action {
                    text: i18n("2 Minutes")
                    icon.source: selectDialog.selectIndex === 0 ? "../image/menu_select.png" : ""
                    onTriggered:{
                        selectDialog.selectIndex = 0;
                        dimTime = i18n("2 Minutes")
                        setIdleTime(2 * 60)
                    }
                }

                Kirigami.JMenuSeparator { }

                Action {
                    text: i18n("5 Minutes")
                    icon.source:selectDialog.selectIndex === 1 ? "../image/menu_select.png" : ""
                    onTriggered:{
                        selectDialog.selectIndex = 1;
                        dimTime = i18n("5 Minutes")
                        setIdleTime(5 * 60)
                    }
                }

                Kirigami.JMenuSeparator { }
                Action {
                    text: i18n("10 Minutes")
                    icon.source: selectDialog.selectIndex === 2 ? "../image/menu_select.png" : ""
                    onTriggered:{
                        selectDialog.selectIndex = 2;
                        dimTime = i18n("10 Minutes")
                        setIdleTime(10 * 60)
                    }
                }

                Kirigami.JMenuSeparator { }
                Action {
                    text: i18n("15 Minutes")
                    icon.source: selectDialog.selectIndex === 3 ? "../image/menu_select.png" : ""
                    onTriggered:{
                        selectDialog.selectIndex = 3;
                        dimTime = i18n("15 Minutes")
                        setIdleTime(15 * 60)
                    }
                }

                Kirigami.JMenuSeparator { }

                Action {
                    text: i18n("Never")
                    icon.source: selectDialog.selectIndex === 4 ? "../image/menu_select.png" : ""
                    onTriggered:{
                        selectDialog.selectIndex = 4;
                        dimTime = i18n("Never")
                        setIdleTime(-1)
                    }
                }
        }

//        JrDialog {
//            id: selectDialog

//            onMenuSelectChanged: {
//                switch (value) {
//                case 0:
//                    dimTime = i18n("2 Minutes")
//                    setIdleTime(2 * 60)
//                    break
//                case 1:
//                    dimTime = i18n("5 Minutes")
//                    setIdleTime(5 * 60)
//                    break
//                case 2:
//                    dimTime = i18n("10 Minutes")
//                    setIdleTime(10 * 60)
//                    break
//                case 3:
//                    dimTime = i18n("15 Minutes")
//                    setIdleTime(15 * 60)
//                    break
//                case 4:
//                    dimTime = i18n("Never")
//                    setIdleTime(-1)
//                    break
//                }
//            }
//        }

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

            property bool isUpdateStyle: false

            title: isUpdateStyle ? i18n("Restart") : i18n("Set scale ")
            text: isUpdateStyle ? i18n("Change appearance style this setting will restart your PAD") : i18n("Attention, the running apps will be closed to fit new configuration.")
            leftButtonText: i18n("Cancel")
            rightButtonText: isUpdateStyle ? i18n("Restart") : i18n("Set")
            dim: true
            focus: true

            onLeftButtonClicked: {
                if (isUpdateStyle) {
                    jthemeManager.themeName = isDarkTheme ? lightThemeName : darkThemeName
                }
                scaleWarningDlg.close()
            }

            onRightButtonClicked: {
                if (isUpdateStyle) {
                    jthemeManager.saveTheme()
                    kcm.restartDevice()
                } else {
                    selectScaleDialog.px = scale_area.x + scale_area.width - selectScaleDialog.width
                    selectScaleDialog.py = scale_area.y + 45
                    selectScaleDialog.mScaleValue = scaleValue
                    selectScaleDialog.open()
                }
                scaleWarningDlg.close()
            }
        }
    }
}
