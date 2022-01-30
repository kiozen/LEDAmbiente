#include "device_manager.hpp"
#include "model_colors.hpp"

ModelColors::ModelColors(DeviceManager& parent)
    : QAbstractListModel(&parent)
    , deviceManager_(parent)
{
}

QHash<int, QByteArray> ModelColors::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[RoleColorValue] = "colorValue";
    return roles;
}

int ModelColors::rowCount(const QModelIndex& parent) const
{
    return colors_.count();
}

QVariant ModelColors::data(const QModelIndex& idx, int role) const
{
    QVariant value;
    int i = idx.row();

    if((i < 0) || (i >= colors_.count()))
    {
        return value;
    }

    switch(role)
    {
    case RoleColorValue:
        value = colors_[i];
        break;
    }

    return value;
}

void ModelColors::SetColors(const QVector<QColor>& colors)
{
    beginResetModel();
    colors_ = colors;
    endResetModel();
    emit onRowCountChanged();
}

void ModelColors::add(const QColor& color)
{
    if(!colors_.contains(color.toHsv()))
    {
        beginInsertRows(QModelIndex(), colors_.count(), colors_.count());
        colors_ << color.toHsv();
        endInsertRows();
        emit onRowCountChanged();
        deviceManager_.setPredefinedColors(colors_);
    }
}

void ModelColors::remove(int idx)
{
    if((idx >= 0) && (idx < colors_.count()))
    {
        beginRemoveRows(QModelIndex(), idx, idx);
        colors_.removeAt(idx);
        endRemoveRows();

        emit onRowCountChanged();
        deviceManager_.setPredefinedColors(colors_);
    }
}

void ModelColors::replace(int idx, const QColor& color)
{
    if((idx >= 0) && (idx < colors_.count()))
    {
        colors_[idx] = color;
        emit dataChanged(index(idx, 0), index(idx, 0));
        deviceManager_.setPredefinedColors(colors_);
    }
}
