import app from "ags/gtk4/app";
import { Astal, Gdk } from "ags/gtk4";

const MARGIN = 8;

export default function Dock(gdkmonitor: Gdk.Monitor) {
    const {TOP, LEFT, RIGHT, BOTTOM } = Astal.WindowAnchor;

    // TODO: add CPU and Memory usage

    return (
        <window
            visible
            name="bar"
            class="Bar"
            gdkmonitor={gdkmonitor}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={BOTTOM | LEFT | RIGHT}
            application={app}
            marginTop={MARGIN}
            marginLeft={MARGIN}
            marginRight={MARGIN}
            marginBottom={0}
        >
        </window>
    );
}
