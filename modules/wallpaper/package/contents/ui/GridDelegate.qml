import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import jingos.display 1.0

Item {
    id: itemRoot

    Column {
        property int smallSpacing : 5

        anchors.centerIn: parent
        spacing: 6 * appScale

        Image {
            id: icon
            anchors{
                horizontalCenter: label.horizontalCenter
            }
            width: itemRoot.width / 3
            height: width
            source: model.imagePath === "" ? "../image/camera.png" : model.imagePath//"file:///usr/share/home_icons/" + model.applicationName + ".png"

            onStatusChanged:  {
                if(status === Image.Error) {
                    icon.source = "file:///usr/share/home_icons/defult.png"
                }
            }
        }

        Label {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            visible: text.length > 0

            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            maximumLineCount: 2
            elide: Text.ElideRight

            text:  model.name

            font.pixelSize: wallpaper_root.appFontSize - 10 * JDisplay.sp(1.0)
            color: "white"
        }
    }
}

