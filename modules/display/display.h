/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 *                         2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef DISPLAY_H
#define DISPLAY_H

#include <KQuickAddons/ConfigModule>
#include <QObject>
#include <QDBusPendingReply>
#include "displaymodel.h"
#include <sessionmanagement.h>

class Display : public KQuickAddons::ConfigModule
{
    Q_OBJECT
    Q_PROPERTY(bool touchDoubleOn READ touchDoubleOn WRITE setTouchDoubleOn NOTIFY touchDoubleOnChanged)

public:
    Display(QObject *parent, const QVariantList &args);
    Q_INVOKABLE void restartDevice();
    bool touchDoubleOn();
    void setTouchDoubleOn(bool touchDoubleOn);
Q_SIGNALS:
    void touchDoubleOnChanged();
private:
   QString touchDoubleOnString = "gesture mode = 0x0001\n";
   QString touchDoubleOFFString = "gesture mode = 0x0000\n";
   bool m_isOn = false;
   SessionManagement m_session;
};
#endif
