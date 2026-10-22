# TUI Center — Design

## Intent

Criar `tui-center`, um launcher TUI em Rust que reúne ferramentas de terminal em
um único painel. O usuário navega por cards, filtra por texto e executa a
ferramenta escolhida; ao sair da ferramenta, o `tui-center` volta ao mesmo
estado de terminal e continua utilizável.

O projeto será um repositório independente em `~/Documents/tui-center`, com
flake próprio para desenvolvimento e empacotamento. A configuração NixOS em
`~/my-nixos` consumirá esse repositório como input local do flake, permitindo
instalação via Home Manager sem misturar o código do app à configuração do
sistema.

## Goals

- Exibir os apps configurados como cards com ícone, nome, categoria e descrição.
- Navegar com `j`/`k`/`h`/`l`, setas e `Enter`.
- Filtrar em tempo real por nome, categoria ou descrição.
- Criar automaticamente `~/.config/tui-center/config.toml` quando ele não existir.
- Restaurar o terminal e substituir o processo do launcher pelo programa escolhido.
- Mostrar um erro tratado na TUI quando o executável não existir ou falhar ao iniciar.
- Poder ser compilado com Cargo e empacotado pelo flake do próprio projeto
  (`nix build` em `~/Documents/tui-center`).
- Ter um ambiente de desenvolvimento reproduzível via `nix develop`.
- Ser consumido pela configuração NixOS como input local e instalado pelo Home Manager.
- Ter testes automatizados para configuração, filtro, navegação e caminhos de erro.

## Non-goals

- Gerenciar instalação/desinstalação de ferramentas.
- Executar comandos em shell (`sh -c`), capturar stdout/stderr ou rodar em background.
- Editar a configuração dentro da TUI.
- Adicionar categorias dinâmicas, plugins, temas configuráveis ou integração com desktop.
- Preservar o estado interno das ferramentas executadas; apenas o estado do
  `tui-center` é mantido.

## Anti-goals

- Deixar o terminal em raw mode/alternate screen após sair ou após um erro.
- Fazer o processo principal abortar quando um comando configurado não existe.
- Exigir que o usuário edite a configuração antes do primeiro uso.
- Introduzir um runtime assíncrono ou um framework TUI mais pesado sem necessidade.

## Constraints

- Rust stable e edição 2021 ou superior.
- `ratatui` para desenho, `crossterm` para eventos/terminal, `serde` + `toml`
  para configuração, `clap` para a CLI.
- Linux é o alvo principal; o código deve evitar dependências específicas de
  plataforma fora do necessário para localizar executáveis.
- O subprocesso herda stdin/stdout/stderr e precisa ocupar o terminal como uma
  aplicação interativa normal.
- O flake do projeto usa `rustPlatform.buildRustPackage` e `Cargo.lock` para
  builds reproduzíveis.
- O repositório do app não deve depender de arquivos internos de `my-nixos`.
- O input local em `my-nixos` deve continuar compatível com avaliação pura do
  flake; por isso não será usada uma referência absoluta solta no Nix.

## Approaches Considered

1. **Crate modular com grid responsivo e busca explícita (escolhida).** Separa
   configuração, estado, UI e execução; usa `/` para entrar no modo de busca,
   eliminando o conflito entre digitar `q` e encerrar o app. Grid de 1–3 colunas
   conforme a largura.
2. **Crate mínimo de um arquivo com lista vertical.** Menos arquivos, mas
   dificulta testes e não explora bem telas largas.
3. **Grid com filtro sempre ativo.** Digitação imediata, mas exige regras
   ambíguas para `q`/`Esc` e piora a previsibilidade dos atalhos.

A opção 1 foi escolhida por equilibrar simplicidade, testabilidade e aderência ao
pedido original. O uso de `/` é uma decisão deliberada para manter `q` e `Esc`
como saída previsíveis.

## Repository Strategy

1. **Repositório separado com flake próprio e input local (escolhida).** O app
   fica em `~/Documents/tui-center`, com `flake.nix`, `devShells.default` e
   `packages.default`. `~/my-nixos` adiciona esse repositório como input
   `git+file:///home/sampaiol/Documents/tui-center` e instala o pacote via Home
   Manager. Preserva a avaliação pura do flake, usa apenas arquivos commitados
   (evitando copiar `target/`) e separa claramente app e configuração do sistema.
2. **Crate dentro de `my-nixos`.** Menos repositórios, mas mistura o ciclo de
   desenvolvimento do app com a configuração NixOS.
3. **Derivação local apontando diretamente para uma pasta absoluta.** Simples de
   escrever, porém falha ou exige modo impuro na avaliação de flakes e não é
   reproduzível.

A opção 1 foi escolhida. O input `git+file:` é local e temporário; poderá virar
`git+https://...` quando o repositório tiver um remoto, sem mudar o módulo do
Home Manager. Usar `git+file:` em vez de `path:` garante que o flake consuma
somente arquivos versionados e não copie `target/` para o Nix Store.

## Architecture

Repositório `~/Documents/tui-center`:

```text
tui-center/
├── flake.nix
├── flake.lock
├── package.nix
├── Cargo.toml
├── Cargo.lock
├── README.md
├── .envrc
├── .gitignore
└── src/
    ├── main.rs       # CLI, inicialização, loop de eventos e ciclo do terminal
    ├── config.rs     # descoberta, criação e parsing da configuração
    ├── app.rs        # estado, filtro, navegação e comandos de teclado
    ├── ui.rs         # layout, cards, header, status e overlay de erro
    └── launcher.rs   # resolução de executável e execução do subprocesso
```

Integração em `~/my-nixos`:

```text
flake.nix                         # input tui-center
home/default.nix                  # importa ./packages/tui-center.nix
home/packages/tui-center.nix      # instala o pacote no Home Manager
```

O `main.rs` mantém a responsabilidade pelo terminal e pelo loop. O loop usa
`crossterm::event::read()` bloqueante e redesenha a cada evento (incluindo
resize); não há tick nem limpeza automática de status. `App` não depende de
`ratatui` nem de `crossterm`; isso permite testar estado, filtro e navegação com
testes unitários simples.

## Configuration

### Localização

- `--config <PATH>` tem prioridade.
- Sem a flag, usa o diretório de configuração do usuário via `dirs::config_dir()`,
  resultando em `~/.config/tui-center/config.toml` no Linux.
- Se o arquivo não existir, cria o diretório e grava uma configuração de exemplo.
  Isso vale também para um caminho passado em `--config`, incluindo a criação dos
  diretórios-pai. A decisão segue literalmente o requisito de criar o arquivo
  automaticamente no primeiro uso; o README alertará sobre erros de digitação no
  caminho customizado.
- Se não for possível determinar o diretório de configuração ou criar/ler o
  arquivo, a aplicação inicia em modo de erro amigável na TUI, em vez de entrar
  em pânico.

O exemplo gerado contém exatamente:

```toml
[[apps]]
name = "Atuin"
category = "Produtividade"
description = "Histórico de comandos interativo"
command = "atuin"
args = ["history", "list"]
icon = "📜"

[[apps]]
name = "Nix Tree"
category = "NixOS"
description = "Navegador de dependências do Nix Store"
command = "nix-tree"
args = ["/run/current-system"]
icon = "❄️"

[[apps]]
name = "Btop"
category = "Sistema"
description = "Monitor de recursos e processos"
command = "btop"
icon = "📊"
```

Esses apps são ilustrativos e não serão adicionados automaticamente ao
`home.packages`; se algum não estiver instalado, o erro de executável ausente
será mostrado na TUI.

### Schema

```toml
[[apps]]
name = "Atuin"
category = "Produtividade"
description = "Histórico de comandos interativo"
command = "atuin"
args = ["history", "list"]
icon = "📜"
```

Campos:

- `name`, `command`: obrigatórios.
- `category`, `description`: opcionais; usam `""` como fallback.
- `args`: opcional; usa lista vazia.
- `icon`: opcional; usa `"▸"` como fallback.
- `apps`: opcional; usa lista vazia, resultando em uma tela de estado vazio.
- Chaves desconhecidas são ignoradas (comportamento padrão do `serde`), para não
  quebrar a inicialização por causa de campos extras ou erros de digitação em
  campos opcionais. Arquivo vazio é equivalente a zero apps.

## Application State

```text
App {
  apps: Vec<AppEntry>,
  filter: String,
  selected: usize,
  mode: Normal | Search,
  columns: usize,
  status: Option<String>,
  overlay: Option<ErrorOverlay>,
  should_quit: bool,
}

ErrorOverlay {
  message: String,
  dismissible: bool,
}
```

- `filtered_indices()` calcula a lista visível sem alterar a lista original.
- A busca é case-insensitive e sem acentos, dividida por `split_whitespace`.
  Cada termo precisa aparecer em nome, categoria ou descrição; termos diferentes
  podem casar em campos diferentes (AND entre termos, OR entre campos).
- A normalização usa `unicode-normalization` (NFD) para remover marcas
  combinantes, então `historico` encontra `Histórico`.
- Alterar o filtro reseta a seleção para o primeiro resultado.
- A seleção é sempre limitada ao número de resultados filtrados.
- Após executar um app, a TUI volta ao modo normal com o filtro preservado.
- `columns` é atualizado pela camada de UI conforme a largura disponível.
- Mensagens de status persistem até a próxima tecla; não há timer nem tick.
- `Enter` sem resultados é um no-op e mostra uma mensagem curta na status bar.

## Keyboard Model

### Modo normal

| Tecla | Ação |
|---|---|
| `j` / `↓` | Descer uma linha do grid |
| `k` / `↑` | Subir uma linha do grid |
| `h` / `←` | Card anterior |
| `l` / `→` | Próximo card |
| `Enter` | Executar app selecionado |
| `/` | Entrar no modo de busca |
| `q` / `Esc` / `Ctrl+C` | Sair |
| `Backspace` | Apagar último caractere do filtro, se houver |

### Modo de busca

| Tecla | Ação |
|---|---|
| Caractere imprimível | Adicionar ao filtro |
| `Backspace` | Remover último caractere |
| `Esc` | Limpar filtro e voltar ao modo normal |
| `Enter` | Executar app selecionado |
| `↑` / `↓` | Navegar verticalmente |
| `Ctrl+C` | Sair |

O header indica claramente quando a busca está ativa e mostra a consulta atual.
Não há cursor de texto; a barra exibe `_` quando o modo de busca está ativo.

Semântica do grid:

- `h`/`←` movem para o resultado linear anterior e `l`/`→` para o próximo,
  atravessando o fim/início de uma linha. Nos extremos, a seleção fica parada.
- `j`/`↓` somam `columns` ao índice e `k`/`↑` subtraem `columns`, com clamp em
  `0..len-1`. Isso permite alcançar a última linha parcial.
- Não há wrap-around.
- Com zero resultados, nenhuma navegação altera a seleção e `Enter` é no-op.

## UI

Layout vertical:

1. **Header (altura fixa):** título `TUI Center`, contagem de resultados,
   linha de busca e ajuda de teclas.
2. **Body (flexível):** grid de cards com scroll vertical.
3. **Status bar (1 linha):** mensagem de execução/erro ou dica, mantida até a
   próxima tecla.

Responsividade:

- Largura `< 60`: 1 coluna.
- Largura `60–99`: 2 colunas.
- Largura `>= 100`: 3 colunas.
- Cada card tem altura fixa de 5 linhas: borda, ícone + nome, categoria e
  descrição truncada.
- O grid calcula quantas linhas cabem e rola para manter o card selecionado visível.
- O card selecionado usa borda/cor de destaque.
- Sem resultados: painel centralizado com `Nenhum app encontrado`.

Erros:

- Erro de configuração na inicialização: overlay não dispensável com a mensagem
  e instrução para sair. Apenas `q`, `Esc` ou `Ctrl+C` encerram. O grid e a
  busca não respondem enquanto esse overlay estiver ativo.
- Executável não encontrado ou sem permissão de execução: overlay dispensável
  `Erro ao executar`, fechado com `Enter` ou `Esc`; `q` não encerra enquanto o
  overlay estiver aberto.
- Falha ao substituir o processo (`exec`): a TUI é restaurada e mostra um overlay
  dispensável com o erro.

## Process Execution Lifecycle

Ao confirmar um app:

1. Resolver o executável antes de mexer no terminal. Comandos com `/` são
   tratados como caminho (absoluto ou relativo) e verificados diretamente;
   comandos sem `/` são procurados em cada entrada de `PATH` na ordem definida.
   Um arquivo existente sem bit de execução (em Unix) conta como inválido. Em
   qualquer falha, mostrar o overlay e não iniciar o programa.
2. Restaurar o terminal: desabilitar raw mode, sair do alternate screen, mostrar
   o cursor, limpar a tela e posicionar o cursor no topo.
3. Criar `std::process::Command` com o comando e argumentos, herdando o terminal.
4. Substituir o processo atual pelo programa escolhido com `exec()`; o
   `tui-center` deixa de existir e não fica em background.
5. Quando o programa termina, o shell volta e a saída permanece visível — por
   exemplo, o texto de `--help` não é apagado por um redraw do launcher.
6. Se o `exec()` falhar, a TUI é reinicializada e mostra um overlay dispensável
   com o erro.

O terminal será encapsulado em uma estrutura com `restore()` idempotente e um
guard de `Drop` para restaurar o estado em caso de pânico ou saída antecipada.
O ciclo de suspender/retomar será usado apenas no caminho de falha do `exec()`.

## CLI

```text
tui-center [--config <PATH>]
```

- `--config`: caminho alternativo para o arquivo TOML.
- `--help` e `--version` via `clap`.
- Sem argumentos, usa o caminho padrão e cria o exemplo se necessário.

## Development Environment

O repositório terá um `flake.nix` com:

- `devShells.default`: Rust stable, `cargo`, `rustc`, `rustfmt`, `clippy`,
  `rust-analyzer` e ferramentas básicas de build;
- `packages.default`: o binário compilado;
- `apps.default`: execução via `nix run`;
- `formatter`: `nixfmt` ou equivalente disponível no nixpkgs;
- `.envrc` com `use flake` para quem usa direnv/nix-direnv.

Fluxo de desenvolvimento:

```bash
cd ~/Documents/tui-center
nix develop
cargo run
cargo test
cargo fmt --check
cargo clippy -- -D warnings
nix build
```

`package.nix` usa `rustPlatform.buildRustPackage`, `Cargo.lock` e um fileset que
inclui apenas fontes, manifesto, lock, README e `package.nix`. O arquivo
`flake.lock` do projeto será gerado e commitado.

## Nix Integration

- `~/my-nixos/flake.nix` adiciona:
  ```nix
  tui-center = {
    url = "git+file:///home/sampaiol/Documents/tui-center";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ```
- `home/packages/tui-center.nix` instala
  `inputs.tui-center.packages.${pkgs.stdenv.hostPlatform.system}.default`.
- `home/default.nix` importa o novo módulo.
- O input local é re-lockado com `nix flake update tui-center` após mudanças no
  app. Quando houver remoto, apenas a URL do input muda.
- Nenhuma configuração padrão é instalada declarativamente: o binário cria o
  arquivo no primeiro uso, conforme o requisito.

## Testing Strategy

- `config.rs`: parsing completo, defaults de campos opcionais, criação automática
  do exemplo, caminho customizado e erro de TOML inválido.
- `app.rs`: filtro por nome/categoria/descrição, múltiplos termos,
  case-insensitivity, reset/clamp da seleção, navegação em grid e transições de
  modo.
- `launcher.rs`: resolução em `PATH`, comando absoluto e comando inexistente.
- `ui.rs`: renderização em `TestBackend` para estados normal, vazio, busca e
  overlay de erro, incluindo terminais estreitos.
- Verificação manual: executar `cargo fmt --check`, `cargo clippy -- -D warnings`,
  `cargo test`, `nix build` no repositório do app e uma execução interativa real.
- Verificação da integração: `nix flake update tui-center` e
  `nix eval .#homeConfigurations.sampaiol.activationPackage` em `my-nixos`
  (ou o comando equivalente de build do Home Manager) sem erros de avaliação.

## README

Cobrirá:

- visão geral e requisitos;
- setup do repositório com `nix develop`;
- `cargo run`, build release, testes, formatação e clippy;
- build/instalação via flake do projeto;
- integração como input no flake do NixOS/Home Manager;
- schema e localização da configuração;
- atalhos de teclado;
- como o ciclo de execução/retorno funciona;
- solução de problemas para comandos ausentes do `PATH`.

## Open Decisions Left to the Builder

- Versões exatas das crates e ajustes de API compatíveis com a versão disponível
  no ambiente.
- Detalhes visuais finos (cores exatas, espaçamento interno dos cards) desde que
  preservem o layout e a legibilidade descritos.
- Estratégia exata de testes de UI com `ratatui::backend::TestBackend`.
- Forma de calcular/validar a derivação Nix e o `flake.lock` no ambiente local.
- Configuração exata do `devShell` (ferramentas extras que se mostrarem úteis).
