import { Gtk } from "ags/gtk4";
import Notifd from "gi://AstalNotifd";
import { Notification } from "../../notifications/Notification";

interface Props {
	notifications: Notifd.Notification[];
}

// TODO: create new NotificationCard component just for the list
// TODO: customize to be more like GNOME Shell

export function NotificationList({ notifications }: Props) {
	return (
		<Gtk.ScrolledWindow
			vexpand
			hscrollbarPolicy={Gtk.PolicyType.NEVER}
			class="notif-scroll"
		>
			<box
				orientation={Gtk.Orientation.VERTICAL}
				spacing={8}
				class="notif-list"
			>
				{notifications.map((notification) => (
					<Notification
						notification={notification}
						onDismiss={() => notification.dismiss()}
						onTimeout={() => {}}
					/>
				))}
				{/* <For each={notifications}>
					{(notification) => <Notification notification={notification} />}
				</For> */}
			</box>
		</Gtk.ScrolledWindow>
	);
}
