import { Gtk } from "ags/gtk4";
import Gsk from "gi://Gsk";

export function fillPath(
	snapshot: Gtk.Snapshot,
	pathBuilder: Gsk.PathBuilder,
	color: any,
): void {
	snapshot.append_fill(pathBuilder.to_path(), Gsk.FillRule.WINDING, color);
}
