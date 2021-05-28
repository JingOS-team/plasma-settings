/*
    Copyright 2014-2015 Harald Sitter <sitter@kde.org>
    Copyright 2016 David Rosca <nowrep@gmail.com>
    Copyright 2019 Sefa Eyeoglu <contact@scrumplex.net>
    Copyright 2020 Nicolas Fella <nicolas.fella@gmx.de>
    Copyright 2021 Wang Rui <wangrui@jingos.com> 

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation; either version 2 of
    the License or (at your option) version 3 or any later version
    accepted by the membership of KDE e.V. (or its successor approved
    by the membership of KDE e.V.), which shall act as a proxy
    defined in Section 14 of version 3 of the license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import org.kde.kcm 1.3
import org.kde.kirigami 2.15 as Kirigami
import org.kde.plasma.private.volume 0.1

Item {

    id: sound_root

    property int screenWidth: 888
    property int screenHeight: 648
    // property int appFontSize: theme.defaultFont.pointSize

    property int statusbar_height : 22
    property int statusbar_icon_size: 22
    property int default_setting_item_height: 45

    property int marginTitle2Top : 44 
    property int marginItem2Title : 36
    property int marginLeftAndRight : 20
    property int marginItem2Top : 24 
    property int fontNormal: 14

    // property real appScale: 1.3 * width / (1920 * 0.7)
    property int appFontSize: theme.defaultFont.pointSize
    property real currentRingtone
    property bool volumeFeedback: true
    property int maxVolumeValue: Math.round(
                                     100 * PulseAudio.NormalVolume / 100.0)
    property int volumeStep: Math.round(5 * PulseAudio.NormalVolume / 100.0)
    readonly property string dummyOutputName: "auto_null"
    readonly property int currentVolume: paSinkModel.preferredSink.volume
    property bool isMuted: false

    width:parent.width
    height:parent.height 

    // width: Screen.width * 0.7
    // height: Screen.height
    // width: screenWidth * 0.7
    // height: screenHeight

    Component.onCompleted: {
        isMuted = paSinkModel.preferredSink.muted
    }

    function iconName(volume, muted, prefix) {
        if (!prefix) {
            prefix = "audio-volume"
        }
        var icon = null
        var percent = volume / maxVolumeValue
        if (percent <= 0.0 || muted) {
            icon = prefix + "-muted"
        } else if (percent <= 0.25) {
            icon = prefix + "-low"
        } else if (percent <= 0.75) {
            icon = prefix + "-medium"
        } else {
            icon = prefix + "-high"
        }
        return icon
    }

    function isDummyOutput(output) {
        return output && output.name === dummyOutputName
    }

    function boundVolume(volume) {
        return Math.max(PulseAudio.MinimalVolume, Math.min(volume,
                                                           maxVolumeValue))
    }

    function volumePercent(volume, max) {
        if (!max) {
            max = PulseAudio.NormalVolume
        }
        return Math.round(volume / max * 100.0)
    }

    function playFeedback(sinkIndex) {
        if (!volumeFeedback) {
            return
        }
        if (sinkIndex == undefined) {
            sinkIndex = paSinkModel.preferredSink.index
        }
        feedback.play(sinkIndex)
    }

    function increaseVolume() {
        if (!paSinkModel.preferredSink || isDummyOutput(
                    paSinkModel.preferredSink)) {
            return
        }

        var volume = boundVolume(paSinkModel.preferredSink.volume + volumeStep)
        var percent = volumePercent(volume, maxVolumeValue)
        paSinkModel.preferredSink.muted = percent == 0
        paSinkModel.preferredSink.volume = volume
        osd.show(percent)
        playFeedback()
    }

    function decreaseVolume() {
        if (!paSinkModel.preferredSink || isDummyOutput(
                    paSinkModel.preferredSink)) {
            return
        }

        var volume = boundVolume(paSinkModel.preferredSink.volume - volumeStep)
        var percent = volumePercent(volume, maxVolumeValue)
        paSinkModel.preferredSink.muted = percent == 0
        paSinkModel.preferredSink.volume = volume
        osd.show(percent)
        playFeedback()
    }

    function muteVolume() {
        if (!paSinkModel.preferredSink || isDummyOutput(
                    paSinkModel.preferredSink)) {
            return
        }
        var toMute = !paSinkModel.preferredSink.muted
        paSinkModel.preferredSink.muted = toMute
        osd.show(toMute ? 0 : volumePercent(paSinkModel.preferredSink.volume,
                                            maxVolumeValue))
        if (!toMute) {
            playFeedback()
        }
    }

    function switchMute(value) {

        if (!paSinkModel.preferredSink || isDummyOutput(
                    paSinkModel.preferredSink)) {
            return
        }
        // var toMute = !paSinkModel.preferredSink.muted;
        paSinkModel.preferredSink.muted = value
        console.log("setMute :::::" , value )
        // osd.show(toMute ? 0 : volumePercent(paSinkModel.preferredSink.volume,
        //                                     maxVolumeValue))
        if (!value) {
            playFeedback()
        }
    }

    function setVolume(num) {
        if (!paSinkModel.preferredSink || isDummyOutput(
                    paSinkModel.preferredSink)) {
            return
        }
        var volume = boundVolume(num)
        var percent = volumePercent(volume, maxVolumeValue)
        paSinkModel.preferredSink.muted = percent == 0
        paSinkModel.preferredSink.volume = volume
        playFeedback()
    }

    SinkModel {
        id: paSinkModel
    }

    VolumeOSD {
        id: osd
    }

    VolumeFeedback {
        id: feedback
    }

    GlobalActionCollection {
        // KGlobalAccel cannot transition from kmix to something else, so if
        // the user had a custom shortcut set for kmix those would get lost.
        // To avoid this we hijack kmix name and actions. Entirely mental but
        // best we can do to not cause annoyance for the user.
        // The display name actually is updated to whatever registered last
        // though, so as far as user visible strings go we should be fine.
        // As of 2015-07-21:
        //   componentName: kmix
        //   actions: increase_volume, decrease_volume, mute
        name: "kmix"
        displayName: main.displayName

        GlobalAction {
            objectName: "increase_volume"
            text: i18n("Increase Volume")
            shortcut: Qt.Key_VolumeUp
            onTriggered: increaseVolume()
        }

        GlobalAction {
            objectName: "decrease_volume"
            text: i18n("Decrease Volume")
            shortcut: Qt.Key_VolumeDown
            onTriggered: decreaseVolume()
        }

        GlobalAction {
            objectName: "mute"
            text: i18n("Mute")
            shortcut: Qt.Key_VolumeMute
            onTriggered: {
                muteVolume()
            }
        }
    }

    PulseObjectFilterModel {
        id: pluseModel

        filters: [{
                "role": "Name",
                "value": "sink-input-by-media-role:event"
            }]
        sourceModel: StreamRestoreModel {}

        Component.onCompleted: {
            helloTimer2.start()
        }
    }

    Timer {
        id: helloTimer2
        interval: 200 
        repeat: false
        triggeredOnStart: false
        onTriggered: {
            ringtone_slider.value = pluseModel.getVolume()
        }
    }

    Rectangle {
        id: sound_layout
        width:parent.width
        height:parent.height
        color: "#FFF6F9FF"

        Text {
            id: sound_title

            anchors {
                left: parent.left
                top: sound_layout.top
                leftMargin: marginLeftAndRight
                topMargin: marginTitle2Top
            }

            width: 329
            height: 14
            text: i18n("Sounds")
            font.pixelSize: 20
            font.weight: Font.Bold
            verticalAlignment:Text.verticalAlignment
        }

        Rectangle {
            id: sound_area

            anchors {
                left: parent.left
                right: parent.right
                top: sound_title.bottom
                leftMargin: marginLeftAndRight
                rightMargin: marginLeftAndRight
                topMargin: marginItem2Title
            }

            width: parent.width - marginLeftAndRight * 2
            height: default_setting_item_height * 3
            color: "#fff"
            radius: 10

            Rectangle {
                id: sound_slience

                anchors {
                    top: parent.top
                }
                width: parent.width
                height: parent.height / 3
                color: "transparent"

                Text {
                    id: slince_title
                    anchors {
                        left: parent.left
                        leftMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }
                    width: 331
                    height: 17
                    text: i18n("Silent mode")
                    font.pixelSize: fontNormal
                }

                Kirigami.JSwitch {
                    id: slince_switch

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: marginLeftAndRight
                    }
                    checked: isMuted
                    onCheckedChanged: {
                        switchMute(checked)
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: marginLeftAndRight
                    anchors.rightMargin: marginLeftAndRight
                    color: "#f0f0f0"
                }
            }

            Rectangle {
                id: voice_area

                anchors {
                    top: sound_slience.bottom
                }
                width: parent.width
                height: parent.height / 3
                color: "transparent"
                Image {
                    id: voice_ic

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: marginLeftAndRight
                    }
                    source: "../image/ic_voice.png"
                    sourceSize.width: 17
                    sourceSize.height: 17
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: voice_ic.right
                        leftMargin: 10
                    }
                    text: i18n("Voice")
                    font.pixelSize: fontNormal

                }

                Kirigami.JSlider {
                    id: voice_slider

                    anchors {
                        left: voice_ic.right
                        right: parent.right
                        leftMargin: 80
                        rightMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }

                    value: currentVolume
                    from: 0
                    to: maxVolumeValue
                    onValueChanged: {
                        setVolume(value)
                    }
                }

                Kirigami.Separator {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: marginLeftAndRight
                    anchors.rightMargin: marginLeftAndRight
                    color: "#f0f0f0"
                }
            }

            Rectangle {
                id: ringtone_area

                anchors {
                    top: voice_area.bottom
                }
                width: parent.width
                height: parent.height / 3
                color: "transparent"
                
                Image {
                    id: rt_icon

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: marginLeftAndRight
                    }
                    sourceSize.width: 17
                    sourceSize.height: 17
                    source: "../image/ic_ringtone.png"
                }

                Text {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: rt_icon.right
                        leftMargin: 10
                    }
                    text: i18n("Ringtone")
                    font.pixelSize: fontNormal

                }

                Kirigami.JSlider {
                    id: ringtone_slider

                    anchors {
                        left: rt_icon.right
                        right: parent.right
                        leftMargin: 80
                        rightMargin: marginLeftAndRight
                        verticalCenter: parent.verticalCenter
                    }
                    value: pluseModel.getVolume()
                    from: PulseAudio.MinimalVolume
                    to: PulseAudio.MaximalVolume
                    onValueChanged: {
                        pluseModel.setVolume(value)
                    }
                }
            }
        }
    }
}
