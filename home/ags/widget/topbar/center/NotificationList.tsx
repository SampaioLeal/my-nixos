import { Gtk } from "ags/gtk4";
import Notifd from "gi://AstalNotifd";
import { NotificationCard } from "./NotificationCard";
import AstalNotifd from "gi://AstalNotifd";

interface Props {
	notifications: Notifd.Notification[];
}

export function NotificationList({ notifications }: Props) {
	const notifd = AstalNotifd.get_default();

	return (
		<box orientation={Gtk.Orientation.VERTICAL}>
			<Gtk.ScrolledWindow vexpand hscrollbarPolicy={Gtk.PolicyType.NEVER}>
				<box
					orientation={Gtk.Orientation.VERTICAL}
					spacing={8}
					class="notif-list"
				>
					{notifications.map((notification) => (
						<NotificationCard notification={notification} />
					))}
				</box>
			</Gtk.ScrolledWindow>

			<box class="footer" spacing={10}>
				<label
					label="Notificações"
					hexpand
					halign={Gtk.Align.START}
					class="section-title"
				/>
				<button
					class="clear-button"
					onClicked={() =>
						notifd.get_notifications().forEach((n) => n.dismiss())
					}
				>
					<label label="Limpar" />
				</button>
			</box>
		</box>
	);
}
