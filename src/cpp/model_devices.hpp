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
