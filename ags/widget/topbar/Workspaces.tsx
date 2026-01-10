import Hyprland from "gi://AstalHyprland";
import { createBinding, For } from "gnim";
import { attachHoverScroll } from "../../utils/scroll";

export function Workspaces() {
	const hyprland = Hyprland.get_default();

	const focused = createBinding(hyprland, "focusedWorkspace").as((ws) => ws.id);
	const workspaces = createBinding(
		hyprland,
		"workspaces",
	)((ws) => ws.toSorted((a, b) => a.id - b.id));

	function nextWorkspace() {
		const activeWorkspaces = workspaces();
		const focusedWorkspaceIndex = activeWorkspaces.findIndex(
			(ws) => ws.id === focused(),
		);

		if (focusedWorkspaceIndex + 1 === activeWorkspaces.length) return;

		activeWorkspaces[focusedWorkspaceIndex + 1]?.focus();
	}

	function previousWorkspace() {
		const activeWorkspaces = workspaces();
		const focusedWorkspaceIndex = activeWorkspaces.findIndex(
			(ws) => ws.id === focused(),
		);

		if (focusedWorkspaceIndex - 1 === -1) return;

		activeWorkspaces[focusedWorkspaceIndex - 1]?.focus();
	}

	return (
		<box
			spacing={8}
			class="module workspaces"
			$={(self) => {
				attachHoverScroll(self, ({ dy }) => {
					if (dy < 0) nextWorkspace();
					if (dy > 0) previousWorkspace();
				});
			}}
		>
			<For each={workspaces}>
				{(workspace: Hyprland.Workspace) => (
					<button
						onClicked={() => workspace.focus()}
						focusOnClick={false}
						class={focused.as((focused) =>
							focused === workspace.id ? "focused" : "unfocused",
						)}
					></button>
				)}
			</For>
		</box>
	);
}
