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

#include <KSharedConfig>
#include <KConfigGroup>

#include "displaymodel.h"

static const char SOLID_POWERMANAGEMENT_SERVICE[] = "org.kde.Solid.PowerManagement";

DisplayModel::DisplayModel() {
    // QDBusConnection::sessionBus().connect(QString(), QString("/org/kde/kcmshell_clock"),
    //                                       QString("org.kde.kcmshell_clock"), QString("clockUpdated"), this,
    //                                       SLOT(onBrightnessChanged()));
}

void DisplayModel::setScreenIdleTime(int sec)
{
    #if defined (__arm64__) || defined (__aarch64__)
        QDBusInterface brightnessIface(
                QStringLiteral("com.canonical.repowerd"),
                QStringLiteral("/com/canonical/repowerd"),
                QStringLiteral("com.canonical.repowerd"),QDBusConnection::systemBus());
        //设置电池模式与电源模式黑屏time
        brightnessIface.call(QStringLiteral("SetInactivityBehavior"), "display-off","battery",sec);
        brightnessIface.call(QStringLiteral("SetInactivityBehavior"), "display-off","line-power",sec);

        QDBusInterface brightnessDimIface(
                QStringLiteral("com.jingos.repowerd.Screen"),
                QStringLiteral("/com/jingos/repowerd/Screen"),
                QStringLiteral("com.jingos.repowerd.Screen"),QDBusConnection::systemBus());
        //设置暗屏时间time
        int idleTime = sec;
        if(idleTime > 0) idleTime+=10;
        brightnessDimIface.call(QStringLiteral("setInactivityTimeouts"), idleTime,idleTime);

        qDebug()<<"DisplayModel::setScreenIdleTime,sec:"<<sec;
        m_screenIdleTime = sec;
        writeSrceenIdleTimeToFile(m_screenIdleTime);
    #else
        QDBusInterface brightnessIface(
            QStringLiteral("org.kde.Solid.PowerManagement"),
            QStringLiteral("/org/kde/Solid/PowerManagement/Actions/DPMSControl"),
            QStringLiteral("org.kde.Solid.PowerManagement.Actions.DPMS"));
        brightnessIface.asyncCall(QStringLiteral("setDPMSIdleTime"), sec);
    #endif
}

int DisplayModel::getScreenIdleTime()
{
#if defined (__arm64__) || defined (__aarch64__)
    m_screenIdleTime = readScreenIdleTimeFromFile();
    return m_screenIdleTime;
#else
    // QDBusMessage screenMsg=QDBusMessage::createMethodCall("org.kde.Solid.PowerManagement",
    //                         QStringLiteral("/org/kde/Solid/PowerManagement/Actions/DPMSControl"),
    //                         QStringLiteral("org.kde.Solid.PowerManagement.Actions.DPMS"),
    //                         QStringLiteral("DPMSIdleTime"));

    QDBusInterface interface("org.kde.Solid.PowerManagement", "/org/kde/Solid/PowerManagement/Actions/DPMSControl",
                             "org.kde.Solid.PowerManagement.Actions.DPMS",
                             QDBusConnection::sessionBus());
    // QDBusInterface interface("org.kde.Solid.PowerManagement", "/org/kde/Solid/PowerManagement/Actions/SuspendSession",
    //                          "org.kde.Solid.PowerManagement.Actions.SuspendSession",
    //                          QDBusConnection::sessionBus());
    double tmpValue = 0; 
    if (interface.isValid()) {
        QDBusReply<int> reply = interface.call("DPMSIdleTime");
        // QDBusReply<int> reply = interface.call("idleTime");
        if (reply.isValid()) {
            qCritical() << "tmpValue"<< tmpValue;
            tmpValue = reply.value();
            return tmpValue;
        } else {
            qCritical() << "DPMSIdleTime method called failed!";
        }
    }

    return 0;
#endif
}

int DisplayModel::readScreenIdleTimeFromFile()
{
    KSharedConfigPtr profilesConfig = KSharedConfig::openConfig("jingpowermanagementprofilesrc", KConfig::SimpleConfig);
    // Let's start: AC profile before anything else
    KConfigGroup batteryProfile(profilesConfig, "Battery");
    KConfigGroup dimDisplay(&batteryProfile, "DimDisplay");
    int dimOnIdleTime = dimDisplay.readEntry< int >("idleTime", 120000);
    return dimOnIdleTime / 1000;
}

void DisplayModel::writeSrceenIdleTimeToFile(int seconds)
{
    KSharedConfigPtr profilesConfig = KSharedConfig::openConfig("jingpowermanagementprofilesrc", KConfig::SimpleConfig);
    // Let's start: AC profile before anything else
    KConfigGroup batteryProfile(profilesConfig, "Battery");
    KConfigGroup dimDisplay(&batteryProfile, "DimDisplay");
    int dimOnIdleTime = seconds * 1000;
    dimDisplay.writeEntry< int >("idleTime", dimOnIdleTime);

    profilesConfig->sync();
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

void DisplayModel::onBrightnessChanged(int brightness){

}

bool DisplayModel::setAutomatic(bool isAuto)
{
    bool isSetSuc;
    qDebug()<< "userAutobrightnessEnable setAutomatic::isAuto:" << isAuto;
    QDBusInterface brightnessIface(
        QStringLiteral("com.jingos.repowerd.Screen"),
        QStringLiteral("/com/jingos/repowerd/Screen"),
        QStringLiteral("com.jingos.repowerd.Screen"),QDBusConnection::systemBus());
        

    QDBusMessage reply = brightnessIface.call(QStringLiteral("userAutobrightnessEnable"), isAuto);
    qDebug() << "userAutobrightnessEnable setAutomatic:::" << reply.type();
    if (reply.type() == QDBusMessage::ReplyMessage){
        qDebug()<< "userAutobrightnessEnable setAutomatic:success::" << reply.arguments();
        isSetSuc = true;
    }
    return isSetSuc;

}

bool DisplayModel::getAutomatic()
{
   QDBusInterface interface("com.jingos.repowerd.Screen", "/com/jingos/powerd",
                            "com.jingos.powerd",QDBusConnection::systemBus());

    bool tmpValue;
    QDBusMessage reply = interface.call(QStringLiteral("getBrightnessParams"));

    qDebug()<< "userAutobrightnessEnable getAutomatic::reply:" << reply;
    if (reply.type() == QDBusMessage::ReplyMessage) {
        const auto &argument = reply.arguments().at(0).value<QDBusArgument>();
        int a, b, c,d;
        bool e;

        argument.beginStructure();
        argument >> a;
        argument >> b;
        argument >> c;
        argument >> d;
        argument >> e;
        argument.endStructure();
        qDebug() << "userAutobrightnessEnable getAutomatic::reply arguments:"<< argument.currentType()
        << " d::::" <<d << " e:::" << e;
        tmpValue = e;
    } else {
        qDebug() << "DPMSIdleTime method called failed!";
    }
    qDebug()<< "userAutobrightnessEnable getAutomatic::tmpValue:" << tmpValue;

    return tmpValue ;
}
