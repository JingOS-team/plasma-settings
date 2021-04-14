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

import QtQuick 2.2
import org.kde.kirigami 2.5
import org.kde.kirigami 2.15
import QtQuick.Controls 2.14 as QQC2

QQC2.Popup  {
    id: dialog

    property int jingUnit: 18
    property string text
    property string title
    property string centerButtonText
    property int startX: 0
    property int startY: 0
    property QtObject sourceItem: null
    
    signal centerButtonClicked()

    anchors.centerIn: parent

    modal: true
    closePolicy: QQC2.Popup.NoAutoClose
    height: jingUnit * 14
    width:  jingUnit * 25

    contentItem: Item {
        anchors.fill: parent

        Text {
            id: titleText

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: jingUnit * 2 - 4
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter 
            verticalAlignment: Text.AlignVCenter 
            
            width: parent.width - jingUnit
            height: jingUnit * 2 - 2
            font.pointSize: 22
            color: "#000000"
            text: dialog.title
        } 

        Text {
            anchors.top: titleText.bottom
            anchors.topMargin: jingUnit - 3
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter 
            verticalAlignment: Text.AlignVCenter 

            width: parent.width -  jingUnit
            font.pointSize: 17
            wrapMode: Text.WordWrap
            color: "#000000"
            text: dialog.text
        }

        Item {
            id: footer

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            height: jingUnit * 4
            width: parent.width - jingUnit
            Rectangle{
                anchors.top : parent.top
                width : parent.width
                height : 1
                color : "#5C3C3C43"
            }
            Text{
                anchors.centerIn : parent
                text: dialog.centerButtonText
                color: "#FF3C4BE8"
                font.pointSize : 22
            }
            MouseArea{
                anchors.fill : parent
                onClicked:{
                    dialog.centerButtonClicked()
                }
            }
        }
    }

    background: JBlurBackground{
        id: bkground

        width:parent.width
        height: parent.height
        sourceItem: applicationWindow().pageStack.currentItem
        backgroundColor:"#EDFFFFFF"
        
        blurRadius: 130
        radius: jingUnit 
    }

    onVisibleChanged:{
        var jx = contentItem.mapToItem(dialog.parent, dialog.x, dialog.y)
        bkground.startX = jx.x
        bkground.startY = jx.y
    }
}
