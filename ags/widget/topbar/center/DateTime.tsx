import { createPoll } from "ags/time";
import { Accessor } from "ags";
import { CentralPopover } from "./CentralPopover";

export function DateTime() {
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
		<menubutton class="module datetime">
			<label label={formatted} />
			<popover class="central-popover">
				<CentralPopover now={now} />
			</popover>
		</menubutton>
	);
}
