/*
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
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#ifndef UPDATETOOL_H
#define UPDATETOOL_H

#include <QObject>
#include <QCoreApplication>
#include <QGuiApplication>
#include "mynetworkobject.h"
#include <QException>
#include <QStorageInfo>

using namespace std;

class UpdateTool : public QObject
{
    Q_OBJECT
public:
    explicit UpdateTool();
    ~UpdateTool(){};

    MyNetworkObject *myNetworkObject;
    static QString settingFileName  ;

    // QString localVersionCode;
    Q_INVOKABLE void launchDistUpgrade(QString version);
    QString valueVersion ;
    

    QString readLocalInfo();
    int Parse_Seniverse_Now_Json(QString& json);
    Q_INVOKABLE QString readLocalVersion();
    Q_INVOKABLE void readRemoteVersion();
    Q_INVOKABLE bool hasNewVersion();
    Q_INVOKABLE void setCheckCycle(int cycle);
    Q_INVOKABLE int getCheckCycle();
    Q_INVOKABLE double getStorageTotalSize();

    static QString loadSetting( QString key , QString value ) ;
	static QString saveSetting( QString key , QString value ) ;

private:
    QStorageInfo storage = QStorageInfo::root();  
    
public slots: 
    void readRemoteSuccess(QString data);
    void readRemoteFailure(QString error);
    

signals: 
    void checkedFinish(int status , QString log , QString version);    
};

#endif
