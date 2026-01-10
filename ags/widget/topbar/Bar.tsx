import app from "ags/gtk4/app";
import { Astal, Gdk } from "ags/gtk4";
import { PowerMenu } from "./PowerMenu";
import { TimeAndNotifications } from "./TimeAndNotifications";
import { Media } from "./Media";
import { Networks } from "./Networks";
import { Volume } from "./Volume";
import { Workspaces } from "./Workspaces";
import { Tray } from "./Tray";

const MARGIN = 8;

export default function Bar(gdkmonitor: Gdk.Monitor) {
	const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

	// TODO: add CPU and Memory usage

	return (
		<window
			visible
			name="bar"
			class="Bar"
			gdkmonitor={gdkmonitor}
			exclusivity={Astal.Exclusivity.EXCLUSIVE}
			anchor={TOP | LEFT | RIGHT}
			application={app}
			marginTop={MARGIN}
			marginLeft={MARGIN}
			marginRight={MARGIN}
			marginBottom={0}
		>
			<centerbox cssName="centerbox">
				<box $type="start" spacing={6}>
					<Workspaces />
					<Media />
				</box>

				<box $type="center">
					<TimeAndNotifications />
				</box>

				<box $type="end" spacing={6}>
					<Tray />
					<Networks />
					<Volume />
					<PowerMenu />
				</box>
			</centerbox>
		</window>
	);
}
