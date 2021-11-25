import QtQuick 2.0
import jingos.display 1.0

Item {
    id:lockScrren
    property int appFontSize: 14 * JDisplay.sp(1.0)//theme.defaultFont.pointSize
    property alias imageRadius : radiusImage.imageRadius
    property alias lockImageUrl: radiusImage.url

    RadiusImage{
        id:radiusImage

        anchors.fill: parent
        url:wallpaper_root.lockwallpaperUrl
    }

    Text {
        id: timeText
        anchors{
            right: cameraImage.right
            bottom: dateText.top
        }
        text: "09:48"
        font.bold: true
        color: "#FFFFFF"
        font.pointSize: appFontSize + 9 * JDisplay.sp(1.0)
    }
    Text {
        id: dateText

        anchors{
         verticalCenter: cameraImage.verticalCenter
         right: cameraImage.left
         rightMargin: 5 * appScale
        }
        text: i18n("2020-09-12.Monday")
        color: "#FFFFFF"
        font.pointSize: appFontSize - 10 * JDisplay.sp(1.0)
    }
    Image {
        id: cameraImage

        anchors{
         right: radiusImage.right
         rightMargin: 10 * appScale
         bottom: radiusImage.bottom
         bottomMargin: 10 * appScale
        }
        width: 8 * appScale
        height: 8 * appScale
        source: "../image/camera.png"
    }

}
