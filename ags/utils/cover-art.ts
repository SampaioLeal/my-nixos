import { exec } from "ags/process";

export function getLocalCoverPath(url: string, index: number) {
	const COVER_PATH = `/tmp/mpris-cover-arts/${index}.png`;

	if (url.startsWith("http")) {
		exec(["curl", "-s", url, "-o", COVER_PATH, "--create-dirs"]);

		return COVER_PATH;
	} else {
		return url.replace("file://", "");
	}
}
