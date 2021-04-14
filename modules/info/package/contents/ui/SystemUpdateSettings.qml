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

    property real appScale: 1.3 * parent.width / (1920 * 0.7)
    property int appFontSize: theme.defaultFont.pointSize
    property string dimTime: "Every day"

    width: parent.width
    height: parent.height

    UpdateTool {
        id: updateTool
    }

    Component.onCompleted: {
        var cycle = updateTool.getCheckCycle()

        switch (cycle) {
        case 24 * 60 * 60 * 1000:
            dimTime = "Every day"
            break
        case 24 * 60 * 60 * 1000 * 2:
            dimTime = "Every two days"
            break
        case 24 * 60 * 60 * 1000 * 7:
            dimTime = "Weekly"
            break
        case 24 * 60 * 60 * 1000 * 14:
            dimTime = "Every two weeks"
            break
        case 24 * 60 * 60 * 1000 * 10000:
            dimTime = "Never"
            break
        default:
            dimTime = "Every day"
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
        case "Every day":
            return 0
        case "Every two days":
            return 1
        case "Weekly":
            return 2
        case "Every two weeks":
            return 3
        case "Never":
            return 4
        }
        return 0
    }

    function setIdleTime(val) {
        // 24* 60 * 60 * 1000
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
                leftMargin: 34 * system_info_root.appScale
                topMargin: 68 * system_info_root.appScale
            }

            width: 400 * appScale
            height: 41 * appScale
            color:"transparent"

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: 34 * appScale
                height: width
                sourceSize.width: width
                sourceSize.height: width

                source: "../image/icon_left.png"

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("back..about")
                        system_info_root.popView()
                    }
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 * appScale
                }

                width: 500
                height: 50

                text: i18n("Update Settings")
                font.pointSize: appFontSize + 11
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }
        }

        Rectangle {
            id: sleep_area

            anchors {
                left: parent.left
                top: page_statusbar.bottom
                leftMargin: 72 * appScale
                topMargin: 36 * 2 * appScale
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

                text: i18n("Automatically check for updates ")
                font.pointSize: appFontSize + 2
            }

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 34 * appScale
                }

                text: dimTime
                font.pointSize: appFontSize + 2
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
                    dimTime = "Every day"
                    setIdleTime(24 * 60 * 60 * 1000)
                    break
                case 1:
                    dimTime = "Every two days"
                    setIdleTime(24 * 60 * 60 * 1000 * 2)
                    break
                case 2:
                    dimTime = "Weekly"
                    setIdleTime(24 * 60 * 60 * 1000 * 7)
                    break
                case 3:
                    dimTime = "Every two weeks"
                    setIdleTime(24 * 60 * 60 * 1000 * 14)
                    break
                case 4:
                    dimTime = "Never"
                    setIdleTime(24 * 60 * 60 * 1000 * 10000)
                    break
                }
            }
        }
    }
}
