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
#include <QFile>
#include <QProcess>
#include <QDebug>
#include <QTextCodec>
#include <QUrl>
#include <QSettings>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <exception>
#include <KSharedConfig>
#include <KConfigGroup>
#include <QDBusInterface>
#include <QDBusReply>
#include <BluezQt/Manager>
#include <BluezQt/Adapter>

#include "mynetworkobject.h"
#include "updatetool.h"

QString UpdateTool::settingFileName = "/usr/share/lastCheckedTime.ini" ;

UpdateTool::UpdateTool() {


    myNetworkObject = new MyNetworkObject();
    connect(myNetworkObject , SIGNAL(requestSuccessSignal(QString)) , this , SLOT(readRemoteSuccess(QString)));
    connect(myNetworkObject , SIGNAL(requestFailSignal(QString)) , this , SLOT(readRemoteFailure(QString)));
}


void UpdateTool::launchDistUpgrade(QString v_version)
{
    QProcess process(this);
    process.startDetached("qaptupdator -s "+ v_version);
}

QString UpdateTool::readLocalVersion()
{
    QString ver1 = ""; 
    QString dataFromFile;

    QTextCodec * code = QTextCodec::codecForName("utf8");
    QFile file("/usr/share/jingosinfo/systeminfo.conf");

    if ( !file.open(QIODevice::ReadOnly | QIODevice::Text) )
        return "";

    QTextStream stream(&file);
    stream.setCodec(code);
    while (stream.atEnd() == 0) {
        ver1 = stream.readAll();
    }
    QString result = "";
    QStringList list = ver1.split("\n");

    QString version= list.at(1);
    result.append(version.remove("version="));
    QString revision= list.at(2);
    result.append(".");
    result.append(revision.remove("revision="));

    return result ; 
}

double UpdateTool::getStorageTotalSize()
{
    return storage.bytesTotal();
}

QString UpdateTool::readLocalInfo()
{
    QString ver1 = ""; 
    QString dataFromFile;
    QTextCodec * code = QTextCodec::codecForName("utf8");
    QFile file("/usr/share/jingosinfo/systeminfo.conf");

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        emit checkedFinish(3 , "Read local info failure" , "");
        return "";
    }

    QTextStream stream(&file);
    stream.setCodec(code);
    while (stream.atEnd() == 0) {
        ver1 = stream.readAll();
    }
    QString result = "?localversion=";
    QStringList list = ver1.split("\n");

    QString version= list.at(1);
    result.append(version.remove("version="));
    QString revision= list.at(2);
    result.append(".");
    result.append(revision.remove("revision="));
    result.append("&platform=");
    
    QString buildnum= list.at(3);
    QString stage= list.at(4);
    QString architecture= list.at(5);
    result.append(architecture.remove("architecture="));
    QString hwversion= list.at(6);
    
    QString firmware= list.at(7);
    QString product= list.at(8);
    result.append("&product=");
    result.append("community");
    result.append("&lang=en");

    return result;
}

void UpdateTool::readRemoteVersion()
{
    QString urlStr = "https://om.jingos.com/api/v1/ota/versioncheck";
    QString version = readLocalInfo();
    if(version== ""){
        emit checkedFinish(4 , "" , "");
        return ;
    }
    urlStr.append(version);
    QUrl url = QUrl(urlStr);
    
    myNetworkObject->get(url);
}

bool UpdateTool::hasNewVersion()
{
    QString newVersionStr = loadSetting("haveNewVersion" , "false");
    QVariant tempValue = newVersionStr;
    bool tempFinished = tempValue.toBool();
    return tempFinished;
}
 
void UpdateTool::readRemoteSuccess(QString data) 
{
    Parse_Seniverse_Now_Json(data);
}

void UpdateTool::readRemoteFailure(QString error) 
{
    if(error == "Timeout") {
        emit checkedFinish(4 , "" , "");
    } else {
        emit checkedFinish(3 , error , "");
    }
}

void UpdateTool::setCheckCycle(int cycle)
{
    saveSetting("check_cycle" , QString::number(cycle));
    QDBusInterface iface("org.jingos.info.checkcycle", 
        "/services/jingos_dbus/settingsdbus", 
        "", 
        QDBusConnection::sessionBus());
        
    if (iface.isValid()) {
        QDBusReply<QString> reply = iface.call("setCheckCycle",cycle);
        if (reply.isValid()) {
            return;
        }
    }
}

int UpdateTool::getCheckCycle()
{
    QString value = loadSetting("check_cycle", QString::number(24 * 60 * 60 * 1000 * 2));
    return value.toInt();
}

QString UpdateTool::loadSetting(QString key, QString defaultValue) 
{
    KSharedConfigPtr profilesConfig = KSharedConfig::openConfig("update_config" , KConfig::SimpleConfig);
    KConfigGroup acProfile(profilesConfig , "UPDATE");
    QString value = acProfile.readEntry(key, defaultValue);
    return value ; 
}

QString UpdateTool::saveSetting(QString key, QString value) 
{
    KSharedConfigPtr profilesConfig = KSharedConfig::openConfig("update_config" , KConfig::SimpleConfig);
    KConfigGroup acProfile(profilesConfig, "UPDATE");
    acProfile.writeEntry(key, value);
    profilesConfig->sync();
    return "";
}

int UpdateTool::Parse_Seniverse_Now_Json(QString& seniverse_now_json)
{
    QJsonParseError err_rpt;
    QJsonDocument  root_Doc = QJsonDocument::fromJson(seniverse_now_json.toUtf8(), &err_rpt);//字符串格式化为JSON
    if(err_rpt.error != QJsonParseError::NoError) {
        return -1;
    } else {
        QJsonObject root_Obj = root_Doc.object();
        bool newVersion = root_Obj.value("newVersion").toBool();
        qDebug() << "newVersion:::" << newVersion;

        QString changedLog = "\n" ; 
        QJsonValue result_Value = root_Obj.value("versionNodeList");
        if(result_Value.isArray()) {

                QJsonObject result_Obj = result_Value.toArray().at(result_Value.toArray().size()-1).toObject();
                QString versionName = result_Obj.value("versionName").toString();
                qDebug() << "VersionNum::: "<<versionName;
                // if(i == result_Value.toArray().size() -1) {
                    valueVersion = versionName;
                // }
                QJsonValue changloglist = result_Obj.value("changeLogList");
                if(changloglist.isArray()) {
                    for(int j = 0 ; j < changloglist.toArray().size() ; j++) {
                        QJsonObject change_Obj = changloglist.toArray().at(j).toObject();
                        QString changeType = change_Obj.value("type").toString();
                        QString changeInfo = change_Obj.value("info").toString();
                        changedLog.append("type: " + changeType +" \n");
                        changedLog.append("info: " + changeInfo +" \n");      
                        changedLog.append("\n");
                    }   
                }
        }

        if(newVersion) {
            emit checkedFinish(1 , changedLog , valueVersion);
        } else {
            emit checkedFinish(2 , "Current Version is Lastest" , "");
        }
    }
    return 0;
}
