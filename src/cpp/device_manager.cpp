#include "device_manager.hpp"

#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMessageBox>
#include <QTcpSocket>

DeviceManager::DeviceManager(QObject* parent)
    : QObject(parent)
{
    socket_ = new QTcpSocket(this);
    socket_->setSocketOption(QAbstractSocket::LowDelayOption, 1);
    connect(socket_, &QTcpSocket::connected, this, &DeviceManager::slotConnected);
    connect(socket_, &QTcpSocket::disconnected, this, &DeviceManager::slotDisconnected);
    connect(socket_, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::errorOccurred), this, &DeviceManager::slotError);
    connect(socket_, &QTcpSocket::readyRead, this, &DeviceManager::slotReadyRead);

    connect(socket_, &QTcpSocket::stateChanged, [this](const QAbstractSocket::SocketState& socketState){
        qDebug() << socketState;
    });
}

Q_INVOKABLE void DeviceManager::connectToDevice(const QString& ip, const QString& name)
{
    qDebug() << "connectToDevice" << ip << name;
    name_ = name;
    socket_->connectToHost(ip, 7756);
}

Q_INVOKABLE void DeviceManager::disconnectFromDevice()
{
    qDebug() << "disconnectFromDevice";
    socket_->disconnectFromHost();
}

void DeviceManager::slotConnected()
{
    requestColor();
    connected_ = true;
    emit connectedChanged();
}

void DeviceManager::slotDisconnected()
{
    color_ = QColor();
    connected_ = false;
    emit connectedChanged();
}

void DeviceManager::slotError(const QAbstractSocket::SocketError& socketError)
{
    qDebug() << socketError;
}

void DeviceManager::slotReadyRead()
{
    const QByteArray& data = socket_->readLine();
    const QJsonObject& msg = QJsonDocument::fromJson(data).object();
    qDebug() << "recv:" << msg;

    if(msg["rsp"] == "get_color")
    {
        quint8 red = msg["red"].toInt();
        quint8 green = msg["green"].toInt();
        quint8 blue = msg["blue"].toInt();
        color_ = QColor(red, green, blue);
        emit colorChanged();

        power_ = msg["power"].toBool();
        emit powerChanged();
    }
    else if(msg["rsp"] == "get_name")
    {
        name_ = msg["name"].toString();
        emit nameChanged();
    }
}

void DeviceManager::sendJson(const QJsonObject& msg)
{
    qDebug() << "send:" << msg;

    const QByteArray& data = QJsonDocument(msg).toJson(QJsonDocument::Compact) + '\n';
    if(socket_->write(data) < 0)
    {
        qDebug() << "Failed to send command" << msg["cmd"] << "." << socket_->errorString();
    }
}

void DeviceManager::setColor(const QColor& color)
{
    if(!color_.isValid())
    {
        return;
    }

    color_ = color;
    QJsonObject msg = {
        {"cmd", "set_color"},
    };
    msg["blue"] = color_.blue();
    msg["red"] = color_.red();
    msg["green"] = color_.green();

    sendJson(msg);
}

void DeviceManager::setPower(bool on)
{
    power_ = on;
    QJsonObject msg = {
        {"cmd", "set_power"},
    };
    msg["power"] = power_;
    sendJson(msg);
}

void DeviceManager::requestColor()
{
    QJsonObject msg = {
        {"cmd", "get_color"},
    };

    sendJson(msg);
}

