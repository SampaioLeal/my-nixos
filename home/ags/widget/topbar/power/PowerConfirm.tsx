import { Gtk } from "ags/gtk4";

interface PowerConfirmProps {
	action: { icon: string; label: string };
	onConfirm: () => void;
	onCancel: () => void;
}

export function PowerConfirm({ action, onConfirm, onCancel }: PowerConfirmProps) {
	return (
		<box class="power-confirm" orientation={Gtk.Orientation.VERTICAL} spacing={16}>
			<label class="confirm-title" label={`${action.icon}  ${action.label}?`} />

			<box spacing={12} homogeneous>
				<button class="cancel-btn" onClicked={onCancel}>
					<label label="Cancelar" />
				</button>
				<button class="confirm-btn" onClicked={onConfirm}>
					<label label="Confirmar" />
				</button>
			</box>
		</box>
	);
}
