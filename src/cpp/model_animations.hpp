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

