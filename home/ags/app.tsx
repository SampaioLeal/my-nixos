import app from "ags/gtk4/app";
import style from "./style.scss";

import { Bar } from "./widget/topbar/Bar";
import { NotificationPopups } from "./widget/notifications/NotificationPopups";
// import Dock from "./widget/dock/Dock";

app.start({
	css: style,
	instanceName: "semps-shell",
	main() {
		const monitors = app.get_monitors();

		NotificationPopups();

		monitors.map(Bar);
		// app.get_monitors().map(Dock);
	},
	requestHandler(argv: string[], response: (response: string) => void) {
		const [cmd, arg, ...rest] = argv;
		if (cmd == "say") {
			return response(arg);
		}
		response("unknown command");
	},
});
