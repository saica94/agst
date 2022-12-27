﻿# Auto Gaming Setting Tool Ver.GUI-1.1.0

# アセンブリの読み込み
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# 先に関数定義をしたくないので
$SKIP=$true;iex ((gc $MyInvocation.InvocationName|%{
    if ($SKIP -and ($_ -notmatch "^####FuncDef\s*$")){return}
    $SKIP=$false
    $_
})-join "`r`n")

# global変数の定義
 # マウス加速関連
$Mouse_acc_path = "HKCU:\Control Panel\Mouse"
$Mouse_acc_key1 = "MouseSpeed"
$Mouse_acc_key2 = "MouseThreshold1"
$Mouse_acc_key3 = "MouseThreshold2"
 # タスクバー関連
$Taskbar_size_path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Taskbar_size_key1 = "TaskbarSi"

# フォームの設定
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(390,310)
$Form.Text = "Auto Gaming Setting Tool Ver1.1.0"
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.FormBorderStyle = "Fixed3D"
#$Form.ShowInTaskbar = $false
$Form.ShowIcon = $false

# ボタンの設定
$Button = New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Point(5,107)
$Button.Size = New-Object System.Drawing.Size(360,30)
$Button.Text = "自動設定開始"
$Form.Controls.Add($Button)
$Button.Add_Click({Btn_Click})

# ラジオボックスの設定
 # マウス加速
 # グループの設定
$Mouse_acc = New-Object System.Windows.Forms.GroupBox
$Mouse_acc.Location = New-Object System.Drawing.Point(5,5)
$Mouse_acc.Size = New-Object System.Drawing.Size(175,100)
$Mouse_acc.Text = "マウス加速設定"
 # ラジオボタン配置
$ON = New-Object System.Windows.Forms.RadioButton
$ON.Location = New-Object System.Drawing.Point(10,15)
$ON.Size = New-Object System.Drawing.Size(100,30)
$ON.Text = "マウス加速-ON"
$OFF = New-Object System.Windows.Forms.RadioButton
$OFF.Location = New-Object System.Drawing.Point(10,40)
$OFF.Size = New-Object System.Drawing.Size(110,30)
$OFF.Checked = $True
$OFF.Text = "マウス加速-OFF"

 # タスクバー変更
 # グループの設定
$Taskbar_size = New-Object System.Windows.Forms.GroupBox
$Taskbar_size.Location = New-Object System.Drawing.Point(185,5)
$Taskbar_size.Size = New-Object System.Drawing.Size(180,100)
$Taskbar_size.Text = "タスクバー設定"
 # ラジオボタン配置
$LAR = New-Object System.Windows.Forms.RadioButton
$LAR.Location = New-Object System.Drawing.Point(10,15)
$LAR.Size = New-Object System.Drawing.Size(120,30)
$LAR.Text = "タスクバーサイズ：大"
$MID = New-Object System.Windows.Forms.RadioButton
$MID.Location = New-Object System.Drawing.Point(10,40)
$MID.Size = New-Object System.Drawing.Size(120,30)
$MID.Text = "タスクバーサイズ：中"
$MID.Checked = $True
$SMA = New-Object System.Windows.Forms.RadioButton
$SMA.Location = New-Object System.Drawing.Point(10,65)
$SMA.Size = New-Object System.Drawing.Size(120,30)
$SMA.Text = "タスクバーサイズ：小"

# グループにラジオボタンを入れる
$Mouse_acc.Controls.AddRange(@($ON,$OFF))
$Taskbar_size.Controls.AddRange(@($LAR,$MID,$SMA))
$Form.Controls.Add($Mouse_acc)
$Form.Controls.Add($Taskbar_size)
# $Form.TopMost

# テキストボックスの設定
$TextBox = New-Object System.Windows.Forms.Textbox
$TextBox.Location = New-Object System.Drawing.Point(5,140)
$TextBox.Size = New-Object System.Drawing.Size(360,120)
$TextBox.Multiline = $True
$TextBox.ScrollBars = [Windows.Forms.ScrollBars]::Vertical
$Form.Controls.Add($TextBox)

# フォームの表示
$Form.Icon = $MyIcon
$Form.Add_Shown({$Form.Activate()})
$Form.TopMost = $True
$DialogResult = $Form.ShowDialog()

####FuncDef
function Btn_Click(){
    # Google ChromeのDL＆インストール
    $TextBox.AppendText("Google Chrome のダウンロードを行います。`r`n")
    $Path = $env:TEMP
    $Installer = "chrome_installer.exe"
    Invoke-WebRequest "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26browser%3D0%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26brand%3DGTPM/update2/installers/ChromeSetup.exe" -OutFile $Path\$Installer
    $TextBox.AppendText("Google Chrome のインストールを行います。`r`n")
    Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait
    $TextBox.AppendText("インストーラーの削除を行います。`r`n")
    Remove-Item $Path\$Installer

    if($OFF.Checked){
        $TextBox.AppendText("マウス加速を切ります。`r`n")
        # キーを更新する
        Set-ItemProperty $Mouse_acc_path -name $Mouse_acc_key1 -value "0" -Force
        Set-ItemProperty $Mouse_acc_path -name $Mouse_acc_key2 -value "0" -Force
        Set-ItemProperty $Mouse_acc_path -name $Mouse_acc_key3 -value "0" -Force
    }

    if($LAR.Checked){
        $TextBox.AppendText("タスクバーのサイズを`"大`"に変更します。`r`n")
        Set-ItemProperty $Taskbar_size_path -Name $Taskbar_size_key1 -Value "2" -Force
    } elseif($MID.Checked){
        $TextBox.AppendText("タスクバーのサイズを`"中`"に変更します。`r`n")
        Set-ItemProperty $Taskbar_size_path -Name $Taskbar_size_key1 -Value "1" -Force
    } else {
        $TextBox.AppendText("タスクバーのサイズを`"小`"に変更します。`r`n")
        Set-ItemProperty $Taskbar_size_path -Name $Taskbar_size_key1 -Value "0" -Force
    }
    $TextBox.AppendText("タスクバーの設定を反映させる為にexplorer.exeを再起動します。`r`n")
    $nid = (Get-Process explorer).id

    Stop-Process -Id $nid
    Wait-Process -Id $nid
    Start-Process "explorer.exe"

    $TextBox.AppendText("電源プランの変更をします。`r`n")
    $TextBox.AppendText("一部のRyzen CPUではこの処理はスキップされます。`r`n")
    # 電源プランの変更
    $ReturnData = New-Object PSObject | Select-Object CPUName
    $Win32_Processor = Get-WmiObject Win32_Processor
    $ReturnData.CPUName = @($Win32_Processor.Name)[0]
    if ($ReturnData.CPUName -Like "AMD Ryzen * 5**0*") {
        # 休止状態を無効にし、高速スタートアップを自動的に無効化させる
        powercfg /hibernate off
        powercfg -setacvalueindex scheme_balanced sub_buttons pbuttonaction 3
    } else {
        # 電源プランを高パフォーマンスに変更
        powercfg /setactive scheme_min
        powercfg /hibernate off
        powercfg -setacvalueindex scheme_min sub_buttons pbuttonaction 3
    }
    $TextBox.AppendText("全ての処理が完了しました。`r`n")
    $TextBox.AppendText("このウィンドウを閉じても構いません。`r`n")
    $TextBox.AppendText("なお、一部の設定を正しく反映させるためにPCの再起動を行ってください。")
}