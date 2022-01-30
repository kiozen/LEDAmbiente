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
#ifndef SRC_CPP_MODEL_COLORS_HPP
#define SRC_CPP_MODEL_COLORS_HPP

#include <QAbstractListModel>
#include <QColor>

class ModelColors : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int rowCount READ rowCount NOTIFY onRowCountChanged)
public:
    ModelColors(class DeviceManager& parent);
    virtual ~ModelColors() = default;

    enum Role
    {
        RoleColorValue = Qt::UserRole + 1,
    };


    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& idx, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void add(const QColor& color);
    Q_INVOKABLE void remove(int idx);
    Q_INVOKABLE void replace(int idx, const QColor& color);

    void SetColors(const QVector<QColor>& colors);

signals:
    void onRowCountChanged();

private:
    class DeviceManager& deviceManager_;
    QVector<QColor> colors_;
};


#endif // SRC_CPP_MODEL_COLORS_HPP
