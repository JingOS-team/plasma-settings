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

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10 as QQC2

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id:complex_pwd

    property bool isErrorShow : false
    property bool isagain : false
    // 0: 没有问题
    // 1: 长度问题
    // 2: 两次密码不一致
    property int errorStatus : 0
    property string  password
    property string  passwordagain
    property alias edittext: keyLineEdit.labelData

    onVisibleChanged: {
        root.complexShow = visible
    }
    onEdittextChanged: {
        if (edittext.length == 0) {
            isErrorShow = false
        }
    }

    Item {
        id: title

        anchors.top: parent.top
        width: parent.width
        height: 22 * appFontSize

        Kirigami.JIconButton {
            id: backLabel

            anchors {
                top: parent.top
                left: parent.left
                topMargin: 48 * appScaleSize
                leftMargin: 14 * appScaleSize
            }
            width: 32 * appScaleSize
            height: 32 * appScaleSize

            visible: passwordVerify.visible
            source: "qrc:/image/arrow_left.svg"
            color: Kirigami.JTheme.iconForeground

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    popView()
                }
            }
        }

        Kirigami.Label {
            anchors {
                top: parent.top
                left: backLabel.right
                topMargin: 54 * appScaleSize
                leftMargin: 10 * appScaleSize
            }

            height: 20 * appScaleSize
            font.bold: true
            text: i18n("Complex Password")
            font.pixelSize: 20 * appFontSize
            color: Kirigami.JTheme.majorForeground
        }
    }

    Rectangle{
        anchors {
            top : title.bottom
            topMargin: 80 * appScaleSize
            horizontalCenter: parent.horizontalCenter
        }

        width: 233 * appScaleSize
        height: 93 * appScaleSize
        color: "transparent"

        Text {
            id: input_title

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width: 164 * appScaleSize
            height: 17 * appScaleSize
            horizontalAlignment: Text.AlignHCenter

            font.pixelSize: 17 * appFontSize
            color: Kirigami.JTheme.majorForeground
            text: isagain ? i18n("Verify your new password") :i18n("Enter your new password")
        }

        Kirigami.JKeyBdLineEdit{
            id: keyLineEdit

            anchors.centerIn: parent
            width: 233 * appScaleSize
            height: 30 * appScaleSize

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: input_title.bottom
            anchors.topMargin: 24 * appScaleSize
            courseColor: "#FF3C4BE8"//Kirigami.JTheme.highlightColor
            textColor: Kirigami.JTheme.majorForeground//"black"
            cleanIconColor: isDarkTheme ? Kirigami.JTheme.cardBackground : "#FFFFFFFF"
            cleanIconBackgroundColor: "#FFAEAEAE"
            color: Kirigami.JTheme.textFieldBackground
            lengthMaxLimit: true

            onMousePress: {
                virtuaKey.open()
            }
        }

        PlasmaComponents.Label {
            id: errortTip

            anchors.top: keyLineEdit.bottom//authenticationinput.bottom
            anchors.topMargin: 8 * appScaleSize
            font.pixelSize: 12 * appFontSize
            height: 14 * appScaleSize
            width: 233 * appScaleSize

            color: Kirigami.JTheme.highlightRed//"#FFE95B4E"
            visible: isErrorShow

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: {
                if (errorStatus == 1) {
                    return i18n("Wrong password, please try again")
                } else if (errorStatus == 2) {
                    return i18n("Password did not match, please try again")
                } else if (errorStatus == 3) {
                    return i18n("Set a 4 to 32-character\npassword(including at least 1 letter)")
                } else if (errorStatus == 4) {
                    return i18n("Must include at least 1 letter")
                }
            }
        }

        PlasmaComponents.Label {
            id: input_tip

            height: 14 * appScaleSize
            width: 233 * appScaleSize
            anchors.top: keyLineEdit.bottom//authenticationinput.bottom
            anchors.topMargin: 8 * appScaleSize
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 12 * appFontSize
            color: Kirigami.JTheme.minorForeground//"#993C3C43"
            visible: !isagain && !isErrorShow
            horizontalAlignment: Text.AlignHCenter
            text:i18n("Set a 4 to 32-character\npassword(including at least 1 letter)")
        }
    }

    function verifyPasswordWord(passwordStr){
        if (passwordStr.length >= 4 && passwordStr.length <= 32) {
            // 通过 正则表达式 检测文字的合法性
            if (kcm.isDigitStr(passwordStr)) {
                isErrorShow = true
                errorStatus = 4
            } else {
                password  = passwordStr
                isagain = true
                keyLineEdit.labelData = ""
                keyLineEdit.labelDisplayData = ""
            }

        } else if (passwordStr.length < 4 | passwordStr.length > 32) {
            isErrorShow = true
            errorStatus = 3

        } else {
            isErrorShow = true
            errorStatus = 1
        }
    }

    function checkPassword() {
        if (password == passwordagain) {
            kcm.setPassword(password, "complex")
        } else {
            keyLineEdit.clearData()
            isErrorShow = true
            errorStatus = 2
        }
        password = ""
        passwordagain = ""
        isagain = false
    }

    function getPasswordText() {
        var text = "";
        for(var i = 0 ; i < passwordInput.count ; i ++){
            text += passwordInput.get(i).value;
        }
        return text;
    }

    RegExpValidator {
        id: pinValidator

        regExp: /[0-9]+/
    }

    Component.onCompleted: {
       complex_pwd.focus = true
       complex_pwd.forceActiveFocus()
    }

    Kirigami.JPasswdKeyBd {
            id:virtuaKey

            boardHeight: 648 * appScaleSize * 0.5069
            y: complex_pwd.height-boardHeight
            closePolicy: Popup.NoAutoClose

            onKeyBtnClick: {
                if (isErrorShow) {
                    isErrorShow = false
                }
                keyLineEdit.opAddStr(str)
            }
            onKeyBtnEnter: {
                if (isagain) {
                    passwordagain = keyLineEdit.labelData
                    checkPassword()
                } else {
                    verifyPasswordWord(keyLineEdit.labelData)
                }
            }
            onKeyBtnDel: {
                isErrorShow = false
                keyLineEdit.opSubStr()
            }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Return) {
            if (isagain) {
                passwordagain = keyLineEdit.labelData
                checkPassword()
            } else {
                verifyPasswordWord(keyLineEdit.labelData)
            }
        }
    }
}


