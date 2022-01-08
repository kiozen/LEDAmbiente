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
