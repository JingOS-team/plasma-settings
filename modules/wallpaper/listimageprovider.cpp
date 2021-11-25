#include "listimageprovider.h"
#include <QThreadPool>
#include <QtConcurrent/QtConcurrent>

QImage ListImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    QStringList idAll = id.split("*");
    QString imagePath = idAll[0];
    // QImage preview = m_wallpaperImageMap.value(imagePath);
    if(imagePath.startsWith("file://")){
        imagePath = imagePath.mid(7);
    }
    QImage preview;
    bool isContains = m_imageCache-> findImage(imagePath,&preview);
    qDebug()<<" requestImage:::: idall::" <<idAll << " preview is cached"<<isContains;
    if (isContains) {
        return preview;
    } else {
        preview.load(imagePath);
        QImage scaledImage = preview.scaled(500,500,Qt::KeepAspectRatio,Qt::SmoothTransformation);
            // // m_wallpaperImageMap.insert(imagePath,scaledImage);
        return scaledImage;
    }
    return {};
}

void ListImageProvider::onFinished()
{

}

// static int threadLoadImage(QStringList systemWallpaperPaths,KImageCache *m_imageCache)
static int threadLoadImage(QStringList systemWallpaperPaths)
{
    qDebug()<< ":::::::::: future start::systemWallpaper:" << systemWallpaperPaths;
    KImageCache  *m_imageCache = new KImageCache(QStringLiteral("org.jingos.wallpaer"), 100*1024*1024);
    for(int i = 0; i < systemWallpaperPaths.count();i++){
            QString imagePath = systemWallpaperPaths[i];
            QImage newImagePreview;
            if(!m_imageCache){
                return 0;
            }
            bool isContains = m_imageCache->findImage(imagePath,&newImagePreview);
            if(!isContains) {
                newImagePreview.load(imagePath);
                QImage scaledImage = newImagePreview.scaled(500,500,Qt::KeepAspectRatio,Qt::SmoothTransformation);
                if(!m_imageCache){
                return 0;
                }
                m_imageCache-> insertImage(imagePath,scaledImage);
            }
        }
    return 0;
}

void ListImageProvider::loadCacheImage(QStringList systemWallpaperPaths)
{
    watcher.setFuture(QtConcurrent::run(QThreadPool::globalInstance(), &threadLoadImage,systemWallpaperPaths));

}

