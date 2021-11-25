#ifndef HELPER_H
#define HELPER_H

/*
 * KFontInst - KDE Font Installer
 *
 * Copyright 2003-2010 Craig Drummond <craig@kde.org>
 *
 * ----
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include <QObject>
#include <QSet>
#include <KAuth>

using namespace KAuth;

namespace KFI
{

typedef struct {
    uint8_t command[32];               // 设置成 “boot-recovery”
    uint8_t status[32];
    uint8_t recovery[768];
    uint8_t stage[32];
    uint8_t reserved[1184];             // 行为参数，各个参数用逗号分割，形如 “ignore-tags,reboot”
} ResetData;

class Helper : public QObject
{
    Q_OBJECT

public:

    Helper();
    ~Helper() override;
    enum EStatus
    {
        STATUS_OK=0,
        STATUS_FAIL=-1
    };
public Q_SLOTS:

    ActionReply manage(const QVariantMap &args);

private:
    int factoryReset(const QVariantMap &args);
};

}

#endif
