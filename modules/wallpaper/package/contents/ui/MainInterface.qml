import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQml.Models 2.3
import jingos.display 1.0

Item {
    id:lockScrren
    property int appFontSize: JDisplay.sp(1.0)//theme.defaultFont.pointSize
    property alias imageRadius : radiusImage.imageRadius
    property bool isFullShow : radiusImage.imageRadius === 0
    property alias mainInterfaceImageUrl: radiusImage.url
    property alias mainWallpaperBackgroundReady: radiusImage.isImageReady

    ListModel{
      id:dockModel
      ListElement{
       imagePath:"../image/clock.svg"
      }
      ListElement{
       imagePath:"../image/files.svg"
      }
      ListElement{
          name:"Settings"
          imagePath:"../image/settings.svg"
      }
      ListElement{
       imagePath:"../image/app_store.svg"
      }
    }

    ListModel{
        id:gridModel
        ListElement{
            name:"Voice Memos"
            imagePath:"../image/voice_memos.svg"
        }
        ListElement{
            name:"Screen Projection"
            imagePath:"../image/screen_projection.svg"
        }
        ListElement{
            name:"Calculator"
            imagePath:"../image/calculator.svg"
        }
        ListElement{
            name:"Files"
            imagePath:"../image/files.svg"
        }
        ListElement{
            name:"App Store"
            imagePath:"../image/app_store.svg"
        }
        ListElement{
            name:"Photos"
            imagePath:"../image/photos.svg"
        }

        ListElement{
            name:"Calendar"
            imagePath:"../image/calendar.png"
        }
        ListElement{
            name:"Settings"
            imagePath:"../image/settings.svg"
        }
        ListElement{
            name:"Mail"
            imagePath:"../image/mail.svg"
        }
        ListElement{
            name:"Media"
            imagePath:"../image/media.svg"
        }
        ListElement{
            name:"Camera"
            imagePath:"../image/camera.svg"
        }
        ListElement{
            name:"Browser"
            imagePath:"../image/browser.svg"
        }
    }
    RadiusImage{
        id:radiusImage

        anchors.fill: parent
        url:wallpaper_root.wallpaperUrl
        // imageSourceSize: Qt.size(width,height)
        // antialiasing: true
        // smooth: true
    }

    JGridView{
        id:jgrid
        anchors{
            horizontalCenter: radiusImage.horizontalCenter
            top: radiusImage.top
            topMargin: 20 * appScale
        }
        width: parent.width - 50 * appScale
        height: parent.height - 50 * appScale
        model: gridModel
    }

    Item {
        id: footItem
        anchors {
            bottom: radiusImage.bottom
            bottomMargin: 10 * appScale
        }
        width: radiusImage.width
        height: footItem.iconWidthAndHeight  * 2

        property int iconWidthAndHeight: radiusImage.width / 24

        ShaderEffectSource {
            id: effectSource
            anchors.top: footItem.top
            anchors.bottom: footItem.bottom
            anchors.horizontalCenter: footItem.horizontalCenter

            property point mapPoint: effectSource.mapToItem(radiusImage, effectSource.x, effectSource.y)

            width: favoriteAppRow.width + 20 * appScale
            height: parent.height

            sourceItem: radiusImage
            sourceRect: Qt.rect(x,
                                mapPoint.y,
                                effectSource.width,
                                effectSource.height)
            visible: false
        }

        FastBlur {
            id: fastBlur
            anchors.fill: effectSource
            source: effectSource
            radius: 50
            visible: false
        }

        OpacityMask {
            id: mask
            anchors.fill: fastBlur
            source: fastBlur
            maskSource: dockBgRectangle
            visible: true
        }

        Rectangle {
            id: dockBgRectangle
            anchors.fill: effectSource

            color: "#ffffff"
            opacity: 0.3
            radius: height / 3
            visible: true
            clip: true
        }

        Row {
            id: favoriteAppRow
            anchors.centerIn: dockBgRectangle
            spacing: 5 * appScale

            Repeater {
                id: dockRepeater
                model:dockModel

                z: 50
                delegate: Image {
                    id: dockBarImage
                    width: footItem.iconWidthAndHeight
                    height: width
                    source: imagePath//"../image/camera.png"
                    asynchronous:true
                    sourceSize: Qt.size(width,height)
                }
            }
        }
    }
}
