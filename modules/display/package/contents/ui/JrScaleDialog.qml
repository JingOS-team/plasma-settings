/*
 * Copyright 2021 Rui Wang <wangrui@jingos.com>
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
    property int mScaleValue

    x: px
    y: py
    width: 369 * appScale
    height: contentItem.height
    modal: true
    focus: true

    signal menuSelectChanged(int value)

    background: Rectangle {
        id: background
        color: "transparent"
    }

    contentItem: Rectangle {
        id: contentItem

        anchors.left: parent.left
        anchors.right: parent.right
        width: parent.width
        height: 69 * appScale * 5 + 28 * appScale
        radius: 15 * appScale
        color: "#fff"
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            radius: 20
            samples: 25
            color: "#1A000000"
            verticalOffset: 0
            spread: 0
        }

        Rectangle {
            id: menu_content

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 28
                bottomMargin: 28
                leftMargin: 28
                rightMargin: 28
            }

            width: root.width - 28 * 2 * appScale
            color: "transparent"

            ScrollView {
                anchors.fill: parent

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                contentWidth: -1
                background: Item {}

                Column {
                    id: menu_list

                    spacing: 0

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale
                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "100%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34
                            source: "../image/menu_select.png"
                            visible: mScaleValue == 100 ? true : false
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 100
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale
                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "110%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34
                            visible: mScaleValue == 110 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 110
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "120%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34

                            visible: mScaleValue == 120 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 120
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "130%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34

                            visible: mScaleValue == 130 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 130
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"
                        
                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "140%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34

                            visible: mScaleValue == 140 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 140
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "150%"
                        }
                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34

                            visible: mScaleValue == 150 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 150
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"
                        
                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "160%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34

                            source: "../image/menu_select.png"
                            visible: mScaleValue == 160 ? true : false
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 160
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "170%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34
                            visible: mScaleValue == 170 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 170
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }
                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "180%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34
                            visible: mScaleValue == 180 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 180
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale
                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "190%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34
                            visible: mScaleValue == 190 ? true : false
                            source: "../image/menu_select.png"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                mScaleValue = 190
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }

                    Rectangle {
                        width: menu_content.width
                        height: 69 * appScale

                        color: "transparent"

                        Text {
                            anchors {
                                left: parent.left
                                leftMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            font.pointSize: appFontSize + 2
                            text: "200%"
                        }

                        Image {
                            anchors {
                                right: parent.right
                                rightMargin: 31 * appScale
                                verticalCenter: parent.verticalCenter
                            }

                            width: 34
                            height: 34
                            source: "../image/menu_select.png"
                            visible: mScaleValue == 200 ? true : false
                        }

                        MouseArea {
                            anchors.fill: parent
                            
                            onClicked: {
                                mScaleValue = 200
                                menuSelectChanged(mScaleValue)
                                root.close()
                            }
                        }
                    }
                }
            }
        }
    }
}
