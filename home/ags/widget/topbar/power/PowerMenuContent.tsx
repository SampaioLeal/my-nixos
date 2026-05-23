import { createState } from "ags";
import { Gtk } from "ags/gtk4";
import { execAsync } from "ags/process";
import { PowerConfirm } from "./PowerConfirm";

interface Action {
	id: string;
	icon: string;
	label: string;
	command: string;
	needsConfirm: boolean;
}

const ACTIONS: Action[] = [
	{ id: "shutdown", icon: "⏻", label: "Desligar", command: "systemctl poweroff", needsConfirm: true },
	{ id: "reboot", icon: "↻", label: "Reiniciar", command: "systemctl reboot", needsConfirm: true },
	{ id: "sleep", icon: "⏾", label: "Suspender", command: "systemctl suspend", needsConfirm: false },
	{ id: "logout", icon: "⇥", label: "Sair", command: "hyprctl dispatch exit", needsConfirm: true },
	{ id: "lock", icon: "🔒", label: "Trancar", command: "hyprlock", needsConfirm: false },
	{ id: "hibernate", icon: "⏚", label: "Hibernar", command: "systemctl hibernate", needsConfirm: true },
];

export function PowerMenuContent() {
	const [selectedAction, setSelectedAction] = createState<Action | null>(null);

	const executeAction = (action: Action) => {
		if (action.needsConfirm) {
			setSelectedAction(action);
		} else {
			execAsync(["bash", "-c", action.command]).catch(console.error);
		}
	};

	const confirmAction = () => {
		const action = selectedAction();
		if (!action) return;
		execAsync(["bash", "-c", action.command]).catch(console.error);
		setSelectedAction(null);
	};

	const cancelConfirm = () => {
		setSelectedAction(null);
	};

	const selected = selectedAction();

	if (selected) {
		return (
			<PowerConfirm
				action={selected}
				onConfirm={confirmAction}
				onCancel={cancelConfirm}
			/>
		);
	}

	return (
		<box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
			<box spacing={8} homogeneous>
				{ACTIONS.slice(0, 3).map((action) => (
					<button
						class="action-btn"
						onClicked={() => executeAction(action)}
						hexpand
					>
						<box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
							<label class="action-icon" label={action.icon} />
							<label class="action-label" label={action.label} />
						</box>
					</button>
				))}
			</box>
			<box spacing={8} homogeneous>
				{ACTIONS.slice(3, 6).map((action) => (
					<button
						class="action-btn"
						onClicked={() => executeAction(action)}
						hexpand
					>
						<box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
							<label class="action-icon" label={action.icon} />
							<label class="action-label" label={action.label} />
						</box>
					</button>
				))}
			</box>
		</box>
	);
}
