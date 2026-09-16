import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Pill {
    id: root
    Layout.fillHeight: true

    onWheel: function (wheel) {
        if (wheel.angleDelta.y > 0) {
            Hyprland.dispatch("hl.dsp.focus({ workspace = 'm+1' })");
        } else {
            Hyprland.dispatch("hl.dsp.focus({ workspace = 'm-1' })");
        }
    }

    Row {
        spacing: 8

        Repeater {
            model: Hyprland.workspaces

            Rectangle {
                id: indicator
                property bool isFocused: modelData.focused
                property bool isOccupied: modelData.windows > 0

                width: isFocused ? 24 : 8
                height: 8
                radius: height / 2
                color: isFocused ? "white" : isOccupied ? "#66ffffff" : '#58ffffff'

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
                }
            }
        }
    }
}
