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
    property real appScale: 1.3
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
        id: home_view

        Item {
            anchors.fill: parent
            //color: "#FFF2F2F7"

            Image {
                id: backLabel

                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 68 * appScale
                    leftMargin: 38 * appScale
                }

                sourceSize.width: 34 * appScale
                sourceSize.height: 34 * appScale

                visible: false
                source: "../image/arrow_left.png"
            }

            Kirigami.Label {
                id: title

                anchors {
                    top: parent.top
                    left: backLabel.right
                    topMargin: 68 * appScale
                    leftMargin: 12 * appScale
                }

                font.pointSize: defaultFontSize + 9
                font.bold: true
                text: "Password"
            }

            Rectangle {
                id: mainPage

                anchors {
                    top: title.bottom
                    left: parent.left
                    topMargin: 42 * appScale
                    leftMargin: 72 * appScale
                    horizontalCenter: parent.horizontalCenter
                }

                width: 923 * appScale
                height: 69 * appScale

                color: "white"
                radius: 15 * appScale

                Kirigami.Label {
                    anchors.left: parent.left
                    anchors.leftMargin: 32 * appScale
                    anchors.verticalCenter: parent.verticalCenter

                    text: "Change Password"
                    color: "#FF3C4BE8"
                    font.pointSize: defaultFontSize
                }

                Image {
                    anchors.right: parent.right
                    anchors.rightMargin: 18 * appScale
                    anchors.verticalCenter: parent.verticalCenter

                    sourceSize.width: 34 * appScale
                    sourceSize.height: 34 * appScale

                    source: "../image/arrow_right.png"
                }

                MouseArea {
                    anchors.fill: parent
                    
                    onClicked: {
                        gotoPage("keyboard_view")
                    }
                }
            }
        }
    }
}
