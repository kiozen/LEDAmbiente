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

    qRegisterMetaType<light_t>();
    qRegisterMetaType<animation_t>();
    qRegisterMetaType<alarm_t>();
    qRegisterMetaType<system_t>();

    context->setContextProperty("modelDevices", model_devices_);
    context->setContextProperty("deviceManager", device_manager_);
}
