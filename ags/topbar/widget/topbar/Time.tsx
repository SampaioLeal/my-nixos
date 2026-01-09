import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";

export function Time() {
	const time = createPoll("", 1000, "date +'%d de %b %H:%M'");

	return (
		<menubutton class="module time">
			<label label={time} />
			<popover class="calendar">
				<TimePopover />
			</popover>
		</menubutton>
	);
}

function TimePopover() {
	const timeSecs = createPoll("", 250, "date +%H:%M:%S");
	const dateFull = createPoll("", 60000, "date +'%A, %d de %B'");

	return (
		<box
			orientation={Gtk.Orientation.VERTICAL}
			spacing={16}
			class="popover-container"
		>
			{/* Bloco do Relógio Centralizado */}
			<box orientation={Gtk.Orientation.VERTICAL} class="time-header">
				<label class="clock-label" label={timeSecs} halign={Gtk.Align.CENTER} />
				<label class="date-label" label={dateFull} halign={Gtk.Align.CENTER} />
			</box>

			{/* Calendário GTK */}
			<Gtk.Calendar
				visible={true}
				class="calendar-widget"
				halign={Gtk.Align.CENTER}
			/>
		</box>
	);
}
