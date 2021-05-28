

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
import QtQuick 2.4 as QtQ
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3 as Controls

import org.kde.kirigami 2.15 as Kirigami

import org.kde.kcm 1.2
QtQ.Rectangle {
    id: systemWallpaper

    property alias gridModel: detailGrid.model
    property var setWallpaperUrl

    color: "#FFF6F9FF"

    QtQ.Item {
        id: title

        anchors {
            top: parent.top
            topMargin: 42
            left: parent.left
            leftMargin: 20 * appScale
        }
        height: backLabel.height
        width: parent.width

        Kirigami.JIconButton {
            id: backLabel

            anchors {
                left: parent.left
            }

            width: 27 * appScale
            height: 27 * appScale

            source: "qrc:/package/contents/image/arrow_left.png"

            QtQ.MouseArea {
                anchors.fill: parent

                onClicked: {
                    popView()
                    if (isSetWallpaperSuc) {
                        wallpaper_root.wallpaperChanged()
                        isSetWallpaperSuc = false
                    }
                }
            }
        }

        Kirigami.Label {
            id:systemTitle
            anchors {
                left: backLabel.right
                leftMargin: 11 * appScale
                verticalCenter: backLabel.verticalCenter
            }

            font.pixelSize: appFontSize + 6
            font.bold: true
            text: i18n("System wallpaper")
        }
    }

    QtQ.GridView {
        id: detailGrid
        property bool movementEndd
        anchors {
            top: title.bottom
            topMargin: 14 * appScale
            bottom: parent.bottom
            left: title.left
            leftMargin: -11 * appScale
            right: parent.right
            rightMargin: -3 * appScale
        }

        onMovementStarted: {
            movementEndd = false
        }

        onMovementEnded: {
            movementEndd = true
        }
        width: parent.width
        cellWidth: width / 3
        cellHeight: cellWidth * 131/180
        clip: true
        cacheBuffer: height * 2
        model: (isCurrentWallpaperLoaded & isTipImageLoaded) ? wallpaper_root.systemWallpapers.length : 0
        delegate: QtQ.Item {
            id: gdelegate
            width: detailGrid.cellWidth
            height: detailGrid.cellHeight
            RadiusImage {
                id:itemImage
                anchors.centerIn: parent
                url: wallpaper_root.systemWallpapers[index]//"../image/bg.png"
                imageRadius: 10 * appScale
                width: detailGrid.cellWidth - (22 * appScale)
                height: detailGrid.cellHeight - (18 * appScale)
                imageModel: QtQ.Image.PreserveAspectCrop
                imageAsynchronous: true
                // imageSourceSize: Qt.size(width,height)
                QtQ.MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log(" onClicked::" + itemImage.url)
                        systemWallpaper.openWallpaperView(itemImage.url)
                    }
                }
            }


           HoverItem {
               id: hoverItem

               anchors.centerIn: itemImage
               radius: 10 * appScale
               width: itemImage.width + 10 * appScale
               height: itemImage.height + 10 * appScale
               color: "transparent"
               listMovewMend: detailGrid.movementEndd
               onListMovewMendChanged: {
                   if (!listMovewMend) {
                       itemHover = false
                   }
               }
               onItemClicked: {
                    console.log(" onClicked::" + itemImage.url)
                       systemWallpaper.openWallpaperView(itemImage.url)
               }
           }

        }
    }

    function openWallpaperView(imageUrl){
        console.log(" openWallpaperView::" + imageUrl)
        // applicationWindow().pageStack.layers.push(wallpaperComponent,{'source':imageUrl})
        setWallpaperUrl = imageUrl
        wallpaperLoader.active = true
    }

    function popWallpaperView(){
        // applicationWindow().pageStack.layers.pop()
        // wallpaperItem.visible = false
        wallpaperLoader.active = false

    }
    property bool isSetWallpaperSuc: false
    QtQ.Component{
        id:wallpaperComponent
        Kirigami.JWallPaperItem{
            id:wallpaperItem
            parent: Controls.Overlay.overlay
            source: setWallpaperUrl
            onSetWallPaperFinished:{
                console.log(" setwallpaper finnish:" + success)
                popWallpaperView()
                isSetWallpaperSuc = success
            }
            onCancel:{
                console.log(" setwallpaper cancel")
                popWallpaperView()
                isSetWallpaperSuc = false
            }
        }
    }
    QtQ.Loader{
        id:wallpaperLoader
        sourceComponent: wallpaperComponent
        active: false
    }



}
