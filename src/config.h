/*
 * SPDX-FileCopyrightText: 2020 Dimitris Kardarakos <dimkard@posteo.net>
 *                         2021 Wang Rui <wangrui@jingos.com>                          
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef SETTINGSCONFIG_H
#define SETTINGSCONFIG_H

#include <QObject>
#include <QVariantMap>

class SettingsConfig : public QObject
{
Q_OBJECT
    Q_PROPERTY(QString selectName READ selectName WRITE setSelectName NOTIFY selectNameChanged)

public:

    explicit SettingsConfig(QObject *parent = nullptr);
    ~SettingsConfig() override;
    void setSelectName(const QString name);
    QString selectName(){return m_selectName;};

Q_SIGNALS:
    void selectNameChanged(QString name);

private:
    QString m_selectName = "wifi";

};

#endif
