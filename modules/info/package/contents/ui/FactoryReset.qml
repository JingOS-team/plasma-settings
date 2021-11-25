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
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: display_sub

    property int marginLeftAndRight : 14  * appScale
    property string currentBatteryState: getBatteryData('State', false)
    property bool isCharging: currentBatteryState == "Charging"
    property var currentBattery: pmSource2.data["Battery"]["Percent"]

    width: parent.width
    height: parent.height

    Rectangle {
        anchors.fill: parent

        width: parent.width
        height: parent.height
        color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            width: parent.width
            height: 22 * appScale
            color: "transparent"

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 20 * appScale
                topMargin: 44 * appScale
            }

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
                    verticalCenter: back_icon.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 * appScale
                }

                width: 500 * appScale
                text: i18n("Factory Reset")
                font.pixelSize: 20 * appFontSize
                font.weight: Font.Bold
                color: Kirigami.JTheme.majorForeground
            }
        }

        Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                top: page_statusbar.bottom
                leftMargin: 20 * appScale
                rightMargin: 20 * appScale
                topMargin: 18 * appScale
            }

            height: 200 * appScale
            radius: 15 * appScale
            color:"transparent"

            Text {
                id: legal_content
                
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    leftMargin: marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    topMargin: marginLeftAndRight
                    bottomMargin: marginLeftAndRight
                }

                width: parent.width - marginLeftAndRight * 2
                wrapMode: Text.WordWrap
                font.pixelSize: 16  * appFontSize
                maximumLineCount: 10
                color: Kirigami.JTheme.majorForeground
                text: i18n("This will delete all data from your device, including:\n·Photos and videos\n·Music \n·Apps \n·Backups \n·System data and settings \n·All files in memory")
            }
        }

        Rectangle{
            id:resetButton
            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 41 * appScale
            }
            color:Kirigami.JTheme.highlightColor//"#3C4BE8"
            width: 284 * appScale
            height: 42 * appScale
            radius: 7 * appScale

            Text{
                id: resetText
                anchors.centerIn: parent
                text:i18n("Reset")
                font.pixelSize: 14 * appFontSize
                color:"#FFFFFF"
            }

            MouseArea{
                anchors.fill: parent
                onClicked:{
                    console.log("  reset system isCharging:" + isCharging + " currentBattery:" + currentBattery)
                    if(isCharging || currentBattery >= 50){
                        kcm.resetSystem()
                    } else {
                        confirmDlg.open()
                    }
                }
            }
        }

    }

    PlasmaCore.DataSource {
        id: pmSource

        engine: "powermanagement"
        connectedSources: ["Battery"]
    }

     PlasmaCore.DataSource {
        id: pmSource2
        engine: "powermanagement"
        connectedSources: ["Battery", "AC Adapter"]
    }

    function getBatteryData(key, def) {
        var value = pmSource.data.Battery[key]
        if (typeof value === 'undefined') {
            return def
        } else {
            return value
        }
    }


    Kirigami.JDialog {
        id: confirmDlg

        title: i18n("Insufficient Charge")
        text: i18n("This restore requires at least 50% battery or to be connected to a power source.")
        leftButtonText: i18n("")
        rightButtonText: i18n("")
        centerButtonText: i18n("OK")
        dim: true
        focus: true
        onCenterButtonClicked:{
            confirmDlg.close()
        }

    }
}
