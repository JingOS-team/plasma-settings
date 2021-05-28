/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.jingos.info 1.0

Item {
    id: legal_sub

    // property real appScale: 1.3 * parent.width / (1920 * 0.7)
    // property int appFontSize: theme.defaultFont.pointSize
    property string dimTime: "Every day"
    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property int radiusCommon: 10 
    property int fontNormal: 14

    UpdateTool {
        id: updateTool
    }

    Component.onCompleted: {
        var cycle = updateTool.getCheckCycle()
        console.log("current cycle is ", cycle)
        switch (cycle) {
        case 24 * 60 * 60 * 1000:
            dimTime = i18n("Every day")
            break
        case 24 * 60 * 60 * 1000 * 2:
            dimTime = i18n("Every two days")
            break
        case 24 * 60 * 60 * 1000 * 7:
            dimTime = i18n("Weekly")
            break
        case 24 * 60 * 60 * 1000 * 14:
            dimTime = i18n("Every two weeks")
            break
        case 24 * 60 * 60 * 1000 * 15:
            dimTime = i18n("Never")
            break
        default:
            dimTime = i18n("Every day")
            break
        }
        console.log("current dimTime is ", dimTime)
    }

    Timer {
        id: helloTimer2

        interval: 200 //定时周期
        repeat: false
        triggeredOnStart: false

        onTriggered: {
            // int cycle = updateTool.getCheckCycle()
            // int cycle = 24 * 3600 * 1000
            // var cycle = 3600;
        }
    }

    function getIndex(dimTime) {
        switch (dimTime) {
        case i18n("Every day"):
            return 0
        case i18n("Every two days"):
            return 1
        case i18n("Weekly"):
            return 2
        case i18n("Every two weeks"):
            return 3
        case i18n("Never"):
            return 4
        }
        return 0
    }

    function setIdleTime(val) {
        // 24* 60 * 60 * 1000
        console.log("set idle time : ",val);
        updateTool.setCheckCycle(val)
    }

    Rectangle {
        width: parent.width
        height: parent.height

        color: "#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: statusbar_height
            color: "transparent"

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: statusbar_icon_size
                height: width
                sourceSize.width: width
                sourceSize.height: width

                source: "../image/icon_left.png"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        system_info_root.popView()
                    }
                }
            }

             Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 
                }

                width: 359
                height: 14
                text: i18n("Update Settings")
                // font.pointSize: appFontSize + 11
                font.pixelSize: 20
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle {
            id: sleep_area

            anchors {
                left: parent.left
                top: page_statusbar.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height

            color: "#fff"
            radius: radiusCommon

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 32 * appScale
                }

                text: i18n("Automatically check for updates ")
                // font.pointSize: appFontSize + 2
                font.pixelSize: fontNormal
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                text: dimTime
                // font.pointSize: appFontSize + 2
                font.pixelSize: fontNormal
                color: "#99000000"
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

        JrDialog {
            id: selectDialog
            
            onMenuSelectChanged: {
                switch (value) {
                case 0:
                    dimTime = i18n("Every day")
                    setIdleTime(24 * 60 * 60 * 1000)
                    break
                case 1:
                    dimTime = i18n("Every two days")
                    setIdleTime(24 * 60 * 60 * 1000 * 2)
                    break
                case 2:
                    dimTime = i18n("Weekly")
                    setIdleTime(24 * 60 * 60 * 1000 * 7)
                    break
                case 3:
                    dimTime = i18n("Every two weeks")
                    setIdleTime(24 * 60 * 60 * 1000 * 14)
                    break
                case 4:
                    dimTime = i18n("Never")
                    setIdleTime(24 * 60 * 60 * 1000 * 15)
                    break
                }
            }
        }
    }
}
