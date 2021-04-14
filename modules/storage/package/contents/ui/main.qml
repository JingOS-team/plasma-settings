/*
 *   Copyright 2020 Dimitris Kardarakos <dimkard@posteo.net>
 *   Copyright 2021 Wang Rui <wangrui@jingos.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import org.kde.kcm 1.2 as KCM
import QtQuick 2.7
import org.kde.kirigami 2.10 as Kirigami
import QtQuick.Controls 2.10
import jingos.storage 1.0

Rectangle {
    id: storage_root

    property real appScale: 1.3 * parent.width / (1920 * 0.7)
    property int appFontSize: theme.defaultFont.pointSize
    property string storageName: "Storage space:"
    property string storageType: ""
    property double storageTotal: 0
    property string storageTotalValue: ""
    property double storageAvailable: 0
    property string storageAvailableValue: ""

    width: parent.width
    height: parent.height

    Component.onCompleted: {
        storageName = sm.getStorageName()
        storageType = sm.getStorageType()
        storageTotal = sm.getStorageTotalSize()
        storageTotalValue = (storageTotal / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
        storageAvailable = sm.getStorageAvailableSize()
        storageAvailableValue = ((storageTotal - storageAvailable) / 1000 / 1000 / 1000).toFixed(
                    1) + "GB"
        console.log("storageName: ", storageName)
        if (storageName == "") {
            storageName = "Storage Info："
        }
        console.log("storageType: ", storageType)
        console.log("storageTotal: ", storageTotal)
        console.log("storageAvailable: ", storageAvailable)
    }

    StorageModel {
        id: sm
    }

    Rectangle {
        anchors.fill: parent

        color: "#FFF6F9FF"

        Text {
            id: storage_title

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: 72 * appScale
                topMargin: 68 * appScale
            }

            width: 500
            height: 50
            text: i18n("Storage")
            font.pointSize: appFontSize + 11
            font.weight: Font.Bold
        }

        Rectangle {
            id: storage1_area

            anchors {
                top: storage_title.bottom
                left: parent.left
                topMargin: 42 * appScale
                leftMargin: 72 * appScale
                right: parent.right
                rightMargin: 72 * appScale
            }

            height: 69 * 2 * appScale
            color: "#fff"
            radius: 15 * appScale

            Rectangle {
                id: s1_top

                width: parent.width
                height: 69 * appScale

                Text {
                    id: auto_title

                    anchors {
                        left: parent.left
                        leftMargin: 31 * appScale
                        verticalCenter: parent.verticalCenter
                    }

                    width: 331
                    height: 26 * appScale
                    text: storageName
                    font.pointSize: appFontSize + 2
                }

                Text {
                    id: auto_value

                    anchors {
                        right: parent.right
                        rightMargin: 31 * appScale
                        verticalCenter: parent.verticalCenter
                    }

                    width: 331
                    height: 26 * appScale
                    text: i18n("used: %1 / %2 " , storageAvailableValue , storageTotalValue)
                    color: "#993C3C43"
                    font.pointSize: appFontSize + 2
                }
            }

            JProgress {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: 31 * appScale
                    rightMargin: 31 * appScale
                    top: s1_top.bottom
                    topMargin: 8 * appScale
                }

                height: 28 * appScale
                totalValue: 100
                usedPower: (1 - (storageAvailable / storageTotal).toFixed(2)) * 100
            }
        }
    }
}
