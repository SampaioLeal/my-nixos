import AstalTray from "gi://AstalTray";
import { createBinding, For } from "gnim";

const tray = AstalTray.get_default();

export function Tray() {
	const items = createBinding(tray, "items");

	return (
		<box spacing={8} class="system-tray">
			<For each={items}>
				{(item) => (
					<menubutton
						class="module tray-item"
						tooltipMarkup={createBinding(item, "tooltipMarkup")}
						$={(self) => {
							self.menuModel = item.menuModel;
							self.insert_action_group("dbusmenu", item.actionGroup);
							item.connect("notify::action-group", () => {
								self.insert_action_group("dbusmenu", item.actionGroup);
							});
						}}
					>
						<image gicon={createBinding(item, "gicon")} />
					</menubutton>
				)}
			</For>
		</box>
	);
}
