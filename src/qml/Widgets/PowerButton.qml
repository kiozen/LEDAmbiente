import QtQuick 2.0
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.5

Button {
    id: idPowerButton

    checkable: true
    icon.source: "/icons/power-sharp.png"
    icon.height: 100
    icon.width: 100
    icon.color: idPowerButton.enabled ? checked ? "green" : Material.foreground : Material.buttonDisabledColor

    background: Rectangle {
        border.width: idPowerButton.checked ? 2 : 1
        border.color: idPowerButton.enabled ? idPowerButton.checked ? "green" : Material.foreground : Material.buttonDisabledColor
        radius: 4
        color: Material.background
    }
}
