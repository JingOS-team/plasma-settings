/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef POWER_H
#define POWER_H

#include <KQuickAddons/ConfigModule>
#include <QObject>

class Power : public KQuickAddons::ConfigModule
{
    Q_OBJECT

public:
    Power(QObject *parent, const QVariantList &args);

};

#endif
