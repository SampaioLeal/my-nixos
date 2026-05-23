import { PowerMenuContent } from "./power/PowerMenuContent";

const NIX_LOGO = "";

export function PowerMenu() {
	return (
		<menubutton class="module powermenu">
			<label label={NIX_LOGO} />
			<popover class="power-menu">
				<PowerMenuContent />
			</popover>
		</menubutton>
	);
}
