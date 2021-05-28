/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *                Han Young <hanyoung@protonmail.com>
 *                Wang Rui <wangrui@jingos.com>
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
#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusPendingCallWatcher>
#include <QDBusPendingReply>
#include <QDBusInterface>
#include <QDebug>
#include <QDBusReply>

#include "displaymodel.h"

static const char SOLID_POWERMANAGEMENT_SERVICE[] = "org.kde.Solid.PowerManagement";

DisplayModel::DisplayModel() {
}

void DisplayModel::setScreenIdleTime(int sec)
{
    QDBusInterface brightnessIface(
        QStringLiteral("org.kde.Solid.PowerManagement"),
        QStringLiteral("/org/kde/Solid/PowerManagement/Actions/DPMSControl"),
        QStringLiteral("org.kde.Solid.PowerManagement.Actions.DPMS"));
    brightnessIface.asyncCall(QStringLiteral("setDPMSIdleTime"), sec);
}

int DisplayModel::getScreenIdleTime()
{
    QDBusMessage screenMsg=QDBusMessage::createMethodCall("org.kde.Solid.PowerManagement",
                            QStringLiteral("/org/kde/Solid/PowerManagement/Actions/DPMSControl"),
                            QStringLiteral("org.kde.Solid.PowerManagement.Actions.DPMS"),
                            QStringLiteral("DPMSIdleTime"));

    QDBusInterface interface("org.kde.Solid.PowerManagement", "/org/kde/Solid/PowerManagement/Actions/DPMSControl",
                             "org.kde.Solid.PowerManagement.Actions.DPMS",
                             QDBusConnection::sessionBus());
    double tmpValue = 0; 
    if (interface.isValid()) {
        QDBusReply<int> reply = interface.call("DPMSIdleTime");
        if (reply.isValid()) {
            qCritical() << "tmpValue"<< tmpValue;
            tmpValue = reply.value();
            return tmpValue;
        } else {
            qCritical() << "DPMSIdleTime method called failed!";
        }
    }

    return 0;
}

void DisplayModel::setApplicationScale(int scale)
{
    QDBusInterface brightnessIface(
        QStringLiteral("org.kde.KWin"),
        QStringLiteral("/KWin"),
        QStringLiteral(""));
    double value1 =  scale;
    double scaleValue = value1 / 100;
    brightnessIface.asyncCall(QStringLiteral("setAppDefaultScale"), scaleValue);
}

int DisplayModel::getApplicationScale()
{
    QDBusInterface interface("org.kde.KWin", "/KWin",
                             "org.kde.KWin",
                             QDBusConnection::sessionBus());
    double tmpValue = 0; 
    if (interface.isValid()) {
        QDBusReply<qreal> reply = interface.call("getAppDefaultScale");
        if (reply.isValid()) {
            tmpValue = reply.value();
        } else {
            qCritical() << "getScale method called failed!";
        }
    }

    return tmpValue * 100 ; 
}