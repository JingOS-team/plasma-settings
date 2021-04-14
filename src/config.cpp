/*
 * SPDX-FileCopyrightText: 2020 Dimitris Kardarakos <dimkard@posteo.net>
 *                         2021 Wang Rui <wangrui@jingos.com>                          
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "config.h"
#include <KLocalizedString>
#include <KConfig>
#include <KConfigGroup>
#include <QDebug>
#include <QRegExp>
#include <QDir>
#include <QUrl>


SettingsConfig::SettingsConfig(QObject *parent)
    : QObject(parent)
    , m_selectName("wifi")
{

}

SettingsConfig::~SettingsConfig()
{
  
}
void SettingsConfig::setSelectName(const QString name)
{
    m_selectName = name;
    Q_EMIT selectNameChanged(name);
}







