/*
    Copyright 2014-2015 Harald Sitter <sitter@kde.org>
    Copyright 2016 David Rosca <nowrep@gmail.com>
    Copyright 2019 Sefa Eyeoglu <contact@scrumplex.net>
    Copyright 2020 Nicolas Fella <nicolas.fella@gmx.de>
    Copyright 2021 Wang Rui <wangrui@jingos.com>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of
    the License or (at your option) version 3 or any later version
    accepted by the membership of KDE e.V. (or its successor approved
    by the membership of KDE e.V.), which shall act as a proxy
    defined in Section 14 of version 3 of the license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0 as QQC2

import org.kde.kcm 1.3
import org.kde.kirigami 2.15 as Kirigami
import org.kde.plasma.private.volume 0.1
import "openUtils.js" as Nav
import org.kde.kcm 1.2
import jingos.display 1.0

Item {

    id: wallpaper_root

    property real appScale: JDisplay.dp(1.0)
    property real heightScale: appScale
    property int appFontSize: 14 * JDisplay.sp(1.0) 

    property variant systemWallpapers: kcm.systemWallpapers
    property string wallpaperUrl: kcm.wallpaperUrl
    property string lockwallpaperUrl: kcm.lockwallpaperUrl
    property int detailX: Screen.width + 50 * appScale
    property bool isSetWallpaper
    property bool isCurrentWallpaperLoaded: false
    property bool isTipImageLoaded: tipImage.isImageReady

    signal wallpaperChanged()

   anchors.fill:parent 

    onWallpaperChanged:{
        console.log("****** wallpaper changed lockwallpaperUrl:" + kcm.lockwallpaperUrl + " wallpaper:" + kcm.wallpaperUrl)
        // lockScrrenView.lockImageUrl = ""
        // lockScrrenView.lockImageUrl = kcm.lockwallpaperUrl
        // mainInterface.mainInterfaceImageUrl = ""
        // mainInterface.mainInterfaceImageUrl = kcm.wallpaperUrl
        lockwallpaperUrl = ""
        lockwallpaperUrl = kcm.lockwallpaperUrl
        wallpaperUrl = ""
        wallpaperUrl = kcm.wallpaperUrl
    }

    QQC2.StackView {
        id: stack

        anchors.fill: parent

        Component.onCompleted: {
            stack.push(home_view)
        }
    }

    Connections {
        target: kcm

        onCurrentIndexChanged:{
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

    function openSystemWallpaper(){
        console.log(" kcm url :" + systemWallpapers)
        console.log(" kcm count 0 :" + systemWallpapers.length)
        stack.push(detailComponent)
        // zoomAnim.x = 0
        // zoomAnim.mainX = 0 - width - 10
        // zoomAnim.running = true
    }

    function popView() {
        stack.pop()
        // zoomAnim.x = width + 10
        // zoomAnim.mainX = 0
        // zoomAnim.running = true
    }

    // ParallelAnimation
    //     {
    //         id: zoomAnim
    //         property real x: 0
    //         property real mainX: 0

    //         NumberAnimation
    //         {
    //             // target: wallpaperDetail
    //             property: "x"
    //             // from: wallpaperDetail.x
    //             to: zoomAnim.x
    //             duration: Kirigami.Units.longDuration
    //             easing.type: Easing.InOutQuad
    //         }
    //         NumberAnimation
    //         {
    //             // target: mainView
    //             property: "x"
    //             from: mainView.x
    //             to: zoomAnim.mainX
    //             duration: Kirigami.Units.longDuration
    //             easing.type: Easing.InOutQuad
    //         }
    //     }

    Component{
        id:home_view
        Rectangle {
            id:mainView
            width: parent.width
            height: parent.height

            color: Kirigami.JTheme.settingMinorBackground//"#FFF6F9FF"
            Text {
                id: wallpaper_title

                anchors {
                    left: parent.left
                    top: parent.top
                    leftMargin: 20 * appScale
                    topMargin: 44 * appScale
                }

                width: 500 * appScale
                text: i18n("Wallpaper")
                color: Kirigami.JTheme.majorForeground
                font.pixelSize: appFontSize + 6
                font.weight: Font.Bold
            }
            Row {
                id:mainTop
                anchors{
                    left: wallpaper_title.left
                    top: wallpaper_title.bottom
                    topMargin: 18 * appScale
                    right: systemWallpaper.right
                }
                spacing: 43 * appScale
                height: 197 * heightScale
                // width: lockScrrenView.width*2 + spacing
                property var itemWidth: (width - spacing) / 2
                LockScrrenView{
                    id:lockScrrenView
                    width: mainTop.itemWidth//270 * appScale
                    height: 197 * heightScale
                    imageRadius: 10 * appScale
                }
                MainInterface{
                    id:mainInterface
                    width: mainTop.itemWidth
                    height: 197 * heightScale
                    imageRadius: 10 * appScale
                    onMainWallpaperBackgroundReadyChanged:{
                        isCurrentWallpaperLoaded = mainWallpaperBackgroundReady
                    }
                    
                }
            }

            RectshowView{
                id:systemWallpaper

                anchors{
                    top: mainTop.bottom
                    topMargin: 25 * appScale
                    left: wallpaper_title.left
                    right: parent.right
                    rightMargin: 20 * appScale
                }
                width: parent.width
                height: 77 * appScale
                rectRadius: height / 8
                borderWidth: 0
                color: Kirigami.JTheme.cardBackground//"#FFFFFF"
                RadiusImage{
                    id:tipImage

                    anchors.left: parent.left
                    height: parent.height
                    width: height
                    imageRadius: systemWallpaper.radius
                    url: isCurrentWallpaperLoaded ? (systemWallpapers.length > 0 ? "image://imageProvider/"+systemWallpapers[0] : "../image/local_default.png") : ""
                    defaultUrl: "../image/local_default.png"
                    imageView.mipmap: true
                }
                Item {
                    id: contentItem

                    anchors{
                        verticalCenter: tipImage.verticalCenter
                        left: tipImage.right
                        leftMargin: 12 * appScale
                    }
                    width: titleText.contentWidth
                    height: titleText.contentHeight + lengthText.contentHeight + 10 * appScale
                    Text {
                        id: titleText
                        anchors{
                            top: parent.top
                        }
                        text: i18n("System wallpaper")
                        color: Kirigami.JTheme.majorForeground//"#000000"
                        font.pixelSize: appFontSize
                    }
                    Text {
                        id: lengthText

                        anchors{
                            top: titleText.bottom
                            topMargin: 4 * appScale
                        }
                        text: systemWallpapers.length
                        color: Kirigami.JTheme.minorForeground//"#4D000000"
                        font.pixelSize: appFontSize - 2
                    }
                }

                Kirigami.JIconButton {
                    id: infoDetailImage
                    anchors{
                        right: parent.right
                        rightMargin: 11 * appScale
                        verticalCenter: parent.verticalCenter
                    }
                    width: 30 * appScale
                    height: 30 * appScale
                    source: "qrc:/package/contents/image/icon_right.png"
                    color:Kirigami.JTheme.iconMinorForeground
                }

                MouseArea{
                 anchors.fill: parent
                 onClicked: {
                     if (systemWallpapers.length > 0) {
                        openSystemWallpaper()
                     }
                 }
                }
            }
        }


    }

    Component{
        id:detailComponent
        SystemWallpaperView{
          id:wallpaperDetail
          width: wallpaper_root.width
          height: wallpaper_root.height
        //   Component.onCompleted:{
        //       x = detailX
        //   }
        }
    }


}
