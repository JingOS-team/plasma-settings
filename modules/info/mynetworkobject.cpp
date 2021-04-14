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

#include "mynetworkobject.h"

MyNetworkObject::MyNetworkObject(QObject *parent) : QObject(parent) {
    networkAccessManager = new QNetworkAccessManager(this);
    dataStr="";
    QObject::connect(networkAccessManager, SIGNAL(finished(QNetworkReply *)), this, SLOT(finishedSlot(QNetworkReply *)));
}

void MyNetworkObject::get(QUrl url) {
    QNetworkRequest request = QNetworkRequest(url);
    request.setHeader(QNetworkRequest::UserAgentHeader, \
                      QVariant("Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.76 Mobile Safari/537.36"));
    networkAccessManager->get(request);
}

void MyNetworkObject::finishedSlot(QNetworkReply *reply) {
    printAttribute(reply, QNetworkRequest::HttpStatusCodeAttribute, "HttpStatusCodeAttribute");
    printAttribute(reply, QNetworkRequest::HttpReasonPhraseAttribute, "HttpReasonPhraseAttribute");

    if(reply->error() == QNetworkReply::NoError) {
        QByteArray buffer = reply->readAll();
        dataStr = QString::fromUtf8(buffer);
        emit requestSuccessSignal(dataStr);
    } else {
        emit requestFailSignal(reply->errorString());
    }
    reply->deleteLater();
}

void MyNetworkObject::printAttribute(QNetworkReply *reply, QNetworkRequest::Attribute code, QString codeStr) {
    QVariant attributeVarient = reply->attribute(code);
    QString result = QString("%1 = %2").arg(codeStr).arg(attributeVarient.toString());
}

