import { Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";

const NIX_LOGO = "";

export function PowerMenu() {
	const openPowerMenu = () =>
		execAsync([
			"hyprctl",
			"dispatch",
			"exec",
			"[float; size 36 8; center]",
			"ghostty -e ~/.config/waybar/scripts/power-menu.sh",
		]);

	return (
		<button
			class="module powermenu"
			onClicked={openPowerMenu}
			halign={Gtk.Align.CENTER}

			// onClicked={() => {
			//   const cc = app.get_window("controll-center");
			//   if (cc) cc.visible = !cc.visible;
			// }}
		>
			{/* <image iconName="system-shutdown" /> */}
			<label label={NIX_LOGO} />
		</button>
	);
}
