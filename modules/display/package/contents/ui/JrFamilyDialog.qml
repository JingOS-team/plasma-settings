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
import jingos.font 1.0

Popup {
    id: root

    property string uid
    property var description: ""
    property int px: 0
    property int py: 0
    property int selectIndex
    property string currentFamily

    FontModel {
        id: fontModel 
    }

    signal familyChanged(string family)

    x: px
    y: py
    width: 240 + 100
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
        height: 45 * 5 + 2
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
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                topMargin: 8
                bottomMargin: 8
                leftMargin: 8
                rightMargin: 8
            }

            width: root.width - 8 * 2 
            height: 45 * 5
            color: "transparent"

            ListView {
                id: listview1
                model: fontModel.subPixelOptionsModel
                width: parent.width
                height: listview1.count < 5 ? listview1.count * 45  - 1 : 5 * 45  - 1

                
                delegate: Rectangle {
                    width: menu_content.width
                    height: 45 

                    Component.onCompleted: {
                        currentFamily = fontModel.getFontFamily();
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked: {
                            currentFamily = display
                            familyChanged(display)
                            root.close();
                        }
                    }
                    Text {
                        anchors {
                            verticalCenter:parent.verticalCenter
                            left:parent.left
                            leftMargin: 20
                        }
                        text: display
                        font.pixelSize: 14
                    }

                    Image {
                        anchors {
                            verticalCenter:parent.verticalCenter
                            right:parent.right
                            rightMargin: 20
                        }
                        source: "../image/menu_select.png"
                        width: 22
                        height : 22 
                        sourceSize.width: 22
                        sourceSize.height : 22 
                        visible: display == currentFamily
                    }

                    Kirigami.Separator {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        color: "#f0f0f0"
                    }

                }
            }
        }
    }
}
