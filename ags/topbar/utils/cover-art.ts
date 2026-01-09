import { exec } from "ags/process";

const COVER_PATH = "/tmp/mpris-cover-arts/current.png";

export function getLocalCoverPath(url: string) {
	if (url.startsWith("http")) {
		exec(["curl", "-s", url, "-o", COVER_PATH, "--create-dirs"]);

		return COVER_PATH;
	} else {
		return url.replace("file://", "");
	}
}
