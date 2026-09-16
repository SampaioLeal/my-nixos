import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets

Pill {
    id: root
    Layout.fillHeight: true

    readonly property var players: Mpris.players.values
    readonly property MprisPlayer activePlayer: {
        // Try to find one that is currently playing
        const playing = players.find(p => p.playbackState === MprisPlaybackState.Playing);
        if (playing)
            return playing;

        // Otherwise fall back to the first available player, or null
        return players.length > 0 ? players[0] : null;
    }

    visible: activePlayer?.playbackState === MprisPlaybackState.Playing

    RowLayout {
        spacing: 8

        ClippingRectangle {
            visible: activePlayer?.trackArtUrl != null
            implicitWidth: 20
            implicitHeight: 20
            radius: 4

            Image {
                source: activePlayer?.trackArtUrl ?? ""
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignVCenter
                fillMode: Image.PreserveAspectFit
                sourceSize: Qt.size(20, 20)
            }
        }

        Text {
            text: {
                if (!activePlayer)
                    return "";
                var title = activePlayer.trackTitle ?? "";
                var artist = activePlayer.trackArtist ?? "";
                if (title && artist)
                    return title + " - " + artist;
                return title || artist;
            }
            color: "white"
            font.pixelSize: 12
        }
    }
}
