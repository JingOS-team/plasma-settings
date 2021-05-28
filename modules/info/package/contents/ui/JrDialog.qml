/*
 * Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

Popup {
    id: root

    property string uid
    property var description: ""
    property int px: 0
    property int py: 0
    property int selectIndex

    signal menuSelectChanged(int value)

    property int screenWidth: 888
    property int screenHeight: 648
    property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 18 
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24
    property int radiusCommon: 10 
    property int fontNormal: 14 

    width: 300
    height: contentItem.height

    x: px
    y: py
    modal: true
    focus: true

    background: Rectangle {
        id: background
        color: "transparent"
    }

    contentItem: Rectangle {
        id: contentItem

        anchors.left: parent.left
        anchors.right: parent.right

        width: parent.width
        height: default_setting_item_height * 5 + 14 

        radius: radiusCommon
        // layer.enabled: true
        // layer.effect: DropShadow {
        //     horizontalOffset: 0
        //     radius:20
        //     samples:25
        //     color: "#1A000000"
        //     verticalOffset: 0
        //     spread: 0
        // }
        color: "#ffffff"

        Rectangle {
            id: menu_content

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 14
                bottomMargin: 14
                leftMargin: 14
                rightMargin: 14
            }

            width: root.width - 14 * 2
            color: "transparent"

            Column {
                id: menu_list

                spacing: 0

                Rectangle {
                    width: menu_content.width
                    height: default_setting_item_height
                    color: "transparent"

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        font.pixelSize: fontNormal
                        text: i18n("Every day")
                    }

                    Image {
                        anchors {
                            right: parent.right
                            rightMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        width: 17
                        height: 17

                        source: "../image/menu_select.png"
                        visible: selectIndex == 0 ? true : false
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            selectIndex = 0
                            menuSelectChanged(selectIndex)
                            root.close()
                        }
                    }
                }

                Rectangle {
                    width: menu_content.width
                    height: default_setting_item_height

                    color: "transparent"

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        font.pixelSize: fontNormal
                        text: i18n("Every two days")
                    }

                    Image {
                        anchors {
                            right: parent.right
                            rightMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        width: 17
                        height: 17

                        visible: selectIndex == 1 ? true : false
                        source: "../image/menu_select.png"
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            selectIndex = 1
                            menuSelectChanged(selectIndex)
                            root.close()
                        }
                    }
                }

                Rectangle {
                    width: menu_content.width
                    height: default_setting_item_height

                    color: "transparent"

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        font.pixelSize: fontNormal
                        text: i18n("Weekly")
                    }

                    Image {
                        anchors {
                            right: parent.right
                            rightMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        width: 17
                        height: 17
                        source: "../image/menu_select.png"
                        visible: selectIndex == 2 ? true : false
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            selectIndex = 2
                            menuSelectChanged(selectIndex)
                            root.close()
                        }
                    }
                }

                Rectangle {
                    width: menu_content.width
                    height: default_setting_item_height

                    color: "transparent"

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        font.pixelSize: fontNormal
                        text: i18n("Every two weeks")
                    }

                    Image {
                        anchors {
                            right: parent.right
                            rightMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        width: 17
                        height: 17
                        source: "../image/menu_select.png"
                        visible: selectIndex == 3 ? true : false
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            selectIndex = 3
                            menuSelectChanged(selectIndex)
                            root.close()
                        }
                    }
                }

                Rectangle {
                    width: menu_content.width
                    height: default_setting_item_height

                    color: "transparent"

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        font.pixelSize: fontNormal
                        text: i18n("Never")
                    }
                    
                    Image {
                        anchors {
                            right: parent.right
                            rightMargin: marginLeftAndRight
                            verticalCenter: parent.verticalCenter
                        }

                        width: 17
                        height: 17
                        source: "../image/menu_select.png"
                        visible: selectIndex == 4 ? true : false
                    }

                    MouseArea {
                        anchors.fill: parent
                        
                        onClicked: {
                            selectIndex = 4
                            menuSelectChanged(selectIndex)
                            root.close()
                        }
                    }
                }
            }
        }
    }
}
