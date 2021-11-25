/**
 * SPDX-FileCopyrightText: 2020 Tobias Fella <fella@posteo.de>
 *                         2021 Wang Rui <wangrui@jingos.com>
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */
#include "display.h"

#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusPendingCallWatcher>
#include <QDBusPendingReply>

#include <KAboutData>
#include <KLocalizedString>
#include <KPluginFactory>

#include "displaymodel.h"
#include "fontmodel.h"
#include "fontssettings.h"
#include <QProcess>
#include <QFile>
#include <QTextStream>

#include <unistd.h>

K_PLUGIN_CLASS_WITH_JSON(Display, "metadata.json")

Display::Display(QObject *parent, const QVariantList &args)
    : KQuickAddons::ConfigModule(parent, args)
{
    qmlRegisterType<DisplayModel>("display", 1, 0, "DisplayModel");
    qmlRegisterType<FontModel>("jingos.font", 1, 0, "FontModel");
    qmlRegisterType<FontsSettings>();

    // KLocalizedString::setApplicationDomain("kcm_display");
    KAboutData *about = new KAboutData("kcm_display", i18n("Display"), "1.0", QString(), KAboutLicense::GPL);
    about->addAuthor(i18n("Tobias Fella"), QString(), "fella@posteo.de");
    setAboutData(about);
    setButtons(KQuickAddons::ConfigModule::NoAdditionalButton);
}

void Display::restartDevice()
{
    qDebug() << " restartDevice:::";
    //   QProcess::execute("reboot");
     m_session.requestReboot(SessionManagement::ConfirmationMode::Skip);
}

bool Display::touchDoubleOn()
{
    bool isOn = false;
    QFile file("/sys/touchscreen/gesture");
    if (file.open(QIODevice::ReadWrite))
    {
       QString gestureContent = QString(file.readAll());
       qDebug()<<" gestureContent:::" << gestureContent;
       isOn = gestureContent == touchDoubleOnString;
    }
    file.close();
    m_isOn = isOn;
    return isOn;
}
void Display::setTouchDoubleOn(bool touchDoubleOn)
{
    qDebug()<<" touchDoubleOn:::" << touchDoubleOn << " m_isOn:" << m_isOn;
    if (touchDoubleOn == m_isOn) {
        return;
    }
    int value = touchDoubleOn ? 1 : 0;
    QFile file("/sys/touchscreen/gesture");
    if (file.open(QIODevice::ReadWrite  | QFile::Truncate))
    {
       QTextStream out(&file);
       out << value;
       qDebug()<<" set content:::" << value;
    }
    file.close();
    emit touchDoubleOnChanged();
}

#include "display.moc"