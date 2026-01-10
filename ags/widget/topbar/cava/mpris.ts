import Mpris from "gi://AstalMpris";
import { createExternal } from "ags";

const mpris = Mpris.get_default();

export function filterActivePlayers(players: Mpris.Player[]) {
	return players.filter((player: Mpris.Player) => {
		// Check for essential properties that indicate a usable player
		if (!player.title && !player.artist) {
			return false;
		}

		// Check playback status
		// Only include players that are playing or paused
		if (player.playback_status) {
			return [
				Mpris.PlaybackStatus.PLAYING,
				Mpris.PlaybackStatus.PAUSED,
			].includes(player.playback_status);
		}

		return true;
	});
}

export const activePlayers = createExternal(mpris.get_players(), (set) => {
	// poll players periodically as binding to "players" does not seem to work reliably
	const interval = setInterval(() => {
		set(mpris.get_players());
	}, 1000);

	return () => {
		clearInterval(interval);
	};
});

export const firstActivePlayer = activePlayers((players) => {
	const active = filterActivePlayers(players);
	return active.length > 0 ? active[0] : null;
});
