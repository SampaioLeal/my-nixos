import Wp from "gi://AstalWp";
import { createBinding } from "gnim";
import { attachHoverScroll } from "../../utils/scroll";

type VolumeAction = "increase" | "decrease" | "mute";

const CHANGE_SPEED = 0.02;
const MAX_VOLUME = 1;

export function Volume() {
	const wp = Wp.get_default();
	const defaultInput = wp.audio.default_microphone;
	const defaultOutput = wp.audio.default_speaker;

	function changeVolume(device: Wp.Endpoint, action: VolumeAction) {
		let delta = 0;

		if (action === "increase") delta = 1;
		if (action === "decrease") delta = -1;

		const newVolume = device.volume + CHANGE_SPEED * delta;

		if (newVolume < 0) {
			device.volume = 0;
			return;
		}
		if (newVolume > MAX_VOLUME) {
			device.volume = MAX_VOLUME;
			return;
		}

		device.volume += CHANGE_SPEED * delta;
	}

	return (
		<box spacing={8}>
			<button class="module volume">
				<box
					spacing={6}
					$={(self) => {
						attachHoverScroll(self, ({ dy }) => {
							if (dy < 0) changeVolume(defaultInput, "increase");
							if (dy > 0) changeVolume(defaultInput, "decrease");
						});
					}}
				>
					<image iconName={createBinding(defaultInput, "volumeIcon")} />
					<label
						label={createBinding(
							defaultInput,
							"volume",
						)((volume) => `${Math.round(volume * 100)}%`)}
					/>
				</box>
			</button>

			<button class="module volume">
				<box
					spacing={6}
					$={(self) => {
						attachHoverScroll(self, ({ dy }) => {
							if (dy < 0) changeVolume(defaultOutput, "increase");
							if (dy > 0) changeVolume(defaultOutput, "decrease");
						});
					}}
				>
					<image iconName={createBinding(defaultOutput, "volumeIcon")} />
					<label
						label={createBinding(
							defaultOutput,
							"volume",
						)((volume) => `${Math.round(volume * 100)}%`)}
					/>
				</box>
			</button>
		</box>
	);
}
