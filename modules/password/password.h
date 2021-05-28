/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef LOCKSCREENPIN_H
#define LOCKSCREENPIN_H

#include <KQuickAddons/ConfigModule>
#include <QObject>

class Password : public KQuickAddons::ConfigModule
{
    Q_OBJECT

public:
    Password(QObject *parent, const QVariantList &args);

    Q_INVOKABLE void setPassword(const QString &password, const QString &type);
    Q_INVOKABLE void savePasswordType(const QString type);

signals: 
    void confirmSuccess();
    
public slots:
    void slotReceiveDbusConfirm();

private:
    QString m_passwordType = "simple";
};

#endif
