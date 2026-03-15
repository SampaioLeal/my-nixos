import { Accessor, createBinding, For, With } from "ags";
import { Gtk } from "ags/gtk4";
import Notifd from "gi://AstalNotifd";
import { NotificationList } from "./NotificationList";

interface CentralPopoverProps {
	now: Accessor<Date>;
}

export function CentralPopover({ now }: CentralPopoverProps) {
	const notifd = Notifd.get_default();

	const notifications = createBinding(notifd, "notifications");

	const time = now((date) =>
		date.toLocaleTimeString("pt", { timeStyle: "medium" }),
	);
	const date = now((date) =>
		date.toLocaleDateString("pt", { dateStyle: "full" }),
	);

	return (
		<box class="central-container" spacing={20}>
			{/* Lado Esquerdo: Central de Notificações (Estilo GNOME) */}
			<box
				class="notifications-section"
				orientation={Gtk.Orientation.VERTICAL}
				hexpand
			>
				<With value={notifications}>
					{(list) =>
						list.length ? (
							<NotificationList notifications={list} />
						) : (
							<box
								orientation={Gtk.Orientation.VERTICAL}
								valign={Gtk.Align.CENTER}
								vexpand
								class="empty-state"
								spacing={16}
							>
								<image
									iconName="notifications-disabled-symbolic"
									pixelSize={48}
								/>
								<label label="Sem notificações" />
							</box>
						)
					}
				</With>
			</box>

			{/* Lado Direito: Calendário e Hora */}
			<box
				orientation={Gtk.Orientation.VERTICAL}
				class="calendar-section"
				valign={Gtk.Align.START}
			>
				<box orientation={Gtk.Orientation.VERTICAL} class="time-header">
					<label class="clock-label" label={time} />
					<label class="date-label" label={date} />
				</box>
				<Gtk.Calendar visible={true} class="calendar-widget" />
			</box>
		</box>
	);
}
