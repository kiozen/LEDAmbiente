#include "application_engine.hpp"
#include "device_manager.hpp"
#include "model_devices.hpp"

#include <QQmlContext>

ApplicationEngine::ApplicationEngine()
{
    addImportPath("qrc:/");

    QQmlContext* context = rootContext();

    model_devices_ = new ModelDevice(this);
    device_manager_ = new DeviceManager(this);

    qRegisterMetaType<alarm_t>();

    context->setContextProperty("modelDevices", model_devices_);
    context->setContextProperty("deviceManager", device_manager_);
}
