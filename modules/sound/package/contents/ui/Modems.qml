/*
 *   Copyright 2020 Dimitris Kardarakos <dimkard@posteo.net>
 *   Copyright 2021 Rui Wang <wangrui@jingos.com> 
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
import QtQuick.Layouts 1.2
import QtQuick 2.7
import QtQuick.Controls 2.2 as Controls
import org.kde.kirigami 2.10 as Kirigami
import MeeGo.QOfono 0.2

KCM.SimpleKCM {
    title: i18n("Modems")

    OfonoManager {
        id: ofonoManager
    }

    Kirigami.CardsListView {
        width: parent.width

        model: ofonoManager.modems.length

        delegate: Kirigami.AbstractCard {
            property int modemId: model.index

            width: parent.width

            header: Kirigami.Heading {
                text: ofonoManager.modems.length == 1 ? i18n("Modem") : i18np(
                                                            "Modem 1",
                                                            "Modem %1",
                                                            modemId + 1)
                level: 2
                horizontalAlignment: Text.AlignHCenter
            }

            contentItem: Kirigami.FormLayout {
                width: parent.width

                Controls.Label {
                    Layout.fillWidth: true

                    visible: ofonoModem.name != ""
                    wrapMode: Text.WordWrap
                    text: ofonoModem.name
                    Kirigami.FormData.label: i18n("Name:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: ofonoModem.serial != ""
                    wrapMode: Text.WordWrap
                    text: ofonoModem.serial
                    Kirigami.FormData.label: i18n("IMEI:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: ofonoModem.manufacturer != ""
                    wrapMode: Text.WordWrap
                    text: ofonoModem.manufacturer
                    Kirigami.FormData.label: i18n("Manufacturer:")
                }
                Controls.Label {
                    Layout.fillWidth: true

                    visible: ofonoModem.model != ""
                    wrapMode: Text.WordWrap
                    text: ofonoModem.model
                    Kirigami.FormData.label: i18n("Model:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: ofonoModem.revision != ""
                    wrapMode: Text.WordWrap
                    text: ofonoModem.revision
                    Kirigami.FormData.label: i18n("Revision:")
                }

                Controls.Label {
                    Layout.fillWidth: true
                    
                    visible: ofonoModem.type != ""
                    wrapMode: Text.WordWrap
                    text: ofonoModem.type
                    Kirigami.FormData.label: i18n("Type:")
                }
            }

            OfonoModem {
                id: ofonoModem

                modemPath: ofonoManager.modems[modemId]
            }
        }
    }
}
