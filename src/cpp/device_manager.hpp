#ifndef SRC_CPP_DEVICE_MANAGER_HPP
#define SRC_CPP_DEVICE_MANAGER_HPP

#include <QAbstractSocket>
#include <QObject>

class DeviceManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
public:
    DeviceManager(QObject* parent);
    virtual ~DeviceManager() = default;

    Q_INVOKABLE void connectToDevice(const QString& ip);
    Q_INVOKABLE void disconnectFromDevice();

    bool connected() const {return connected_;}

signals:
    void connectedChanged();

private slots:
    void slotConnected();
    void slotDisconnected();
    void slotError(const QAbstractSocket::SocketError& socketError);

private:
    class QTcpSocket* socket_;
    QString ip_;
    bool connected_;
};

#endif // SRC_CPP_DEVICE_MANAGER_HPP
