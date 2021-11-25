/*
 * Copyright 2020 Devin Lin <espidev@gmail.com>
 *                Han Young <hanyoung@protonmail.com>
 *                Wang Rui <wangrui@jingos.com>
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



#ifndef STORAGE_MODEL_H
#define STORAGE_MODEL_H

#include <QObject>
#include <QStorageInfo>
#include <QObject>
#include <QAbstractItemModel>
#include <QStandardItemModel>
#include <QTimer>

class StorageModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel *subPixelOptionsModel READ subPixelOptionsModel CONSTANT)
   
    
public:
    explicit StorageModel();
    ~StorageModel();

    Q_INVOKABLE QString getStorageName();
    Q_INVOKABLE QString getStorageType();
    Q_INVOKABLE double getStorageTotalSize();
    Q_INVOKABLE double getStorageAvailableSize();  
    Q_INVOKABLE double getHomeTotalSize();
    Q_INVOKABLE double getHomeAvailableSize();  
    Q_INVOKABLE void getAllMountedInfo();
    QString GetStorageSize(qint64 size);
    QString GetFreeSizePrecent(qint64 freeSize ,qint64 totalSize);

    QAbstractItemModel *subPixelOptionsModel() const;
    QString disk();

signals: 
    void refreshListView();
private:
    QStorageInfo storage = QStorageInfo::root();  
    QStandardItemModel *m_subPixelOptionsModel;
    QTimer *mTimer;
    qint64 allFreeSize ;
    qint64 allTotalSize ;
    qint64 homeFreeSize ;
    qint64 homeTotalSize ;
};

#endif // STORAGE_MODEL_H

