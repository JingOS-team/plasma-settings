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

    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property real appScale: 1.3 * screenWidth / 1920
    property int appFontSize: theme.defaultFont.pointSize
    property string cTimeZone : "" 
    property string sTimeZone : ""

    width: screenWidth * 0.7
    height: screenHeight

    TimeTool {
        id: timeTool 
        onDlgConfirm : {
            console.log("onDlgConfirm");
            kcm.saveTimeZone(sTimeZone)
        }

        onDlgCancel : {
            console.log("onDlgCancel");
            kcm.saveTimeZone(cTimeZone)
        }

    }

    Component.onCompleted : {
        cTimeZone = kcm.timeZone
    }

    Component {
        id: listDelegateComponent

        // Kirigami.BasicListItem {
        Rectangle{
            width:parent.width
            height: 69 * appScale
            
            Text {
                anchors.verticalCenter:parent.verticalCenter
                font.pointSize: appFontSize + 2
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
                // text: model.timeZoneId
            }

            Image {
                source:"../image/menu_select.png"
                width: 34 * appScale
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
                height: 1 *appScale
                color: "#f0f0f0"
            }
            
            MouseArea {
                anchors.fill:parent
                onClicked: {
                    sTimeZone = model.timeZoneId
                    kcm.saveTimeZone(sTimeZone)
                    main.popView();
                }
            }
        }
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
                leftMargin: 34 * appScale
                topMargin: 68 * appScale
            }

            width: parent.width
            height: 41 * appScale

            color: "transparent"

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: 34 * appScale
                height: width

                source: "../image/icon_left.png"
                sourceSize.width: width
                sourceSize.height: width

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("back..about")
                        popView()
                    }
                }
            }

            Text {
                id: confirmBtn

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 34* 2 * appScale
                }

                height: 36 * appScale
                color:"#FF3C4BE8"
                text: i18n(" ")
                font.pointSize: appFontSize + 6
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id:input_parent
                
                height: 36 * appScale
                color:"transparent"
                anchors {
                    left: back_icon.right
                    right: confirmBtn.left
                    leftMargin:17 * appScale
                    rightMargin: 17 * appScale
                    verticalCenter: parent.verticalCenter
                }

                Kirigami.JSearchField {
                    id: timezone_input
                    // Layout.fillWidth: true      
                    // Layout.fillHeight: true 
                    anchors.fill:parent
                    font.pointSize: appFontSize -2
                    focus: true
                    onTextChanged: {
                        kcm.timeZonesModel.setFilterFixedString(text)
                    }
                }
            }

             
        }
        Rectangle {
            
            anchors {
                top: page_statusbar.bottom
                left: parent.left
                right: parent.right
                bottom:parent.bottom
                topMargin: 47 * appScale
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 72 * appScale
                    rightMargin: 72 * appScale

                }
                height:parent.height


                ListView {
                    id:tz_list
                    clip: true
                    anchors.fill: parent
                    implicitWidth: 18 * Kirigami.Units.gridUnit
                    model: kcm.timeZonesModel 
                    delegate: Kirigami.DelegateRecycler {
                        width: parent.width
                        sourceComponent: listDelegateComponent
                    }
                        // AdaptiveSearch {
                        //     id: adaptive
                        //     anchors.fill: parent
                        //     model: parent.model
                    
                        //     onFilterUpdated: {
                        //         tz_list.model = adaptive.filtermodel
                        //     }
                        // }
                }
            }
        }
        
    }
}
