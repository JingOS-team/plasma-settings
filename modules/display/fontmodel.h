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

#ifndef FONT_MODEL_H
#define FONT_MODEL_H

#include <QObject>
#include <QAbstractItemModel>
#include <QStandardItemModel>
#include <QFont>
#include <sessionmanagement.h>

#include "fontssettings.h"

class FontsSettings;

class FontModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel *subPixelOptionsModel READ subPixelOptionsModel CONSTANT)
    Q_PROPERTY(FontsSettings *fontsSettings READ fontsSettings CONSTANT)
    
public:
    explicit FontModel();
    ~FontModel(){};

    FontsSettings *fontsSettings() const;

    void load();
    void save();
    Q_INVOKABLE int getFontSize();

    Q_INVOKABLE QString getFontFamily();

    Q_INVOKABLE void setSystemFont(QString family , int size);
    Q_INVOKABLE QFont getSystemFont();

    QAbstractItemModel *subPixelOptionsModel() const;

private:
    FontsSettings *m_settings;
    QStandardItemModel *m_subPixelOptionsModel;
    QFont currntFont;
    SessionManagement m_session;

};

#endif // FONT_MODEL_H
