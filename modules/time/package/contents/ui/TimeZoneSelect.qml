/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Rui Wang <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2

import org.jingos.settings.time 1.0

Item {
    id: timezone_layout

    property string cTimeZone : ""
    property string sTimeZone : ""
    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 22 * appScale
    property int default_setting_item_height: 45 * appScale
    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale
    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36  * appScale
    property int marginLeftAndRight : 20  * appScale
    property int marginItem2Top : 24  * appScale
    property int radiusCommon: 10  * appScale
    property int fontNormal: 14 * appFontSize

    TimeTool {
        id: timeTool
        onDlgConfirm: {
            kcm.saveTimeZone(sTimeZone)
        }
    }

    Component.onCompleted: {
        cTimeZone = kcm.timeZone
    }

    Component {
        id: listDelegateComponent

        Rectangle{
            width: input_parent.width
            height: default_setting_item_height

            color: "transparent"
            Text {
                anchors.verticalCenter:parent.verticalCenter
                font.pixelSize: 17 * appFontSize
                text: {
                    if (model) {
                        if (model.region) {
                            var regionName = model.region
                            if(regionName == i18n("Asia/Taiwan")){
                                regionName = i18n("Asia/Taipei(China)")
                            }
                            else if(regionName == i18n("Asia/台湾")){
                                regionName = i18n("Asia/台湾（中国）")
                            }
                            else if(regionName == i18n("Asia/Hong Kong")){
                                regionName = i18n("Asia/Hong Kong(China)")
                            }
                            else if(regionName == i18n("Asia/香港")){
                                regionName = i18n("Asia/香港（中国）")
                            }
                            else if(regionName == i18n("Asia/Macao")){
                                regionName = i18n("Asia/Macao(China)")
                            }
                            else if(regionName == i18n("Asia/澳门")){
                                regionName = i18n("Asia/澳门（中国）")
                            }
                            return "%1 , %2".arg(model.city).arg(regionName)
                        } else {
                            return model.city
                        }
                    }
                    return ""
                }
                color: Kirigami.JTheme.majorForeground
            }

            Image {
                width: 22 * appScale
                height: width
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 0
                }

                source: "../image/menu_select.png"
                visible: model.timeZoneId == kcm.timeZone ? true : false
            }

            Kirigami.JMenuSeparator {
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
            }

            MouseArea {
                anchors.fill:parent
                onClicked: {
                    sTimeZone = model.timeZoneId
                    kcm.saveTimeZone(sTimeZone)
                    kcm.timeZonesModel.filterString = ""
                    main.popView();
                }
            }
        }
    }

    Rectangle {
        id: root

        width: parent.width
        height: parent.height

        color: Kirigami.JTheme.settingMinorBackground

        Rectangle {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: 48  * appScale
            }

            width: parent.width
            height: 27  * appScale

            color: "transparent"

            Kirigami.JIconButton {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter
                width: (22 + 8) * appScale
                height: (22 + 8) * appScale
                source: Qt.resolvedUrl("../image/icon_left.png")

                onClicked: {
                    kcm.timeZonesModel.filterString = ""
                    popView()
                }
            }

            Text {
                id: confirmBtn

                height: 22  * appScale
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight * 2
                }

                color:"#FF3C4BE8"
                text: i18n(" ")
                font.pixelSize: 17 * appFontSize
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id:input_parent

                height: 36 * appScale
                anchors {
                    left: back_icon.right
                    right: confirmBtn.left
                    leftMargin:marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    verticalCenter: parent.verticalCenter
                }

                color:"transparent"

                Kirigami.JSearchField {
                    id: timezone_input
                    width: parent.width
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 17 *appFontSize
                    focus: true
                    onTextChanged: {
                        kcm.timeZonesModel.filterString = text
                    }
                }
            }
        }

        Rectangle {
            id: time_select_area

            anchors {
                top: page_statusbar.bottom
                left: parent.left
                right: parent.right
                bottom:parent.bottom
                bottomMargin: 2 * appScale
                topMargin: 10 * appScale
            }

            color:"transparent"

            Rectangle {
                id: list_wrap

                height:parent.height - 22 * appScale
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: time_select_area.bottom
                    top: time_select_area.top
                    leftMargin: marginLeftAndRight
                    rightMargin: marginLeftAndRight
                    bottomMargin: 2 * appScale
                    topMargin: 10  * appScale
                }

                color:"transparent"
                clip: true
                ListView {
                    id: tz_list

                    clip: true
                    anchors.fill: parent
                    anchors.leftMargin: marginLeftAndRight * 2
                    implicitWidth: list_wrap.width - marginLeftAndRight * 3
                    model: kcm.timeZonesModel
                    delegate:listDelegateComponent
                }
            }
        }
    }
}
