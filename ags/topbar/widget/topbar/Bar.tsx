import { Astal, Gdk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { Networks } from "./Networks";
import { PowerMenu } from "./PowerMenu";
import { Time } from "./Time";
import { Volume } from "./Volume";
import { Workspaces } from "./Workspaces";
import { CavaVis } from "./Cava";

const MARGIN = 8;

export default function Bar(gdkmonitor: Gdk.Monitor) {
	const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

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
					<CavaVis />
				</box>

				<box $type="center">
					<Time />
				</box>

				<box $type="end" spacing={6}>
					{/* Tray */}
					<Networks />
					<Volume />
					<PowerMenu />
				</box>
			</centerbox>
		</window>
	);
}
