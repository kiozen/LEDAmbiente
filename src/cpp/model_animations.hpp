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
#ifndef SRC_CPP_MODEL_ANIMATIONS_HPP
#define SRC_CPP_MODEL_ANIMATIONS_HPP

#include <QAbstractListModel>
#include <QVector>

class ModelAnimations : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
public:
    ModelAnimations(QObject* parent);
    virtual ~ModelAnimations() = default;

    void update(const class QJsonArray& animations);

    Q_INVOKABLE QString resolveHash(const QString& hash) const;

    enum Role
    {
        RoleAnimationName = Qt::UserRole + 1,
        RoleAnimationDescription = Qt::UserRole + 2,
        RoleAnimationHash = Qt::UserRole + 3,
    };


    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

    int currentIndex() const {return currentIndex_;}
    void setCurrentIndex(int index);

    void setCurrentAnimation(const QString& hash);

signals:
    void currentIndexChanged();

private:
    struct animation_t
    {
        QString name;
        QString description;
        QString hash;
    };

    QVector<animation_t> animations_;
    int currentIndex_ {-1};
};
#endif // SRC_CPP_MODEL_ANIMATIONS_HPP

