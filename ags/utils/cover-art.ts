import { execAsync } from "ags/process";
import { URL } from "gnim/fetch";

const CACHE_DIR = "/tmp/mpris-cover-arts";
const MAX_COVERS = 10;

export async function getLocalCoverPath(url: URL) {
	const path = url.pathname.replaceAll("/", "-");
	const fileName = `${path}.png`;
	const COVER_PATH = `${CACHE_DIR}/${fileName}`;

	// 1. Se for arquivo local, retorna direto
	if (!url.protocol.startsWith("http")) {
		return url.toString().replace("file://", "");
	}

	// 2. Checa se o arquivo já existe (usando ls ou test via shell)
	try {
		await execAsync(["test", "-f", COVER_PATH]);
		// Se o comando acima não der erro, o arquivo existe
		return COVER_PATH;
	} catch {
		// Se deu erro, o arquivo não existe, prosseguimos para o download
	}

	// 3. Gerencia o limite de 10 imagens (Remove a mais antiga se necessário)
	try {
		// Lista arquivos por data (os mais antigos primeiro)
		const filesRaw = await execAsync([
			"bash",
			"-c",
			`ls -tr ${CACHE_DIR}/*.png 2>/dev/null`,
		]);
		const files = filesRaw.split("\n").filter((f) => f.trim() !== "");

		if (files.length >= MAX_COVERS) {
			const toDelete = files.slice(0, files.length - MAX_COVERS + 1);
			for (const file of toDelete) {
				await execAsync(["rm", file]);
			}
		}
	} catch (e) {
		// Pasta pode não existir ainda, o curl criará abaixo
	}

	// 4. Download da nova imagem
	await execAsync([
		"curl",
		"-s",
		url.toString(),
		"-o",
		COVER_PATH,
		"--create-dirs",
	]);

	return COVER_PATH;
}
