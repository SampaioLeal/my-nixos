import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    default property alias content: container.data

    color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0)
    radius: height / 2

    implicitWidth: container.implicitWidth + 24 // Padding horizontal (12px cada lado)
    implicitHeight: parent.height // Padding vertical (8px cada lado)

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        onWheel: function (wheel) {
            root.wheel(wheel);
        }
    }

    signal wheel(var event)

    RowLayout {
        id: container
        anchors.centerIn: parent
        spacing: 8
    }
}
