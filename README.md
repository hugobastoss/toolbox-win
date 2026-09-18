# Toolbox do Técnico — Atalhos Rápidos (Win+R / PowerShell)

Coleção de comandos administrativos do Windows organizados por categoria, mais um script (`ToolboxTecnico.ps1`) que reúne tudo em uma interface gráfica simples, executável direto do GitHub.

---

## 🚀 Como executar o toolbox via PowerShell (GitHub)

Repositório: [hugobastoss/toolbox-win](https://github.com/hugobastoss/toolbox-win)

Basta rodar o comando abaixo no **Win+R** ou em qualquer terminal:

```powershell
powershell -c "irm https://raw.githubusercontent.com/hugobastoss/toolbox-win/main/ToolboxTecnico.ps1 | iex"
```

**O que acontece:**
- `irm` baixa o conteúdo do script direto do GitHub
- `iex` executa o script baixado, sem precisar salvar nada em disco
- Abre uma janela com todos os comandos abaixo, com busca, filtro por categoria e opção de rodar como Administrador

**Atalho para deixar mais rápido:** salve a linha acima como uma função no seu perfil do PowerShell (`$PROFILE`) nas máquinas que você usa com frequência:

```powershell
function toolbox { irm https://raw.githubusercontent.com/hugobastoss/toolbox-win/main/toolbox-win.ps1 | iex }
```

Depois é só digitar `toolbox` no terminal.

> **Nota sobre cache:** o `raw.githubusercontent.com` passa por um CDN que pode levar alguns minutos para refletir uma atualização do arquivo. Se editar o script e a mudança não aparecer, aguarde um pouco ou adicione `?v=2` no final da URL para forçar a busca da versão nova.

---

## 🖥️ Consoles MMC (.msc)

| Comando | Função |
|---|---|
| `compmgmt.msc` | Gerenciamento do Computador (discos, eventos, usuários, serviços) |
| `devmgmt.msc` | Gerenciador de Dispositivos |
| `services.msc` | Serviços do Windows |
| `eventvwr.msc` | Visualizador de Eventos |
| `diskmgmt.msc` | Gerenciamento de Disco |
| `taskschd.msc` | Agendador de Tarefas |
| `lusrmgr.msc` | Usuários e Grupos Locais |
| `secpol.msc` | Política de Segurança Local |
| `gpedit.msc` | Editor de Diretiva de Grupo Local (Pro/Enterprise) |
| `certmgr.msc` | Gerenciador de Certificados |
| `wf.msc` | Firewall do Windows com Segurança Avançada |
| `perfmon.msc` | Monitor de Desempenho |
| `fsmgmt.msc` | Pastas Compartilhadas |
| `wmimgmt.msc` | Gerenciamento do WMI |

## ⚙️ Painel de Controle (.cpl)

| Comando | Função |
|---|---|
| `appwiz.cpl` | Programas e Recursos (desinstalar) |
| `sysdm.cpl` | Propriedades do Sistema |
| `ncpa.cpl` | Conexões de Rede |
| `firewall.cpl` | Firewall do Windows |
| `powercfg.cpl` | Opções de Energia |
| `desk.cpl` | Configurações de Tela (clássico) |
| `timedate.cpl` | Data e Hora |
| `intl.cpl` | Configurações Regionais |
| `inetcpl.cpl` | Opções da Internet |

## 🔧 Diagnóstico e Reparo

| Comando | Função |
|---|---|
| `msconfig` | Configuração do Sistema (boot, serviços, inicialização) |
| `msinfo32` | Informações do Sistema (specs completas) |
| `dxdiag` | Diagnóstico do DirectX (vídeo/áudio) |
| `resmon` | Monitor de Recursos (CPU/disco/rede em tempo real) |
| `mdsched` | Diagnóstico de Memória do Windows |
| `verifier` | Verificador de Driver *(requer admin)* |
| `cleanmgr` | Limpeza de Disco |
| `dfrgui` | Desfragmentador/Otimizador de Disco |
| `cmd /k sfc /scannow` | Verificação de arquivos de sistema *(requer admin)* |

## 📝 Registro e Sistema

| Comando | Função |
|---|---|
| `regedit` | Editor do Registro |
| `optionalfeatures` | Ativar/desativar recursos do Windows |

## 🌐 Rede e Acesso Remoto

| Comando | Função |
|---|---|
| `mstsc` | Conexão de Área de Trabalho Remota (RDP) |
| `msra` | Assistência Remota |

## 💻 Terminal

| Comando | Função |
|---|---|
| `cmd` | Prompt de Comando |
| `powershell` | PowerShell |

## 📁 Pastas Rápidas (shell:)

| Comando | Função |
|---|---|
| `shell:startup` | Pasta de Inicialização do usuário |
| `shell:common startup` | Inicialização para todos os usuários |
| `shell:sendto` | Pasta do "Enviar para" |
| `%temp%` | Pasta de temporários do usuário |
| `shell:recyclebinfolder` | Lixeira |

## 🆕 Configurações Modernas (ms-settings:)

| Comando | Função |
|---|---|
| `ms-settings:windowsupdate` | Windows Update |
| `ms-settings:network-status` | Status de Rede |
| `ms-settings:display` | Tela (painel moderno) |
| `ms-settings:appsfeatures` | Apps e Recursos |

---

## ⚠️ Boas práticas de segurança

- **Nunca** coloque senhas, tokens ou dados de cliente dentro do `.ps1` que fica público no GitHub.
- O padrão `irm | iex` executa o script sem passar pela Política de Execução do PowerShell — use apenas com scripts de fontes que você controla ou confia.
- Antes de rodar qualquer script `irm | iex` de terceiros (ou reaproveitar um link seu antigo), vale abrir o conteúdo e conferir antes de executar.
- Esse mesmo padrão é usado em golpes de engenharia social (falsa verificação de CAPTCHA, falso update de driver) que pedem para a vítima colar um comando no Win+R. Se um cliente relatar isso, é quase sempre phishing.

---

## 📦 Arquivos deste repositório

- `ToolboxTecnico.ps1` — script com a interface gráfica que reúne todos os comandos acima
- `README.md` — este documento
