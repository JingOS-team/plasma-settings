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

    property int appFontSize: theme.defaultFont.pointSize
    property string cTimeZone : "" 
    property string sTimeZone : ""
    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45
    property int screenWidth: 888
    property int screenHeight: 648
    property int marginTitle2Top : 44 
    property int marginItem2Title : 36 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 
    property int radiusCommon: 10 
    property int fontNormal: 14

    width: parent.width
    height: parent.height

    TimeTool {
        id: timeTool 
        onDlgConfirm : {
            console.log("onDlgConfirm");
            kcm.saveTimeZone(sTimeZone)
        }

        onDlgCancel : {
            console.log("onDlgCancel");
            // kcm.saveTimeZone(cTimeZone)
        }

    }

    Component.onCompleted : {
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
                font.pixelSize: 17
                text: {
                    if (model) {
                        if (model.region) {
                            return "%1 , %2".arg(model.city).arg(model.region)
                        } else {
                            return model.city
                        }
                    }
                    return ""
                }
            }

            Image {
                source:"../image/menu_select.png"
                width: 22 
                height:width
                anchors{
                    verticalCenter:parent.verticalCenter
                    right:parent.right
                    rightMargin:0 
                }
                visible: model.timeZoneId == kcm.timeZone ? true : false 
            }

            Kirigami.Separator {
                anchors.bottom:parent.bottom
                anchors.left:parent.left
                anchors.right: parent.right
                height: 1 
                color: "#f0f0f0"
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

        color: "#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight 
                topMargin: 48 
            }

            width: parent.width
            height: 27 

            color: "transparent"

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter
                width: 22 
                height: width
                source: "../image/icon_left.png"
                sourceSize.width: width
                sourceSize.height: width

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("back..about")
                        kcm.timeZonesModel.filterString = ""
                        popView()
                    }
                }
            }

            Text {
                id: confirmBtn

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight * 2 
                }

                height: 22 
                color:"#FF3C4BE8"
                text: i18n(" ")
                font.pixelSize: 17
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id:input_parent
                
                height: 36
                color:"transparent"

                anchors {
                    left: back_icon.right
                    right: confirmBtn.left
                    leftMargin:marginLeftAndRight 
                    rightMargin: marginLeftAndRight 
                    verticalCenter: parent.verticalCenter
                }

                Kirigami.JSearchField {
                    id: timezone_input
                    width: parent.width
                    anchors.verticalCenter:parent.verticalCenter
                    font.pixelSize: 17
                    bgColor:"#FFFFFFFF"
                    focus: true
                    onTextChanged: {
                        kcm.timeZonesModel.filterString = text
                    }
                }
            }
        }

        Rectangle {
            id:time_select_area
            anchors {
                top: page_statusbar.bottom
                left: parent.left
                right: parent.right
                bottom:parent.bottom
                bottomMargin: 2
                topMargin: 10
            }
            color:"transparent"

            Rectangle {
                id:list_wrap
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom:time_select_area.bottom
                    top: time_select_area.top
                    leftMargin: marginLeftAndRight 
                    rightMargin: marginLeftAndRight 
                    bottomMargin: 2
                    topMargin: 10 
                }
                height:parent.height - 22
                color:"transparent"
                clip: true

                ListView {
                    id:tz_list
                    clip: true
                    anchors.fill: parent
                    anchors.leftMargin: marginLeftAndRight * 2
                    implicitWidth: list_wrap.width - marginLeftAndRight * 3
                    model: kcm.timeZonesModel 
                    // delegate: Kirigami.DelegateRecycler {
                    //     width: parent.width
                    //     sourceComponent: listDelegateComponent
                    // }
                    delegate:listDelegateComponent

                }
            } 
        }
        
    }
}
