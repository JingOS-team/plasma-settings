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

class Display : public KQuickAddons::ConfigModule
{
    Q_OBJECT

public:
    Display(QObject *parent, const QVariantList &args);

};
#endif
