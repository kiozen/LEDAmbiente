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
#ifndef SRC_CPP_MODEL_DEVICES_HPP
#define SRC_CPP_MODEL_DEVICES_HPP

#include <QAbstractListModel>
#include <QElapsedTimer>
#include <QHostAddress>
#include <QHostInfo>
#include <QMap>
#include <QMutex>

class ModelDevice : public QAbstractListModel
{
    Q_OBJECT
public:
    ModelDevice(QObject* parent);
    virtual ~ModelDevice() = default;

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

private:
    void SlotUpdate();
    void SlotReceive();

    static constexpr quint16 PORT = 7755;

    enum Role
    {
        RoleDeviceName = Qt::UserRole + 1,
        RoleDeviceMac = Qt::UserRole + 2,
        RoleDeviceAddr = Qt::UserRole + 3,
    };

    class QTimer* timer_;
    class QUdpSocket* socket_;

    struct device_info_t
    {
        QString name;
        QHostAddress addr;
        QHostInfo host_info;
        QElapsedTimer last_seen;
    };

    QMap<QString, device_info_t> devices_;
    mutable QMutex mutex_ {QMutex::Recursive};
};

#endif // SRC_CPP_MODEL_DEVICES_HPP
