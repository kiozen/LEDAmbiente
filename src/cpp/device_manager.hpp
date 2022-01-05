#ifndef SRC_CPP_DEVICE_MANAGER_HPP
#define SRC_CPP_DEVICE_MANAGER_HPP

#include <QAbstractSocket>
#include <QColor>
#include <QDebug>
#include <QObject>
#include <QTime>

struct alarm_t
{
    Q_GADGET
public:
    QString name;
    bool active {false};
    qint32 hour {-1};
    qint32 minute {-1};
    bool mon {false};
    bool tue {false};
    bool wed {false};
    bool thu {false};
    bool fri {false};
    bool sat {false};
    bool sun {false};
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(bool active MEMBER active)
    Q_PROPERTY(qint32 hour MEMBER hour)
    Q_PROPERTY(qint32 minute MEMBER minute)
    Q_PROPERTY(bool mon MEMBER mon)
    Q_PROPERTY(bool tue MEMBER tue)
    Q_PROPERTY(bool wed MEMBER wed)
    Q_PROPERTY(bool thu MEMBER thu)
    Q_PROPERTY(bool fri MEMBER fri)
    Q_PROPERTY(bool sat MEMBER sat)
    Q_PROPERTY(bool sun MEMBER sun)
};
Q_DECLARE_METATYPE(alarm_t)


class DeviceManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(bool power READ power WRITE setPower NOTIFY powerChanged)
    Q_PROPERTY(alarm_t alarm READ alarm WRITE setAlarm NOTIFY alarmChanged)
public:
    DeviceManager(QObject* parent);
    virtual ~DeviceManager() = default;

    Q_INVOKABLE void connectToDevice(const QString& ip, const QString& name);
    Q_INVOKABLE void disconnectFromDevice();

    bool connected() const {return connected_;}

    QColor color() const {return light_.color;}
    void setColor(const QColor& color);

    QString name() const {return name_;}

    bool power() const {return light_.power;}
    void setPower(bool on);

    alarm_t alarm() const
    {
        return alarm_;
    }
    void setAlarm(const alarm_t& alarm);

    enum day_e
    {
        mon = 1,
        tue = 2,
        wed = 3,
        thu = 4,
        fri = 5,
        sat = 6,
        sun = 0
    };
    Q_ENUMS(day_e)

signals:
    void connectedChanged();
    void colorChanged();
    void nameChanged();
    void powerChanged();
    void alarmChanged();

private slots:
    void slotConnected();
    void slotDisconnected();
    void slotError(const QAbstractSocket::SocketError& socketError);
    void slotReadyRead();

private:
    void requestColor();
    void requestAlarm();
    void requestPower();

    void sendJson(const QJsonObject& msg);

    class QTcpSocket* socket_;
    QString ip_;
    bool connected_;

    QString name_;

    struct light_t
    {
        QColor color;
        bool power;
    };

    light_t light_;

    alarm_t alarm_;
};

#endif // SRC_CPP_DEVICE_MANAGER_HPP
