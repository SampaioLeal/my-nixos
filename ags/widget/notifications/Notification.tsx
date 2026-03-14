// import Adw from "gi://Adw";
import GLib from "gi://GLib";
import Notifd from "gi://AstalNotifd";
import Pango from "gi://Pango";
import { Gdk, Gtk } from "ags/gtk4";
import Adw from "gi://Adw";
import Apps from "gi://AstalApps";
import { timeout } from "ags/time";
import { configs } from "../../configs";

function getIconByAppName(appName: string) {
	const apps = new Apps.Apps();
	const app = apps.fuzzy_query(appName)[0];

	if (app && app.icon_name) {
		return app.icon_name;
	}

	return "";
}

function isIcon(icon?: string | null) {
	const iconTheme = Gtk.IconTheme.get_for_display(Gdk.Display.get_default()!);

	if (!icon) return false;

	return iconTheme.has_icon(icon);
}

function fileExists(path: string) {
	return GLib.file_test(path, GLib.FileTest.EXISTS);
}

function time(time: number, format = "%H:%M") {
	return GLib.DateTime.new_from_unix_local(time).format(format)!;
}

function urgency(n: Notifd.Notification) {
	const { LOW, NORMAL, CRITICAL } = Notifd.Urgency;
	switch (n.urgency) {
		case LOW:
			return "low";
		case CRITICAL:
			return "critical";
		case NORMAL:
		default:
			return "normal";
	}
}

interface NotificationProps {
	notification: Notifd.Notification;
	onDismiss: () => void;
	onTimeout: () => void;
}

export function Notification({
	notification,
	onDismiss,
	onTimeout,
}: NotificationProps) {
	const appIcon =
		notification.appIcon ||
		notification.desktopEntry ||
		getIconByAppName(notification.appName);

	timeout(configs.notifications.displayTime, () => {
		onTimeout();
	});

	return (
		<Adw.Clamp maximumSize={400}>
			<box
				widthRequest={400}
				class={`notification ${urgency(notification)}`}
				orientation={Gtk.Orientation.VERTICAL}
			>
				<box class="header" valign={Gtk.Align.CENTER}>
					{isIcon(appIcon) && (
						<image
							class="app-icon"
							visible={Boolean(appIcon)}
							iconName={appIcon}
						/>
					)}

					<label
						class="app-name"
						halign={Gtk.Align.START}
						valign={Gtk.Align.BASELINE_CENTER}
						ellipsize={Pango.EllipsizeMode.END}
						label={notification.appName || "Unknown"}
					/>

					<label
						class="time"
						hexpand
						halign={Gtk.Align.END}
						valign={Gtk.Align.BASELINE_CENTER}
						label={time(notification.time)}
					/>

					<button onClicked={onDismiss}>
						<image iconName="window-close-symbolic" />
					</button>
				</box>

				<Gtk.Separator visible />

				<box class="content">
					{notification.image && fileExists(notification.image) && (
						<image
							valign={Gtk.Align.START}
							overflow={Gtk.Overflow.HIDDEN}
							class="image"
							file={notification.image}
							pixelSize={100}
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

					<box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.CENTER}>
						<label
							class="summary"
							wrap
							xalign={0}
							lines={2}
							label={notification.summary}
							ellipsize={Pango.EllipsizeMode.END}
						/>

						{notification.body && (
							<label
								class="body"
								wrap
								useMarkup
								xalign={0}
								label={notification.body}
							/>
						)}
					</box>
				</box>

				{notification.actions.length > 0 && (
					<box class="actions">
						{notification.actions.map(({ label, id }) => (
							<button hexpand onClicked={() => notification.invoke(id)}>
								<label label={label} halign={Gtk.Align.CENTER} hexpand />
							</button>
						))}
					</box>
				)}
			</box>
		</Adw.Clamp>
	);
}
