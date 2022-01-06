#ifndef SRC_CPP_DEVICE_MANAGER_HPP
#define SRC_CPP_DEVICE_MANAGER_HPP

#include <QAbstractSocket>
#include <QColor>
#include <QDebug>
#include <QObject>
#include <QTime>

#include "model_animations.hpp"

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

struct light_t
{
    Q_GADGET
public:
    QColor color;
    bool power {false};
    Q_PROPERTY(bool power MEMBER power)
    Q_PROPERTY(QColor color MEMBER color)
};
Q_DECLARE_METATYPE(light_t)

struct animation_t
{
    Q_GADGET
public:
    QString hash;
    bool power {false};
    Q_PROPERTY(QString hash MEMBER hash)
    Q_PROPERTY(bool power MEMBER power)
};
Q_DECLARE_METATYPE(animation_t)


class DeviceManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)

    Q_PROPERTY(light_t light READ light WRITE setLight NOTIFY lightChanged)
    Q_PROPERTY(animation_t animation READ animation WRITE setAnimation NOTIFY animationChanged)
    Q_PROPERTY(alarm_t alarm READ alarm WRITE setAlarm NOTIFY alarmChanged)

    Q_PROPERTY(ModelAnimations * animations READ animations CONSTANT)
public:
    DeviceManager(QObject* parent);
    virtual ~DeviceManager() = default;

    Q_INVOKABLE void connectToDevice(const QString& ip, const QString& name);
    Q_INVOKABLE void disconnectFromDevice();

    bool connected() const {return connected_;}
    QString name() const {return name_;}

    light_t light() const {return light_;}
    void setLight(const light_t& light);

    animation_t animation() const {return animation_;}
    void setAnimation(const animation_t& animation);

    alarm_t alarm() const {return alarm_;}
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

    ModelAnimations * animations(){return animations_;}
    void setAnimation(const QString& hash);

signals:
    void connectedChanged();
    void nameChanged();
    void lightChanged();
    void animationChanged();
    void alarmChanged();
//    void animationsChanged();

private slots:
    void slotConnected();
    void slotDisconnected();
    void slotError(const QAbstractSocket::SocketError& socketError);
    void slotReadyRead();

private:
    void requestColor();
    void requestAlarm();
    void requestPower();
    void requestAnimations();

    void sendJson(const QJsonObject& msg);

    class QTcpSocket* socket_;
    QString ip_;
    bool connected_;

    QString name_;


    light_t light_;
    animation_t animation_;
    alarm_t alarm_;
    ModelAnimations* animations_;
};

#endif // SRC_CPP_DEVICE_MANAGER_HPP
