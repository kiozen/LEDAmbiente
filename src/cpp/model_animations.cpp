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
