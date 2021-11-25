/*
 * Copyright 2020  Dimitris Kardarakos <dimkard@posteo.net>
 * Copyright 2021 Wang Rui <wangrui@jingos.com>
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

#include "battery.h"
#include "batteryutil.h"
#include <KAboutData>
#include <KLocalizedString>
#include <KPluginFactory>


K_PLUGIN_CLASS_WITH_JSON(Battery, "battery.json")
Battery::Battery(QObject *parent, const QVariantList &args)
    : KQuickAddons::ConfigModule(parent, args)
{

    qmlRegisterType<BatteryUtil>("BatteryUtil", 1, 0, "BatteryUtil");

    KAboutData *about = new KAboutData("kcm_battery", i18n("Battery"), "1.0", QString(), KAboutLicense::GPL);
    KLocalizedString::setApplicationDomain("kcm_battery");
    about->addAuthor(i18n("Jake Wu"), QString(), "jake@jingos.com");
    setAboutData(about);

    qDebug() << "Battery module loaded";
}

#include "battery.moc"
