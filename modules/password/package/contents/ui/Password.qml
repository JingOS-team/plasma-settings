/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-FileCopyrightText: 2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10 as QQC2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2

Rectangle {
    id: root

    property int mWidth: parent.width
    property int mHeight: parent.height
    property real appScale: 1
    //property real appScale: 1.3 * parent.width / (1920 * 0.7)
    property int defaultFontSize: theme.defaultFont.pointSize
    property string titleName: "Passcode"
    property string inputText: ""

    color: "#FFF6F9FF"

    QQC2.StackView {
        id: stack

        anchors.fill: parent

        Component.onCompleted: {
            stack.push(home_view)
        }
    }

    function gotoPage(name) {
        if (name == "keyboard_view") {
            stack.push(keyboard_view)
        } else if( name == "complex_view"){
            stack.push(complex_view)
        }
    }

    function popView() {
        stack.pop()
    }

    Component {
        id: keyboard_view

        Keyboard {}
    }

    Component {
        id: complex_view

        Complex {}
    }

    Component {
        id: home_view

        Item {
            anchors.fill: parent
            //color: "#FFF2F2F7"

            Kirigami.Label {
                id: title

                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 48 * appScale
                    leftMargin: 20 * appScale
                }
                height: 20 * appScale
                font.pixelSize: 20
                font.bold: true
                text: i18n("Password")
            }

            Rectangle {
                id: mainPage

                anchors {
                    top: title.bottom
                    left: parent.left
                    topMargin: 18 * appScale
                    leftMargin: 20 * appScale
                    horizontalCenter: parent.horizontalCenter
                }

                width: root.width - 40 * appScale
                height: 45 * appScale * 2

                color: "white"
                radius: 10 * appScale

                
                Item {

                    id: change_pwd
                    anchors {
                        top: parent.top 
                    }
                    width: parent.width
                    height : 45

                    Kirigami.Label {
                        anchors.left: parent.left
                        anchors.leftMargin: 20 * appScale
                        anchors.verticalCenter: parent.verticalCenter

                        text: i18n("Simple Password")
                        color:"black"
                        font.pixelSize: 14
                        
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.rightMargin: 20 * appScale
                        anchors.verticalCenter: parent.verticalCenter

                        sourceSize.width: 22 * appScale
                        sourceSize.height: 22 * appScale

                        source: "../image/arrow_right.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        
                        onClicked: {
                            gotoPage("keyboard_view")
                        }
                    }

                }
                Kirigami.Separator{
                    id:separator
                    anchors{
                        top: change_pwd.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: 20 * appScale
                        rightMargin: 20 * appScale
                    }
                    color: "#FFF0F0F0"
                }

                Item {

                    id: complex_pwd
                    anchors {
                        top: separator.bottom
                        bottom : parent.bottom 
                    }
                    width: parent.width
                    height : 45

                    Kirigami.Label {
                        anchors.left: parent.left
                        anchors.leftMargin: 20 * appScale
                        anchors.verticalCenter: parent.verticalCenter

                        text: i18n("Complex Password")
                        color:"black"
                        font.pixelSize: 14
                        
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.rightMargin: 20 * appScale
                        anchors.verticalCenter: parent.verticalCenter

                        sourceSize.width: 22 * appScale
                        sourceSize.height: 22 * appScale

                        source: "../image/arrow_right.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        
                        onClicked: {
                            gotoPage("complex_view")
                        }
                    }

                }

            }
        }
    }

    Connections{
        target: kcm

        onConfirmSuccess:{
            showToast(i18n("Password reset complete"))
        }
    }
    ToastView{
        id:toastShow
    }

    function showToast(tips)
    {
        toastShow.toastContent = tips
        toastShow.x = (root.width - toastShow.width - 200) / 2
        toastShow.y = root.width - toastShow.height - 36
        toastShow.visible = true
    }
}