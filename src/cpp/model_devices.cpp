/**********************************************************************************************
    Copyright (C) 2022 Oliver Eichler <oliver.eichler@gmx.de>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

**********************************************************************************************/
#include "model_devices.hpp"

#include <arpa/inet.h>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkDatagram>
#include <QTimer>
#include <QUdpSocket>


constexpr int UPDATE_DEVICES = 1000;
constexpr int EXPIRE_DEVICES = 3000;

ModelDevice::ModelDevice(QObject* parent)
    : QAbstractListModel(parent)
{
    timer_ = new QTimer(this);
    timer_->setInterval(UPDATE_DEVICES);
    timer_->setSingleShot(false);
    connect(timer_, &QTimer::timeout, this, &ModelDevice::SlotUpdate);
    timer_->start();

    socket_ = new QUdpSocket(this);
    socket_->bind(QHostAddress("172.16.1.38"), PORT);
    connect(socket_, &QUdpSocket::readyRead, this, &ModelDevice::SlotReceive);
}

QHash<int, QByteArray> ModelDevice::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[RoleDeviceName] = "deviceName";
    roles[RoleDeviceMac] = "deviceMac";
    roles[RoleDeviceAddr] = "deviceAddr";

    return roles;
}

int ModelDevice::rowCount(const QModelIndex& parent) const
{
    return devices_.count();
}

QVariant ModelDevice::data(const QModelIndex& index, int role) const
{
    QMutexLocker lock(&mutex_);

    QVariant value;

    int i = index.row();

    if(i >= devices_.size())
    {
        return value;
    }

    QString key = devices_.keys().at(i);
    const device_info_t& device = devices_.value(key);

    switch(role)
    {
    case Role::RoleDeviceName:
        value = !device.name.isEmpty() ? device.name : !device.host_info.hostName().isEmpty() ? device.host_info.hostName() : tr("Unknown");
        break;

    case Role::RoleDeviceMac:
        value = key;
        break;

    case Role::RoleDeviceAddr:
        value = device.addr.toString();
        break;
    }

    return value;
}

void ModelDevice::SlotUpdate()
{
    QMutexLocker lock(&mutex_);
    QMap<QString, device_info_t> updated_devices;
    for(const QString& key : devices_.keys())
    {
        const device_info_t& info = devices_.value(key);
        if(info.last_seen.elapsed() < EXPIRE_DEVICES)
        {
            updated_devices[key] = info;
        }
    }
    if(updated_devices.keys() != devices_.keys())
    {
        beginResetModel();
        devices_.swap(updated_devices);
        endResetModel();
    }

    QJsonObject msg = {
        {"cmd", "identify"}
    };

    if(socket_->writeDatagram(QJsonDocument(msg).toJson(QJsonDocument::Compact), QHostAddress::Broadcast, PORT) < 0)
    {
        qDebug() << "Failed to send identify request." << socket_->errorString();
    }
}

void ModelDevice::SlotReceive()
{
    const QNetworkDatagram& datagram = socket_->receiveDatagram();
    const QJsonObject& msg = QJsonDocument::fromJson(datagram.data()).object();

    if(msg["rsp"] != "identify")
    {
        return;
    }

    QMutexLocker lock(&mutex_);

    const QString& mac = msg["mac"].toString();

    if(!devices_.contains(mac))
    {
        device_info_t info;
        info.name = msg["name"].toString();
        info.addr = datagram.senderAddress();
        info.last_seen.start();

        QHostInfo::lookupHost(info.addr.toString(), [this, mac](const QHostInfo& info){
            if(devices_.contains(mac))
            {
                beginResetModel();
                devices_[mac].host_info = info;
                endResetModel();
            }
        });

        beginResetModel();
        devices_[mac] = info;
        endResetModel();
    }
    else
    {
        const QString& name = msg["name"].toString();
        device_info_t& info = devices_[mac];
        if(info.name != name)
        {
            beginResetModel();
            info.name = name;
            endResetModel();
        }
        info.last_seen.restart();
    }
}
