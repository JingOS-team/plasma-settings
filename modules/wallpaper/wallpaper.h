/*
 * Copyright 2020  Dimitris Kardarakos <dimkard@posteo.net>
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

#include <KQuickAddons/ConfigModule>
#include <QObject>
#include <KConfigGroup>
#include <KSharedConfig>
#include "listimageprovider.h"

#ifndef WALLPAPER_H
#define WALLPAPER_H

class Wallpaper : public KQuickAddons::ConfigModule
{
    Q_OBJECT
    Q_PROPERTY(QString wallpaperUrl READ wallpaperUrl WRITE setWallpaperUrl NOTIFY wallpaperUrlChanged)
    Q_PROPERTY(QStringList systemWallpapers READ systemWallpapers NOTIFY systemWallpaperUrlChanged)
    Q_PROPERTY(QString lockwallpaperUrl READ lockwallpaperUrl WRITE setLockWallpaperUrl NOTIFY wallpaperUrlChanged)

public:
    Wallpaper(QObject *parent, const QVariantList &args);
    ~Wallpaper();
    void connectWallpaperSignal();
    void setWallpaperUrl(QString wallpaperUrl);
    QString wallpaperUrl();
    QString lockwallpaperUrl();
    void setLockWallpaperUrl(QString wallpaperUrl);
    QStringList systemWallpapers(){
        return m_systemWallpaperUrls;
    };
public slots:
   void onWallpaerChanged(QString wallpaperUrl);
signals:
   void wallpaperUrlChanged();
   void systemWallpaperUrlChanged();
private:
   QString m_wallpaperUrl;
   QString m_lockWallpaperUrl;
   QStringList m_systemWallpaperUrls;
   KConfigGroup* cfg;
   ListImageProvider *lp;
};

#endif
