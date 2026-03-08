import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";

export function TimeAndNotifications() {
	// TODO: add notifications center like gnome shell
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
			halign={Gtk.Align.CENTER}
			class="popover-container"
		>
			<box orientation={Gtk.Orientation.VERTICAL} class="time-header">
				<label class="clock-label" label={timeSecs} />
				<label class="date-label" label={dateFull} />
			</box>

			<Gtk.Calendar
				visible={true}
				class="calendar-widget"
				showDayNames={true}
				showHeading={true}
			/>
		</box>
	);
}
