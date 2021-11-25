/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */
import QtQuick 2.0
import QtQml 2.0
import org.kde.kirigami 2.15 as Kirigami

Rectangle {
    id: hoverItem

    property bool isHover: true
    property bool itemHover
    property bool itemPressed
    property bool listMovewMend
    signal itemClicked
    width: 180
    height: 40

    Component {
        id: highlightComponent
        Rectangle {
            width: hoverItem.width
            height: hoverItem.height
            radius: hoverItem.radius
            color: hoverItem.itemPressed ? Kirigami.JTheme.pressBackground : Kirigami.JTheme.hoverBackground//"#4D787880" : "#33767680"

            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }

    Loader {
        id: hoverLoader
        anchors.fill: hoverItem
        sourceComponent: highlightComponent
        active: hoverItem.itemHover && !hoverItem.itemPressed
    }

    Loader {
        id: pressLoader
        anchors.fill: hoverItem
        sourceComponent: highlightComponent
        active: hoverItem.itemPressed && hoverItem.itemHover
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: isHover
        onExited: {
            itemHover = false
            itemPressed = false
            }
        onEntered: {
            itemHover = true
            itemPressed = false
        }
        onPressed: itemPressed = true
        onReleased: itemPressed = false
        onClicked: {
            itemClicked()
        }
    }
}