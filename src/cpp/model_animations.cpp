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
#include "model_animations.hpp"


#include <QJsonArray>
#include <QJsonObject>


ModelAnimations::ModelAnimations(QObject* parent)
    : QAbstractListModel(parent)
{
}

void ModelAnimations::update(const QJsonArray& animations)
{
    beginResetModel();
    animations_.clear();
    for(const QJsonValue& value : animations)
    {
        const QJsonObject& animation = value.toObject();

        animations_.append({
            animation.value("name").toString(),
            animation.value("description").toString(),
            animation.value("hash").toString()
        });
    }
    endResetModel();
}

QHash<int, QByteArray> ModelAnimations::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[RoleAnimationName] = "animationName";
    roles[RoleAnimationDescription] = "animationDescription";
    roles[RoleAnimationHash] = "animationHash";
    return roles;
}

int ModelAnimations::rowCount(const QModelIndex& parent) const
{
    return animations_.count();
}

QVariant ModelAnimations::data(const QModelIndex& index, int role) const
{
    QVariant value;

    int i = index.row();

    if(i >= animations_.size())
    {
        return value;
    }

    const animation_t& animation = animations_[i];

    switch(role)
    {
    case Role::RoleAnimationName:
        value = animation.name;
        break;

    case Role::RoleAnimationDescription:
        value = animation.description;
        break;

    case Role::RoleAnimationHash:
        value = animation.hash;
        break;
    }

    return value;
}

void ModelAnimations::setCurrentIndex(int index)
{
    currentIndex_ = index;
    emit currentIndexChanged();
}

void ModelAnimations::setCurrentAnimation(const QString& hash)
{
    int newIndex = -1;
    for(int i = 0; i < animations_.count(); i++)
    {
        if(animations_.at(i).hash == hash)
        {
            newIndex = i;
            break;
        }
    }

    setCurrentIndex(newIndex);
}

Q_INVOKABLE QString ModelAnimations::resolveHash(const QString& hash) const
{
    QString name;
    for(const animation_t& animation : animations_)
    {
        if(hash == animation.hash)
        {
            name = animation.name;
            break;
        }
    }

    return name;
}
