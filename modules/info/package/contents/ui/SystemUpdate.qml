

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

    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    property real appScale: 1.3 * screenWidth / 1920
    property int appFontSize: theme.defaultFont.pointSize
    property string processTxt: i18n("Downloading...")
    property string valueVersion
    property string currentVersion
    property string errorContent

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

    width: parent.width
    height: parent.height

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
            }
        }
    }

    Component.onCompleted: {
        currentVersion = updateTool.readLocalVersion()
        updateTool.readRemoteVersion()

        if (networkStatus.networkStatus != "Connected") {
            checkNetworkDlg.open()
        }
    }

    Timer {
        id: checkVersion

        interval: 3000 
        repeat: false
        triggeredOnStart: false

        onTriggered: {
            upState = 1
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
                leftMargin: 34 * system_info_root.appScale
                topMargin: 68 * system_info_root.appScale
                right: parent.right
                rightMargin: 67 * system_info_root.appScale
            }

            width: parent.width - 111 * appScale
            height: 41 * appScale
            color: "transparent"

            Image {
                id: back_icon
                
                anchors.verticalCenter: parent.verticalCenter

                width: 34 * appScale
                height: width
                source: "../image/icon_left.png"
                sourceSize.width: width
                sourceSize.height: width
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("back..about")
                        system_info_root.popView()
                    }
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                    leftMargin: 9 * appScale
                }

                width: 500
                height: 50
                verticalAlignment: Text.AlignVCenter

                text: i18n("System Update")
                font.pointSize: appFontSize + 11
                font.weight: Font.Bold
            }

            Image {
                id: setting_icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                width: 36 * appScale
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
                topMargin: 57 * appScale
            }

            width: parent.width
            height: (36 + 15 + 114) * appScale

            color: "transparent"
            visible: upState != 2

            AnimatedImage {
                id: gifImage

                anchors.horizontalCenter: parent.horizontalCenter
                width: 105 * appScale
                height: 116 * appScale
                fillMode: Image.PreserveAspectFit
                source: "../image/load.gif"
                visible: upState == 0
                playing: visible
            }

            Image {
                id: jingos_logo

                anchors.horizontalCenter: parent.horizontalCenter
                width: 105 * appScale
                height: 116 * appScale
                visible: upState == 1
                source: "../image/jingos_logo_update.png"
            }
            Text {
                id: check_tag2

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: jingos_logo.bottom
                    topMargin: 55 * appScale
                }

                visible: upState == 1
                text: i18n("Discover system updatable version %1" , valueVersion)
                font.pointSize: appFontSize + 6
                color: "black"
            }
        }

        Rectangle {
            id: content_area1

            anchors {
                top: page_statusbar.bottom
                topMargin: 257 * appScale
            }

            width: parent.width
            height: (36 + 15 + 114) * appScale
            color: "transparent"
            visible: upState == 2

            Image {
                id: jingos_logo2

                anchors.horizontalCenter: parent.horizontalCenter

                width: 105 * appScale
                height: 116 * appScale
                source: "../image/jingos_logo_update.png"
            }

            Text {
                id: check_tag3

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: jingos_logo2.bottom
                    topMargin: 55 * appScale
                }
                horizontalAlignment: Text.AlignHCenter

                visible: upState == 2
                text: i18n("Your software is already the latest version\n %1" , currentVersion)
                font.pointSize: appFontSize + 6
                color: "black"
            }
        }

        Rectangle {
            id: content_progress

            anchors {
                top: content_area.bottom
                bottom: update_btn.top
                topMargin: 37 * appScale
                bottomMargin: 37 * appScale
            }

            width: parent.width
            color: "transparent"

            Text {
                id: check_tag

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: content_progress.top

                visible: upState == 0
                text: i18n("Checking for updates...")
                font.pointSize: appFontSize + 6
                color: "#99000000"
            }

            Rectangle {
                id: changelog_area

                anchors {
                    fill: parent
                    topMargin: 30 * appScale
                    leftMargin: 106 * appScale
                    rightMargin: 106 * appScale
                }

                width: 854 * appScale
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
                            leftMargin: 10 * appScale
                            rightMargin: 10 * appScale
                        }
                        
                        width: 750 * appScale

                        text: changeLog
                        wrapMode: Text.WordWrap
                        font.pointSize: appFontSize + 6
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
                bottomMargin: 100 * appScale
            }

            width: 400 * appScale
            height: 68 * appScale

            color: "blue"
            radius: 15 * appScale
            visible: upState == 1

            Text {
                anchors.centerIn: parent
                color: "white"
                text: i18n("Update now")
                font.pointSize: appFontSize + 2
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
            leftButtonText: i18n("OK")
            rightButtonText: i18n("Cancel")
            dim: true
            focus: true

            onRightButtonClicked: {
                checkBatteryDlg.close()
            }

            onLeftButtonClicked: {
                updateTool.launchDistUpgrade(valueVersion)
                system_info_root.popView()
                checkBatteryDlg.close()
            }
        }

        Kirigami.JDialog {
            id: checkNetworkDlg

            anchors.centerIn: parent
            title: i18n("Unable to check for updates")
            text: i18n("Please connect to the network and try again")
            leftButtonText: "OK"
            rightButtonText: "Cancel"
            dim: true
            focus: true

            onRightButtonClicked: {
                system_info_root.popView()
                checkBatteryDlg.close()
            }

            onLeftButtonClicked: {
                system_info_root.popView()
                checkBatteryDlg.close()
            }
        }

        Kirigami.JDialog {
            id: checkErrorDlg

            anchors.centerIn: parent
            
            title: i18n("Unable to check for updates")
            text: errorContent
            leftButtonText: i18n("OK")
            rightButtonText: i18n("Cancel")
            dim: true
            focus: true

            onRightButtonClicked: {
                checkBatteryDlg.close()
                system_info_root.popView()
            }

            onLeftButtonClicked: {
                checkBatteryDlg.close()
                system_info_root.popView()
            }
        }
    }
}
