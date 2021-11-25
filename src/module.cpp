/***************************************************************************
 *                                                                         *
 *   Copyright 2019 Nicolas Fella <nicolas.fella@gmx.de>                   *
 *             2021 Wang Rui <wangrui@jingos.com>
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

#include "module.h"

#include <KPackage/PackageLoader>

#include <KPluginFactory>
#include <KPluginLoader>

static QMutex mutex;
static QHash<QString, KQuickAddons::ConfigModule *> loadedPlugins;

KQuickAddons::ConfigModule *Module::kcm() const
{
    return m_kcm;
}

void ModuleLoader::doLoad(const QString &parameter)
{
    for (int i = 0; i < preLoadModuleList.size(); ++i)
    {
        QString moduleName = preLoadModuleList.at(i).toLocal8Bit().constData();
        loadModule(moduleName);
    }
}

void ModuleLoader::loadModule(QString name)
{
    qDebug()<<"[liubangguo]ModuleLoader::loadModule,name:"<<name;
    mutex.lock();
    const QString pluginPath = KPluginLoader::findPlugin(QLatin1String("kcms/") + "kcm_" + name);
    KQuickAddons::ConfigModule * findModule = loadedPlugins.value(name);
    if(findModule != nullptr){
        mutex.unlock();
        return;
    }


    KPluginLoader loader(pluginPath);
    KPluginFactory *factory = loader.factory();
    if (!factory) {
        qWarning() << "[liubangguo]Error loading KCM plugin:" << loader.errorString();
    } else {
        KQuickAddons::ConfigModule * kcm = factory->create<KQuickAddons::ConfigModule>(this);
        loadedPlugins.insert(name, kcm);
        if (!kcm) {
            qWarning() << "[liubangguo]Error creating object from plugin" << loader.fileName();
        }
    }
    mutex.unlock();
}

QString Module::name() const
{
    return m_name;
}

Module::Module() 
{
    KPackage::PackageLoader::self()->listPackages(QString(), "kpackage/kcms/");

    m_loader = new ModuleLoader();
    m_loader->moveToThread(&m_loadThread);
    connect(&m_loadThread, &QThread::finished, m_loader, &QObject::deleteLater);
    connect(this, &Module::operate, m_loader, &ModuleLoader::doLoad);
    connect(m_loader, &ModuleLoader::resultReady, this, &Module::loadResults);
              m_loadThread.start();
}

void Module::loadWallpaperCache()
{
    const QString pluginPath = KPluginLoader::findPlugin(QLatin1String("kcms/") + "kcm_wallpaper");

    KPluginLoader loader(pluginPath);
    KPluginFactory *factory = loader.factory();
    if (!factory) {
        qWarning() << "Error loading KCM plugin:" << loader.errorString();
    } else {
        auto m_kcmWallpaper = factory->create<KQuickAddons::ConfigModule>(this);
        loadedPlugins.insert("wallpaper", m_kcmWallpaper);
        if (!m_kcmWallpaper) {
            qWarning() << "Error creating object from plugin" << loader.fileName();
        }
    }
}


void Module::setName(const QString &name)
{
    if (m_name == name) {
        return;
    }
    
    m_name = name;
    Q_EMIT nameChanged();
    KQuickAddons::ConfigModule * findModule = loadedPlugins.value(m_name);
    // if (m_kcm != nullptr) {
    //     Q_EMIT m_kcm->currentIndexChanged(1);
    // }
    if(findModule != nullptr){
    //if((m_name == "bluetooth" | m_name == "mobile_info" | m_name == "wifi" | m_name == "password") && findModule != nullptr){
        m_kcm = findModule;
        Q_EMIT kcmChanged();
         if (m_kcm != nullptr) {
            Q_EMIT m_kcm->currentIndexChanged(1);
        }
        return;
    }

    qDebug()<<"[liubangguo]Module::setName,find module is null,name:"<<name;
    mutex.lock();

    KQuickAddons::ConfigModule * module = loadedPlugins.value(m_name);

    const QString pluginPath = KPluginLoader::findPlugin(QLatin1String("kcms/") + "kcm_" + name);

    KPluginLoader loader(pluginPath);
    KPluginFactory *factory = loader.factory();
    if (!factory) {
        qWarning() << "Error loading KCM plugin:" << loader.errorString();
    } else {
        m_kcm = factory->create<KQuickAddons::ConfigModule>(this);
        loadedPlugins.insert(m_name, m_kcm);
        if (!m_kcm) {
            qWarning() << "Error creating object from plugin" << loader.fileName();
        }
    }

   Q_EMIT kcmChanged();

    if (module != nullptr){
        qDebug()<<Q_FUNC_INFO << " module remove::::::";
        delete module;
    }
    mutex.unlock();

}

void Module::loadResults(const QString &result)
{
    qDebug()<<"[liubangguo]load all finished";
}
