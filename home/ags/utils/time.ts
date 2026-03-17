import GLib from "gi://GLib";

export function getTimeLabel(time: number) {
	const now = GLib.DateTime.new_now_local().to_unix();
	const diff = now - time;

	if (diff < 60) return "Agorinha";

	const mins = Math.floor(diff / 60);

	if (mins === 1) return "1 minuto atrás";
	if (mins < 60) return `${mins} minutos atrás`;

	return GLib.DateTime.new_from_unix_local(time).format("%H:%M") || "";
}
