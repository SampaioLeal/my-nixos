import Mpris from "gi://AstalMpris";

export function findPlayer(players: Mpris.Player[]): Mpris.Player | undefined {
	const activePlayer = players.find(
		(p) => p.playback_status === Mpris.PlaybackStatus.PLAYING,
	);
	if (activePlayer) return activePlayer;

	return players.find((p) => p.title !== undefined);
}
