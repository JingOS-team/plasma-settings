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

    property real appScale: 1.3 * parent.width / (1920 * 0.7)
    property int appFontSize: theme.defaultFont.pointSize
    property real brightnessValue: -1
    property real scaleValue: 0
    property real initScale: -1
    property int maxScale: 200
    property bool disableBrightnessUpdate: true
    property int maxBrightness: 0
    property int screenDim: 0
    property string dimTime: "2 Minutes"
    property bool positiveChange: false

    width: parent.width
    height: parent.height

    Component.onCompleted: {
        getCurrentBright.start()
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
        var time = 300
        switch (time) {
        case 2 * 60:
            return "2 Minutes"
        case 5 * 60:
            return "5 Minutes"
        case 10 * 60:
            return "10 Minutes"
        case 15 * 60:
            return "15 Minutes"
        case 30 * 60 * 60:
            return "Never"
        default:
            return "2 Minutes"
        }
    }

    function getIndex(dimTime) {
        switch (dimTime) {
        case "2 Minutes":
            return 0
        case "5 Minutes":
            return 1
        case "10 Minutes":
            return 2
        case "15 Minutes":
            return 3
        case "Never":
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
                leftMargin: 72 * appScale
                topMargin: 68 * appScale
            }
            width: 500
            height: 50
            text: i18n("Display & Brightness")
            font.pointSize: appFontSize + 11
            font.weight: Font.Bold
        }

        Text {
            id: brightness_title

            anchors {
                left: parent.left
                top: title.bottom
                leftMargin: 103 * appScale
                topMargin: 42 * appScale
            }
            width: 500
            height: 50
            text: i18n("Brightness")
            font.pointSize: appFontSize - 2
            color: "#4D000000"
        }

        Rectangle {
            id: brightness_area

            anchors {
                left: parent.left
                top: brightness_title.bottom
                leftMargin: 72 * appScale
                topMargin: 18 * appScale
            }

            width: parent.width - 144 * appScale
            height: 69 * appScale
            color: "#fff"
            radius: 15 * appScale

            Rectangle {
                id: brightness_top

                width: parent.width
                height: parent.height
                color: "transparent"

                Image {
                    id: ic_small

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 27 * appScale
                    }

                    source: "../image/brightness_less.png"
                    sourceSize.width: 28 * appScale
                    sourceSize.height: 28 * appScale
                }

                Image {
                    id: ic_large

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 27 * appScale
                    }

                    source: "../image/brightness_more.png"
                    sourceSize.width: 28 * appScale
                    sourceSize.height: 28 * appScale
                }

                Kirigami.JSlider {
                    id: brightness_slider

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: ic_small.right
                        right: ic_large.left
                        leftMargin: 34 * appScale
                        rightMargin: 34 * appScale
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
                leftMargin: 72 * appScale
                topMargin: 36 * appScale
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

                text: i18n("Sleep")
                font.pointSize: appFontSize + 2
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: right_icon1.left
                    rightMargin: 2 * appScale
                }

                text: dimTime
                font.pointSize: appFontSize + 2
                color: "#99000000"
            }

            Image {
                id: right_icon1

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 17 * appScale
                }
                
                source: "../image/icon_right.png"
                sourceSize.width: 34 * appScale
                sourceSize.height: 34 * appScale
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    selectDialog.px = sleep_area.x + sleep_area.width - selectDialog.width
                    selectDialog.py = sleep_area.y + 69 * appScale
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
                leftMargin: 72 * appScale
                topMargin: 36 * appScale
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

                text: i18n("Applications scale")
                font.pointSize: appFontSize + 2
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: right_icon.left
                    rightMargin: 2 * appScale
                }

                text: i18n("%1 %",scaleValue)
                font.pointSize: appFontSize + 2
                color: "#99000000"
            }

            Image {
                id: right_icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 17 * appScale
                }

                source: "../image/icon_right.png"
                sourceSize.width: 34 * appScale
                sourceSize.height: 34 * appScale
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    scaleWarningDlg.open()
                }
            }
        }

        JrDialog {
            id: selectDialog

            onMenuSelectChanged: {
                switch (value) {
                case 0:
                    dimTime = "2 Minutes"
                    setIdleTime(2 * 60)
                    break
                case 1:
                    dimTime = "5 Minutes"
                    setIdleTime(5 * 60)
                    break
                case 2:
                    dimTime = "10 Minutes"
                    setIdleTime(10 * 60)
                    break
                case 3:
                    dimTime = "15 Minutes"
                    setIdleTime(15 * 60)
                    break
                case 4:
                    dimTime = "Never"
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
            leftButtonText: "OK"
            rightButtonText: "Cancel"
            dim: true
            focus: true

            onRightButtonClicked: {
                scaleWarningDlg.close()
            }

            onLeftButtonClicked: {
                selectScaleDialog.px = scale_area.x + scale_area.width - selectScaleDialog.width
                selectScaleDialog.py = scale_area.y + 69 * appScale
                selectScaleDialog.mScaleValue = scaleValue
                selectScaleDialog.open()
                scaleWarningDlg.close()
            }
        }
    }
}
