import { createBinding, createState, With } from "ags";
import { Gtk } from "ags/gtk4";
import { firstActivePlayer } from "./cava/mpris";
import Mpris from "gi://AstalMpris";
import { getLocalCoverPath } from "../../utils/cover-art";
import { CavaDraw } from "./cava/core/CavaWidget";

interface Props {
	player: Mpris.Player;
}

const MAX_COVER_ART = 5

function Cover({ player }: Props) {
	const [index, setIndex] = createState(1)
	const [localCover, setLocalCover] = createState(
		getLocalCoverPath(player.artUrl, 1),
	);

	player.connect("notify::art-url", () => {
		const url = player.artUrl;

		if (!url) {
			setLocalCover("");
			return;
		}

		let newIndex = index() + 1

		if(newIndex > MAX_COVER_ART) {
			newIndex = 1
		}
		
		const path = getLocalCoverPath(url, newIndex);

		setLocalCover(path);
		setIndex(newIndex)
	});

	return (
		<image class="cover" overflow={Gtk.Overflow.HIDDEN} file={localCover} />
	);
}

const MAX_LEN = 20;

function MusicBox({ player }: Props) {
	let measureBox: Gtk.Widget | null = null;

	const title = createBinding(
		player,
		"metadata",
	)(() => {
		if (!player.title) return "";

		if (player.title.length > MAX_LEN) {
			return `${player.artist} - ${player.title.substring(0, 20)}...`;
		}

		return `${player.artist} - ${player.title}`;
	});

	return (
		<overlay
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
	return (
		<box class="module media">
			<With value={firstActivePlayer}>
				{(player) => (player ? <MusicBox player={player} /> : "")}
			</With>
		</box>
	);
}
