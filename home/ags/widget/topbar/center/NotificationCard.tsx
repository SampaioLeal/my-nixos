import { Gtk } from "ags/gtk4";
import Notifd from "gi://AstalNotifd";
import GLib from "gi://GLib";
import Pango from "gi://Pango?version=1.0";
import { getIconByAppName, isIcon } from "../../../utils/icons";
import { fileExists } from "../../../utils/files";

interface Props {
	notification: Notifd.Notification;
}

function getTimeLabel(time: number) {
	const now = GLib.DateTime.new_now_local().to_unix();
	const diff = now - time;

	if (diff < 60) return "Agorinha";

	const mins = Math.floor(diff / 60);

	if (mins === 1) return "1 minuto atrás";
	if (mins < 60) return `${mins} minutos atrás`;

	return GLib.DateTime.new_from_unix_local(time).format("%H:%M") || "";
}

export function NotificationCard({ notification }: Props) {
	const appIcon =
		notification.appIcon ||
		notification.desktopEntry ||
		getIconByAppName(notification.appName);

	return (
		<button class="notification-card" onClicked={() => notification.dismiss()}>
			<box spacing={12} orientation={Gtk.Orientation.HORIZONTAL}>
				{/* Ícone */}
				<box valign={Gtk.Align.START}>
					{!notification.image && <image iconName={appIcon} pixelSize={44} />}

					{notification.image && fileExists(notification.image) && (
						<image
							valign={Gtk.Align.START}
							overflow={Gtk.Overflow.HIDDEN}
							class="image"
							file={notification.image}
							pixelSize={44}
						/>
					)}

					{notification.image && isIcon(notification.image) && (
						<box valign={Gtk.Align.START} class="icon-image">
							<image
								iconName={notification.image}
								halign={Gtk.Align.CENTER}
								valign={Gtk.Align.CENTER}
							/>
						</box>
					)}
				</box>

				{/* Área de Texto */}
				<box
					spacing={4}
					orientation={Gtk.Orientation.VERTICAL}
					valign={Gtk.Align.CENTER}
					hexpand
				>
					<box spacing={8} orientation={Gtk.Orientation.HORIZONTAL}>
						<label
							class="summary"
							label={notification.summary}
							ellipsize={Pango.EllipsizeMode.END}
						/>

						<label
							class="time"
							label={getTimeLabel(notification.time)}
							valign={Gtk.Align.BASELINE_CENTER}
						/>
					</box>

					{notification.body && (
						<label
							class="body"
							label={notification.body}
							halign={Gtk.Align.START}
							ellipsize={Pango.EllipsizeMode.END}
						/>
					)}
				</box>
			</box>
		</button>
	);
}
