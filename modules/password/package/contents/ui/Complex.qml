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


Item{
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

    onEdittextChanged: {
        if(edittext.length == 0){
            isErrorShow = false 
        }
    }

    Item{
        id:title

        anchors.top:parent.top
        width: parent.width
        height : 22

        Image {
            id:backLabel

            anchors {
                top: parent.top
                left: parent.left
                topMargin: 48 * appScale
                leftMargin: 14 * appScale
            }

            sourceSize.width: 22 * appScale
            sourceSize.height: 22 * appScale

            visible:passwordVerify.visible
            source: "../image/arrow_left.png"

            MouseArea {
                anchors.fill:parent

                onClicked:{
                    popView()
                }
            }
        }

        Kirigami.Label {
            anchors {
                top: parent.top
                left: backLabel.right
                topMargin: 48 * appScale
                leftMargin: 10 * appScale
            }

            height: 20 * appScale
            font.bold: true
            text: i18n("Complex Password")
            font.pixelSize: 20
        }
    }

    Rectangle{
        anchors {
            top : title.bottom
            topMargin: 80
            horizontalCenter: parent.horizontalCenter
        }

        width: 233
        height : 17 + 24 + 30 + 8 + 14
        color: "transparent"

        Text {
            id: input_title
            anchors {
                top: parent.top 
                horizontalCenter: parent.horizontalCenter
            }
            width: 164
            height: 17
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 17 
            text: isagain ? i18n("Verify your new password") :i18n("Enter your new password")
        }

        Kirigami.JKeyBdLineEdit{
            id:keyLineEdit
            anchors.centerIn:parent
            width:233
            height:30
         
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: input_title.bottom
            anchors.topMargin:24
            courseColor:"#FF3C4BE8"
            textColor:"black"
            cleanIconColor:"#FFFFFF"
            cleanIconBackgroundColor:"#FFAEAEAE"
            
            onMousePress:{
                virtuaKey.open()
            }
        }

        PlasmaComponents.Label {
            
            id: errortTip
            anchors.top: keyLineEdit.bottom//authenticationinput.bottom
            anchors.topMargin: 8
            font.pixelSize: 12
            height: 14
            width: 233
            color: "#FFE95B4E"
            visible: isErrorShow

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text:{
                if(errorStatus == 1){
                    return i18n("Wrong password, please try again")
                }else if(errorStatus == 2){
                    return i18n("Password did not match, please try again")                    
                }else if(errorStatus == 3){
                    return i18n("Set a 4 to 32-character password") 
                }
            } 
        }

        PlasmaComponents.Label {
            
            id: input_tip
            anchors.top: keyLineEdit.bottom//authenticationinput.bottom
            anchors.topMargin: 8
            anchors.horizontalCenter:parent.horizontalCenter
            font.pixelSize: 12
            height: 14
            color: "#993C3C43"
            visible: !isagain && !isErrorShow
            horizontalAlignment: Text.AlignHCenter
            text:i18n("Set a 4 to 32-character password") 
        }

        
    }

    function verifyPasswordWord(passwordStr){
        if(passwordStr.length >= 4 && passwordStr.length <= 32){
            // 通过 正则表达式 检测文字的合法性
            password  = passwordStr
            isagain = true 
            keyLineEdit.labelData =""
            keyLineEdit.labelDisplayData =""
        } else if (passwordStr.length < 4 | passwordStr.length > 32){
            isErrorShow = true
            errorStatus = 3
        } else {
            isErrorShow = true
            errorStatus = 1
        }
    }

    function checkPassword() {
        if(password == passwordagain) {
            popView()
            kcm.setPassword(password,"complex")
        } else {
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

    Kirigami.JPasswdKeyBd{
            id:virtuaKey
            boardHeight:648*0.5069
            y:complex_pwd.height-boardHeight
            closePolicy:Popup.NoAutoClose
            onKeyBtnClick:{
                if(isErrorShow){
                    isErrorShow = false 
                }
                keyLineEdit.opAddStr(str)
            }
            onKeyBtnEnter:{
                if(isagain){
                    passwordagain = keyLineEdit.labelData
                    checkPassword()
                }else {
                    verifyPasswordWord(keyLineEdit.labelData)
                }
            }
            onKeyBtnDel:{
                isErrorShow = false 
                keyLineEdit.opSubStr()
            }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_Return){
            if(isagain){
                passwordagain = keyLineEdit.labelData
                checkPassword()
            }else {
                verifyPasswordWord(keyLineEdit.labelData)
            }
        }
    }

}

 
