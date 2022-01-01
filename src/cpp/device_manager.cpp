#include "device_manager.hpp"

#include <QDebug>
#include <QMessageBox>
#include <QTcpSocket>

DeviceManager::DeviceManager(QObject* parent)
    : QObject(parent)
{
    socket_ = new QTcpSocket(this);
    connect(socket_, &QTcpSocket::connected, this, &DeviceManager::slotConnected);
    connect(socket_, &QTcpSocket::disconnected, this, &DeviceManager::slotDisconnected);
    connect(socket_, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::errorOccurred), this, &DeviceManager::slotError);
}

Q_INVOKABLE void DeviceManager::connectToDevice(const QString& ip)
{
    qDebug() << "connectToDevice" << ip;
    socket_->connectToHost(ip, 7756);
}

Q_INVOKABLE void DeviceManager::disconnectFromDevice()
{
    socket_->disconnectFromHost();
}

void DeviceManager::slotConnected()
{
    connected_ = true;
    emit connectedChanged();
}

void DeviceManager::slotDisconnected()
{
    connected_ = false;
    emit connectedChanged();
}

void DeviceManager::slotError(const QAbstractSocket::SocketError& socketError)
{
    qDebug() << socketError;
}
