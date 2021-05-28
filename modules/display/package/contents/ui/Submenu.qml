/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Rui Wang <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import jingos.font 1.0

Item {
    id: fonts_sub

    property int screenWidth: 888
    property int screenHeight: 648
    property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24
    property int radiusCommon: 10 
    property int fontNormal: 14 


    // width: screenWidth * 0.7
    // height: screenHeight

    // 0: extra small   - 20 
    // 1: small         - 24
    // 2: normal        - 28
    // 3: large         - 32
    // 4: extra large   - 34

    property int currentFontSize: 14

    Component.onCompleted:{
        font_size_slider.load()
        fonts_size_value.load()
        
    }

    FontModel {
        id: fontModel 
    }

    function changePreview(value) {
        console.log("changePreview : " , value )
        switch(value){
            case 0:
                currentFontSize = 10; 
                break; 
            case 1: 
                currentFontSize = 12; 
                break; 
            case 2: 
                currentFontSize = 14; 
                break; 
            case 3: 
                currentFontSize = 16; 
                break; 
            case 4: 
                currentFontSize = 17; 
                break; 
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

        // Title Bar
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
                source: "../image/icon_left.png"
                sourceSize.width: width
                sourceSize.height: width

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        popView()
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
                text: i18n("Fonts")
                // font.pointSize: appFontSize + 11
                font.pixelSize: 20
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: apply

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 25 
                }

                height: 14
                text: i18n("Apply")
                color: "blue"
                font.pixelSize: 16
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill:parent 
                    onClicked: {
                        // console.log()
                        fontWarningDlg.open()
                        
                    }
                }
            }
        }

        Rectangle {
            id: font_size_item
            anchors {
                left: parent.left
                right: parent.right
                top: page_statusbar.bottom
                leftMargin: marginLeftAndRight
                rightMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            height: 90
            radius: 10 
            visible: false 

            Rectangle {
                id: font_size_title 
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right 
                }
                width: parent.width
                height: 45
                radius: 10 

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Font Size")
                    // font.pointSize: appFontSize + 2
                    font.pixelSize: 12
                    color: "#4D000000"
                }
            }

            JrStepSliderItem {
                id : font_size_slider
                anchors {
                    top : font_size_title.bottom 
                    left : parent.left
                    right: parent.right 
                    bottom: parent.bottom 
                }
                height: 45

                function load() {

                    var size = fontModel.getFontSize();

                    if(size >= 17){
                        font_size_slider.sliderValue = 4
                    }else if(size >= 16 ){
                        font_size_slider.sliderValue = 3
                    }else if (size >= 14){
                        font_size_slider.sliderValue = 2
                    }else if (size >= 12){
                        font_size_slider.sliderValue = 1
                    }else {
                        font_size_slider.sliderValue = 0 
                    }
                }

                onSliderChanged: {
                    changePreview(value);
                }
            }
        }

        Rectangle {
            id: fonts_item

            anchors {
                left: parent.left
                // top: font_size_item.bottom
                top: page_statusbar.bottom
                leftMargin: marginLeftAndRight
                // topMargin: marginItem2Top
                topMargin: marginItem2Title

            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height

            color: "#fff"
            radius: 10 

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: marginLeftAndRight
                }

                text: i18n("Font")
                // font.pointSize: appFontSize + 2
                font.pixelSize: 14
            }

            Text {
                id:fonts_size_value
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: fonts_right_icon.left
                    rightMargin: 9
                }

                function load() {
                    
                    var family = fontModel.getFontFamily();
                    fonts_size_value.text = family
                }

                // font.pointSize: appFontSize + 2
                font.pixelSize: 14
            }

            Image {
                id: fonts_right_icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: marginLeftAndRight
                }

                source: "../image/icon_right.png"
                sourceSize.width: statusbar_icon_size
                sourceSize.height: statusbar_icon_size
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    familyDialog.px = fonts_item.x + fonts_item.width -  familyDialog.width * 1.1
                    familyDialog.py = fonts_size_value.y - 40 
                    familyDialog.open()
                }
            }
        }

        Rectangle {
            id: preview_area

            anchors {
                left: parent.left
                top: fonts_item.bottom
                leftMargin: marginLeftAndRight
                topMargin: marginItem2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: 250

            color: "#fff"
            radius: 10 

            Rectangle {
                id: preview_title 
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right 
                }
                width: parent.width
                height: 45
                radius: 10 

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: marginLeftAndRight
                    }

                    text: i18n("Preview")
                    font.pixelSize: 12
                    color: "#4D000000"
                }
            }

            Rectangle {
                id: preview_content
                radius: 10 

                anchors {
                    top: preview_title.bottom 
                    left: parent.left
                    right:parent.right
                    bottom:parent.bottom
                }

                Rectangle {
                    id: center_tag
                    anchors.centerIn:parent
                    width: 10 
                    height : 10 
                }

                Rectangle {
                    id: preview_list

                    anchors {
                        verticalCenter:preview_content.verticalCenter
                        left:preview_content.left
                        leftMargin: 20
                        // right:center_tag.left
                    }

                    radius: 10
                    width: 190
                    height: 156
                    color: "#FFFFFF"
                    // color: "green"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0.2
                        radius: 10
                        samples: 25
                        color: "#2A000000"
                        verticalOffset: 0.2
                        spread: 0
                    }
                    
                    CheckItem {
                        id: item_1
                        anchors {
                            horizontalCenter:parent.horizontalCenter
                            top:parent.top
                            topMargin: 10 
                        }
                        icon_name: "../image/font_icon_1.png"
                        title_name: "Icons"
                        title_size: currentFontSize
                        fontFamily: fonts_size_value.text
                        isCheck: true 
                    }
                    Rectangle {
                        id: sep1
                        width:parent.width - 40
                        height : 1
                        anchors {
                            top : item_1.bottom 
                            horizontalCenter:parent.horizontalCenter
                        }
                        color:"#223c3d43"
                    }

                    CheckItem {
                        id: item_2
                         anchors {
                            horizontalCenter:parent.horizontalCenter
                            top: sep1.bottom 
                        }
                        icon_name: "../image/font_icon_2.png"
                        title_name: "List"
                        title_size: currentFontSize
                        fontFamily: fonts_size_value.text
                        isCheck: false 
                    }

                    Rectangle {
                        id: sep2
                        width:parent.width - 40
                        height : 1
                        anchors {
                            top : item_2.bottom 
                            horizontalCenter:parent.horizontalCenter
                        }
                        color:"#223c3d43"
                    }

                    CheckItem {
                        id: item_3
                         anchors {
                            horizontalCenter:parent.horizontalCenter
                             top: sep2.bottom 
                        }
                        icon_name: "../image/font_icon_3.png"
                        title_name: "Name"
                        title_size: currentFontSize
                        fontFamily: fonts_size_value.text
                        isCheck: false 
                    }
                }

                Rectangle {
                    id: preview_txt
                    anchors {
                        verticalCenter:preview_content.verticalCenter
                        // right:preview_content.right 
                        // rightMargin: 20 
                        left : center_tag.right
                    }

                    radius: 10
                    width: 251
                    height : 140
                    color: "#ddFFFFFF"
                    // color:"red"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        horizontalOffset: 0.3
                        radius: 10
                        samples: 25
                        color: "#2A000000"
                        verticalOffset: 0.3
                        spread: 0
                    }

                    Text {
                        anchors.centerIn:preview_txt 
                        text: "Main text will look like this.\n1234567890!@#%&*()_+-="
                        font.pixelSize: currentFontSize
                        font.family: fonts_size_value.text
                        width: 196
                        horizontalAlignment: Text.AlignHCenter

                    }

                }

            }
           
            JrFamilyDialog {
                id: familyDialog

                onFamilyChanged: {
                    fonts_size_value.text = family
                }
            }

            Kirigami.JDialog {
                id: fontWarningDlg

                anchors.centerIn: parent
                title: i18n("Restart")
                text: i18n("Applying this setting will restart your PAD")
                leftButtonText: i18n("Cancel")
                rightButtonText: i18n("Restart")
                // rightButtonTextColor: "red"
                dim: true
                focus: true

                onLeftButtonClicked: {
                    fontWarningDlg.close()
                }

                onRightButtonClicked: {
                    var family = fonts_size_value.text
                    var size = currentFontSize
                    fontModel.setSystemFont(family , size)
                    fontWarningDlg.close()
                }
            }
        }
    }
}
