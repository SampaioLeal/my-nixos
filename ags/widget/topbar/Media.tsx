import { createBinding, createComputed, createState, With } from "ags";
import { Gtk } from "ags/gtk4";
import { findPlayer } from "./cava/mpris";
import Mpris from "gi://AstalMpris";
import { getLocalCoverPath } from "../../utils/cover-art";
import { CavaDraw } from "./cava/core/CavaWidget";
import { URL } from "gnim/fetch";
import { configs } from "../../configs";

interface Props {
	player: Mpris.Player;
}

function Cover({ player }: Props) {
	const [localCover, setLocalCover] = createState("");

	const updateCover = async () => {
		const url = player.artUrl;

		if (!url) {
			setLocalCover("");
			return;
		}

		const path = await getLocalCoverPath(new URL(url));
		setLocalCover(path);
	};

	updateCover();

	player.connect("notify::art-url", updateCover);

	return (
		<image
			class="cover-art"
			overflow={Gtk.Overflow.HIDDEN}
			pixelSize={20}
			file={localCover}
		/>
	);
}

function MusicBox({ player }: Props) {
	let measureBox: Gtk.Widget | null = null;

	const metadata = createBinding(player, "metadata");
	const title = metadata(() => {
		if (!player.title) return "";

		if (player.title.length > configs.topbar.media.maxTitleLength) {
			return `${player.title.substring(0, 20)}... - ${player.artist}`;
		}

		return `${player.title} - ${player.artist}`;
	});
	const tooltipText = metadata(() => {
		return `${player.title} - ${player.artist}`;
	});

	return (
		<overlay
			tooltipText={tooltipText}
			$={(self) => {
				if (measureBox) {
					self.set_measure_overlay(measureBox, true);
				}
			}}
		>
			<box class="cava" $type="overlay" canTarget={false} visible={true}>
				<CavaDraw vexpand hexpand />
			</box>

			<box
				$type="overlay"
				$={(self) => {
					measureBox = self;
				}}
				spacing={12}
			>
				<box class="cover">
					<Cover player={player} />
				</box>
				<box class="title">
					<label label={title} />
				</box>
			</box>
		</overlay>
	);
}

export function Media() {
	const mpris = Mpris.get_default();

	return (
		<box class="module media">
			<With value={createBinding(mpris, "players")}>
				{(players: Mpris.Player[]) => {
					if (!players.length) return null;

					const activePlayer = findPlayer(players);
					if (!activePlayer) return null;

					return <MusicBox player={activePlayer} />;
				}}
			</With>
		</box>
	);
}
