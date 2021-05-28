import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.15

ToolTip
{
    id: toast

    property alias toastContent : toastText.text
    property alias toastItem: footerBlur.sourceItem
    property int lastAppScaleSize: 1

    delay: 0
    timeout: 2000

    width: (247 * lastAppScaleSize)
    height: 46 * lastAppScaleSize
    background: Rectangle
    {
        radius: 12
        color: "transparent"
        ShaderEffectSource
        {
            id: footerBlur

            width: parent.width
            height: parent.height

            visible: false
            sourceItem: recordMainView
            sourceRect: Qt.rect(toast.x, toast.y, width, height)
        }

        FastBlur{
            id:fastBlur

            anchors.fill: parent

            source: footerBlur
            radius: 60
            cached: true
            visible: false
        }

        Rectangle{
            id:maskRect

            anchors.fill:fastBlur

            visible: false
            clip: true
            radius: 12
        }
        OpacityMask{
            id: mask
            anchors.fill: maskRect
            visible: true
            source: fastBlur
            maskSource: maskRect
        }

        Rectangle{
            anchors.fill: footerBlur
            color: "#80000000"
            radius: 12
        }
    }
    Text
    {
        id: toastText
        // width:436
        anchors{
             horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 30 * lastAppScaleSize
            right: parent.right
            rightMargin: 30 * lastAppScaleSize
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap//WrapAnywhere
        text: ""
        font
        {
            pixelSize: 14
        }
        color: "white"
    }
}
