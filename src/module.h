/***************************************************************************
 *                                                                         *
 *   Copyright 2019 Nicolas Fella <nicolas.fella@gmx.de>                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

#pragma once

#include <QStringList>
#include <KQuickAddons/ConfigModule>
#include <QObject>


class ModuleLoader : public QObject
  {
      Q_OBJECT

  public slots:
      void doLoad(const QString &parameter);

  signals:
      void resultReady(const QString &result);


private:
      void loadModule(QString name);

      QStringList preLoadModuleList = {
          "pointer",
          "trackpad",
          "keyboard",
          "storage",
          "battery",
          "mobile_time",
          "translations",
          "mobile_info",
          "sound",
          "wallpaper",
          "display",
          "password",
          "vpn",
          "cellular",
          "bluetooth",
          "wifi"
      };
  };


class Module : public QObject
{
    Q_OBJECT
    Q_PROPERTY(KQuickAddons::ConfigModule *kcm READ kcm NOTIFY kcmChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)

public:
    Module();
//    void loadModule(QString name);
    KQuickAddons::ConfigModule *kcm() const;
    QString name() const;
    void setName(const QString &name);
    Q_INVOKABLE void loadWallpaperCache();

public slots:
      void loadResults(const QString &);
signals:
      void operate(const QString &);

Q_SIGNALS:
    void kcmChanged();
    void nameChanged();

//public Q_SLOTS:
//    void loadModuleList();


private:

    KQuickAddons::ConfigModule *m_kcm = nullptr;
    QString m_name;
    ModuleLoader* m_loader;
    QThread     m_loadThread;
    QTimer* m_loadModuleTimer;


};
