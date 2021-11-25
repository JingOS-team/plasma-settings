import QtQuick 2.2
import org.kde.kirigami 2.15

Rectangle {
    id: slider_root

    property int marginTitle2Top : 44 
    property int marginItem2Title : 18 
    property int marginLeftAndRight : 20 
    property int marginInnerSize : 12 
    property int marginItem2Top : 24 

    // propert alias sliderValue: slider.value 
    property int sliderValue : 2
    radius: 10 

    signal sliderChanged(int value);

    Rectangle {
        id: slider_area
        height : 23
        anchors {
            top:parent.top 
            left:parent.left 
            right:parent.right
            leftMargin: marginLeftAndRight
            rightMargin: marginLeftAndRight
        }

        Text {
            id: font_size_small
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left 
                
            }
            text : "A"
            font.pixelSize: 10 
        }

        Text {
            id: font_size_big

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right 
                
            }
            text : "A"
            font.pixelSize: 18
        }


        JrStepSlider {
            id: slider
             anchors {
                verticalCenter: parent.verticalCenter
                right: font_size_big.left 
                rightMargin: marginInnerSize
                left: font_size_small.right 
                leftMargin: marginInnerSize
            }
            value: sliderValue
            onValueChanged: {
                sliderChanged(value)
            }
        }
    }

    Rectangle {
        id: slider_info
        anchors {
            left: slider_area.left
            right : slider_area.right 
            top: slider_area.bottom 
            topMargin: 2
            bottom : parent.bottom 
        }
        
        Text {
            text: i18n("Extra Small")
            font.pixelSize: 9
            anchors {
                verticalCenter:parent.verticalCenter
                left: parent.left
            }
        }

        Text {
            text: i18n("Extra Large")
            font.pixelSize: 9
            anchors {
                verticalCenter:parent.verticalCenter
                right: parent.right
            }
        }

        Text {
            text: i18n("Normal")
            font.pixelSize: 9
            anchors {
                verticalCenter:parent.verticalCenter
                horizontalCenter:parent.horizontalCenter
            }
        }

        Text {
            text: i18n("Small")
            font.pixelSize: 9
            anchors {
                verticalCenter:parent.verticalCenter
                left:parent.left
                leftMargin: slider_info.width / 4
            }
        }

        Text {
            text: i18n("Large")
            font.pixelSize: 9
            anchors {
                verticalCenter:parent.verticalCenter
                right :parent.right
                rightMargin: slider_info.width / 4
            }
        }
    }
    

}
