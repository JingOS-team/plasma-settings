/*
 * Copyright 2020  Dimitris Kardarakos <dimkard@posteo.net>
 * Copyright 2021 Rui Wang <wangrui@jingos.com>
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

#include "wallpaper.h"
#include <KAboutData>
#include <KLocalizedString>
#include <KPluginFactory>
#include <QtDBus/QDBusConnectionInterface>
#include <QtDBus/QDBusInterface>
#include <QDir>

K_PLUGIN_CLASS_WITH_JSON(Wallpaper, "wallpaper.json")
#define SERVICE_NAME  "org.kde.jingwallpaper.qtdbus.edit"

#define WALLPAPER_SERVICE_NAME "org.jing.systemui.wallpaper"
#define WALLPAPER_PATH "/jing/systemui/wallpaper"
#define WALLPAPER_INTERFACE "org.jing.systemui.wallpaper"
#define WALLPAPERDIR "/usr/share/wallpapers/jing/"

Wallpaper::Wallpaper(QObject *parent, const QVariantList &args)
    : KQuickAddons::ConfigModule(parent, args)
{
    KLocalizedString::setApplicationDomain("kcm_wallpaper");
    KAboutData *about = new KAboutData("kcm_wallpaper", i18n("Wallpaper"), "1.0", QString(), KAboutLicense::GPL);
    about->addAuthor(i18n("Zhang he gang"), QString(), "zhanghegang@jingos.com");
    setAboutData(about);
    connectWallpaperSignal();
    qDebug() << "Wallpaper module loaded";
}

void Wallpaper::connectWallpaperSignal()
{
//    bool isConnect = QDBusConnection::sessionBus().connect(WALLPAPER_SERVICE_NAME,
//                                          WALLPAPER_PATH,
//                                          WALLPAPER_INTERFACE,
//                                          "wallpaperChanged",
//                                          this,
//                                          SLOT(onWallpaerChanged(QString)));
//    qDebug()<<Q_FUNC_INFO << " connect wallpaper signal:" << isConnect;

    // KSharedConfig::Ptr kdeglobals = KSharedConfig::openConfig("kdeglobals");
    // cfg = new KConfigGroup(kdeglobals, "Icons");
    // QString currentTheme = cfg->readEntry("Theme", QString("breeze"));
    QDir wallpapersPath(QLatin1String(WALLPAPERDIR));
    m_systemWallpaperUrls = wallpapersPath.entryList(QDir::AllEntries | QDir::NoDotAndDotDot);

    for(int i = 0; i < m_systemWallpaperUrls.count();i++){
        m_systemWallpaperUrls[i] = wallpapersPath.path() +"/"+ m_systemWallpaperUrls[i];
    }
    // setWallpaperUrl("/usr/share/icons/jing/");
    qDebug()<< Q_FUNC_INFO 
    // << " cfg:" << cfg << " currentTheme:" << currentTheme
            <<" syswallpaperurls:" << m_systemWallpaperUrls;

}

void Wallpaper::onWallpaerChanged(QString wallpaperUrl)
{
    setWallpaperUrl(wallpaperUrl);
}

void Wallpaper::setWallpaperUrl(QString wallpaperUrl)
{
    m_wallpaperUrl = wallpaperUrl;
    emit wallpaperUrlChanged();
}

QString Wallpaper::wallpaperUrl()
{
    KSharedConfig::Ptr kdeglobals = KSharedConfig::openConfig("kdeglobals", KConfig::FullConfig);
    KConfigGroup cfg = KConfigGroup(kdeglobals, "Wallpapers");
    QString defaultWallpaper = cfg.readEntry("defaultLauncherWallpaper", QString(""));
    QString currentLauncherpaper = cfg.readEntry("launcherWallpaper", defaultWallpaper);
    qDebug()<< " **wallpaper Url::::" << currentLauncherpaper;
    return currentLauncherpaper;
}

void Wallpaper::setLockWallpaperUrl(QString wallpaperUrl)
 {
    m_lockWallpaperUrl = wallpaperUrl;
    emit wallpaperUrlChanged();
 }

QString Wallpaper::lockwallpaperUrl()
{
    KSharedConfig::Ptr kdeglobals = KSharedConfig::openConfig("kdeglobals", KConfig::FullConfig);
    KConfigGroup cfg = KConfigGroup(kdeglobals, "Wallpapers");
    QString defaultWallpaper = cfg.readEntry("defaultLockScreenWallpaper", QString(""));
    QString currentLauncherpaper = cfg.readEntry("lockscreenWallpaper", defaultWallpaper);
    qDebug()<< " **lockwallpaper Url::::" << currentLauncherpaper;
    return currentLauncherpaper;
}

void Wallpaper::intoLibwallpaper(QString imageUrl)
{
    if (!QDBusConnection::sessionBus().isConnected()) {
        fprintf(stderr, "Cannot connect to the D-Bus session bus.\n"
                        "To start it, run:\n"
                        "\teval `dbus-launch --auto-syntax`\n");
        return ;
    }

    QDBusInterface iface(SERVICE_NAME, "/", "", QDBusConnection::sessionBus());
    if (iface.isValid()) {
        QDBusReply<QString> reply = iface.call("setWallpaper", imageUrl);
        if (reply.isValid()) {
            printf("Reply was: %s\n", qPrintable(reply.value()));
            return ;
        }

        fprintf(stderr, "Call failed: %s\n", qPrintable(reply.error().message()));
        return ;
    }
}

QString Wallpaper::getWallpaper()
{
    if (!QDBusConnection::sessionBus().isConnected()) {
        fprintf(stderr, "Cannot connect to the D-Bus session bus.\n"
                        "To start it, run:\n"
                        "\teval `dbus-launch --auto-syntax`\n");
        return "";
    }

    QDBusInterface iface(WALLPAPER_SERVICE_NAME, WALLPAPER_PATH, WALLPAPER_INTERFACE, QDBusConnection::sessionBus());
    if (iface.isValid()) {
        QDBusReply<QString> reply = iface.call("getWallpaper");
        if (reply.isValid()) {
            printf("Reply was: %s\n", qPrintable(reply.value()));
            return reply.value();
        }

        fprintf(stderr, "Call failed: %s\n", qPrintable(reply.error().message()));
        return "";
    }
    return "";
}
#include "wallpaper.moc"
