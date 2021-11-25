/*
 * KHelper - KDE Font Installer
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

#include "Helper.h"
#include <QDebug>
#include <QCoreApplication>
#include <QDomDocument>
#include <QTextCodec>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>
#include <sys/errno.h>
#include <QFile>
#include <cstring>

#define KFI_DBUG qDebug() << time(nullptr)

KAUTH_HELPER_MAIN("org.kde.factoryreset", KFI::Helper)

namespace KFI
{

Helper::Helper()
{
    KFI_DBUG;
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
}

Helper::~Helper()
{
}

ActionReply Helper::manage(const QVariantMap &args)
{
    int result= -1;
    QString method=args["method"].toString();

    KFI_DBUG << method;

    if("factoryReset"==method)
        result=factoryReset(args);
    else
        KFI_DBUG << "Uknown action";

    if(EStatus::STATUS_OK==result)
        return ActionReply::SuccessReply();

    ActionReply reply(ActionReply::HelperErrorType);
    reply.setErrorCode(static_cast<KAuth::ActionReply::Error>(result));
    return reply;
}

int Helper::factoryReset(const QVariantMap &args)
{
    QString path = "/dev/disk/by-partlabel/misc";
    QFile systemMiscFile(path);
    bool isOpen = systemMiscFile.open(QIODevice::ReadWrite);
    qDebug()<< " factoryReset isopen:" << isOpen;
    if (isOpen) {
        qDebug()<< " factoryReset open success";
        ResetData resetData;
        std::memset(&resetData,0,sizeof(ResetData));
        std::strcpy((char *)resetData.command, "boot-recovery");
        std::strcpy((char *)resetData.reserved, "reboot");
        systemMiscFile.resize(0);
        systemMiscFile.write(reinterpret_cast<char *>(&resetData),sizeof(ResetData));
        systemMiscFile.close();
    } else {
        return STATUS_FAIL;
    }

    int result=STATUS_OK;

    return result;
}

}
