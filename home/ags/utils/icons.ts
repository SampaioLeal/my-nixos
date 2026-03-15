import { Gdk, Gtk } from "ags/gtk4";
import AstalApps from "gi://AstalApps";

export function getIconByAppName(appName: string) {
	const apps = new AstalApps.Apps();
	const app = apps.fuzzy_query(appName)[0];

	if (app && app.icon_name) {
		return app.icon_name;
	}

	return "";
}

export function isIcon(icon?: string | null) {
	const iconTheme = Gtk.IconTheme.get_for_display(Gdk.Display.get_default()!);

	if (!icon) return false;

	return iconTheme.has_icon(icon);
}
