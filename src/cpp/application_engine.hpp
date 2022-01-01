#ifndef SRC_CPP_APPLICATION_ENGINE_HPP
#define SRC_CPP_APPLICATION_ENGINE_HPP

#include <QQmlApplicationEngine>

class ApplicationEngine : public QQmlApplicationEngine
{
public:
    ApplicationEngine();
    virtual ~ApplicationEngine() = default;

private:
    class ModelDevice* model_devices_;
    class DeviceManager* device_manager_;
};

#endif // SRC_CPP_APPLICATION_ENGINE_HPP
