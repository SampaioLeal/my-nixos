import { Gtk } from "ags/gtk4";
import Notifd from "gi://AstalNotifd";
import AstalNotifd from "gi://AstalNotifd";
import { Notification } from "../../notifications/Notification";

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
						<Notification
							notification={notification}
							classes="card"
							onDismiss={() => notification.dismiss()}
						/>
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
