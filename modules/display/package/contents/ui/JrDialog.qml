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

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45
    property int screenWidth: 888
    property int screenHeight: 648
    property int marginTitle2Top : 44 
    property int marginItem2Title : 36 
    property int marginLeftAndRight : 10 
    property int marginItem2Top : 24 
    property int radiusCommon: 10 
    property int fontNormal: 14

    signal menuSelectChanged(int value)

    x: px
    y: py
    width: 240 
    height: contentItem.height

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
        height: default_setting_item_height  * 5 + 8 * 2 + 4
        radius: 10
        color: "#fff"

        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            radius: 10
            samples: 25
            color: "#1A000000"
            verticalOffset: 0
            spread: 0
        }

        Rectangle {
            id: menu_content

            anchors {
                fill:parent 
                topMargin: 8
                bottomMargin: 0
                leftMargin: marginLeftAndRight
                rightMargin: marginLeftAndRight
            }

            width: root.width - marginLeftAndRight * 2 
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

                        font.pixelSize: 14
                        text: i18n("2 Minutes")
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

                    Kirigami.Separator {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: marginLeftAndRight
                        anchors.rightMargin: marginLeftAndRight
                        color: "#f0f0f0"
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

                        font.pixelSize: 14
                        text: i18n("5 Minutes")
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
                        visible: selectIndex == 1 ? true : false
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            selectIndex = 1
                            menuSelectChanged(selectIndex)
                            root.close()
                        }
                    }

                    Kirigami.Separator {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: marginLeftAndRight
                        anchors.rightMargin: marginLeftAndRight
                        color: "#f0f0f0"
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

                        font.pixelSize: 14
                        text: i18n("10 Minutes")
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
                    Kirigami.Separator {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: marginLeftAndRight
                        anchors.rightMargin: marginLeftAndRight
                        color: "#f0f0f0"
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

                        font.pixelSize: 14
                        text: i18n("15 Minutes")
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

                    Kirigami.Separator {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: marginLeftAndRight
                        anchors.rightMargin: marginLeftAndRight
                        color: "#f0f0f0"
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
                        font.pixelSize: 14
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
