import Bluetooth from "gi://AstalBluetooth";
import Network from "gi://AstalNetwork";
import { execAsync } from "ags/process";
import { createBinding } from "gnim";

export function Networks() {
	const network = Network.Network.get_default();

	return (
		<box spacing={8}>
			{network.wired && <WiredConnection />}
			{/* {network.wifi && <WifiConnection />} */}
			<BluetoothStatus />
		</box>
	);
}

function WiredConnection() {
	const network = Network.Network.get_default();

	const tooltipText = createBinding(network.wired, "device").as((device) => {
		if (!device || !device.ip4Config) return "Desconectado";

		const config = device.ip4Config;

		const addresses =
			config
				.get_addresses()
				.map((addr) => addr.get_address())
				.join(", ") || "N/A";
		const gateway = config.gateway || "N/A";
		const nameservers = config.get_nameservers().join(", ") || "N/A";
		const id = network.client.primaryConnection?.id || "Ethernet";
		const iface = device.interface || "N/A";

		return [
			`${id} (${iface})`,
			`IP: ${addresses}`,
			`GW: ${gateway}`,
			`DNS: ${nameservers}`,
		].join("\n");
	});

	const openNmTui = () =>
		execAsync(["hyprctl", "dispatch", "exec", "[float]", "ghostty -e nmtui"]);

	return (
		<button
			class="module internet"
			tooltipText={tooltipText}
			onClicked={openNmTui}
		>
			<image iconName={createBinding(network.wired, "iconName")} />
		</button>
	);
}

function BluetoothStatus() {
	const bluetooth = Bluetooth.Bluetooth.get_default();
	const isPowered = createBinding(bluetooth, "isPowered");

	const tooltipText = createBinding(bluetooth, "devices").as((devices) => {
		if (!bluetooth.isPowered) return "Bluetooth Desligado";

		const connected = devices
			.filter((d) => d.connected)
			.map((d) => d.name || d.address);

		return connected.length > 0
			? `Conectado a:\n${connected.join("\n")}`
			: "Ligado (Desconectado)";
	});

	const openBluetui = () =>
		execAsync(["hyprctl", "dispatch", "exec", "[float]", "ghostty -e bluetui"]);

	return (
		<button
			class="module bluetooth"
			onClicked={openBluetui}
			tooltipText={tooltipText}
		>
			<image
				iconName={isPowered.as((on) =>
					on ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic",
				)}
			/>
		</button>
	);
}
