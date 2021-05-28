
import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.15 as Kirigami
import QtGraphicalEffects 1.0

Menu{
    id: menu


    signal setLockClicked()
    signal setHomeClicked()
    signal setBothClicked()
    property int mwidth: 430 * appScale
    property int mheight: 210 * appScale
    property var separatorColor: "#5C3C3C43"
    property int separatorWidth: mwidth * 8 / 10
    property int mouseX
    property int mouseY
    property int menuItemCount: menu.count

    Action {
        text: i18n("Set Lock Screen")
        checkable: true
        checked: false
        onCheckedChanged: {
            setLockClicked()
        }
    }

    Action {
        text: i18n("Set Home Screen")

        checkable: true
        checked: false
        onCheckedChanged: {
            setHomeClicked()
        }
    }

    Action {
        text: i18n("Set Both")
        checkable: true
        checked: false
        onCheckedChanged: {
            setBothClicked()
        }
    }


    delegate: MenuItem {
        id: menuItem
        width: menu.mwidth
        height: mheight / menuItemCount
        implicitWidth: menu.mwidth
        implicitHeight: mheight / menuItemCount
        padding: 0

        MouseArea {
            anchors.fill: parent
            enabled: menuItem.opacity === 0.5
        }

        arrow: Canvas {
            width: 0
            height: 0
            visible: menuItem.subMenu
            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = menuItem.highlighted ? "#ffffff" : "#21be2b"
                ctx.moveTo(15, 15)
                ctx.lineTo(width - 15, height / 2)
                ctx.lineTo(15, height - 15)
                ctx.closePath()
                ctx.fill()
            }
        }

        indicator: Item {
            width: 0
            height: 0
        }

        contentItem: Item {
            id: munuContentItem
            height: mheight / menuItemCount
            implicitWidth: getAllWidth()

            function getAllWidth() {
                return menu.mwidth
            }
            Text {
                anchors {
                    left: parent.left
                    centerIn: parent
                }
                leftPadding: mwidth / 10
                text: menuItem.text
                font.pointSize: appFontSize + 2
                color: menuItem.highlighted ? "#3C3F48" : "#000000"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        background: Item {
            width: menu.mwidth
            height: mheight / menuItemCount
            implicitWidth: menu.mwidth
            implicitHeight: mheight / menuItemCount
            clip: true
            Rectangle {
                id: bline
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                visible: (menuItem.text !== i18n("Set Both"))
                color: separatorColor
            }
            Rectangle {
                anchors.fill: parent
                anchors.bottomMargin: menuItemCount === 1 ? 0 : (menu.currentIndex === 0 ? -radius : 0)
                anchors.topMargin: menuItemCount === 1 ? 0 :  (menu.currentIndex === menu.count - 1 ? -radius : 0)
                radius: menuItemCount === 1 ? 20 : (menu.currentIndex === 0
                                                    || menu.currentIndex === menu.count - 1 ? 20 : 0)
                color: menuItemCount === 1 ? "transparent" : (menuItem.highlighted ? "#2E747480" : "transparent")
            }

        }
    }

    background: Rectangle {
        id: mBr

        property string shadowColor: "#80C3C9D9"

        width: mwidth
        implicitWidth: mwidth
        color: "#99FFFFFF"
        radius: 20
        layer.enabled: true
        layer.effect: DropShadow {
            id: rectShadow
            anchors.fill: mBr
            color: mBr.shadowColor
            source: mBr
            samples: 9
            radius: 4
            horizontalOffset: 0
            verticalOffset: 0
            spread: 0
        }
    }

}
