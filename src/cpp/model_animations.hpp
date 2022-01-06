#ifndef SRC_CPP_MODEL_ANIMATIONS_HPP
#define SRC_CPP_MODEL_ANIMATIONS_HPP

#include <QAbstractListModel>
#include <QVector>

class ModelAnimations : public QAbstractListModel
{
    Q_OBJECT
public:
    ModelAnimations(QObject* parent);
    virtual ~ModelAnimations() = default;

    void update(const class QJsonArray& animations);

    enum Role
    {
        RoleAnimationName = Qt::UserRole + 1,
        RoleAnimationDescription = Qt::UserRole + 2,
        RoleAnimationHash = Qt::UserRole + 3,
    };


    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;

private:
    struct animation_t
    {
        QString name;
        QString description;
        QString hash;
    };

    QVector<animation_t> animations_;
};
#endif // SRC_CPP_MODEL_ANIMATIONS_HPP

