#ifndef SRC_CPP_DEVICE_MANAGER_HPP
#define SRC_CPP_DEVICE_MANAGER_HPP

#include <QAbstractSocket>
#include <QColor>
#include <QDebug>
#include <QObject>

class DeviceManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(bool power READ power WRITE setPower NOTIFY powerChanged)
public:
    DeviceManager(QObject* parent);
    virtual ~DeviceManager() = default;

    Q_INVOKABLE void connectToDevice(const QString& ip, const QString& name);
    Q_INVOKABLE void disconnectFromDevice();

    bool connected() const {return connected_;}

    QColor color() const {return color_;}
    void setColor(const QColor& color);

    QString name() const {return name_;}

    bool power() const {return power_;}
    void setPower(bool on);

signals:
    void connectedChanged();
    void colorChanged();
    void nameChanged();
    void powerChanged();

private slots:
    void slotConnected();
    void slotDisconnected();
    void slotError(const QAbstractSocket::SocketError& socketError);
    void slotReadyRead();

private:
    void requestColor();

    void sendJson(const QJsonObject& msg);

    class QTcpSocket* socket_;
    QString ip_;
    bool connected_;
    QColor color_;
    QString name_;
    bool power_;
};

#endif // SRC_CPP_DEVICE_MANAGER_HPP
