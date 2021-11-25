/*
 * Copyright 2019  Jonah Brüchert <jbb@kaidan.im>
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "distroinfo.h"
#include "hardwareinfo.h"
#include "softwareinfo.h"
#include <KQuickAddons/ConfigModule>
#include <BluezQt/Manager>
#include <BluezQt/InitManagerJob>
#include <QChar>
#include <QDataStream>
#include <sessionmanagement.h>

#ifndef INFO_H
#define INFO_H

typedef struct {
    uint8_t command[32];               // 设置成 “boot-recovery”
    uint8_t status[32];
    uint8_t recovery[768];
    uint8_t stage[32];
    uint8_t reserved[1184];             // 行为参数，各个参数用逗号分割，形如 “ignore-tags,reboot”
} ResetData;

class Info : public KQuickAddons::ConfigModule
{
    Q_OBJECT

    Q_PROPERTY(DistroInfo *distroInfo READ distroInfo NOTIFY distroInfoChanged)
    Q_PROPERTY(SoftwareInfo *softwareInfo READ softwareInfo NOTIFY softwareInfoChanged)
    Q_PROPERTY(HardwareInfo *hardwareInfo READ hardwareInfo NOTIFY hardwareInfoChanged)
    Q_PROPERTY(QString localDeviceName READ localDeviceName NOTIFY localDeviceNameChanged)
    DistroInfo *distroInfo() const;
    SoftwareInfo *softwareInfo() const;
    HardwareInfo *hardwareInfo() const;

public:
    Info(QObject *parent, const QVariantList &args);
    ~Info();
     QString localDeviceName(){ return m_localDeviceName; };
    Q_INVOKABLE void copyInfoToClipboard() const;
    Q_INVOKABLE QString getLocalDeviceName();
    Q_INVOKABLE void setLocalDeviceName(const QString localName);
    Q_INVOKABLE QString getLocalDeviceAdress();
    Q_INVOKABLE QString getDeviceIMEI();
    Q_INVOKABLE void resetSystem();

Q_SIGNALS:
    void distroInfoChanged();
    void softwareInfoChanged();
    void hardwareInfoChanged();
    void localDeviceNameChanged(const QString localDeviceName); 
public slots: 
    void initJobResult(BluezQt::InitManagerJob *job);

private:
    DistroInfo *m_distroInfo;
    SoftwareInfo *m_softwareInfo;
    HardwareInfo *m_hardwareInfo;
    BluezQt::Manager *m_manager;
    QString m_localDeviceName = "";
    BluezQt::InitManagerJob *initJob;
    SessionManagement m_session;

};

#endif // INFO_H
