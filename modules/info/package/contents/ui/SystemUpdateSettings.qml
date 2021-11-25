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
    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36  * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale
    property int radiusCommon: 10  * appScale
    property int fontNormal: 14 * appFontSize

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

        color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"

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

            // Image {
            //     id: back_icon

            //     anchors.verticalCenter: parent.verticalCenter

            //     width: statusbar_icon_size
            //     height: width
            //     sourceSize.width: width
            //     sourceSize.height: width
            //     source: "../image/icon_left.png"

            //     MouseArea {
            //         anchors.fill: parent

            //         onClicked: {
            //             system_info_root.popView()
            //         }
            //     }
            // }

             Kirigami.JIconButton {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: (22 + 8) * appScale
                height: width
                source: Qt.resolvedUrl("../image/icon_left.png")
                color: Kirigami.JTheme.iconForeground
                // sourceSize.width: width
                // sourceSize.height: width
                onClicked: {
                    system_info_root.popView()
                }
             }

             Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9  * appScale
                }

                width: 359 * appScale
                height: 14 * appScale
                text: i18n("Update Settings")
                // font.pointSize: appFontSize + 11
                font.pixelSize: 20 *  appFontSize
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                color: Kirigami.JTheme.majorForeground
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

            color: Kirigami.JTheme.cardBackground//"#fff"
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
                color: Kirigami.JTheme.majorForeground
            }

            Text {
                id: selectText
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: item_arrow.left
                    rightMargin: 8 * appScale
                }

                text: dimTime
                // font.pointSize: appFontSize + 2
                font.pixelSize: fontNormal
                color: Kirigami.JTheme.minorForeground//"#99000000"
            }

             Kirigami.JIconButton {
                id: item_arrow

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                width: 30 * appScale
                height: 30 * appScale

                visible: withArrow
                source: Qt.resolvedUrl("../image/icon_right.png")
                color: Kirigami.JTheme.iconMinorForeground
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    selectDialog.px = sleep_area.x + sleep_area.width - selectDialog.width
                    selectDialog.py = sleep_area.y + sleep_area.height/2 + selectText.contentHeight/2
                    selectDialog.selectIndex = getIndex(dimTime)
                    selectDialog.open()

                    // selectDialog.popup(sleep_area.x + sleep_area.width - selectDialog.width, 
                    //     sleep_area.y - selectDialog.height)
                }
            }
        }

        // Kirigami.JPopupMenu{
        //     id:selectDialog

        //     property int selectIndex : getIndex(dimTime)
        //     width: Kirigami.JDisplay.dp(240)
        //     blurBackground.arrowX: selectDialog.width * 0.7
        //     blurBackground.arrowY: 0
        //     blurBackground.arrowWidth: Kirigami.JDisplay.dp(16)
        //     blurBackground.arrowHeight: Kirigami.JDisplay.dp(11)
        //     blurBackground.arrowPos: Kirigami.JRoundRectangle.ARROW_BOTTOM

        //     textPointSize: Kirigami.JDisplay.sp(10.5)
        //     iconHeight: Kirigami.JDisplay.dp(22)
        //     Action {
        //             text: i18n("Every day")
        //             icon.source: selectDialog.selectIndex === 0 ? "../image/menu_select.png" : ""
        //             onTriggered:{
        //                 selectDialog.selectIndex = 0;
        //                 dimTime = i18n("Every day")
        //                  setIdleTime(24 * 60 * 60 * 1000)
        //                 // setIdleTime(2 * 60)
        //             }
        //         }

        //         Kirigami.JMenuSeparator { }

        //         Action {
        //             text: i18n("Every two days")
        //             icon.source:selectDialog.selectIndex === 1 ? "../image/menu_select.png" : ""
        //             onTriggered:{
        //                 selectDialog.selectIndex = 1;
        //                 dimTime = i18n("Every two days")
        //                 setIdleTime(24 * 60 * 60 * 1000 * 2)
        //             }
        //         }

        //         Kirigami.JMenuSeparator { }
        //         Action {
        //             text: i18n("Weekly")
        //             icon.source: selectDialog.selectIndex === 2 ? "../image/menu_select.png" : ""
        //             onTriggered:{
        //                 selectDialog.selectIndex = 2;
        //                 dimTime = i18n("Weekly")
        //                 setIdleTime(24 * 60 * 60 * 1000 * 7)
        //             }
        //         }

        //         Kirigami.JMenuSeparator { }
        //         Action {
        //             text: i18n("Every two weeks")
        //             icon.source: selectDialog.selectIndex === 3 ? "../image/menu_select.png" : ""
        //             onTriggered:{
        //                 selectDialog.selectIndex = 3;
        //                 dimTime = i18n("Every two weeks")
        //                  setIdleTime(24 * 60 * 60 * 1000 * 14)
        //                 // setIdleTime(15 * 60)
        //             }
        //         }

        //         Kirigami.JMenuSeparator { }

        //         Action {
        //             text: i18n("Never")
        //             icon.source: selectDialog.selectIndex === 4 ? "../image/menu_select.png" : ""
        //             onTriggered:{
        //                 selectDialog.selectIndex = 4;
        //                 dimTime = i18n("Never")
        //                 setIdleTime(-1)
        //             }
        //         }
        // }

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
                    setIdleTime(-1)
                    break
                }
            }
        }
    }
}
