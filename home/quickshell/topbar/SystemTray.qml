import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Pill {
    id: root
    Layout.fillHeight: true
    visible: SystemTray.items.values.length > 0

    property color panelBg: "#1f3d3a"
    property int cornerRadius: 14
    property int menuWidth: 200

    RowLayout {
        spacing: 16

        Repeater {
            model: SystemTray.items

            Item {
                id: trayItem
                width: 18
                height: 18
                readonly property var menuItems: modelData.menu ? modelData.menu.items : []

                Image {
                    anchors.centerIn: parent
                    source: modelData.icon
                    width: 16
                    height: 16
                    sourceSize.width: 16
                    sourceSize.height: 16
                    fillMode: Image.PreserveAspectFit
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    width: 6
                    height: 6
                    radius: 3
                    color: modelData.status === "NeedsAttention" ? "#f38ba8" : "transparent"
                    visible: modelData.status !== "Passive"
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            if (modelData.onlyMenu) {
                                trayPopup.toggle();
                            } else if (typeof modelData.activate === "function") {
                                modelData.activate();
                            }
                        } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                            trayPopup.toggle();
                        }
                    }
                }
            }
        }
    }
}
