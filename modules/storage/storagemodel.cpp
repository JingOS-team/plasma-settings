/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *                Han Young <hanyoung@protonmail.com>
 *                Rui Wang<wangrui@jingos.com>
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

#include <QDebug>
#include <QObject>
// #include <solid/device.h>
#include <Solid/Device>
#include <QAbstractItemModel>
#include <QStandardItemModel>
#include <QCoreApplication>
#include <QTime>
#include <QTimer>
#include <QEventLoop>
#include <solid/devicenotifier.h>

#include "storagemodel.h"

// static const char SOLID_POWERMANAGEMENT_SERVICE[] = "org.kde.Solid.PowerManagement";


StorageModel::StorageModel() 
: m_subPixelOptionsModel(new QStandardItemModel(this)){

    getAllMountedInfo();

    Solid::DeviceNotifier *notifier = Solid::DeviceNotifier::instance();
    mTimer = new QTimer();
    
    connect(notifier, &Solid::DeviceNotifier::deviceAdded, [this](const QString &device) 
    {

        Solid::Device deviceItem(device);
        qDebug() << "deviceAdded:: "<< deviceItem.displayName();
        
  
        if (deviceItem.isDeviceInterface(Solid::DeviceInterface::StorageDrive)){

            if (mTimer != nullptr) {
                mTimer->setSingleShot(true);
                connect(mTimer, &QTimer::timeout, this, [=](){
                    qDebug() << "deviceAdded real";
                    getAllMountedInfo();
                    emit refreshListView() ;
                });
                mTimer->start(1000);
	     	}
        }
    });

    connect(notifier, &Solid::DeviceNotifier::deviceRemoved, [this](const QString &device) {
        qDebug() << "deviceRemove" ;

        getAllMountedInfo();
        emit refreshListView() ;

    });
}

StorageModel::~StorageModel()
{
	Solid::DeviceNotifier *notifier = Solid::DeviceNotifier::instance();
    
    disconnect(notifier, &Solid::DeviceNotifier::deviceAdded, 0, 0); 
    disconnect(notifier, &Solid::DeviceNotifier::deviceRemoved, 0, 0); 
 
	qDebug() << "~StorageModel" << "destruct";
	if (mTimer != nullptr) 
	{
		if(mTimer->isActive()) 
		{
			mTimer->stop();
		} 
		delete mTimer;
	}
}

QString StorageModel::getStorageName(){
    qDebug() << "getStorageName" << storage.name();
    return storage.name();
}

QString StorageModel::getStorageType(){
    qDebug() << "getStorageType" << storage.fileSystemType();
    return storage.fileSystemType();
}

double StorageModel::getStorageTotalSize(){
    qDebug() << "getStorageTotalSize" << storage.bytesTotal();
    return storage.bytesTotal();
}

QAbstractItemModel *StorageModel::subPixelOptionsModel() const
{
    return m_subPixelOptionsModel;
}

double StorageModel::getStorageAvailableSize(){
    qDebug() << "getStorageAvailableSize" << storage.bytesAvailable();
    return storage.bytesAvailable();
}  

void StorageModel:: getAllMountedInfo(){
     QStorageInfo storage = QStorageInfo::root();

    QList<QStorageInfo> list = QStorageInfo::mountedVolumes();
    m_subPixelOptionsModel->clear() ; 
 
    int count = list.size();
    qDebug() << "storage device size : =======" <<count;

    QString strInfo = "";
    for(int i = 0; i < count; ++i)
    {
        QStorageInfo diskInfo = list.at(i);
        qint64 freeSize = diskInfo.bytesFree();
        qint64 totalSize = diskInfo.bytesTotal();
        QString tempInfo = "";
        // qDebug() << "storage name : =======" << diskInfo.displayName();

        if(diskInfo.displayName().startsWith("/") && !diskInfo.displayName().startsWith("/media")){
            QString tempInfo1 = QString("name:%1  totalSize:%2 freeSize:%3 \n")
            .arg(diskInfo.displayName())
            .arg(GetStorageSize(totalSize))
            .arg(GetStorageSize(freeSize));
        }else {
             tempInfo = QString("%1,%2,%3,%4")
            .arg(diskInfo.displayName())
            .arg(GetStorageSize(totalSize))
            .arg(GetStorageSize(totalSize- freeSize))
            .arg(GetFreeSizePrecent(freeSize , totalSize));

            strInfo.append(tempInfo);

            auto item = new QStandardItem(tempInfo);
            m_subPixelOptionsModel->appendRow(item);
            
        }
    }

    //  qDebug() << "strInfo=======" << strInfo;
}


QString StorageModel::GetFreeSizePrecent(qint64 freeSize ,qint64 totalSize){
    float precent = (float)freeSize / (float)totalSize ;
    return  QString("%1").arg(precent); ;
}

QString StorageModel::GetStorageSize(qint64 size)
{
    if(size < 1024)
    {
        return QString("%1 B").arg(size);
    }
    else
    {
        size = size / 1024;
    }
 
    double tempSize = 1.0 * size;
    if(tempSize < 1024)
    {
        return QString("%1 KB").arg(tempSize);
    }
    else
    {
        tempSize = tempSize / 1024;
    }
 
    if(tempSize < 1024)
    {
        return QString("%1 MB").arg(tempSize);
    }
    else
    {
        tempSize = tempSize / 1024;
    }
    if(tempSize < 1024)
    {
        return QString("%1 GB").arg(tempSize);
    }
    else
    {
        tempSize = tempSize / 1024;
    }
 
    return "";
}
