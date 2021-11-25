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
#define WALLPAPERDIR "/usr/share/wallpapers/jing/"

Wallpaper::Wallpaper(QObject *parent, const QVariantList &args)
    : KQuickAddons::ConfigModule(parent, args)
{
    KLocalizedString::setApplicationDomain("kcm_wallpaper");
    KAboutData *about = new KAboutData("kcm_wallpaper", i18n("Wallpaper"), "1.0", QString(), KAboutLicense::GPL);
    about->addAuthor(i18n("Zhang he gang"), QString(), "zhanghegang@jingos.com");
    setAboutData(about);

    connectWallpaperSignal();
    qDebug() << "Wallpaper module loaded ";
}

Wallpaper::~Wallpaper()
{
    qDebug() << "~Wallpaper module removed11";
}

void Wallpaper::connectWallpaperSignal()
{
    // KSharedConfig::Ptr kdeglobals = KSharedConfig::openConfig("kdeglobals");
    // cfg = new KConfigGroup(kdeglobals, "Icons");
    // QString currentTheme = cfg->readEntry("Theme", QString("breeze"));
    QDir wallpapersPath(QLatin1String(WALLPAPERDIR));
    m_systemWallpaperUrls = wallpapersPath.entryList(QDir::AllEntries | QDir::NoDotAndDotDot);

    for(int i = 0; i < m_systemWallpaperUrls.count();i++){
        m_systemWallpaperUrls[i] = wallpapersPath.path() +"/"+ m_systemWallpaperUrls[i];
    }
    qDebug()<< Q_FUNC_INFO 
            <<" syswallpaperurls:" << m_systemWallpaperUrls;
    emit systemWallpaperUrlChanged();
    lp = new ListImageProvider(QQmlImageProviderBase::Image);
    lp->loadCacheImage(m_systemWallpaperUrls);
    mainUi();
    engine()->addImageProvider(QLatin1String("imageProvider"), lp);

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
    auto kdeglobals = KSharedConfig::openConfig("kdeglobals");
    KConfigGroup cfg(kdeglobals, "Wallpapers");
    QString currentLauncherpaper = cfg.readEntry("launcherWallpaper", QString());
    if(currentLauncherpaper.isEmpty() || currentLauncherpaper.isNull()) {
       currentLauncherpaper = cfg.readEntry("defaultLauncherWallpaper", QString("file:///usr/share/wallpapers/jing/default.jpg"));
    }
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
    auto kdeglobals = KSharedConfig::openConfig("kdeglobals");
    KConfigGroup cfg(kdeglobals, "Wallpapers");
    QString currentLockScreenWallpaper = cfg.readEntry("lockscreenWallpaper", QString());
    if(currentLockScreenWallpaper.isEmpty() || currentLockScreenWallpaper.isNull()) {
       currentLockScreenWallpaper = cfg.readEntry("defaultLockScreenWallpaper", QString("file:///usr/share/wallpapers/jing/default.jpg"));
    }
    qDebug()<< " **lockwallpaper Url::::" << currentLockScreenWallpaper;
    return currentLockScreenWallpaper;
}
#include "wallpaper.moc"
