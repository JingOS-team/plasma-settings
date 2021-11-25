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
import jingos.display 1.0

Rectangle {
    id: root

    property real appScaleSize: JDisplay.dp(1.0)
    property real appFontSize: JDisplay.sp(1.0)
    property int mWidth: parent.width
    property int mHeight: parent.height
    property string titleName: "Passcode"
    property string inputText: ""

    color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"
    property bool isSwitchModel: false
    property bool keyboardShow: false
    property bool complexShow: false
    property bool homeShow: false

    QQC2.StackView {
        id: stack

        anchors.fill: parent

        Component.onCompleted: {
            stack.push(home_view)
        }
    }

    Connections {
        target: kcm

        onCurrentIndexChanged: {
            if(index == 1){
                popAllView()
            }
        }
    }

    function popAllView() {
        while (stack.depth > 1) {
            stack.pop()
        }
    }

    function gotoPage(name) {
        if (name == "keyboard_view") {
            stack.push(keyboard_view)
        } else if( name == "complex_view") {
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
            onVisibleChanged: {
                root.homeShow = visible
            }

            Kirigami.Label {
                id: title

                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 48 * appScaleSize
                    leftMargin: 20 * appScaleSize
                }
                height: 20 * appScaleSize

                font.pixelSize: 20 * appFontSize
                font.bold: true
                text: i18n("Password")
                color: Kirigami.JTheme.majorForeground
            }

            Rectangle {
                id: mainPage

                anchors {
                    top: title.bottom
                    left: parent.left
                    topMargin: 18 * appScaleSize
                    leftMargin: 20 * appScaleSize
                    horizontalCenter: parent.horizontalCenter
                }

                width: root.width - 40 * appScaleSize
                height: 45 * appScaleSize * 2

                color: Kirigami.JTheme.cardBackground//"white"
                radius: 10 * appScaleSize
                Item {
                    id: change_pwd

                    anchors {
                        top: parent.top
                    }
                    width: parent.width
                    height : 45 *appScaleSize

                    Kirigami.Label {
                        anchors.left: parent.left
                        anchors.leftMargin: 20 * appScaleSize
                        anchors.verticalCenter: parent.verticalCenter

                        text: i18n("Simple Password")
                        font.pixelSize: 14 * appFontSize
                        color: Kirigami.JTheme.majorForeground//"black"
                    }

                    Kirigami.JIconButton {
                        anchors.right: parent.right
                        anchors.rightMargin: 20 * appScaleSize
                        anchors.verticalCenter: parent.verticalCenter

                        width: 30 * appScaleSize
                        height: 30 * appScaleSize

                        source: Qt.resolvedUrl("../image/arrow_right.png")
                        color: Kirigami.JTheme.iconMinorForeground
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            gotoPage("keyboard_view")
                        }
                    }
                }
                Kirigami.Separator {
                    id: separator

                    anchors {
                        top: change_pwd.bottom
                        left: parent.left
                        right: parent.right
                        leftMargin: 20 * appScaleSize
                        rightMargin: 20 * appScaleSize
                    }
                    color: Kirigami.JTheme.dividerForeground//"#FFF0F0F0"
                }

                Item {
                    id: complex_pwd

                    anchors {
                        top: separator.bottom
                        bottom: parent.bottom
                    }
                    width: parent.width
                    height : 45 * appScaleSize

                    Kirigami.Label {
                        anchors.left: parent.left
                        anchors.leftMargin: 20 * appScaleSize
                        anchors.verticalCenter: parent.verticalCenter

                        text: i18n("Complex Password")
                        font.pixelSize: 14 * appFontSize
                        color: Kirigami.JTheme.majorForeground

                    }

                    Kirigami.JIconButton {
                        anchors.right: parent.right
                        anchors.rightMargin: 20 * appScaleSize
                        anchors.verticalCenter: parent.verticalCenter
                        width: 30 * appScaleSize
                        height: 30 * appScaleSize

                        source: Qt.resolvedUrl("../image/arrow_right.png")
                        color: Kirigami.JTheme.iconMinorForeground
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

        onConfirmSuccess: {
            popView()
            showTimer.start()
        }

        onCurrentIndexChanged: {
            if (index == 1) {
                isSwitchModel = true
            }
        }
    }

    Timer{
        id: showTimer

        interval: 100
        onTriggered: {
            if(homeShow || keyboardShow || complexShow) {
                showToast(i18n("Password reset complete"))
            }
        }
    }

     Kirigami.JToolTip{
        id:toastShow

        font.pixelSize: 17 * appFontSize
    }

    function showToast(tips)
    {
        toastShow.text = tips
        toastShow.show(tips, 1500)
    }
}
