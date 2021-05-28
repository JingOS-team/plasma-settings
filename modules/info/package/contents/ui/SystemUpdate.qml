

/**
 * SPDX-FileCopyrightText: 2021 Wang Rui <wangrui@jingos.com>
 *                         
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */
import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.10

import org.kde.kirigami 2.15 as Kirigami
import org.kde.kcm 1.2
import org.jingos.info 1.0
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

Item {
    id: display_sub

    property string processTxt: i18n("Downloading...")
    property string valueVersion
    property string currentVersion
    property string errorContent


    property int screenWidth: 888
    property int screenHeight: 648
    property int appFontSize: theme.defaultFont.pixelSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 17
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36
    property int marginLeftAndRight : 20 
    property int marginItem2Top : 24 

    // width: screenWidth * 0.7
    // height: screenHeight


    /*
        0: checking:
        1: checked_update_avilable
        2: checked_update_unavilable
        3: downloading
        4:install
    */
    property int upState: 0
    property string changeLog: "Change log: \n\nFeature: \n1. adfasdfasdfasdflaksjdfaksjdf;askjfd;alkjf \n" + "2. l;akdjf;alkjsdf;alksdjfaidsfjpaoijpoijpijdsfuahioueqwhoiru \n" + "3. uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n\n"
                               + "Bug : \n" + "1. adfasdfasdfasdflaksjdfaksjdf;askjfd;alkjf \n "
                               + "2. l;akdjf;alkjsdf;alksdjfaidsfjpaoijpoijpijdsfuahioueqwhoiru \n" + "3. uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "4. uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "5. uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "6. uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "6.1 uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "6.2 uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "6.3 uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "6.4 uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf \n" + "7. uhuefhoqwufhoiqwhefoqwifhiqwuefhoiqwuhfoiqwuefhiqwuf "

    PlasmaNM.EnabledConnections {
        id: enabledConnections
    }

    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    UpdateTool {
        id: updateTool

        onCheckedFinish: {
            upState = status
            changeLog = log
            if (upState == 1) {
                valueVersion = version
            } else if (upState == 3) {
                errorContent = i18n("Sever replied: Not Found ")
                checkErrorDlg.open()
            } else if (upState == 4) {
                errorContent = i18n("Request Timeout ")
                checkErrorDlg.open()
            }
        }
    }

    Component.onCompleted: {
        if (networkStatus.networkStatus != "Connected") {
            checkNetworkDlg.open()
        }else {
            checkVersion.start();
        }
    }

    Timer {
        id: checkVersion

        interval: 2000 
        repeat: false
        triggeredOnStart: false

        onTriggered: {
            // upState = 1
            updateTool.readRemoteVersion()
            currentVersion = updateTool.readLocalVersion()
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#FFF6F9FF"

        Rectangle {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: statusbar_height
            color: "transparent"

            Image {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: statusbar_icon_size
                height: width
                source: "../image/icon_left.png"
                sourceSize.width: width
                sourceSize.height: width

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        popView()
                    }
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 
                }

                width: 359
                height: 14
                text: i18n("System Update")
                // font.pixelSize: appFontSize + 11
                font.pixelSize: 20
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: setting_icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 25 

                width: 17
                height: width
                source: "../image/update_settings.png"
                sourceSize.width: width
                sourceSize.height: width

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("update...")
                        system_info_root.gotoPage("update_setting_view")
                    }
                }
            }
        }

        Rectangle {
            id: content_area

            anchors {
                top: page_statusbar.bottom
                topMargin: marginItem2Title
            }

            width: parent.width
            height:  21+36+76
            color: "transparent"
            visible: upState != 2

            AnimatedImage {
                id: gifImage

                anchors.horizontalCenter: parent.horizontalCenter
                width: 69
                height: 76
                fillMode: Image.PreserveAspectFit
                source: "../image/load.gif"
                visible: upState == 0
                playing: visible
            }

            Image {
                id: jingos_logo

                anchors.horizontalCenter: parent.horizontalCenter
                width: 69
                height: 76
                visible: upState == 1
                source: "../image/jingos_logo_update.svg"
            }
            Text {
                id: check_tag2

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: jingos_logo.bottom
                    topMargin: 36
                }

                visible: upState == 1
                text: i18n("Discover system updatable version %1" , valueVersion)
                font.pixelSize: 14
                color: "black"
            }
        }

        Rectangle {
            id: content_area1

            anchors {
                top: page_statusbar.bottom
                topMargin: marginItem2Title
            }

            width: parent.width
            height:  21+36+76
            color: "transparent"
            visible: upState == 2

            Image {
                id: jingos_logo2

                anchors.horizontalCenter: parent.horizontalCenter

                width: 69
                height: 76
                source: "../image/jingos_logo_update.png"
            }

            Text {
                id: check_tag3

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: jingos_logo2.bottom
                    topMargin: 36
                }
                horizontalAlignment: Text.AlignHCenter

                visible: upState == 2
                text: i18n("Your software is already the latest version\n %1" , currentVersion)
                font.pixelSize: appFontSize + 6
                color: "black"
            }
        }

        Rectangle {
            id: content_progress

            anchors {
                top: content_area.bottom
                bottom: update_btn.top
                topMargin: 18
                bottomMargin: 18
            }

            width: parent.width
            color: "transparent"

            Text {
                id: check_tag

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: content_progress.top

                visible: upState == 0
                text: i18n("Checking for updates...")
                font.pixelSize: 14
                color: "#99000000"
            }

            Rectangle {
                id: changelog_area

                anchors {
                    fill: parent
                    topMargin: 33 
                    leftMargin: 102 
                    rightMargin: 102 
                }

                width: 854 
                color: "transparent"
                visible: upState == 1
                // clip:true

                ScrollView {
                    anchors.fill: parent

                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    contentWidth: -1
                    background: Item {}

                    Text {
                        id: change_log

                        anchors {
                            left: changelog_area.left
                            right: changelog_area.right
                            leftMargin: 60 
                            rightMargin: 60 
                        }
                        
                        width: 555

                        text: changeLog
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                        color: "#99000000"
                    }
                }
            }
        }

        Rectangle {
            id: update_btn

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 100 
            }

            width: 370
            height: 42

            color: "blue"
            radius: 10
            visible: upState == 1

            Text {
                anchors.centerIn: parent
                color: "white"
                text: i18n("Update now")
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    checkBatteryDlg.open()
                }
            }
        }

        Kirigami.JDialog {
            id: checkBatteryDlg

            anchors.centerIn: parent

            title: i18n("Update suggestion")
            text: i18n("It is recommended that the battery reaches 50% or connect to the power supply to update")
            centerButtonText: i18n("OK")
            // rightButtonText: i18n("Cancel")
            dim: true
            focus: true

            onCenterButtonClicked: {
                updateTool.launchDistUpgrade(valueVersion)
                system_info_root.popView()
                checkBatteryDlg.close()
            }
        }

        Kirigami.JDialog {
            id: checkNetworkDlg

            anchors.centerIn: parent
            title: i18n("Unable to check for updates")
            text: i18n("Please connect to the network and \n try again")
            centerButtonText: i18n("OK")
            dim: true
            focus: true

            onCenterButtonClicked: {
                system_info_root.popView()
                checkBatteryDlg.close()
            }
        }

        Kirigami.JDialog {
            id: checkErrorDlg

            anchors.centerIn: parent
            
            title: i18n("Unable to check for updates")
            text: errorContent
            centerButtonText: i18n("OK")
            dim: true
            focus: true

            onCenterButtonClicked: {
                checkBatteryDlg.close()
                system_info_root.popView()
            }
        }
    }
}
