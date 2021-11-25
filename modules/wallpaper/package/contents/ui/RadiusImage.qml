/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

import QtQuick 2.15
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.15 as Kirigami

Item {
    id: imgItem
    property alias url: bigImageView.source
    property string defaultUrl: "../image/wallpaper_default.png"
    property int imageRadius : 20
    property alias imageModel : bigImageView.fillMode
    property alias imageAsynchronous : bigImageView.asynchronous
    property alias imageSourceSize: bigImageView.sourceSize
    property alias imageView: bigImageView
    property bool isImageReady: false

//    RectDropshadow {
//        id: shadow
//        color: "#FFFFFF"
//        anchors.fill: parent
//        radius: 20
//        shadowColor: "#80C3C9D9"
//    }
    Component{
        id:defaultComponent
        Rectangle{
        id:defaultRect
        width: imgItem.width
        height: imgItem.height
        color:Kirigami.JTheme.cardBackground//"#E5E5EA"
        radius: imageRadius

        Image {
                id: bigImageView
                anchors.centerIn: parent
                source: defaultUrl
                fillMode: Image.Stretch
                sourceSize: Qt.size(width,height)
            }
        }
    }

    Loader{
        id: defaultLoader
        sourceComponent: defaultComponent
        active: bigImageView.status !== AnimatedImage.Ready
    }


    Image {
        id: bigImageView
        width: parent.width
        height: parent.height
        source: url
        visible: false
        asynchronous: true
        fillMode: Image.Stretch
        // antialiasing: true
        // smooth: true
        onStatusChanged: {
            if (status !== AnimatedImage.Loading) {
                // console.log(" :::: source:" + source + " width:"+ width + " sourceSize:" + sourceSize)
                isImageReady = true
            }
        }
        // sourceSize: Qt.size(width,height)
    }

    Rectangle {
        id: maskRect
        anchors.fill: bigImageView
        visible: false
        clip: true
        radius: imageRadius
    }

    OpacityMask {
        id: mask
        anchors.fill: maskRect
        source: bigImageView
        maskSource: maskRect
        visible: !defaultLoader.active
    }
}
