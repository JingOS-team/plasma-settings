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
    title: i18n("Networks")

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
                horizontalAlignment: Text.AlignHCenter

                text: ofonoManager.modems.length == 1 ? i18n("Network") : i18nc(
                                                            "Network %1",
                                                            modemId + 1)
                level: 2
            }

            contentItem: Kirigami.FormLayout {
                width: parent.width

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.name != ""
                    wrapMode: Text.WordWrap
                    text: netreg.name
                    Kirigami.FormData.label: i18n("Operator:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.mode != ""
                    wrapMode: Text.WordWrap
                    text: netreg.mode
                    Kirigami.FormData.label: i18n("Mode:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.cellId != ""
                    wrapMode: Text.WordWrap
                    text: netreg.cellId
                    Kirigami.FormData.label: i18n("Cell Id:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.mcc != ""
                    wrapMode: Text.WordWrap
                    text: netreg.mcc
                    Kirigami.FormData.label: i18n("MCC:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.mnc != ""
                    wrapMode: Text.WordWrap
                    text: netreg.mnc
                    Kirigami.FormData.label: i18n("MNC:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.technology != ""
                    wrapMode: Text.WordWrap
                    text: netreg.technology
                    Kirigami.FormData.label: i18n("Technology:")
                }

                Controls.Label {
                    Layout.fillWidth: true

                    visible: netreg.strength != ""
                    wrapMode: Text.WordWrap
                    text: "%1 %2".arg(netreg.strength).arg("%")
                    Kirigami.FormData.label: i18n("Strength:")
                }

                Controls.Label {
                    Layout.fillWidth: true
                    
                    visible: netreg.baseStation != ""
                    wrapMode: Text.WordWrap
                    text: netreg.baseStation
                    Kirigami.FormData.label: i18n("Base Station:")
                }
            }

            OfonoNetworkRegistration {
                id: netreg

                modemPath: ofonoManager.modems[modemId]
            }
        }
    }
}
