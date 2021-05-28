import QtQuick 2.0

Item {
    id:lockScrren
    property int appFontSize: 14//theme.defaultFont.pointSize
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
        font.pointSize: appFontSize + 9
    }
    Text {
        id: dateText

        anchors{
         verticalCenter: cameraImage.verticalCenter
         right: cameraImage.left
         rightMargin: 5
        }
        text: i18n("2020-09-12.Monday")
        color: "#FFFFFF"
        font.pointSize: appFontSize - 10
    }
    Image {
        id: cameraImage

        anchors{
         right: radiusImage.right
         rightMargin: 10
         bottom: radiusImage.bottom
         bottomMargin: 10
        }
        width: 8
        height: 8
        source: "../image/camera.png"
    }

}
