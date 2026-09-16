import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: window

    anchors {
        left: true
        top: true
        right: true
    }

    color: Qt.rgba(0, 0, 0, 0.25)
    implicitHeight: 36

    WlrLayershell.namespace: "quickshell:bar"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: window.height

    // ================= CENTRO =================
    Pill {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 4
        anchors.bottomMargin: 4

        Text {
            id: clockText
            color: "white"

            function tick() {
                const months = ["janeiro", "fevereiro", "março", "abril", "maio", "junho", "julho", "agosto", "setembro", "outubro", "novembro", "dezembro",];
                const pad = n => String(n).padStart(2, "0");
                const now = new Date();
                clockText.text = `${pad(now.getDate())} de ${months[now.getMonth()]} ` + `${pad(now.getHours())}:${pad(now.getMinutes())}`;
            }

            Component.onCompleted: clockText.tick()

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clockText.tick()
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 8

        // ================= ESQUERDA =================
        RowLayout {
            Layout.alignment: Qt.AlignLeft
            height: parent.height
            spacing: 8

            // Workspaces
            Workspaces {}

            // Mídia / Músicas
            Media {}
        }

        // ================= DIREITA =================
        RowLayout {
            Layout.alignment: Qt.AlignRight
            height: parent.height
            spacing: 8

            // System Tray
            SystemTray {}

            // Mic + Alto-falante (Pill 2)
            Pill {
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰍬"
                        color: "#e0e0e0"
                        font.pixelSize: 12
                    }
                    Text {
                        text: "100%"
                        color: "#e0e0e0"
                        font.pixelSize: 12
                    }
                }
                RowLayout {
                    spacing: 4
                    Text {
                        text: "󰕾"
                        color: "#e0e0e0"
                        font.pixelSize: 12
                    }
                    Text {
                        text: "100%"
                        color: "#e0e0e0"
                        font.pixelSize: 12
                    }
                }
            }

            // Redes e SysTray (Pill 3 - Wi-Fi, BT, NixOS)
            Pill {
                Text {
                    text: "󰤨"
                    color: "#e0e0e0"
                    font.pixelSize: 12
                }
                Text {
                    text: "󰂯"
                    color: "#e0e0e0"
                    font.pixelSize: 12
                }
                Text {
                    text: ""
                    color: "#7ebae4"
                    font.pixelSize: 14
                } // NixOS / Snowflake
            }
        }
    }
}
