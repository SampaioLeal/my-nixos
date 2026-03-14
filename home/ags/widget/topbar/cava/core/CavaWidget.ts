import { Gtk, Gdk } from "ags/gtk4";
import Cava from "gi://AstalCava";
import { register } from "ags/gobject";
import { jsx } from "ags";

import { drawCatmullRom } from "../visualizers/catmull-rom";

@register({ GTypeName: "Cava" })
export class CavaWidget extends Gtk.Widget {
	static {
		Gtk.Widget.set_css_name.call(this, "cava");
	}

	private cava = Cava.get_default()!;

	constructor(params?: any) {
		const { ...gtkParams } = params || {};

		super(gtkParams);

		this.cava.connect("notify::values", () => {
			this.queue_draw();
		});
	}

	get_color(): Gdk.RGBA {
		const styleContext = this.get_style_context();

		return styleContext.get_color();
	}

	vfunc_snapshot(snapshot: Gtk.Snapshot): void {
		super.vfunc_snapshot(snapshot);

		const values = this.cava.get_values();
		const bars = this.cava.get_bars();

		drawCatmullRom(this, snapshot, values, bars);
	}

	vfunc_dispose(): void {
		super.vfunc_dispose();
	}
}

export interface CavaDrawProps {
	hexpand?: boolean;
	vexpand?: boolean;
}

export function CavaDraw({ hexpand, vexpand }: CavaDrawProps): CavaWidget {
	return jsx(CavaWidget, {
		hexpand,
		vexpand,
	});
}
