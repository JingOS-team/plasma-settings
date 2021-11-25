/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Rui Wang <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.12
import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import jingos.display 1.0

Rectangle {
    id: fonts_sub

    property int screenWidth: 888 * appScaleSize
    property int screenHeight: 648 * appScaleSize
    property string currentSelectText
    property string defaultFontText
    property string defaultFontSize
    property bool isUpdateFont: currentSelectText != defaultFontText || currentDisplayFontSize != defaultFontSize
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

    color: Kirigami.JTheme.settingMinorBackground

    property int currentDisplayFontSize
    property int currentFontSize: currentDisplayFontSize * appFontSize

    Component.onCompleted: {
        currentDisplayFontSize = JDisplay.fontSize
        currentSelectText = JDisplay.fontFamily
        defaultFontText = JDisplay.fontFamily
        defaultFontSize = JDisplay.fontSize
    }

    function changePreview(value) {
        switch(value){
            case 0:
                currentDisplayFontSize = 10;
                break;
            case 1:
                currentDisplayFontSize = 12;
                break;
            case 2:
                currentDisplayFontSize = 14;
                break;
            case 3:
                currentDisplayFontSize = 16;
                break;
            case 4:
                currentDisplayFontSize = 17;
                break;
        }
    }

    Column {
       anchors.fill: parent
       anchors.topMargin: 44 * appScaleSize
       anchors.leftMargin: 20  * appScaleSize
       anchors.rightMargin: 20 * appScaleSize
       spacing: 24 * appScaleSize

        // Title Bar
        Item {
            width: parent.width
            height: 30 * appScaleSize

            Kirigami.JIconButton {
                id: back_icon
                width: (22 + 8) * appScaleSize
                height: width
                anchors.verticalCenter: parent.verticalCenter
                color:Kirigami.JTheme.iconForeground
                source: Qt.resolvedUrl("../image/icon_left.png")
                onClicked: {
                    popView()
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9  * appScaleSize
                }
                text: i18n("Fonts")
                font.pixelSize: 20 * appFontSize
                font.weight: Font.Bold
                color: Kirigami.JTheme.majorForeground
            }

            Kirigami.JButton {
                id: apply

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }

                text: i18n("Apply")
                backgroundColor: "transparent"
                fontColor: isUpdateFont ? Kirigami.JTheme.highlightColor : Kirigami.JTheme.disableForeground
                font.pixelSize: 16 * appFontSize

                onClicked: {
                    if (isUpdateFont) {
                        fontWarningDlg.open()
                    }
                }
            }
        }

        Rectangle {
            id: font_size_item

            width: parent.width
            height: 90 * appScaleSize
            radius: 10 * appScaleSize

            color: Kirigami.JTheme.cardBackground
            visible: false

            Text {
                anchors {
                    left: parent.left
                    leftMargin: 20 * appScaleSize
                    top:parent.top
                    topMargin: 12 * appScaleSize
                }
                text: i18n("Font Size")
                font.pixelSize: 12 * appFontSize
                color: Kirigami.JTheme.minorForeground
            }

            Item {
                id: font_size_slider_item

                height: font_size_slider.height
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12 * appScaleSize
                Text {
                    id: font_size_small
                    anchors {
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: -10 * appScaleSize
                        left: parent.left
                        leftMargin: 20 * appScaleSize
                    }
                    color: Kirigami.JTheme.minorForeground
                    text : "A"
                    font.pixelSize: 10 * appFontSize
                }

                Kirigami.JSlider{
                    id:font_size_slider

                    anchors.left: font_size_small.right
                    anchors.leftMargin: 12 * appScaleSize
                    anchors.right: font_size_big.left
                    anchors.rightMargin: 12 * appScaleSize
                    value:{
                        if(Kirigami.JDisplay.fontSize === 10)
                            return 0.0;
                        if(Kirigami.JDisplay.fontSize === 12)
                            return 1.0;
                        if(Kirigami.JDisplay.fontSize === 14)
                            return 2.0;
                        if(Kirigami.JDisplay.fontSize === 16)
                            return 3.0;
                        if(Kirigami.JDisplay.fontSize === 17)
                            return 4.0;
                    }

                    stepStrs:[i18n("Extra Small"), i18n("Small"), i18n("Normal"), i18n("Large"), i18n("Extra Large")]
                    onValueChanged:{
                        changePreview(value);
                    }
                }

                Text {
                    id: font_size_big

                    anchors {
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: -10  * appScaleSize
                        right: parent.right
                        rightMargin: 20 * appScaleSize
                    }
                    color: Kirigami.JTheme.minorForeground
                    text : "A"
                    font.pixelSize: appFontSize
                }
            }
        }

        Rectangle {
            id: fonts_item

            width: parent.width
            height: 45 * appScaleSize
            radius: 10 * appScaleSize
            color: Kirigami.JTheme.cardBackground

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 20 * appScaleSize
                }

                text: i18n("Font")
                font.pixelSize: 14 * appScaleSize
                color: Kirigami.JTheme.majorForeground
            }

            Text {
                id: fonts_size_value

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: fonts_right_icon.left
                    rightMargin: 9 * appScaleSize
                }
                color: Kirigami.JTheme.minorForeground
                font.pixelSize: 14 * appScaleSize
                text: currentSelectText
            }

            Kirigami.JIconButton {
                id: fonts_right_icon

                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 20 * appScaleSize
                }

                width: 30 * appScaleSize
                height: 30 * appScaleSize
                color:Kirigami.JTheme.iconMinorForeground
                source: Qt.resolvedUrl("../image/icon_right.png")
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    familyDialog.x = fonts_item.x + fonts_item.width -  familyDialog.width
                    familyDialog.y = fonts_item.y - 24 * appScaleSize / 2 - fonts_item.height / 2 + fonts_size_value.height / 2
                    familyDialog.open()
                }
            }
            JrFamilyDialog {
                id: familyDialog

                onFamilyChanged: {
                    currentSelectText = family
                }
            }
        }

        Rectangle {
            id: preview_area

            width: parent.width
            height: 250 * appScaleSize

            color: Kirigami.JTheme.cardBackground
            radius: 10 * appScaleSize

            Text {
                id:preview_title

                anchors {
                    left: parent.left
                    leftMargin: 20 * appScaleSize
                    top: parent.top
                    topMargin: 12 * appScaleSize
                }

                text: i18n("Preview")
                font.pixelSize: 12 * appFontSize
                color: Kirigami.JTheme.minorForeground
            }

            Item {
                id: preview_content

                anchors.verticalCenter: parent.verticalCenter
                width: parent.width

                Rectangle {
                    id: preview_list

                    anchors {
                        verticalCenter:preview_content.verticalCenter
                        left:preview_content.left
                        leftMargin: 20 * appScaleSize
                    }

                    radius: 10 * appScaleSize
                    width: 190 * appScaleSize
                    height: 156 * appScaleSize
                    color: isDarkTheme ? "#E626262A" : "#FFFFFF"

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
                            topMargin: 10 * appScaleSize
                        }
                        icon_name: Qt.resolvedUrl("../image/font_icon_1.png")
                        title_name: "Icons"
                        title_size: currentFontSize
                        fontFamily: fonts_size_value.text
                        isCheck: true
                    }

                    Rectangle {
                        id: sep1

                        width:parent.width - 40 * appScaleSize
                        height : 1 * appScaleSize
                        anchors {
                            top : item_1.bottom
                            horizontalCenter:parent.horizontalCenter
                        }
                        color:Kirigami.JTheme.dividerForeground
                    }

                    CheckItem {
                        id: item_2

                         anchors {
                            horizontalCenter:parent.horizontalCenter
                            top: sep1.bottom
                        }
                        icon_name: Qt.resolvedUrl("../image/font_icon_2.png")
                        title_name: "List"
                        title_size: currentFontSize
                        fontFamily: fonts_size_value.text
                        isCheck: false
                    }

                    Rectangle {
                        id: sep2

                        width:parent.width - 40 * appScaleSize
                        height :1 * appScaleSize
                        anchors {
                            top : item_2.bottom
                            horizontalCenter:parent.horizontalCenter
                        }
                        color: Kirigami.JTheme.dividerForeground
                    }

                    CheckItem {
                        id: item_3

                         anchors {
                            horizontalCenter:parent.horizontalCenter
                             top: sep2.bottom
                        }
                        icon_name: Qt.resolvedUrl("../image/font_icon_3.png")
                        title_name: "Name"
                        title_size: currentFontSize
                        fontFamily: fonts_size_value.text
                        isCheck: false
                    }
                }

                Rectangle {
                    id: preview_txt

                    anchors {
                        verticalCenter: preview_content.verticalCenter
                        left: preview_list.right
                        leftMargin: 73 * appScaleSize
                    }

                    radius: 10 * appScaleSize
                    width: 231 * appScaleSize
                    height : 140 * appScaleSize
                    color: isDarkTheme ? "#E626262A" : "#FFFFFF"

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
                        width: 196 * appScaleSize
                        horizontalAlignment: Text.AlignHCenter
                        color: Kirigami.JTheme.majorForeground
                        clip: true
                        wrapMode: Text.WordWrap
                    }
                }
            }

            Kirigami.JDialog {
                id: fontWarningDlg

                title: i18n("Restart")
                text: i18n("Applying this setting will restart your PAD")
                leftButtonText: i18n("Cancel")
                rightButtonText: i18n("Restart")
                dim: true
                focus: true

                onLeftButtonClicked: {
                    fontWarningDlg.close()
                }

                onRightButtonClicked: {
                    var family = fonts_size_value.text
                    var size = currentDisplayFontSize
                    JDisplay.setSystemFont(family , size);
                    fontWarningDlg.close()
                    kcm.restartDevice()
                }
            }
        }
    }
}
