#include "application_engine.hpp"
#include "model_devices.hpp"

#include <QQmlContext>

ApplicationEngine::ApplicationEngine()
{
    addImportPath("qrc:/");

    QQmlContext* context = rootContext();

    devices_ = new ModelDevice(this);

    context->setContextProperty("modelDevices", devices_);
}
