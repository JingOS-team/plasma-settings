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
import QtQuick 2.7
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.15 as Kirigami
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import jingos.font 1.0
import jingos.display 1.0

Kirigami.JArrowPopup {
    id: root

    width: 240 * appScaleSize
    height: 236 * appScaleSize
    modal: false
    focus: true

    blurBackground.arrowX: width * 0.7
    blurBackground.arrowWidth: 16 * appScaleSize
    blurBackground.arrowHeight: 11 * appScaleSize
    blurBackground.arrowPos: Kirigami.JRoundRectangle.ARROW_TOP
    //blurBackground.radius: JDisplay.dp(10)

    property string currentFamily
    signal familyChanged(string family)

    FontModel {
        id: fontModel
    }
    contentItem: Item {
        id: contentItem

        ListView {
            id: listview1

            clip: true
            anchors.fill: parent
            model: fontModel.subPixelOptionsModel
            snapMode:ListView.SnapToItem
            delegate: Item {
                width: listview1.width
                height: 45 * appScaleSize

                Component.onCompleted: {
                    currentFamily = fonts_sub.currentSelectText
                }
                //background  not use
                Rectangle{
                    anchors.fill: parent
                    visible: false
                    color: mouseArea.containsMouse ? (mouseArea.pressed ? Kirigami.JTheme.pressBackground : Kirigami.JTheme.hoverBackground)
                                                   : "transparent"
                }

                MouseArea {
                    id:mouseArea
                    anchors.fill:parent
                    hoverEnabled: true
                    onClicked: {
                        currentFamily = display
                        familyChanged(display)
                        root.close();
                    }
                }
                Text {
                    anchors.verticalCenter:parent.verticalCenter
                    font.pixelSize: 14 * appFontSize
                    color: Kirigami.JTheme.majorForeground
                    text: display
                }

                Image {
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.right: parent.right
                    source: "../image/menu_select.png"
                    width: 22 * appScaleSize
                    height : 22 * appScaleSize
                    visible: display == currentFamily
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    width:parent.width
                }
            }
        }
    }
}
