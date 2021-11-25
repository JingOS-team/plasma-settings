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

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.2
import QtQuick.Shapes 1.12
import org.kde.kirigami 2.15 as Kirigami
import QtGraphicalEffects 1.0

Item {
    id: item_root

    property string icon_name
    property string title_name
    property int title_size
    property bool isCheck : false
    property string fontFamily : Kirigami.JDisplay.fontFamily

    width: 150 * appScaleSize
    height: 45 * appScaleSize

    Kirigami.Icon {
        id: item_icon
        source: icon_name
        width: 17 * appScaleSize
        height : 17 * appScaleSize
        anchors {
            left:parent.left
            verticalCenter : parent.verticalCenter
        }
        color:Kirigami.JTheme.iconForeground
    }

    Text {
        anchors {
            left:item_icon.right
            leftMargin: 10 * appScaleSize
            verticalCenter : parent.verticalCenter
        }
        text :  title_name
        font.family: fontFamily
        font.pixelSize: title_size
        color: Kirigami.JTheme.majorForeground
    }

    Image {
        id: item_check
        source: "../image/menu_select.png"
        width: 17 * appScaleSize
        height : 17 * appScaleSize
        anchors {
            right:parent.right
            verticalCenter : parent.verticalCenter
        }
        visible: isCheck
    }

}
