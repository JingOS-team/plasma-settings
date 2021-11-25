/*
    Copyright 2013 Jan Grulich <jgrulich@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "networkstatus.h"
// #include "uiutils.h"

#include <QDBusConnection>
#include <QDBusConnectionInterface>

#include <NetworkManagerQt/ActiveConnection>
#include <NetworkManagerQt/Connection>
#include <NetworkManagerQt/WirelessDevice>

#include <KLocalizedString>

NetworkStatus::SortedConnectionType NetworkStatus::connectionTypeToSortedType(NetworkManager::ConnectionSettings::ConnectionType type)
{
    switch (type) {
        case NetworkManager::ConnectionSettings::Adsl:
            return NetworkStatus::NetworkStatus::Adsl;
            break;
        case NetworkManager::ConnectionSettings::Bluetooth:
            return NetworkStatus::Bluetooth;
            break;
        case NetworkManager::ConnectionSettings::Cdma:
            return NetworkStatus::Cdma;
            break;
        case NetworkManager::ConnectionSettings::Gsm:
            return NetworkStatus::Gsm;
            break;
        case NetworkManager::ConnectionSettings::Infiniband:
            return NetworkStatus::Infiniband;
            break;
        case NetworkManager::ConnectionSettings::OLPCMesh:
            return NetworkStatus::OLPCMesh;
            break;
        case NetworkManager::ConnectionSettings::Pppoe:
            return NetworkStatus::Pppoe;
            break;
        case NetworkManager::ConnectionSettings::Vpn:
            return NetworkStatus::Vpn;
            break;
        case NetworkManager::ConnectionSettings::Wired:
            return NetworkStatus::Wired;
            break;
        case NetworkManager::ConnectionSettings::Wireless:
            return NetworkStatus::Wireless;
            break;
        case NetworkManager::ConnectionSettings::WireGuard:
            return NetworkStatus::Wireguard;
            break;
        default:
            return NetworkStatus::Other;
            break;
    }
}

NetworkStatus::NetworkStatus(QObject* parent)
    : QObject(parent)
    ,m_wirelessEnabled(NetworkManager::isWirelessEnabled())
{
    connect(NetworkManager::notifier(), &NetworkManager::Notifier::connectivityChanged, this,  &NetworkStatus::changeActiveConnections);
    connect(NetworkManager::notifier(), &NetworkManager::Notifier::statusChanged, this, &NetworkStatus::statusChanged);
    connect(NetworkManager::notifier(), &NetworkManager::Notifier::activeConnectionsChanged, this, QOverload<>::of(&NetworkStatus::activeConnectionsChanged));
    connect(NetworkManager::notifier(), &NetworkManager::Notifier::wirelessEnabledChanged, this, &NetworkStatus::onWirelessEnabled);

    activeConnectionsChanged();
    statusChanged(NetworkManager::status());
}

NetworkStatus::~NetworkStatus()
{
}

void NetworkStatus::onWirelessEnabled(bool enabled)
{
    m_wirelessEnabled = enabled;
    Q_EMIT wirelessEnabledChanged(enabled);
}

QString NetworkStatus::activeConnections() const
{
    return m_activeConnections;
}

QString NetworkStatus::networkStatus() const
{
    return m_networkStatus;
}

bool NetworkStatus::wirelessEnabled() const
{
    return m_wirelessEnabled;
}

QString NetworkStatus::connectedWifiName() const
{
    return m_connectedWifiName;
}

QString NetworkStatus::connectedVpnName() const
{
    return m_connectedVpnName;
}

void NetworkStatus::activeConnectionsChanged()
{
    for (const NetworkManager::ActiveConnection::Ptr & active : NetworkManager::activeConnections()) {
        connect(active.data(), &NetworkManager::ActiveConnection::default4Changed, this, &NetworkStatus::defaultChanged, Qt::UniqueConnection);
        connect(active.data(), &NetworkManager::ActiveConnection::default6Changed, this, &NetworkStatus::defaultChanged, Qt::UniqueConnection);
        connect(active.data(), &NetworkManager::ActiveConnection::stateChanged, this, &NetworkStatus::changeActiveConnections);
    }

    changeActiveConnections();
}

void NetworkStatus::defaultChanged()
{
    statusChanged(NetworkManager::status());
}

void NetworkStatus::statusChanged(NetworkManager::Status status)
{
    const auto oldNetworkStatus = m_networkStatus;
    switch (status) {
        case NetworkManager::ConnectedLinkLocal:
            m_networkStatus = "ConnectedLinkLocal"; 
            break;
        case NetworkManager::ConnectedSiteOnly:
            m_networkStatus = "ConnectedSiteOnly"; 
            break;
        case NetworkManager::Connected:
            m_networkStatus = "Connected"; 
            break;
        case NetworkManager::Asleep:
            m_networkStatus = "Asleep";
            break;
        case NetworkManager::Disconnected:
            m_networkStatus = "Disconnected";
            break;
        case NetworkManager::Disconnecting:
            m_networkStatus = "Disconnecting";
            break;
        case NetworkManager::Connecting:
            m_networkStatus = "Connecting";
            break;
        default:
            m_networkStatus = checkUnknownReason();
            break;
    }

    if (status == NetworkManager::ConnectedLinkLocal ||
        status == NetworkManager::ConnectedSiteOnly ||
        status == NetworkManager::Connected) {
        changeActiveConnections();
    } else if (m_activeConnections != m_networkStatus) {
        m_activeConnections = m_networkStatus;
        Q_EMIT activeConnectionsChanged(m_activeConnections);
    }

    if (oldNetworkStatus != m_networkStatus) {
        Q_EMIT networkStatusChanged(m_networkStatus);
    }
}

void NetworkStatus::changeActiveConnections()
{
    if (NetworkManager::status() != NetworkManager::Connected &&
        NetworkManager::status() != NetworkManager::ConnectedLinkLocal &&
        NetworkManager::status() != NetworkManager::ConnectedSiteOnly) {
        return;
    }

    QString activeConnections;
    const QString format = QStringLiteral("%1: %2");

    QList<NetworkManager::ActiveConnection::Ptr> activeConnectionList = NetworkManager::activeConnections();
    std::sort(activeConnectionList.begin(), activeConnectionList.end(), [] (const NetworkManager::ActiveConnection::Ptr &left, const NetworkManager::ActiveConnection::Ptr &right)
    {
        return NetworkStatus::connectionTypeToSortedType(left->type()) < NetworkStatus::connectionTypeToSortedType(right->type());
    });

    for (const NetworkManager::ActiveConnection::Ptr &active : activeConnectionList) {
        if (!active->devices().isEmpty()) {

            NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(active->devices().first());
            if (device && ((device->type() != NetworkManager::Device::Generic && device->type() <= NetworkManager::Device::Team)
                           || device->type() == 29)) {  // TODO: Change to WireGuard enum value when it is added
                bool connecting = false;
                bool connected = false;
                QString conType;
                QString status;
                NetworkManager::VpnConnection::Ptr vpnConnection;
                NetworkManager::Connection::Ptr connection = active->connection();

                if (active->vpn()) {
                    conType = i18n("VPN");
                    vpnConnection = active.objectCast<NetworkManager::VpnConnection>();
                    if(vpnConnection){
                        m_connectedVpnName = connection->name();
                        connect(vpnConnection.data(), &NetworkManager::VpnConnection::stateChanged, this, &NetworkStatus::onVpnConnectionStateChanged);
                        Q_EMIT connectedVpnNameChanged(m_connectedVpnName);
                    }
                } else {
                    // conType = UiUtils::interfaceTypeLabel(device->type(), device);
                    NetworkManager::WirelessDevice::Ptr wifiDev = device.objectCast<NetworkManager::WirelessDevice>();
                    if(wifiDev){
                        // NetworkManager::VpnConnection vpnConnection = active.objectCast<NetworkManager::VpnConnection>();
                        m_connectedWifiName = connection->name();
                        Q_EMIT connectedWifiNameChanged(m_connectedWifiName);
                    }
                }

                if (vpnConnection && active->vpn()) {
                    if (vpnConnection->state() >= NetworkManager::VpnConnection::Prepare &&
                        vpnConnection->state() <= NetworkManager::VpnConnection::GettingIpConfig) {
                        connecting = true;
                    } else if (vpnConnection->state() == NetworkManager::VpnConnection::Activated) {
                        connected = true;
                    }
                } else {
                    if (active->state() == NetworkManager::ActiveConnection::Activated) {
                        connected = true;
                    } else if (active->state() == NetworkManager::ActiveConnection::Activating) {
                        connecting = true;
                    }
                }

                if (active->type() == NetworkManager::ConnectionSettings::ConnectionType::WireGuard) {
                    conType = i18n("WireGuard");
                    connected = true;
                }

                // NetworkManager::Connection::Ptr connection = active->connection();
                // if(connection){
                //     connection->settings()->setting(NetworkManager::WirelessSetting);
                //     m_connectedWifiName = connection->name();
                //     Q_EMIT connectedWifiNameChanged(m_connectedWifiName);
                // }
                if (connecting) {
                    status = i18n("Connecting to %1", connection->name());
                } else if (connected) {
                    switch (NetworkManager::connectivity()) {
                        case NetworkManager::NoConnectivity:
                            status = i18n("Connected to %1 (no connectivity)", connection->name());
                            break;
                        case NetworkManager::Limited:
                            status = i18n("Connected to %1 (limited connectivity)", connection->name());
                            break;
                        case NetworkManager::Portal:
                            status = i18n("Connected to %1 (log in required)", connection->name());
                            break;
                        default:
                            status = i18n("Connected to %1", connection->name());
                            break;
                    }
                }

                if (!activeConnections.isEmpty()) {
                    activeConnections += '\n';
                }
                activeConnections += format.arg(conType, status);

                connect(connection.data(), &NetworkManager::Connection::updated, this, &NetworkStatus::changeActiveConnections, Qt::UniqueConnection);
            }
        }
    }

    if (m_activeConnections != activeConnections) {
        m_activeConnections = activeConnections;
        Q_EMIT activeConnectionsChanged(activeConnections);
    }
}

QString NetworkStatus::checkUnknownReason() const
{
    // Check if NetworkManager is running.
    if (!QDBusConnection::systemBus().interface()->isServiceRegistered(NM_DBUS_INTERFACE)) {
        return i18n("NetworkManager not running");
    }

    // Check for compatible NetworkManager version.
    if (NetworkManager::compareVersion(0, 9, 8) < 0) {
        return i18n("NetworkManager 0.9.8 required, found %1.", NetworkManager::version());
    }

    return i18nc("global connection state", "Unknown");
}

void NetworkStatus::onVpnConnectionStateChanged(NetworkManager::VpnConnection::State state, NetworkManager::VpnConnection::StateChangeReason reason)
{
    if (state == NetworkManager::VpnConnection::Failed | state == NetworkManager::VpnConnection::Disconnected) {
        m_connectedVpnName = "";
        Q_EMIT connectedVpnNameChanged(m_connectedVpnName);
    }
}