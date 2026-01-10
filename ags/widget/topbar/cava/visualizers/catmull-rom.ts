import Gsk from "gi://Gsk";
import {
	Point,
	shouldVisualize,
	getVisualizerDimensions,
	fillPath,
} from "../utils";
import Graphene from "gi://Graphene?version=1.0";
import { Gtk } from "ags/gtk4";

export function drawCatmullRom(
	widget: any,
	snapshot: Gtk.Snapshot,
	values: number[],
	bars: number,
) {
	const { width, height, color } = getVisualizerDimensions(widget);

	if (!shouldVisualize(bars, values)) return;

	// 1. Criamos um retângulo que representa a área do widget
	const rect = new Graphene.Rect();
	rect.init(0, 0, width, height);
	// 2. Criamos o RoundedRect (ajuste o radius para bater com seu CSS, ex: 12px)
	const roundedRect = new Gsk.RoundedRect();
	const radius = 12; // Valor que você usou no border-radius do CSS
	roundedRect.init_from_rect(rect, radius);
	// 3. Aplicamos o clip na pilha do snapshot
	snapshot.push_rounded_clip(roundedRect);

	const pathBuilder = new Gsk.PathBuilder();
	pathBuilder.move_to(0, height - height * values[0]);

	const barWidth = width / (bars - 1);

	for (let i = 0; i <= bars - 2 && i + 1 < values.length; i++) {
		let p0: Point, p1: Point, p2: Point, p3: Point;

		if (i === 0) {
			p0 = { x: i * barWidth, y: height - height * values[i] };
			p3 = {
				x: (i + 2) * barWidth,
				y: height - height * values[Math.min(i + 2, values.length - 1)],
			};
		} else if (i === bars - 2) {
			p0 = { x: (i - 1) * barWidth, y: height - height * values[i - 1] };
			p3 = { x: (i + 1) * barWidth, y: height - height * values[i + 1] };
		} else {
			p0 = { x: (i - 1) * barWidth, y: height - height * values[i - 1] };
			p3 = {
				x: (i + 2) * barWidth,
				y: height - height * values[Math.min(i + 2, values.length - 1)],
			};
		}

		p1 = { x: i * barWidth, y: height - height * values[i] };
		p2 = { x: (i + 1) * barWidth, y: height - height * values[i + 1] };

		const c1 = {
			x: p1.x + (p2.x - p0.x) / 6,
			y: p1.y + (p2.y - p0.y) / 6,
		};

		const c2 = {
			x: p2.x - (p3.x - p1.x) / 6,
			y: p2.y - (p3.y - p1.y) / 6,
		};

		pathBuilder.cubic_to(c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
	}

	pathBuilder.line_to(width, height);
	pathBuilder.line_to(0, height);
	pathBuilder.close();

	// 4. Preenchemos o caminho dentro do clip
	fillPath(snapshot, pathBuilder, color);

	// 5. Finalizamos o clip (muito importante para não afetar outros widgets)
	snapshot.pop();
}
