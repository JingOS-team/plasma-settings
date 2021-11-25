/*
 * SPDX-FileCopyrightText: (C) 2021 Wang Rui <wangrui@jingos.com>
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 */

#ifndef LISTIMAGEPROVIDER_H
#define LISTIMAGEPROVIDER_H
#include <QQuickImageProvider>
#include <QDebug>
#include <QMap>
#include <QImage>
#include <QObject>
#include <QFutureWatcher>
#include <kimagecache.h>

class ListImageProvider: public QQuickImageProvider
{
public:
    ListImageProvider(ImageType type, Flags flags = Flags()) :
        QQuickImageProvider(type, flags)
    {

      m_imageCache = new KImageCache(QStringLiteral("org.jingos.wallpaer"), 100*1024*1024);
      qDebug() << Q_FUNC_INFO << " test imageProvider:start:m_imageCache:" << m_imageCache;
    };

    ~ListImageProvider() {
        qDebug() << Q_FUNC_INFO << " test imageProvider:~~:m_imageCache:" << m_imageCache;
      if(watcher.isRunning()){
        watcher.cancel();
      }
      watcher.deleteLater();
      delete m_imageCache;
    }
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
    void loadCacheImage(QStringList systemWallpaperPaths);
public slots:
    void onFinished();
private:
  QMap<QString,QImage> m_wallpaperImageMap;
  KImageCache *m_imageCache;
  QFutureWatcher<int> watcher;
};

#endif // LISTIMAGEPROVIDER_H
