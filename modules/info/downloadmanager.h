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

#ifndef DOWNLOAD_MANAGER_H
#define DOWNLOAD_MANAGER_H

#include <QObject>

class DownLoadManager : public QObject{

    Q_OBJECT

public : 
    // 设置是否支持断点续传;
    void setDownInto(bool isSupportBreakPoint);

    // 获取当前下载链接;
    QString getDownloadUrl();

    // 开始下载文件，传入下载链接和文件的路径;
    void downloadFile(QString url , QString fileName);

    // 下载进度信息;
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);

    // 获取下载内容，保存到文件中;
    void onReadyRead();

    // 下载完成;
    void onFinished();

    // 下载过程中出现错误，关闭下载，并上报错误，这里未上报错误类型，可自己定义进行上报;
    void onError(QNetworkReply::NetworkError code);

    // 停止下载工作;
    void stopWork();

    // 暂停下载按钮被按下,暂停当前下载;
    void stopDownload();

    // 重置参数;
    void reset();

    // 删除文件;
    void removeFile(QString fileName);

    // 停止下载按钮被按下，关闭下载，重置参数，并删除下载的临时文件;
    void closeDownload();

}

#endif

