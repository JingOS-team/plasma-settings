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



#include <QObject>

#ifndef BATTERY_UTIL_H
#define BATTERY_UTIL_H


class BatteryUtil : public QObject
{
    Q_OBJECT
public:
    explicit BatteryUtil();
    ~BatteryUtil(){};

    Q_INVOKABLE qint64 getRemainTime();
    Q_INVOKABLE qint64 getFullTime();
    Q_INVOKABLE double getCurrentPrecentage();

public slots:
    void updatePrecentage(double value);
    
};

#endif // BATTERY_UTIL_H

