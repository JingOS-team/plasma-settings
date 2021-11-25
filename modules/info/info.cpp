/*
 * Copyright 2019  Jonah Brüchert <jbb@kaidan.im>
 *           2021  Wang Rui <wangrui@jingos.com>
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "info.h"
#include "updatetool.h"

#include <KAboutData>
#include <KLocalizedString>
#include <KPluginFactory>
#include <QClipboard>
#include <QGuiApplication>
#include <BluezQt/Adapter>
#include <KConfigGroup>
#include <KSharedConfig>
#include <QFile>
#include <cstring>
#include <QProcess>
#include <KAuth>
#include <QDebug>
#include <QDBusConnection>
#include <QDBusReply>
#include <QDBusInterface>
#include <QMap>
#include <QPair>

K_PLUGIN_CLASS_WITH_JSON(Info, "info.json")

using namespace std;

Info::Info(QObject *parent, const QVariantList &args)
    : KQuickAddons::ConfigModule(parent, args)
    , m_distroInfo(new DistroInfo(this))
    , m_softwareInfo(new SoftwareInfo(this))
    , m_hardwareInfo(new HardwareInfo(this))
{
    KLocalizedString::setApplicationDomain("kcm_mobile_info");
    KAboutData *about = new KAboutData("kcm_mobile_info", i18n("Info"), "1.0", QString(), KAboutLicense::LGPL);
    about->addAuthor(i18n("Jonah Brüchert"), QString(), "jbb@kaidan.im");
    setAboutData(about);
    setButtons(Apply | Default);

    int result = qmlRegisterType<UpdateTool>("org.jingos.info", 1, 0,  "UpdateTool");

    qDebug() << "Info module loaded." << result;
    m_manager = new BluezQt::Manager(this);
    initJob = m_manager->init();
    initJob->start();
    connect(initJob, &BluezQt::InitManagerJob::result, this, &Info::initJobResult);
}

Info::~Info()
{
    if (m_manager != nullptr)
    {
        qDebug()<<"-----------------------Info delete manager-----------------";
        // if(initJob != nullptr && initJob->isRunning()){
        //     initJob->kill();
        // }
        delete m_manager;
    }
}

void Info::copyInfoToClipboard() const
{
    const QString clipboardText = QStringLiteral(
                                      "Operating System: %1\n"
                                      "KDE Plasma Version: %2\n"
                                      "KDE Frameworks Version: %3\n"
                                      "Qt Version: %4\n"
                                      "Kernel Version: %5\n"
                                      "OS-Type: %6\n"
                                      "Processor: %7\n"
                                      "Memory: %8\n")
                                      .arg(distroInfo()->name(),
                                           softwareInfo()->plasmaVersion(),
                                           softwareInfo()->frameworksVersion(),
                                           softwareInfo()->qtVersion(),
                                           softwareInfo()->kernelRelease(),
                                           softwareInfo()->osType(),
                                           hardwareInfo()->processors(),
                                           hardwareInfo()->memory());

    qDebug()<< "CPU INFO:: "<< clipboardText;

    QGuiApplication::clipboard()->setText(clipboardText);
}

void Info::resetSystem()
{
    QVariantMap args;
    args["method"] = "factoryReset";
    KAuth::Action readAction("org.kde.factoryreset.manage");
    readAction.setHelperId("org.kde.factoryreset");
    readAction.setArguments(args);
    KAuth::ExecuteJob *job = readAction.execute();

    if (!job->exec()) {
        qWarning() << "kauth action failed" <<  job->errorString() << job->errorText()
                   << " error:" << job -> error();
    } else {
        qDebug() << " update file Success!";
        // QProcess::execute("reboot");
        m_session.requestReboot(SessionManagement::ConfirmationMode::Skip);
    }
}

DistroInfo *Info::distroInfo() const
{
    return m_distroInfo;
}

SoftwareInfo *Info::softwareInfo() const
{
    return m_softwareInfo;
}

HardwareInfo *Info::hardwareInfo() const
{
    return m_hardwareInfo;
}

void Info::initJobResult(BluezQt::InitManagerJob *job)
{
    if (job->error()) {
        qApp->exit(1);
        return;
    }
    BluezQt::AdapterPtr adaptor = m_manager->usableAdapter();
    if(!adaptor && m_manager->adapters().length() > 0){
        adaptor = m_manager->adapters().at(0);
    }
    if(adaptor){
        m_localDeviceName = adaptor->name();
        if(getLocalDeviceName().isEmpty()){
            setLocalDeviceName("JingPad");
        }else{
            if(getLocalDeviceName() != m_localDeviceName){
                setLocalDeviceName(m_localDeviceName);
                Q_EMIT localDeviceNameChanged(m_localDeviceName);
            }
        }
    }
}

QString Info::getLocalDeviceName()
{
    // BluezQt::AdapterPtr adaptor = m_manager->adapters().at(0);
    // if(adaptor){
    //    return adaptor->name();
    // }
    // return "";
    auto kdeglobals = KSharedConfig::openConfig("kdeglobals");
    KConfigGroup cfg(kdeglobals, "SystemInfo");
    return cfg.readEntry("deviceName", QString(""));
}

QString Info::getDeviceIMEI(){
    QDBusInterface interface("org.ofono", "/",
                             "org.ofono.Manager",
                             QDBusConnection::systemBus());

    QString kValue = "";
    if (interface.isValid()) {
       qDebug() << "getDeviceIMEI.............";
        QDBusMessage reply = interface.call("GetModems");

        qDebug()<< Q_FUNC_INFO << "got reply:" << reply;
        if (reply.type() == QDBusMessage::ReplyMessage) {
            const auto &argument = reply.arguments().at(0).value<QDBusArgument>();

            QDBusObjectPath path;
            QString key;
            QVariant value;

            argument.beginArray();
            while ( !argument.atEnd() ) {
                argument.beginStructure();
                argument >> path;
                qDebug() << path.path();
                argument.beginMap();

                while ( !argument.atEnd() ) {
                    argument.beginMapEntry();
                    argument >> key >> value;
                    if (key == "Serial") {
                        kValue = value.toString();
                    return kValue;
                    }
                    argument.endMapEntry();
                }

                argument.endMap();

                argument.endStructure();
            }
            argument.endArray();

            qDebug() << "getFullTime reply valid";
        } else {
            qDebug() << "getFullTime method called failed!";
        }
    }
    return kValue ;
}

QString Info::getLocalDeviceAdress()
{
    BluezQt::AdapterPtr adaptor = m_manager->adapters().at(0);
    if(adaptor){
       return adaptor->address();
    }
    return "";
}

void Info::setLocalDeviceName(const QString localName)
{

    qDebug() << "设置设备名称--》" << localName;
    BluezQt::AdapterPtr adaptor = m_manager->adapters().at(0);
    adaptor->setName(localName);
    m_localDeviceName = localName;
    Q_EMIT localDeviceNameChanged(m_localDeviceName);
    qDebug() << "设置设备名称--》OK";

    auto kdeglobals = KSharedConfig::openConfig("kdeglobals");
    KConfigGroup cfg(kdeglobals, "SystemInfo");
    cfg.writeEntry("deviceName", localName);
    kdeglobals->sync();
}
#include "info.moc"
