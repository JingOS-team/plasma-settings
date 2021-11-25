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

#ifndef DISPLAY_MODEL_H
#define DISPLAY_MODEL_H

#include <QObject>


class DisplayModel : public QObject
{
    Q_OBJECT
    
public:
    explicit DisplayModel();
    ~DisplayModel(){};

    Q_INVOKABLE void setScreenIdleTime(int sec);
    Q_INVOKABLE int getScreenIdleTime();

    Q_INVOKABLE void setApplicationScale(int scale); 
    Q_INVOKABLE int getApplicationScale();

    Q_INVOKABLE bool setAutomatic(bool isAuto);
    Q_INVOKABLE bool getAutomatic();

private:
    int readScreenIdleTimeFromFile();
    void writeSrceenIdleTimeToFile(int sec);
    

private:
    int m_screenIdleTime;

private slots:
    void onBrightnessChanged(int brightness);

};

#endif // DISPLAY_MODEL_H
