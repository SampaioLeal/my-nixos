import { Gdk } from "ags/gtk4";
import { CavaWidget } from "../core/CavaWidget";

export function shouldVisualize(bars: number, values: number[]): boolean {
	return !(bars === 0 || values.length === 0 || values.every((v) => v < 0.001));
}

export interface WidgetDimensions {
	width: number;
	height: number;
	color: Gdk.RGBA;
}

export function getVisualizerDimensions(widget: CavaWidget): WidgetDimensions {
	return {
		width: widget.get_width(),
		height: widget.get_height(),
		color: widget.get_color(),
	};
}
