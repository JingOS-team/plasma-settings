/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *                Han Young <hanyoung@protonmail.com>
 *                Rui Wang<wangrui@jingos.com>
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

#include <QDebug>
#include <QDBusConnection>
#include <QDBusReply>
#include <QDBusInterface>

#include "batteryutil.h"

// static const char SOLID_POWERMANAGEMENT_SERVICE[] = "org.kde.Solid.PowerManagement";


BatteryUtil::BatteryUtil() {
    qDebug() << "BatteryUtil ::: load" ;
    getFullTime();
}


qint64 BatteryUtil::getRemainTime(){
    QDBusInterface interface("org.freedesktop.UPower", "/org/freedesktop/UPower/devices/battery_battery",
                             "org.freedesktop.UPower.Device",
                             QDBusConnection::systemBus());

    qint64 kValue = 0; 
    qDebug() << "getRemainTime11111111111111";
    if (interface.isValid()) {
       qDebug() << "getRemainTime2222222222222";
        QVariant reply = interface.property("TimeToEmpty");
        if (reply.isValid()) {
            kValue = reply.toLongLong();
            qDebug() << "getRemainTime"<< kValue;
        } else {
            qDebug() << "getRemainTime method called failed!";
        }
    }
    return kValue ; 
}

qint64 BatteryUtil::getFullTime(){
    QDBusInterface interface("org.freedesktop.UPower", "/org/freedesktop/UPower/devices/battery_battery",
                             "org.freedesktop.UPower.Device",
                             QDBusConnection::systemBus());

    qint64 kValue = 0; 
    if (interface.isValid()) {
       qDebug() << "getFullTime2222222222222";
        QVariant reply = interface.property("TimeToFull");
        if (reply.isValid()) {
            kValue = reply.toLongLong();
            qDebug() << "getFullTime"<< kValue;
        } else {
            qDebug() << "getFullTime method called failed!";
        }
    }
    return kValue ; 
}

double BatteryUtil::getCurrentPrecentage(){
   QDBusInterface interface("org.freedesktop.UPower", "/org/freedesktop/UPower/devices/battery_battery",
                             "org.freedesktop.UPower.Device",
                             QDBusConnection::systemBus());

    qint64 kValue = 0; 
    qDebug() << "getCurrentPrecentagee11111111111111";
    if (interface.isValid()) {
        qDebug() << "getCurrentPrecentage2222222222222";
        QVariant reply = interface.property("Percentage");
        if (reply.isValid()) {
            kValue = reply.toDouble();
            qDebug() << "getCurrentPrecentage"<< kValue;
        } else {
            qDebug() << "getCurrentPrecentage method called failed!";
        }
    }
    return kValue ;
}

void BatteryUtil::updatePrecentage(double value ){
    qDebug() << "BatteryUtil :: Precent ::: " << value;
}
