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
#include <QDebug>
#include <QFontDatabase>
#include <KGlobalSettings>
#include <KConfigGroup>
#include <KConfig>
#include <QProcess>

#include "fontmodel.h"
#include "fontssettings.h"


FontModel::FontModel()
    : m_subPixelOptionsModel(new QStandardItemModel(this))
    , m_settings(new FontsSettings(this))
{
    QFontDatabase database;  
    foreach (const QString &family, database.families())  
    {  
        auto item = new QStandardItem(family);
        m_subPixelOptionsModel->appendRow(item);
    } 
    load() ; 
}

QAbstractItemModel *FontModel::subPixelOptionsModel() const
{
    return m_subPixelOptionsModel;
}

void FontModel::load()
{
    currntFont = fontsSettings()->font();
}

FontsSettings *FontModel::fontsSettings() const
{
    return m_settings;
}

void FontModel::setSystemFont(QString family , int size)
{
    QFont font = QFont() ; 
    font.setFamily(family);
    font.setPixelSize(size);
    fontsSettings()->setFont(font);

    save();
}

void FontModel::save()
{
    fontsSettings()->save();
    KGlobalSettings::self()->emitChange(KGlobalSettings::FontChanged);
    // QProcess::execute("reboot");
     m_session.requestReboot(SessionManagement::ConfirmationMode::Skip);
}

QFont FontModel::getSystemFont()
{
    QFont font;
    return font;
}

int FontModel::getFontSize()
{
    return currntFont.pixelSize();
}


QString FontModel::getFontFamily()
{
    return currntFont.family();
}