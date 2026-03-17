import Notifd from "gi://AstalNotifd";
import Pango from "gi://Pango";
import { Gtk } from "ags/gtk4";
import Adw from "gi://Adw";
import { timeout } from "ags/time";
import { configs } from "../../configs";
import { getIconByAppName, isIcon } from "../../utils/icons";
import { fileExists } from "../../utils/files";
import { getTimeLabel } from "../../utils/time";

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
	classes: string;
	onDismiss: () => void;
	onTimeout?: () => void;
}

// TODO: fix timeout when a notification is replaced
export function Notification({
	notification,
	classes,
	onDismiss,
	onTimeout,
}: NotificationProps) {
	const appIcon =
		notification.appIcon ||
		notification.desktopEntry ||
		getIconByAppName(notification.appName);

	timeout(configs.notifications.displayTime, () => {
		onTimeout && onTimeout();
	});

	return (
		<Adw.Clamp maximumSize={500}>
			<box
				widthRequest={500}
				class={`notification ${urgency(notification)} ${classes}`}
				orientation={Gtk.Orientation.VERTICAL}
			>
				<box class="header" hexpand>
					{isIcon(appIcon) && (
						<image
							class="app-icon"
							valign={Gtk.Align.BASELINE}
							visible={Boolean(appIcon)}
							iconName={appIcon}
						/>
					)}

					<label
						class="app-name"
						valign={Gtk.Align.BASELINE_CENTER}
						ellipsize={Pango.EllipsizeMode.END}
						label={notification.appName || "Unknown"}
					/>

					<label
						hexpand
						halign={Gtk.Align.START}
						valign={Gtk.Align.BASELINE_CENTER}
						class="time"
						label={getTimeLabel(notification.time)}
					/>

					<button
						halign={Gtk.Align.END}
						class="dismiss-btn"
						onClicked={onDismiss}
					>
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
							pixelSize={60}
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

					<box
						orientation={Gtk.Orientation.VERTICAL}
						valign={Gtk.Align.CENTER}
						spacing={6}
					>
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
