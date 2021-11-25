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
#include <QDir>
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

StorageModel::StorageModel() : m_subPixelOptionsModel(new QStandardItemModel(this)) {

    getAllMountedInfo();
    disk();

    Solid::DeviceNotifier *notifier = Solid::DeviceNotifier::instance();
    mTimer = new QTimer();

    connect(notifier, &Solid::DeviceNotifier::deviceAdded, [this](const QString &device)
    {
        Solid::Device deviceItem(device);

        if (deviceItem.isDeviceInterface(Solid::DeviceInterface::StorageDrive)){

            if (mTimer != nullptr) {
                mTimer->setSingleShot(true);
                connect(mTimer, &QTimer::timeout, this, [=](){
                    getAllMountedInfo();
                    emit refreshListView() ;
                });
                mTimer->start(1000);
	     	}
        }
    });

    connect(notifier, &Solid::DeviceNotifier::deviceRemoved, [this](const QString &device) {
        getAllMountedInfo();
        emit refreshListView() ;
    });
}

StorageModel::~StorageModel()
{
	Solid::DeviceNotifier *notifier = Solid::DeviceNotifier::instance();

    disconnect(notifier, &Solid::DeviceNotifier::deviceAdded, 0, 0);
    disconnect(notifier, &Solid::DeviceNotifier::deviceRemoved, 0, 0);

	if (mTimer != nullptr)
	{
		if (mTimer->isActive()) {
			mTimer->stop();
		}
		delete mTimer;
	}
}

QString StorageModel::getStorageName() {
    return storage.name();
}

QString StorageModel::getStorageType() {
    return storage.fileSystemType();
}

double StorageModel::getStorageTotalSize() {
    // return storage.bytesTotal();
    return allTotalSize;
}

double StorageModel::getHomeTotalSize() {
    // return storage.bytesTotal();
    return homeTotalSize;
}

double StorageModel::getHomeAvailableSize() {

    return  homeFreeSize;
}

QAbstractItemModel *StorageModel::subPixelOptionsModel() const
{
    return m_subPixelOptionsModel;
}

double StorageModel::getStorageAvailableSize(){
    // QList<QStorageInfo> list = QStorageInfo::mountedVolumes();
    // for(int i = 0 ; i < list.size() ; i++ ){
    //     QStorageInfo diskInfo = list.at(i);
    //     if(diskInfo.displayName() == "/"){
    //         qint64 freeSize = diskInfo.bytesFree();
    //         qDebug() << "get New Storage AvailableSize :: " << freeSize;
    //         return freeSize;
    //     }
    // }
    // qDebug() << "getStorageAvailableSize" << storage.bytesAvailable();
    // return storage.bytesAvailable();
    return  allFreeSize;
}

void StorageModel:: getAllMountedInfo() {
    QStorageInfo storage = QStorageInfo::root();

    QList<QStorageInfo> list = QStorageInfo::mountedVolumes();
    m_subPixelOptionsModel->clear();

    int count = list.size();

    QString strInfo = "";
    for (int i = 0; i < count; ++i) {
        QStorageInfo diskInfo = list.at(i);
        qint64 freeSize = diskInfo.bytesFree();
        qint64 totalSize = diskInfo.bytesTotal();
        QString tempInfo = "";

        if (diskInfo.displayName().startsWith("/") && !diskInfo.displayName().startsWith("/media")) {
            QString tempInfo1 = QString("name:%1 totalSize:%2 freeSize:%3 \n")
            .arg(diskInfo.displayName())
            .arg(GetStorageSize(totalSize))
            .arg(GetStorageSize(freeSize));
        } else if (diskInfo.displayName() == "vendor" || diskInfo.displayName() == "productinfo") {

        } else {
            QString volumeName;
            if (diskInfo.rootPath().contains("/")) {
                volumeName = *(diskInfo.rootPath().split("/").end() - 1);
            } else {
                volumeName = "Unknown";
            }
            tempInfo = QString("%1, %2, %3, %4")
            .arg(volumeName)
            .arg(GetStorageSize(totalSize))
            .arg(GetStorageSize(totalSize - freeSize))
            .arg(GetFreeSizePrecent(freeSize, totalSize));
            strInfo.append(tempInfo);
            auto item = new QStandardItem(tempInfo);
            m_subPixelOptionsModel->appendRow(item);
        }
    }
}

QString StorageModel::GetFreeSizePrecent(qint64 freeSize, qint64 totalSize){
    float precent = (float)freeSize / (float)totalSize ;
    return  QString("%1").arg(precent); ;
}

QString StorageModel::GetStorageSize(qint64 size)
{
    if (size < 1024) {
        return QString("%1 B").arg(size);
    } else {
        size = size / 1024;
    }

    double tempSize = 1.0 * size;
    if (tempSize < 1024) {
        return QString("%1 KB").arg(tempSize);
    } else {
        tempSize = tempSize / 1024;
    }

    if (tempSize < 1024) {
        QString str3 = QString::number(tempSize,'f',1);
        return str3 + " MB";
    } else {
        tempSize = tempSize / 1024;
    }

    if (tempSize < 1024) {
        QString str4 = QString::number(tempSize,'f',1);
        return str4 + " GB";
    } else {
        tempSize = tempSize / 1024;
    }

    return "";
}

QString StorageModel::disk()
{
    QString m_diskDescribe = "";
    // QFileInfoList list = QDir::drives();
    // foreach (QFileInfo dir, list)
    // {
    //     QString dirName = dir.absolutePath();
    //     dirName.remove("/");
    //     LPCWSTR lpcwstrDriver = (LPCWSTR)dirName.utf16();
    //     ULARGE_INTEGER liFreeBytesAvailable, liTotalBytes, liTotalFreeBytes;
    //     if(GetDiskFreeSpaceEx(lpcwstrDriver, &liFreeBytesAvailable, &liTotalBytes, &liTotalFreeBytes) )
    //     {
    //         QString free = QString::number((double) liTotalFreeBytes.QuadPart / GB, 'f', 1);
    //         free += "G";
    //         QString all = QString::number((double) liTotalBytes.QuadPart / GB, 'f', 1);
    //         all += "G";

    //         QString str = QString("%1 %2/%3       ").arg(dirName, free, all);
    //         m_diskDescribe += str;

    //         double freeMem = (double) liTotalFreeBytes.QuadPart / GB;

    //         if(freeMem > m_maxFreeDisk)
    //             m_maxFreeDisk = freeMem;
    //     }
    // }

    QStorageInfo storage = QStorageInfo::root();
    QList<QStorageInfo> list = QStorageInfo::mountedVolumes();

    int count = list.size();
    QString strInfo = "";
    allFreeSize = 0;
    allTotalSize = 0;

    homeFreeSize = 0;
    homeTotalSize = 0;

    for (int i = 0; i < count; ++i) {
        QStorageInfo diskInfo = list.at(i);
        if (!diskInfo.rootPath().startsWith("/media") && !diskInfo.rootPath().startsWith("/home")) {
            qint64 freeSize = diskInfo.bytesFree();
            qint64 totalSize = diskInfo.bytesTotal();
            QString tempInfo = QString("name:%1 totalSize:%2 freeSize:%3 \n")
                .arg(diskInfo.displayName())
                .arg(GetStorageSize(totalSize))
                .arg(GetStorageSize(freeSize));
            strInfo.append(tempInfo);
                // continue ;
            allFreeSize += freeSize ;
            allTotalSize += totalSize;
        } else if (diskInfo.rootPath().startsWith("/home")) {
            homeFreeSize = diskInfo.bytesFree();
            homeTotalSize = diskInfo.bytesTotal();
        }
    }

    return m_diskDescribe;
}
