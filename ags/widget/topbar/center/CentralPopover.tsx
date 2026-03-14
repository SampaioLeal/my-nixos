import { Accessor } from "ags";
import { Gtk } from "ags/gtk4";

interface CentralPopoverProps {
	now: Accessor<Date>;
}

export function CentralPopover({ now }: CentralPopoverProps) {
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
