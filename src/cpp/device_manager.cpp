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
    animations_ = new ModelAnimations(this);
    colors_ = new ModelColors(*this);

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
    system_.initialName = name;
    system_.name.clear();
    socket_->connectToHost(ip, 7756);
}

Q_INVOKABLE void DeviceManager::disconnectFromDevice()
{
    qDebug() << "disconnectFromDevice";
    socket_->disconnectFromHost();
}


void DeviceManager::slotConnected()
{
    // the order of the requests matters
    requestSystenConfig();
    requestColor();
    requestPredefinedColors();
    requestPower();
    // request list of animations befor
    // requesting the current animation
    // or alarm
    requestAnimations();
    requestAnimation();
    requestAlarm();
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

        const QString& rsp = msg["rsp"].toString();

        if(rsp == "get_color")
        {
            quint8 red = msg["red"].toInt();
            quint8 green = msg["green"].toInt();
            quint8 blue = msg["blue"].toInt();
            light_.color = QColor(red, green, blue);
            emit lightChanged();
        }
        else if(rsp == "get_power")
        {
            light_.power = msg["light"].toBool();
            emit lightChanged();
            animation_.power = msg["animation"].toBool();
            emit animationChanged();
        }
        else if(rsp == "get_alarm")
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

            alarm_.animationHash = msg["animation_hash"].toString();

            emit alarmChanged();
        }
        else if(rsp == "get_animation")
        {
            animation_.hash = msg.value("hash").toString();
            animations_->setCurrentAnimation(animation_.hash);
            emit animationChanged();
        }
        else if(rsp == "get_animations")
        {
            animations_->update(msg["animations"].toArray());
        }
        else if(rsp == "get_system_config")
        {
            const QString& name = msg["name"].toString();
            if(!name.isEmpty())
            {
                system_.name = name;
            }
            system_.led_count = msg["led_count"].toInt();
            system_.max_brightness = msg["max_brightness"].toInt();
            emit systemChanged();
        }
        else if(rsp == "get_predefined_colors")
        {
            QVector<QColor> colors;
            for(const QJsonValue& color : msg["colors"].toArray())
            {
                colors << QColor(color.toVariant().toUInt()).toHsv();
            }
            colors_->SetColors(colors);
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

void DeviceManager::requestSystenConfig()
{
    QJsonObject msg = {
        {"cmd", "get_system_config"},
    };

    sendJson(msg);
}

void DeviceManager::requestColor()
{
    QJsonObject msg = {
        {"cmd", "get_color"},
    };

    sendJson(msg);
}

void DeviceManager::requestPredefinedColors()
{
    QJsonObject msg = {
        {"cmd", "get_predefined_colors"},
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

void DeviceManager::requestAnimation()
{
    QJsonObject msg = {
        {"cmd", "get_animation"},
    };

    sendJson(msg);
}

void DeviceManager::requestAnimations()
{
    QJsonObject msg = {
        {"cmd", "get_animations"},
    };

    sendJson(msg);
}

void DeviceManager::setLight(const light_t& light)
{
    QJsonObject msg = {
        {"cmd", "set_color"},
        {"blue", light.color.blue()},
        {"red", light.color.red()},
        {"green", light.color.green()},
    };
    sendJson(msg);


    if(light.power != light_.power)
    {
        QJsonObject msg = {
            {"cmd", "set_power_light"},
            {"power", light.power}
        };
        sendJson(msg);
    }

    light_ = light;
}

void DeviceManager::setAnimation(const animation_t& animation)
{
    QJsonObject msg = {
        {"cmd", "set_animation"},
        {"hash", animation.hash}
    };
    sendJson(msg);


    if(animation.power != animation_.power)
    {
        QJsonObject msg = {
            {"cmd", "set_power_animation"},
            {"power", animation.power}
        };
        sendJson(msg);
    }

    animation_ = animation;
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
    msg["animation_hash"] = alarm_.animationHash;

    sendJson(msg);
    emit alarmChanged();
}

void DeviceManager::setSystem(const system_t& system)
{
    if(system_.name != system.name)
    {
        system_.name = system.name;
        emit nameChanged();
    }

    system_ = system;

    QJsonObject msg = {
        {"cmd", "set_system_config"},
    };

    msg["name"] = system_.name;
    msg["led_count"] = system_.led_count;
    msg["max_brightness"] = system_.max_brightness;

    sendJson(msg);
    emit systemChanged();
}

void DeviceManager::setAnimation(const QString& hash)
{
    QJsonObject msg = {
        {"cmd", "set_animation"},
    };

    msg["hash"] = hash;

    sendJson(msg);
}

void DeviceManager::setPredefinedColors(const QVector<QColor>& predefined)
{
    QJsonObject msg = {
        {"cmd", "set_predefined_colors"},
    };

    QJsonArray json;
    for(const QColor& color : predefined)
    {
        json.append(QJsonValue::fromVariant(color.rgba()));
    }
    msg["colors"] = json;
    sendJson(msg);
}
