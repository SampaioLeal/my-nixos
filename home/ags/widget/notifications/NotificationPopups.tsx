import Notifd from "gi://AstalNotifd";
import { Astal, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { createBinding, createState, For, onCleanup } from "ags";
import { Notification } from "./Notification";

export function NotificationPopups() {
	const monitors = createBinding(app, "monitors");

	const notifd = Notifd.get_default();
	const [popups, setPopups] = createState<Notifd.Notification[]>([]);

	const addPopup = (notification: Notifd.Notification) => {
		setPopups((ns) => [notification, ...ns]);
	};

	const replacePopup = (id: number, notification: Notifd.Notification) => {
		setPopups((ns) => ns.map((n) => (n.id === id ? notification : n)));
	};

	const removePopup = (id: number) => {
		setPopups((ns) => ns.filter((n) => n.id !== id));
	};

	const notifiedHandler = notifd.connect("notified", (_, id, replaced) => {
		const notification = notifd.get_notification(id);
		if (!notification) return;

		if (replaced && popups.peek().some((n) => n.id === id)) {
			replacePopup(id, notification);
		} else {
			addPopup(notification);
		}
	});

	const resolvedHandler = notifd.connect("resolved", (_, id) => {
		removePopup(id);
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
					visible={popups((ns) => ns.length > 0)}
					anchor={Astal.WindowAnchor.TOP}
				>
					<box orientation={Gtk.Orientation.VERTICAL}>
						<For each={popups}>
							{(notification) => (
								<Notification
									notification={notification}
									classes="popup"
									onDismiss={() => notification.dismiss()}
									onTimeout={() => removePopup(notification.id)}
								/>
							)}
						</For>
					</box>
				</window>
			)}
		</For>
	);
}
