

/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQml.Models 2.1
import QtGraphicalEffects 1.0

Item {

    id: editItem

    property alias headCount: rcmdApp.count

    property bool isListViewPress
    //    property Component lockComponent : Qt.createComponent("LockScrrenView.qml")
    //    property Component mainInterfaceComponent : Qt.createComponent("MainInterface.qml")
    signal bannerItemClicked(var bannerName)
    z: 100
    ListView {
        id: rcmdApp
        anchors {
            top: parent.top
        }
        height: parent.height
        width: parent.width
        orientation: Qt.Horizontal
        interactive: true
        clip: true
        spacing: 20
        snapMode: ListView.SnapOneItem
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightMoveDuration: 500
        maximumFlickVelocity: 10000
        highlightMoveVelocity: 5000
        Component.onCompleted: {
            listModel.clear()
            listModel.append(lockComponent.createObject())
            listModel.append(mainInterfaceComponent.createObject())
        }

        onMovementStarted: {
            isListViewPress = true
        }

        onMovementEnded: {
            isListViewPress = false
        }
        model: listModel
    }

    ObjectModel {
        id: listModel
    }

    Component {
        id: lockComponent
        LockScrrenView {
            id: lockView
            width: editItem.width
            height: editItem.height
            imageRadius: 0
        }
    }

    Component {
        id: mainInterfaceComponent
        MainInterface {
            id: mainFace
            width: editItem.width
            height: editItem.height
            imageRadius: 0
        }
    }

    Column {
        anchors {
            bottom: rcmdApp.bottom
            bottomMargin: 82 * appScale
        }
        spacing: 53 * appScale
        width: parent.width //351 * appScale
        PageIndicator {
            id: pageIndicator
            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            interactive: false
            count: rcmdApp.count
            spacing: 15
            currentIndex: rcmdApp.currentIndex
            delegate: Rectangle {
                width: 10
                height: width
                radius: width / 2
                color: rcmdApp.currentIndex === index ? "#FFFFFF" : "#4DFFFFFF"
            }
        }

        Item {
            id: editImage

            anchors {
                horizontalCenter: pageIndicator.horizontalCenter
            }
            width: editIcon.width + tipText.contentWidth
            height: 30

            Image {
                id: editIcon
                width: 30
                height: width
                source: "../image/camera.png"
            }

            Text {
                id: tipText
                anchors {
                    left: editIcon.right
                    leftMargin: 10
                    verticalCenter: editIcon.verticalCenter
                }
                text: i18n("Move & Scale")
                color: "#FFFFFF"
                font.pointSize: appFontSize + 2
            }
        }

        Row {
            id: buttonrow
            anchors {
                horizontalCenter: pageIndicator.horizontalCenter
            }
            spacing: 172 * appScale

            Button{
                id:cancelButton
                width: 179 * appScale
                height: 56 * appScale
                contentItem: Item {
                    id: cancelItem
                    Text {
                        id: cancelText
                        anchors.centerIn: parent
                        text: i18n("Cancel")
                        font.pointSize: appFontSize + 2
                        color: "#000000"
                    }
                }
                background:  Rectangle {
                    width: 179 * appScale
                    height: 56 * appScale
                    radius: 20
                    color: "#99FFFFFF"
                }
                onClicked: {
                    popView()
                }
            }

            Button{
                id:setButton
                width: 179 * appScale
                height: 56 * appScale
                contentItem: Item {
                    id: setItem
                    Text {
                        id: setText
                        anchors.centerIn: parent
                        text: i18n("Set")
                        font.pointSize: appFontSize + 2
                        color: "#000000"
                    }
                }
                background:  Rectangle {
                    width: 179 * appScale
                    height: 56 * appScale
                    radius: 20
                    color: "#99FFFFFF"
                }
                onClicked: {
                    jsetMenu.popup(rcmdApp,rcmdApp.width/2 - jsetMenu.mwidth / 2,rcmdApp.height/2 - jsetMenu.mheight/2)
                }
            }
        }
    }

    Component{
        id:menuBackComponent
        Item{
            id:menuBack
            width: rcmdApp.width
            height: rcmdApp.height
            ShaderEffectSource {
                id: eff
                width: fastBlur.width
                height: fastBlur.height
                sourceItem: rcmdApp
                anchors.centerIn: fastBlur
                visible: false
                sourceRect: Qt.rect(rcmdApp.x, rcmdApp.y, width, height)
            }
            FastBlur {
                id: fastBlur
                anchors.fill: parent
                source: eff
                radius: 64
                cached: true
            }
        }
    }
    Loader{
        id:menuLoader
        sourceComponent: menuBackComponent
        active: loadRect.visible | jsetMenu.opened
    }

    JSetMenu{
        id:jsetMenu
        onSetLockClicked: {
            isShowSetting = true
        }
        onSetHomeClicked: {
            isShowSetting = true
        }
        onSetBothClicked: {
            isShowSetting = true
        }
    }
    property bool isShowSetting
    Rectangle{
        id:loadRect
        anchors.centerIn: parent
        width: 433 * appScale
        height: 120 * appScale
        color: "#99FFFFFF"
        visible: isShowSetting
        radius: 20
        Item {
            id: loadmiddle
            anchors.centerIn: parent
            width: loadImage.width + loadTipText.width + 10
            height: loadImage.height
            Image {
                id: loadImage

                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                width: 44 * appScale
                height: width
                source: "../image/loading.png"
                RotationAnimation{
                    from: 0
                    to:360
                    loops:Animation.Infinite
                    target: loadImage
                    duration: 1000
                    running: loadRect.visible
                }
            }
            Text {
                id: loadTipText

                anchors{
                    verticalCenter: loadImage.verticalCenter
                    left: loadImage.right
                    leftMargin: 10
                }
                text: i18n("Setting wallpaper...")
                color: "#000000"
                font.pointSize: appFontSize + 2
            }
        }


    }

    Timer{
        id:loadTimer
        interval:5000
        running: isShowSetting
        onTriggered:{
            isShowSetting = false
        }
    }

}
