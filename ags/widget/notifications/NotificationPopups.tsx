import Notifd from "gi://AstalNotifd";
import { Astal, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { createBinding, createState, For, onCleanup } from "ags";
import { Notification } from "./Notification";
import { interval } from "ags/time";

export function NotificationPopups() {
	const monitors = createBinding(app, "monitors");

	const notifd = Notifd.get_default();
	const [notifications, setNotifications] = createState<Notifd.Notification[]>(
		[],
	);

	interval(10000, () => {
		Notifd.send_notification(
			new Notifd.Notification({
				summary: "Notification Popup Example",
				appIcon: "bluetooth-active-symbolic",
				// body: "oioi",
				body:
					"Lorem ipsum dolor sit amet, qui ad minim labore adipisicing " +
					"minim sint cillum sint consectetur cupidatat.",
				appName: "teste",
				urgency: Notifd.Urgency.NORMAL,
			}),
			() => null,
		);
	});

	const notifiedHandler = notifd.connect("notified", (_, id, replaced) => {
		const notification = notifd.get_notification(id);
		if (!notification) return;

		console.log(notification.expireTimeout);

		if (replaced && notifications.peek().some((n) => n.id === id)) {
			setNotifications((ns) => ns.map((n) => (n.id === id ? notification : n)));
		} else {
			setNotifications((ns) => [notification, ...ns]);
		}
	});

	const resolvedHandler = notifd.connect("resolved", (_, id) => {
		setNotifications((ns) => ns.filter((n) => n.id !== id));
	});

	onCleanup(() => {
		notifd.disconnect(notifiedHandler);
		notifd.disconnect(resolvedHandler);
	});

	return (
		<For each={monitors}>
			{(monitor) => (
				<window
					$={(self) => onCleanup(() => self.destroy())}
					class="NotificationPopups"
					gdkmonitor={monitor}
					visible={notifications((ns) => ns.length > 0)}
					anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
				>
					<box orientation={Gtk.Orientation.VERTICAL}>
						<For each={notifications}>
							{(notification) => <Notification notification={notification} />}
						</For>
					</box>
				</window>
			)}
		</For>
	);
}
