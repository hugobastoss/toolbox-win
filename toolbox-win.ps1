<#
    ToolboxTecnico.ps1
    ------------------
    Painel grafico com atalhos rapidos para as ferramentas administrativas
    mais usadas por tecnicos de informatica (equivalentes aos comandos do Win+R).

    COMO USAR
    ---------
    1) Duplo clique no arquivo (se a politica de execucao permitir), OU
    2) Botao direito > "Executar com o PowerShell", OU
    3) Via linha de comando (recomendado se der erro de politica de execucao):
         powershell -ExecutionPolicy Bypass -File ToolboxTecnico.ps1

    Marque "Executar como Administrador" antes de clicar em itens que exigem
    elevacao (ex: sfc /scannow, verifier, algumas trocas em secpol/gpedit).
    O Windows vai pedir confirmacao do UAC normalmente.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ------------------------------------------------------------------
# Lista de ferramentas: Nome | Categoria | Comando | Modo de execucao
#   Modo 'Start'    -> Start-Process direto (funciona para a maioria: .msc, .cpl, exe, ms-settings:, protocolos)
#   Modo 'CmdK'     -> abre um cmd.exe com /k (mantem a janela aberta apos rodar)
#   Modo 'Explorer' -> abre a pasta/atalho shell: pelo explorer.exe
# ------------------------------------------------------------------
$itens = @(
    # Consoles MMC (.msc)
    [PSCustomObject]@{Nome='Gerenciamento do Computador';        Categoria='Consoles MMC';         Comando='compmgmt.msc';    Modo='Start'}
    [PSCustomObject]@{Nome='Gerenciador de Dispositivos';        Categoria='Consoles MMC';         Comando='devmgmt.msc';     Modo='Start'}
    [PSCustomObject]@{Nome='Servicos do Windows';                Categoria='Consoles MMC';         Comando='services.msc';    Modo='Start'}
    [PSCustomObject]@{Nome='Visualizador de Eventos';            Categoria='Consoles MMC';         Comando='eventvwr.msc';    Modo='Start'}
    [PSCustomObject]@{Nome='Gerenciamento de Disco';             Categoria='Consoles MMC';         Comando='diskmgmt.msc';    Modo='Start'}
    [PSCustomObject]@{Nome='Agendador de Tarefas';               Categoria='Consoles MMC';         Comando='taskschd.msc';    Modo='Start'}
    [PSCustomObject]@{Nome='Usuarios e Grupos Locais';           Categoria='Consoles MMC';         Comando='lusrmgr.msc';     Modo='Start'}
    [PSCustomObject]@{Nome='Politica de Seguranca Local';        Categoria='Consoles MMC';         Comando='secpol.msc';      Modo='Start'}
    [PSCustomObject]@{Nome='Editor de Diretiva de Grupo Local';  Categoria='Consoles MMC';         Comando='gpedit.msc';      Modo='Start'}
    [PSCustomObject]@{Nome='Gerenciador de Certificados';        Categoria='Consoles MMC';         Comando='certmgr.msc';     Modo='Start'}
    [PSCustomObject]@{Nome='Firewall com Seguranca Avancada';    Categoria='Consoles MMC';         Comando='wf.msc';          Modo='Start'}
    [PSCustomObject]@{Nome='Monitor de Desempenho';              Categoria='Consoles MMC';         Comando='perfmon.msc';     Modo='Start'}
    [PSCustomObject]@{Nome='Pastas Compartilhadas';              Categoria='Consoles MMC';         Comando='fsmgmt.msc';      Modo='Start'}
    [PSCustomObject]@{Nome='Gerenciamento do WMI';               Categoria='Consoles MMC';         Comando='wmimgmt.msc';     Modo='Start'}

    # Painel de Controle (.cpl)
    [PSCustomObject]@{Nome='Programas e Recursos';               Categoria='Painel de Controle';   Comando='appwiz.cpl';      Modo='Start'}
    [PSCustomObject]@{Nome='Propriedades do Sistema';            Categoria='Painel de Controle';   Comando='sysdm.cpl';       Modo='Start'}
    [PSCustomObject]@{Nome='Conexoes de Rede';                   Categoria='Painel de Controle';   Comando='ncpa.cpl';        Modo='Start'}
    [PSCustomObject]@{Nome='Firewall do Windows';                Categoria='Painel de Controle';   Comando='firewall.cpl';    Modo='Start'}
    [PSCustomObject]@{Nome='Opcoes de Energia';                  Categoria='Painel de Controle';   Comando='powercfg.cpl';    Modo='Start'}
    [PSCustomObject]@{Nome='Configuracoes de Tela (classico)';   Categoria='Painel de Controle';   Comando='desk.cpl';        Modo='Start'}
    [PSCustomObject]@{Nome='Data e Hora';                        Categoria='Painel de Controle';   Comando='timedate.cpl';    Modo='Start'}
    [PSCustomObject]@{Nome='Configuracoes Regionais';            Categoria='Painel de Controle';   Comando='intl.cpl';        Modo='Start'}
    [PSCustomObject]@{Nome='Opcoes da Internet';                 Categoria='Painel de Controle';   Comando='inetcpl.cpl';     Modo='Start'}

    # Diagnostico e Reparo
    [PSCustomObject]@{Nome='Configuracao do Sistema (msconfig)'; Categoria='Diagnostico';           Comando='msconfig';        Modo='Start'}
    [PSCustomObject]@{Nome='Informacoes do Sistema';             Categoria='Diagnostico';           Comando='msinfo32';        Modo='Start'}
    [PSCustomObject]@{Nome='Diagnostico DirectX';                Categoria='Diagnostico';           Comando='dxdiag';          Modo='Start'}
    [PSCustomObject]@{Nome='Monitor de Recursos';                Categoria='Diagnostico';           Comando='resmon';          Modo='Start'}
    [PSCustomObject]@{Nome='Diagnostico de Memoria';             Categoria='Diagnostico';           Comando='mdsched';         Modo='Start'}
    [PSCustomObject]@{Nome='Verificador de Driver';              Categoria='Diagnostico';           Comando='verifier';        Modo='Start'}
    [PSCustomObject]@{Nome='Limpeza de Disco';                   Categoria='Diagnostico';           Comando='cleanmgr';        Modo='Start'}
    [PSCustomObject]@{Nome='Desfragmentador/Otimizador de Disco';Categoria='Diagnostico';           Comando='dfrgui';          Modo='Start'}
    [PSCustomObject]@{Nome='Verificar Arquivos do Sistema (SFC)';Categoria='Diagnostico';           Comando='sfc /scannow';    Modo='CmdK'}

    # Registro e Sistema
    [PSCustomObject]@{Nome='Editor do Registro';                 Categoria='Registro/Sistema';      Comando='regedit';         Modo='Start'}
    [PSCustomObject]@{Nome='Recursos do Windows (ativar/desat.)';Categoria='Registro/Sistema';      Comando='optionalfeatures';Modo='Start'}

    # Rede e Acesso Remoto
    [PSCustomObject]@{Nome='Conexao de Area de Trabalho Remota'; Categoria='Rede/Remoto';           Comando='mstsc';           Modo='Start'}
    [PSCustomObject]@{Nome='Assistencia Remota';                 Categoria='Rede/Remoto';           Comando='msra';            Modo='Start'}

    # Terminal
    [PSCustomObject]@{Nome='Prompt de Comando';                  Categoria='Terminal';              Comando='cmd';             Modo='Start'}
    [PSCustomObject]@{Nome='PowerShell';                         Categoria='Terminal';              Comando='powershell';      Modo='Start'}

    # Pastas rapidas (shell:)
    [PSCustomObject]@{Nome='Pasta de Inicializacao (usuario)';   Categoria='Pastas Rapidas';        Comando='shell:startup';         Modo='Explorer'}
    [PSCustomObject]@{Nome='Inicializacao (todos os usuarios)';  Categoria='Pastas Rapidas';        Comando='shell:common startup';  Modo='Explorer'}
    [PSCustomObject]@{Nome='Pasta Enviar Para';                  Categoria='Pastas Rapidas';        Comando='shell:sendto';          Modo='Explorer'}
    [PSCustomObject]@{Nome='Pasta Temp do Usuario';              Categoria='Pastas Rapidas';        Comando=$env:TEMP;               Modo='Explorer'}
    [PSCustomObject]@{Nome='Lixeira';                            Categoria='Pastas Rapidas';        Comando='shell:recyclebinfolder';Modo='Explorer'}

    # Configuracoes Modernas (ms-settings:)
    [PSCustomObject]@{Nome='Windows Update';                     Categoria='Config. Modernas';      Comando='ms-settings:windowsupdate'; Modo='Start'}
    [PSCustomObject]@{Nome='Status de Rede';                     Categoria='Config. Modernas';      Comando='ms-settings:network-status';Modo='Start'}
    [PSCustomObject]@{Nome='Tela (moderno)';                     Categoria='Config. Modernas';      Comando='ms-settings:display';       Modo='Start'}
    [PSCustomObject]@{Nome='Apps e Recursos';                    Categoria='Config. Modernas';      Comando='ms-settings:appsfeatures';  Modo='Start'}
)

# ------------------------------------------------------------------
# Funcao que efetivamente executa o item selecionado
# ------------------------------------------------------------------
function Invoke-ItemSelecionado {
    param(
        [Parameter(Mandatory)] $Item,
        [bool] $ComoAdmin
    )
    try {
        switch ($Item.Modo) {
            'CmdK' {
                $args = "/k $($Item.Comando)"
                if ($ComoAdmin) {
                    Start-Process -FilePath 'cmd.exe' -ArgumentList $args -Verb RunAs
                } else {
                    Start-Process -FilePath 'cmd.exe' -ArgumentList $args
                }
            }
            'Explorer' {
                Start-Process -FilePath 'explorer.exe' -ArgumentList "`"$($Item.Comando)`""
            }
            default {
                if ($ComoAdmin) {
                    Start-Process -FilePath $Item.Comando -Verb RunAs
                } else {
                    Start-Process -FilePath $Item.Comando
                }
            }
        }
        return $true
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Nao foi possivel abrir '$($Item.Nome)'.`n`nDetalhe: $($_.Exception.Message)",
            'Erro ao executar',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
        return $false
    }
}

# ------------------------------------------------------------------
# Montagem da interface
# ------------------------------------------------------------------
$form                 = New-Object System.Windows.Forms.Form
$form.Text            = 'Toolbox do Tecnico - Atalhos Rapidos'
$form.Size            = New-Object System.Drawing.Size(760, 560)
$form.StartPosition   = 'CenterScreen'
$form.MinimumSize     = New-Object System.Drawing.Size(600, 420)
$form.Font            = New-Object System.Drawing.Font('Segoe UI', 9)

# --- Linha de filtros (categoria + busca) ---
$lblCategoria         = New-Object System.Windows.Forms.Label
$lblCategoria.Text    = 'Categoria:'
$lblCategoria.Location = New-Object System.Drawing.Point(10, 15)
$lblCategoria.AutoSize = $true

$comboCategoria       = New-Object System.Windows.Forms.ComboBox
$comboCategoria.Location = New-Object System.Drawing.Point(80, 12)
$comboCategoria.Width    = 180
$comboCategoria.DropDownStyle = 'DropDownList'
$categoriasUnicas = @('Todas') + ($itens | Select-Object -ExpandProperty Categoria -Unique | Sort-Object)
$comboCategoria.Items.AddRange($categoriasUnicas)
$comboCategoria.SelectedIndex = 0

$lblBusca             = New-Object System.Windows.Forms.Label
$lblBusca.Text        = 'Buscar:'
$lblBusca.Location    = New-Object System.Drawing.Point(280, 15)
$lblBusca.AutoSize    = $true

$textBusca            = New-Object System.Windows.Forms.TextBox
$textBusca.Location   = New-Object System.Drawing.Point(330, 12)
$textBusca.Width      = 260
$textBusca.Anchor     = 'Top,Left,Right'

# --- Lista de ferramentas ---
$listView             = New-Object System.Windows.Forms.ListView
$listView.Location    = New-Object System.Drawing.Point(10, 45)
$listView.Size        = New-Object System.Drawing.Size(720, 400)
$listView.Anchor      = 'Top,Bottom,Left,Right'
$listView.View        = 'Details'
$listView.FullRowSelect = $true
$listView.GridLines   = $true
$listView.MultiSelect = $false
$listView.Columns.Add('Nome', 300)       | Out-Null
$listView.Columns.Add('Categoria', 160)  | Out-Null
$listView.Columns.Add('Comando', 230)    | Out-Null

function Atualizar-Lista {
    $listView.Items.Clear()
    $catSel = $comboCategoria.SelectedItem
    $busca  = $textBusca.Text.Trim().ToLower()

    foreach ($it in $itens) {
        $passaCategoria = ($catSel -eq 'Todas') -or ($it.Categoria -eq $catSel)
        $passaBusca = [string]::IsNullOrEmpty($busca) -or
                      ($it.Nome.ToLower().Contains($busca)) -or
                      ($it.Comando.ToLower().Contains($busca))
        if ($passaCategoria -and $passaBusca) {
            $li = New-Object System.Windows.Forms.ListViewItem($it.Nome)
            $li.SubItems.Add($it.Categoria) | Out-Null
            $li.SubItems.Add($it.Comando)   | Out-Null
            $li.Tag = $it
            $listView.Items.Add($li) | Out-Null
        }
    }
}

$comboCategoria.Add_SelectedIndexChanged({ Atualizar-Lista })
$textBusca.Add_TextChanged({ Atualizar-Lista })

# --- Checkbox Admin ---
$chkAdmin             = New-Object System.Windows.Forms.CheckBox
$chkAdmin.Text        = 'Executar como Administrador'
$chkAdmin.Location    = New-Object System.Drawing.Point(10, 455)
$chkAdmin.AutoSize    = $true
$chkAdmin.Anchor      = 'Bottom,Left'

# --- Status ---
$lblStatus            = New-Object System.Windows.Forms.Label
$lblStatus.Text       = 'Selecione um item e clique em Executar (ou de dois cliques na linha).'
$lblStatus.Location   = New-Object System.Drawing.Point(10, 485)
$lblStatus.Size       = New-Object System.Drawing.Size(500, 20)
$lblStatus.Anchor     = 'Bottom,Left'
$lblStatus.ForeColor  = [System.Drawing.Color]::DimGray

# --- Botoes ---
$btnExecutar          = New-Object System.Windows.Forms.Button
$btnExecutar.Text     = 'Executar'
$btnExecutar.Location = New-Object System.Drawing.Point(520, 480)
$btnExecutar.Size     = New-Object System.Drawing.Size(100, 30)
$btnExecutar.Anchor   = 'Bottom,Right'

$btnFechar            = New-Object System.Windows.Forms.Button
$btnFechar.Text       = 'Fechar'
$btnFechar.Location   = New-Object System.Drawing.Point(630, 480)
$btnFechar.Size       = New-Object System.Drawing.Size(100, 30)
$btnFechar.Anchor     = 'Bottom,Right'

function Executar-Selecionado {
    if ($listView.SelectedItems.Count -eq 0) {
        $lblStatus.Text = 'Selecione um item da lista primeiro.'
        return
    }
    $item = $listView.SelectedItems[0].Tag
    $ok = Invoke-ItemSelecionado -Item $item -ComoAdmin $chkAdmin.Checked
    if ($ok) {
        $lblStatus.Text = "Executado: $($item.Nome)"
    }
}

$btnExecutar.Add_Click({ Executar-Selecionado })
$listView.Add_DoubleClick({ Executar-Selecionado })
$btnFechar.Add_Click({ $form.Close() })

# --- Monta o form ---
$form.Controls.AddRange(@(
    $lblCategoria, $comboCategoria, $lblBusca, $textBusca,
    $listView, $chkAdmin, $lblStatus, $btnExecutar, $btnFechar
))

Atualizar-Lista
[System.Windows.Forms.Application]::Run($form)
