import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";
import { Accessor } from "gnim";

export function TimeAndNotifications() {
	// TODO: add notifications center like gnome shell
	const now = createPoll(new Date(), 1000, () => new Date());
	const formatted = now((date) => {
		const month = date.toLocaleDateString("pt", {
			month: "long",
		});
		const time = date.toLocaleTimeString("pt", {
			timeStyle: "short",
		});

		return `${date.getDate()} de ${month} ${time}`;
	});

	return (
		<menubutton class="module time">
			<label label={formatted} />
			<popover class="calendar">
				<TimePopover now={now} />
			</popover>
		</menubutton>
	);
}

interface TimePopoverProps {
	now: Accessor<Date>;
}

function TimePopover({ now }: TimePopoverProps) {
	const time = now((date) => {
		const formatted = date.toLocaleTimeString("pt", {
			timeStyle: "medium",
		});

		return formatted;
	});
	const date = now((date) => {
		const formatted = date.toLocaleDateString("pt", {
			dateStyle: "full",
		});

		return formatted;
	});
	return (
		<box
			orientation={Gtk.Orientation.VERTICAL}
			halign={Gtk.Align.CENTER}
			class="popover-container"
		>
			<box orientation={Gtk.Orientation.VERTICAL} class="time-header">
				<label class="clock-label" label={time} />
				<label class="date-label" label={date} />
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
