#include "device_manager.hpp"

#include <QDebug>
#include <QJsonArray>
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
    requestAlarm();
    requestPower();
    connected_ = true;
    emit connectedChanged();
}

void DeviceManager::slotDisconnected()
{
    light_.color = QColor();
    connected_ = false;
    emit connectedChanged();
}

void DeviceManager::slotError(const QAbstractSocket::SocketError& socketError)
{
    qDebug() << socketError;
}

void DeviceManager::slotReadyRead()
{
    while(socket_->bytesAvailable())
    {
        const QByteArray& data = socket_->readLine();
        const QJsonObject& msg = QJsonDocument::fromJson(data).object();
        qDebug() << "recv:" << msg;

        if(msg["rsp"] == "get_color")
        {
            quint8 red = msg["red"].toInt();
            quint8 green = msg["green"].toInt();
            quint8 blue = msg["blue"].toInt();
            light_.color = QColor(red, green, blue);
            emit colorChanged();
        }
        else if(msg["rsp"] == "get_power")
        {
            light_.power = msg["power"].toBool();
            emit powerChanged();
        }
        else if(msg["rsp"] == "get_name")
        {
            name_ = msg["name"].toString();
            emit nameChanged();
        }
        else if(msg["rsp"] == "get_alarm")
        {
            alarm_.name = msg["name"].toString();
            alarm_.active = msg["active"].toBool();
            alarm_.hour = msg["hour"].toInt();
            alarm_.minute = msg["minute"].toInt();

            QSet<int> days;
            for(const QJsonValue& day : msg["days"].toArray())
            {
                days.insert(day.toInt());
            }

            alarm_.mon = days.contains(mon);
            alarm_.tue = days.contains(tue);
            alarm_.wed = days.contains(wed);
            alarm_.thu = days.contains(thu);
            alarm_.fri = days.contains(fri);
            alarm_.sat = days.contains(sat);
            alarm_.sun = days.contains(sun);

            emit alarmChanged();
        }
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
    if(!light_.color.isValid())
    {
        return;
    }

    light_.color = color;
    QJsonObject msg = {
        {"cmd", "set_color"},
    };
    msg["blue"] = light_.color.blue();
    msg["red"] = light_.color.red();
    msg["green"] = light_.color.green();

    sendJson(msg);
}

void DeviceManager::setPower(bool on)
{
    light_.power = on;
    QJsonObject msg = {
        {"cmd", "set_power"},
    };
    msg["power"] = light_.power;
    sendJson(msg);
}

void DeviceManager::requestColor()
{
    QJsonObject msg = {
        {"cmd", "get_color"},
    };

    sendJson(msg);
}

void DeviceManager::requestAlarm()
{
    QJsonObject msg = {
        {"cmd", "get_alarm"},
    };

    sendJson(msg);
}

void DeviceManager::requestPower()
{
    QJsonObject msg = {
        {"cmd", "get_power"},
    };

    sendJson(msg);
}

void DeviceManager::setAlarm(const alarm_t& alarm)
{
    alarm_ = alarm;

    QJsonObject msg = {
        {"cmd", "set_alarm"},
    };
    msg["name"] = alarm_.name;
    msg["active"] = alarm_.active;
    msg["hour"] = alarm_.hour;
    msg["minute"] = alarm_.minute;

    QJsonArray days;
    if(alarm_.mon)
    {
        days.append(mon);
    }
    if(alarm_.tue)
    {
        days.append(tue);
    }
    if(alarm_.wed)
    {
        days.append(wed);
    }
    if(alarm_.thu)
    {
        days.append(thu);
    }
    if(alarm_.fri)
    {
        days.append(fri);
    }
    if(alarm_.sat)
    {
        days.append(sat);
    }
    if(alarm_.sun)
    {
        days.append(sun);
    }

    msg["days"] = days;

    sendJson(msg);
}

