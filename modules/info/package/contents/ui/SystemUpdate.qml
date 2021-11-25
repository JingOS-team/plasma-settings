/*
 * Copyright (C) 2021 Beijing Jingling Information System Technology Co., Ltd. All rights reserved.
 *
 * Authors:
 * Zhang He Gang <zhanghegang@jingos.com>
 *
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

    property int screenWidth: 888 * appScale
    property int screenHeight: 648 * appScale
    property int statusbar_height : 22 * appScale
    property int statusbar_icon_size: 17 * appScale
    property int default_setting_item_height: 45 * appScale

    property int marginTitle2Top : 44  * appScale
    property int marginItem2Title : 36 * appScale
    property int marginLeftAndRight : 14  * appScale
    property int marginItem2Top : 24  * appScale
    property bool isDarkTheme: Kirigami.JTheme.colorScheme === "jingosDark"

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

    Connections {
        target: updateTool

        onCheckedFinish: {
            upState = status
            changeLog = log
            if (upState == 1) {
                rootHasNewVersion = 1
                valueVersion = version
            } else if (upState == 2) {
                rootHasNewVersion = 2
            } else if (upState == 3) {
                errorContent = i18n("Sever replied: Not Found ")
                checkErrorDlg.open()
            } else if (upState == 4) {
                errorContent = i18n("Request Timeout ")
                checkErrorDlg.open()
            } else if (upState == 5) {
                rootHasNewVersion = 1
                valueVersion = version
            }
        }
    }

    Component.onCompleted: {
        if (networkStatus.networkStatus != "Connected") {
            checkNetworkDlg.open()
        } else {
            checkVersion.start();
        }
    }

    Timer {
        id: checkVersion

        interval: 2000
        repeat: false
        triggeredOnStart: false

        onTriggered: {
            updateTool.readRemoteVersion()
            currentVersion = updateTool.readLocalVersion()
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: Kirigami.JTheme.settingMinorBackground

        Rectangle {
            id: page_statusbar

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: marginLeftAndRight - 10 * appScale
                topMargin: marginTitle2Top
            }

            width: parent.width - marginLeftAndRight * 2
            height: statusbar_height
            color: "transparent"

            Kirigami.JIconButton {
                id: back_icon

                anchors.verticalCenter: parent.verticalCenter

                width: (22 + 8) * appScale
                height: width
                source: Qt.resolvedUrl("../image/icon_left.png")
                color: Kirigami.JTheme.iconForeground
                onClicked: {
                    popView()
                }
            }

            Text {
                id: title

                anchors {
                    verticalCenter: parent.verticalCenter
                    left: back_icon.right
                }
                width: 359 * appScale
                height: 14 * appScale

                text: i18n("Software Update")
                font.pixelSize: 20 * appFontSize
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
                color: Kirigami.JTheme.majorForeground
            }

            Kirigami.JIconButton {
                id: setting_icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                width: 35 * appScale
                height: width

                source: Qt.resolvedUrl("../image/update_settings.svg")
                color: Kirigami.JTheme.iconForeground
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        system_info_root.gotoPage("update_setting_view")
                    }
                }
            }
        }

        Rectangle {
            id: content_area

            anchors {
                top: page_statusbar.bottom
                topMargin: content_progress.visible ? 12 * appScale : marginItem2Title * 4
            }
            width: parent.width
            height:  (21+36+76+36) * appScale

            color: "transparent"
            visible: upState != 2
            AnimatedImage {
                id: gifImage

                anchors.horizontalCenter: parent.horizontalCenter
                width: 69 * appScale
                height: 76 * appScale
                fillMode: Image.PreserveAspectFit
                source: isDarkTheme ? "../image/black_load.gif" : "../image/load.gif"
                visible: upState == 0
                playing: visible
            }

            Image {
                id: jingos_logo

                anchors.horizontalCenter: parent.horizontalCenter
                width: 69 * appScale
                height: 76 * appScale
                visible: upState === 1 || upState === 5
                source: "../image/jingos_logo_update.svg"
            }

            Text {
                id: check_tag

                anchors{
                    horizontalCenter: parent.horizontalCenter
                    top: gifImage.bottom
                    topMargin: 16 * appScale
                }

                visible: gifImage.visible
                text: i18n("Checking for updates...")
                font.pixelSize: 17 * appFontSize
                color: Kirigami.JTheme.minorForeground
            }

            Text {
                id: check_tag2

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: jingos_logo.bottom
                    topMargin: 16 * appScale
                }

                visible: jingos_logo.visible
                text: upState === 5 ? i18n("Current version %1  found updateable packages",valueVersion) : i18n("Discover system updatable version %1" , valueVersion)
                font.pixelSize: 14 * appFontSize
                color: Kirigami.JTheme.majorForeground//"black"
            }

            Text {
                id: check_tip

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: check_tag2.bottom
                    topMargin: 20 * appScale
                }
                width: parent.width - (30  * appScale + marginLeftAndRight) * 2
                wrapMode: Text.WordWrap
                maximumLineCount: 2

                visible: jingos_logo.visible
                text: i18n("Before updating, please make sure your device is charged. During the updating process, please connect to the Internet throughout.")
                font.pixelSize: 12 * appFontSize
                horizontalAlignment: Text.AlignHCenter
                color: Kirigami.JTheme.majorForeground
            }
        }

        Rectangle {
            id: content_area1

            anchors {
                top: page_statusbar.bottom
                topMargin: marginItem2Title * 4
            }

            width: parent.width
            height: 133 * appScale
            color: "transparent"
            visible: upState == 2

            Image {
                id: jingos_logo2

                anchors.horizontalCenter: parent.horizontalCenter
                width: 69 * appScale
                height: 76 * appScale

                source: "../image/jingos_logo_update.png"
            }

            Text {
                id: check_tag3

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: jingos_logo2.bottom
                    topMargin: 36 * appScale
                }
                horizontalAlignment: Text.AlignHCenter

                visible: upState == 2
                text: i18n("Your software is already the latest version\n %1" , currentVersion)
                font.pixelSize: 17 * appFontSize
                color: Kirigami.JTheme.majorForeground
            }
        }

        Rectangle {
            id: content_progress

            anchors {
                top: content_area.bottom
                bottom: update_btn.top
                bottomMargin: 18 * appScale
            }

            width: parent.width
            color: "transparent"
            visible: upState == 1

            ScrollView {
                anchors.fill: parent

                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                contentWidth: -1
                background: Item {}

                Text {
                    id: change_log

                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: 30  * appScale + marginLeftAndRight
                        rightMargin: 30  * appScale + marginLeftAndRight
                    }

                    text: changeLog
                    wrapMode: Text.WordWrap
                    font.pixelSize: 14 *appFontSize
                    color: Kirigami.JTheme.minorForeground
                }
            }
        }

        Rectangle {
            id: update_btn

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 41  * appScale
            }

            width: 370 * appScale
            height: 42 * appScale

            color: Kirigami.JTheme.highlightColor//"blue"
            radius: 10 * appScale
            visible: upState === 1 || upState === 5

            Text {
                anchors.centerIn: parent
                color: "white"
                text: i18n("Update now")
                font.pixelSize: 14 * appFontSize
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

            title: i18n("Update suggestion")
            text: i18n("It is recommended that the battery reaches 50% or connect to the power supply to update")
            centerButtonText: i18n("OK")
            dim: true
            focus: true

            onCenterButtonClicked: {
                if (updateTool.getQaptupdatorUpdateStatus() === 2) {
                    system_info_root.rootHasupdating = true
                } else {
                    system_info_root.rootHasupdating = false
                }
                updateTool.launchDistUpgrade(valueVersion)
                checkBatteryDlg.close()
                system_info_root.popView()
            }
        }

        Kirigami.JDialog {
            id: checkNetworkDlg

            title: i18n("Unable to check for updates")
            text: i18n("Please connect to the network and \n try again")
            centerButtonText: i18n("OK")
            dim: true
            focus: true

            onCenterButtonClicked: {
                checkNetworkDlg.close()
                system_info_root.popView()
            }
        }

        Kirigami.JDialog {
            id: checkErrorDlg

            title: i18n("Unable to check for updates")
            text: errorContent
            centerButtonText: i18n("OK")
            dim: true
            focus: true
            onCenterButtonClicked: {
                checkErrorDlg.close()
                system_info_root.popView()
            }
        }
    }
}
