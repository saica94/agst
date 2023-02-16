# Auto Gaming Setting Tool Ver.GUI-1.2.2
$title = "Auto Gaming Setting Tool Ver2.2.2"

# 管理者権限の確認
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$bool_admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# アセンブリの読み込み
try{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
}catch{
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show("Error: 必要なアセンブリをロードできませんでした。`r`n[System.Drawing],[System.Windows.Forms]が読み込めませんでした。")
    exit
}

$exePath = (Get-Process AGST).Path

if(-not $bool_admin){
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show("管理者権限で起動されていない為、実行できません。`r`n管理者権限で実行しますか？","確認","YesNo","Question","Button2")
    if($msgBoxInput -eq "Yes"){
        Start-Process -FilePath $exePath -Verb runAs
    }
    exit
}

# 先に関数定義をしたくないので
$SKIP=$true;iex ((gc $MyInvocation.InvocationName|%{
    if($SKIP -and ($_ -notmatch "^####FuncDef\s*$")){return}
    $SKIP=$false
    $_
})-join "`r`n")

# global変数の定義
 # OSの取得
if((Get-WmiObject Win32_OperatingSystem).caption -like "*Windows 11*"){
    $OS = "Win11"
} else {
    $OS = "Other Win"
}

 # マウス加速関連
$Mouse_acc_Path = "HKCU:\Control Panel\Mouse"
$Mouse_acc_Key1 = "MouseSpeed"
$Mouse_acc_Key2 = "MouseThreshold1"
$Mouse_acc_Key3 = "MouseThreshold2"
 # タスクバー関連
$TaskBar_Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$TaskBar_Size_Key1 = "TaskbarSi"
$TaskIcon_Position_Key1 = "TaskbarAl"
$TaskBar_ClassicMode_Key1 = "Start_ShowClassicMode"
$TaskBar_Search_Disabled_Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
$TaskBar_Search_Disabled_Key1 = "SearchboxTaskbarMode"
$TaskBar_Widged_Key1 = "Taskbarda"
 # XBox Game bar 関連
$XBox_Game_bar_Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR"
$XBox_Game_bar_Key1 = "AppCaptureEnabled"
 # 固定キー関連
$StickyKeys_Path = "HKCU:\Control Panel\Accessibility\StickyKeys"
$StickyKeys_Key1 = "Flags"
 # Windows 広告関連
$AdvertisingInfo_Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
$AdvertisingInfo_Key1 = "Enabled"
$SyncProviderNotif_Key1 = "ShowSyncProviderNotifications"
$ContentDeliver_Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
$ContentDeliver_Key1 = "SubscribedContent-338388Enabled"
$ContentDeliver_Key2 = "SubscribedContent-310093Enabled"
$ContentDeliver_Key3 = "SubscribedContent-338389Enabled"
$LockScreenOverlay_Key1 = "RotatingLockScreenOverlayEnabled"
$UserProfileEngagement_Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
$UserProfileEngagement_Key1 = "ScoobeSystemSettingEnabled"
$Privacy_Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"
$Privacy_Key1 = "TailoredExperiencesWithDiagnosticDataEnabled"
 # ウィンドウのスナップ関連
$Window_snap_Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Window_snap_key1 = "EnableSnapBar"
 # Form コントロールで使うフォント設定
if($OS -eq "Win11"){
    $Font = New-Object System.Drawing.Font("Yu Gothic UI",12,([System.Drawing.FontStyle]::Regular),[System.Drawing.GraphicsUnit]::Pixel)
} elseif($OS -eq "Other Win"){
    $Font = New-Object System.Drawing.Font("Meiryo Gothic UI",12,([System.Drawing.FontStyle]::Regular),[System.Drawing.GraphicsUnit]::Pixel)

}
# メインフォームの設定
$MainForm = New-Object System.Windows.Forms.Form
$MainForm.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
$MainForm.ForeColor = "White"
$MainForm.Size = New-Object System.Drawing.Size(390,260)
$MainForm.AutoScaleDimensions = New-Object System.Drawing.SizeF(96,96)
$MainForm.Text = $title
$MainForm.MaximizeBox = $false
$MainForm.MinimizeBox = $false
$MainForm.FormBorderStyle = "Fixed3D"
$MainForm.ShowIcon = $false
$MainForm.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi
$MainForm.Font = $Font
$MainForm.StartPosition = "CenterScreen"
$MainForm.ShowIcon = $false

# サブフォームの設定
$SubForm = New-Object System.Windows.Forms.Form
$SubForm.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
$SubForm.ForeColor = "White"
$SubForm.Size = New-Object System.Drawing.Size(387,720)
$SubForm.AutoScaleDimensions = New-Object System.Drawing.SizeF(96,96)
$SubForm.Text = "Options"
$SubForm.MaximizeBox = $false
$SubForm.MinimizeBox = $false
$SubForm.FormBorderStyle = "Fixed3D"
$SubForm.ShowIcon = $false
$SubForm.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Dpi
$SubForm.Font = $Font
$SubForm.StartPosition = "CenterScreen"
$SubForm.Visible = $false
$SubForm.Owner = $MainForm

# チェックボックスの設定
 # Google Chrome インストール有無確認
 # チェックボックスの配置
$chkbox = New-Object System.Windows.Forms.CheckBox
$chkbox.Location = New-Object System.Drawing.Point(6,70)
$chkbox.Size = New-Object System.Drawing.Size(356,20)
$chkbox.ForeColor = "White"
$chkbox.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
$chkbox.Text = ("Google Chromeをインストールする")
$chkbox.Checked = $True

# サブフォームボタン用の設定
$OptionsButton = New-Object System.Windows.Forms.Button
$OptionsButton.Location = New-Object System.Drawing.Point(5,5)
$OptionsButton.Size = New-Object System.Drawing.Size(360,30)
$OptionsButton.Text = "オプション"
$OptionsButton.Add_Click({Options_Click})
$OptionsButton.ForeColor = "White"
$OptionsButton.BackColor = [System.Drawing.Color]::FromArgb(65,65,70)
$OptionsButton.FlatStyle = "Flat"

# メインフォームボタンの設定
$AutoRun = New-Object System.Windows.Forms.Button
$AutoRun.Location = New-Object System.Drawing.Point(5,40)
$AutoRun.Size = New-Object System.Drawing.Size(360,30)
$AutoRun.Text = "自動設定開始"
$AutoRun.Add_Click({AutoRun_Click})
$AutoRun.ForeColor = "White"
$AutoRun.BackColor = [System.Drawing.Color]::FromArgb(65,65,70)
$AutoRun.FlatStyle = "Flat"

# テキストボックスの設定
$TextBox = New-Object System.Windows.Forms.RichTextbox
$TextBox.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
$TextBox.Location = New-Object System.Drawing.Point(5,90)
$TextBox.Size = New-Object System.Drawing.Size(360,120)
$TextBox.Multiline = $True
$TextBox.ScrollBars = [Windows.Forms.ScrollBars]::Vertical
$TextBox.BorderStyle = "Fixed3D"
$TextBox.SelectionColor = "White"

# 各コントロールをFormに入れる
$MainForm.Controls.Add($chkbox)
$MainForm.Controls.Add($OptionsButton)
$MainForm.Controls.Add($AutoRun)
$MainForm.Controls.Add($TextBox)


# グループボックスの設定
# マウス加速設定
$Mouse_acc = New-Object System.Windows.Forms.GroupBox
$Mouse_acc.Location = New-Object System.Drawing.Point(5,5)
$Mouse_acc.Size = New-Object System.Drawing.Size(175,100)
$Mouse_acc.Text = "マウス加速"
$Mouse_acc.ForeColor = "White"
# ラジオボタン配置
$accON = New-Object System.Windows.Forms.RadioButton
$accON.Location = New-Object System.Drawing.Point(10,15)
$accON.Size = New-Object System.Drawing.Size(100,30)
$accON.Text = "マウス加速-ON"
$accON.FlatStyle = "Popup"
$accOFF = New-Object System.Windows.Forms.RadioButton
$accOFF.Location = New-Object System.Drawing.Point(10,40)
$accOFF.Size = New-Object System.Drawing.Size(110,30)
$accOFF.Checked = $True
$accOFF.Text = "マウス加速-OFF"
$accOFF.FlatStyle = "Popup"
$accOFF.Checked = $True

# タスクバーサイズ設定
$TaskBar_Size = New-Object System.Windows.Forms.GroupBox
$TaskBar_Size.Location = New-Object System.Drawing.Point(185,5)
$TaskBar_Size.Size = New-Object System.Drawing.Size(175,100)
$TaskBar_Size.Text = "タスクバー"
$TaskBar_Size.ForeColor = "White"
# ラジオボタン配置
$LARGE = New-Object System.Windows.Forms.RadioButton
$LARGE.Location = New-Object System.Drawing.Point(10,15)
$LARGE.Size = New-Object System.Drawing.Size(120,30)
$LARGE.Text = "タスクバーサイズ：大"
$LARGE.FlatStyle = "Popup"
$MEDIUM = New-Object System.Windows.Forms.RadioButton
$MEDIUM.Location = New-Object System.Drawing.Point(10,40)
$MEDIUM.Size = New-Object System.Drawing.Size(120,30)
$MEDIUM.Text = "タスクバーサイズ：中"
$MEDIUM.FlatStyle = "Popup"
$SMALL = New-Object System.Windows.Forms.RadioButton
$SMALL.Location = New-Object System.Drawing.Point(10,65)
$SMALL.Size = New-Object System.Drawing.Size(120,30)
$SMALL.Text = "タスクバーサイズ：小"
$SMALL.FlatStyle = "Popup"
$SMALL.Checked = $True

# スタートメニューの変更
$Start_Menu = New-Object System.Windows.Forms.GroupBox
$Start_Menu.Location = New-Object System.Drawing.Point(5,110)
$Start_Menu.Size = New-Object System.Drawing.Size(175,100)
$Start_Menu.Text = "スタートメニュー"
$Start_Menu.ForeColor = "White"
# ラジオボタン配置
$Win10 = New-Object System.Windows.Forms.RadioButton
$Win10.Location = New-Object System.Drawing.Point(10,15)
$Win10.Size = New-Object System.Drawing.Size(120,30)
$Win10.Text = "Win10 仕様"
$Win10.FlatStyle = "Popup"
$Win10.Checked = $True
$Win11 = New-Object System.Windows.Forms.RadioButton
$Win11.Location = New-Object System.Drawing.Point(10,40)
$Win11.Size = New-Object System.Drawing.Size(120,30)
$Win11.Text = "Win11 仕様"
$Win11.FlatStyle = "Popup"

# XBOX Gamer Barの無効
$XBOX = New-Object System.Windows.Forms.GroupBox
$XBOX.Location = New-Object System.Drawing.Point(185,110)
$XBOX.Size = New-Object System.Drawing.Size(175,100)
$XBOX.Text = "XBOX Game Bar"
$XBOX.ForeColor = "White"
#ラジオボタン配置
$xboxON = New-Object System.Windows.Forms.RadioButton
$xboxON.Location = New-Object System.Drawing.Point(10,15)
$xboxON.Size = New-Object System.Drawing.Size(120,30)
$xboxON.Text = "有効"
$xboxON.FlatStyle = "Popup"
$xboxOFF = New-Object System.Windows.Forms.RadioButton
$xboxOFF.Location = New-Object System.Drawing.Point(10,40)
$xboxOFF.Size = New-Object System.Drawing.Size(120,30)
$xboxOFF.Text = "無効"
$xboxOFF.FlatStyle = "Popup"
$xboxOFF.Checked = $True

# Windows広告の設定
$Ads = New-Object System.Windows.Forms.GroupBox
$Ads.Location = New-Object System.Drawing.Point(5,215)
$Ads.Size = New-Object System.Drawing.Size(175,100)
$Ads.Text = "Windows広告"
$Ads.ForeColor = "White"
#ラジオボタン配置
$adsON = New-Object System.Windows.Forms.RadioButton
$adsON.Location = New-Object System.Drawing.Point(10,15)
$adsON.Size = New-Object System.Drawing.Size(120,30)
$adsON.Text = "有効"
$adsON.FlatStyle = "Popup"
$adsOFF = New-Object System.Windows.Forms.RadioButton
$adsOFF.Location = New-Object System.Drawing.Point(10,40)
$adsOFF.Size = New-Object System.Drawing.Size(120,30)
$adsOFF.Text = "無効"
$adsOFF.FlatStyle = "Popup"
$adsOFF.Checked = $True

# タスクバー検索アイコン
$search = New-Object System.Windows.Forms.GroupBox
$search.Location = New-Object System.Drawing.Point(185,215)
$search.Size = New-Object System.Drawing.Size(175,100)
$search.Text = "検索バー"
$search.ForeColor = "White"
$seaON = New-Object System.Windows.Forms.RadioButton
$seaON.Location = New-Object System.Drawing.Point(10,15)
$seaON.Size = New-Object System.Drawing.Size(120,30)
$seaON.Text = "表示"
$seaON.FlatStyle = "Popup"
$seaOFF = New-Object System.Windows.Forms.RadioButton
$seaOFF.Location = New-Object System.Drawing.Point(10,40)
$seaOFF.Size = New-Object System.Drawing.Size(120,30)
$seaOFF.Text = "非表示"
$seaOFF.FlatStyle = "Popup"
$seaOFF.Checked = $True

# ウィジェットアイコン
$widget = New-Object System.Windows.Forms.GroupBox
$widget.Location = New-Object System.Drawing.Point(5,320)
$widget.Size = New-Object System.Drawing.Size(175,100)
$widget.Text = "ウィジェットアイコン"
$widget.ForeColor = "White"
$widON = New-Object System.Windows.Forms.RadioButton
$widON.Location = New-Object System.Drawing.Point(10,15)
$widON.Size = New-Object System.Drawing.Size(120,30)
$widON.Text = "表示"
$widON.FlatStyle = "Popup"
$widOFF = New-Object System.Windows.Forms.RadioButton
$widOFF.Location = New-Object System.Drawing.Point(10,40)
$widOFF.Size = New-Object System.Drawing.Size(120,30)
$widOFF.Text = "非表示"
$widOFF.FlatStyle = "Popup"
$widOFF.Checked = $true

# ウィンドウスナップ
$snap = New-Object System.Windows.Forms.GroupBox
$snap.Location = New-Object System.Drawing.Point(185,320)
$snap.Size = New-Object System.Drawing.Size(175,100)
$snap.Text = "ウィンドウスナップ"
$snap.ForeColor = "White"
$snapON = New-Object System.Windows.Forms.RadioButton
$snapON.Location = New-Object System.Drawing.Point(10,15)
$snapON.Size = New-Object System.Drawing.Size(120,30)
$snapON.Text = "ON"
$snapON.FlatStyle = "Popup"
$snapOFF = New-Object System.Windows.Forms.RadioButton
$snapOFF.Location = New-Object System.Drawing.Point(10,40)
$snapOFF.Size = New-Object System.Drawing.Size(120,30)
$snapOFF.Text = "OFF"
$snapOFF.FlatStyle = "Popup"
$snapOFF.Checked = $True

# コンテキストメニュー
$contextmenu = New-Object System.Windows.Forms.GroupBox
$contextmenu.Location = New-Object System.Drawing.Point(5,425)
$contextmenu.Size = New-Object System.Drawing.Size(175,100)
$contextmenu.Text = "コンテキストメニュー"
$contextmenu.ForeColor = "White"
$conWin10 = New-Object System.Windows.Forms.RadioButton
$conWin10.Location = New-Object System.Drawing.Point(10,15)
$conWin10.Size = New-Object System.Drawing.Size(120,30)
$conWin10.Text = "Win10"
$conWin10.FlatStyle = "Popup"
$conWin10.Checked = $true
$conWin11 = New-Object System.Windows.Forms.RadioButton
$conWin11.Location = New-Object System.Drawing.Point(10,40)
$conWin11.Size = New-Object System.Drawing.Size(120,30)
$conWin11.Text = "Win11"
$conWin11.FlatStyle = "Popup"

# タスクアイコンの位置
$TaskIconPos = New-Object System.Windows.Forms.GroupBox
$TaskIconPos.Location = New-Object System.Drawing.Point(185,425)
$TaskIconPos.Size = New-Object System.Drawing.Size(175,100)
$TaskIconPos.Text = "タスクアイコンの位置"
$TaskIconPos.ForeColor = "White"
# ラジオボタンの配置
$IconPosLeft = New-Object System.Windows.Forms.RadioButton
$IconPosLeft.Location = New-Object System.Drawing.Point(10,15)
$IconPosLeft.Size = New-Object System.Drawing.Size(120,30)
$IconPosLeft.Text = "左揃え"
$IconPosLeft.FlatStyle = "Popup"
$IconPosLeft.Checked = $True
$IconPosCenter = New-Object System.Windows.Forms.RadioButton
$IconPosCenter.Location = New-Object System.Drawing.Point(10,40)
$IconPosCenter.Size = New-Object System.Drawing.Size(120,30)
$IconPosCenter.Text = "中央揃え"
$IconPosCenter.FlatStyle = "Popup"

# 固定キー設定
$staticKey = New-Object System.Windows.Forms.GroupBox
$staticKey.Location = New-Object System.Drawing.Point(5,530)
$staticKey.Size = New-Object System.Drawing.Size(175,100)
$staticKey.Text = "固定キーショートカット"
$staticKey.ForeColor = "White"
# ラジオボタンの配置
$keyON = New-Object System.Windows.Forms.RadioButton
$keyON.Location = New-Object System.Drawing.Point(10,15)
$keyON.Size = New-Object System.Drawing.Size(120,30)
$keyON.Text = "有効"
$keyON.FlatStyle = "Popup"
$keyOFF = New-Object System.Windows.Forms.RadioButton
$keyOFF.Location = New-Object System.Drawing.Point(10,40)
$keyOFF.Size = New-Object System.Drawing.Size(120,30)
$keyOFF.Text = "無効"
$keyOFF.FlatStyle = "Popup"
$keyOFF.Checked = $True

# 電源プランの変更
$pwr = New-Object System.Windows.Forms.GroupBox
$pwr.Location = New-Object System.Drawing.Point(185,530)
$pwr.Size = New-Object System.Drawing.Size(175,100)
$pwr.Text = "電源プランの変更"
$pwr.ForeColor = "White"
# ラジオボタンの配置
$pwrON = New-Object System.Windows.Forms.RadioButton
$pwrON.Location = New-Object System.Drawing.Point(10,15)
$pwrON.Size = New-Object System.Drawing.Size(120,30)
$pwrON.Text = "変更する"
$pwrON.FlatStyle = "Popup"
$pwrON.Checked = $True
$pwrOFF = New-Object System.Windows.Forms.RadioButton
$pwrOFF.Location = New-Object System.Drawing.Point(10,40)
$pwrOFF.Size = New-Object System.Drawing.Size(120,30)
$pwrOFF.Text = "変更しない"
$pwrOFF.FlatStyle = "Popup"

# 適応ボタンの配置
$apply = New-Object System.Windows.Forms.Button
$apply.Location = New-Object System.Drawing.Point(5,635)
$apply.Size = New-Object System.Drawing.Size(355,30)
$apply.Text = "適応"
$apply.Add_Click({apply_Click})
$apply.ForeColor = "White"
$apply.BackColor = [System.Drawing.Color]::FromArgb(65,65,70)
$apply.FlatStyle = "Flat"

# グループの追加
$Mouse_acc.Controls.AddRange(@($accON,$accOFF))
$SubForm.Controls.Add($Mouse_acc)
if($os -eq "Win11"){
    $TaskBar_Size.Controls.AddRange(@($LARGE,$MEDIUM,$SMALL))
    $SubForm.Controls.Add($TaskBar_Size)
    $Start_Menu.Controls.AddRange(@($Win10,$Win11))
    $SubForm.Controls.Add($Start_Menu)
    $XBOX.Controls.AddRange(@($xboxON,$xboxOFF))
    $SubForm.Controls.Add($XBOX)
    $Ads.Controls.AddRange(@($adsON,$adsOFF))
    $SubForm.Controls.Add($Ads)
    $search.Controls.AddRange(@($seaON,$seaOFF))
    $SubForm.Controls.Add($search)
    $widget.Controls.AddRange(@($widON,$widOFF))
    $SubForm.Controls.Add($widget)
    $snap.Controls.AddRange(@($snapON,$snapOFF))
    $SubForm.Controls.Add($snap)
    $contextmenu.Controls.AddRange(@($conWin10,$conWin11))
    $SubForm.Controls.Add($contextmenu)
    $TaskIconPos.Controls.AddRange(@($IconPosLeft,$IconPosCenter))
    $SubForm.Controls.Add($TaskIconPos)
}
$staticKey.Controls.AddRange(@($keyON,$keyOFF))
$SubForm.Controls.Add($staticKey)
$pwr.Controls.AddRange(@($pwrON,$pwrOFF))
$SubForm.Controls.Add($pwr)
$SubForm.Controls.Add($apply)

# サブフォームのクロージングイベント
$Close = {
    $_.Cancel = $true
    $SubForm.Visible = $false
}
$SubForm.Add_Closing($Close)

# フォームの表示
$MainForm.Showdialog()

####FuncDef
function AutoRun_Click(){
    $TextBox.ForeColor = "White"
    $TextBox.Font = $Font
    if($chkbox.Checked){
        # Google ChromeのDL＆インストール
        $TextBox.AppendText("Google Chrome のダウンロードを行います。`r`n")
        $Path = $env:TEMP
        $Installer = "chrome_installer.exe"
        Invoke-WebRequest "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26browser%3D0%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26brand%3DGTPM/update2/installers/ChromeSetup.exe" -OutFile $Path\$Installer
        $TextBox.AppendText("Google Chrome のインストールを行います。`r`n")
        Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs -Wait
        $TextBox.AppendText("インストーラーの削除を行います。`r`n")
        Remove-Item $Path\$Installer
    }

    if($OFF.Checked){
        $TextBox.AppendText("マウス加速を無効化します。`r`n")
        # キーを更新する
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key1 -Value "0" -Force
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key2 -Value "0" -Force
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key3 -Value "0" -Force
    } else {
        $TextBox.AppendText("マウス加速を有効化します。`r`n")
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key1 -Value "1" -Force
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key2 -Value "1" -Force
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key3 -Value "1" -Force
    }
    if($LARGE.Checked){
        $TextBox.AppendText("タスクバーのサイズを`"大`"に変更します。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_Size_Key1 -Value "2" -Force
    } elseif($MEDIUM.Checked){
        $TextBox.AppendText("タスクバーのサイズを`"中`"に変更します。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_Size_Key1 -Value "1" -Force
    } else {
        $TextBox.AppendText("タスクバーのサイズを`"小`"に変更します。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_Size_Key1 -Value "0" -Force
    }

    if(($OS -eq "Win11") -and ($Win10.Checked)){
        # Windows 10のようなスタートメニューに変更する
        $TextBox.AppendText("Windows10仕様のスタートメニューに変更します。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_ClassicMode_Key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($Win11.Checked)){
        $TextBox.AppendText("Windows11仕様のスタートメニューに変更します。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_ClassicMode_Key1 -Value "1" -Force
    }

    if(($OS -eq "Win11") -and ($seaOFF.Checked)){
        $TextBox.AppendText("タスクバーの検索アイコンを非表示にします。`r`n")
        Set-ItemProperty $TaskBar_Search_Disabled_Path -Name $TaskBar_Search_Disabled_Key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($seaON.Checked)){
        $TextBox.AppendText("タスクバーの検索アイコンを表示します。`r`n")
        Set-ItemProperty $TaskBar_Search_Disabled_Path -Name $TaskBar_Search_Disabled_Key1 -Value "1" -Force
    }

    if(($OS -eq "Win11") -and ($widOFF.Checked)){
        $TextBox.AppendText("タスクバーのウィジェットアイコンを非表示にします。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_Widged_Key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($widON.Checked)){
        $TextBox.AppendText("タスクバーのウィジェットアイコンを表示します。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskBar_Widged_Key1 -Value "1" -Force
    }

    if(($OS -eq "Win11") -and ($snapOFF.Checked)){
        $TextBox.AppendText("ウィンドウスナップの一部機能を無効化します。`r`n")
        Set-ItemProperty $Window_snap_Path -Name $Window_snap_key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($snapON.Checked)){
        $TextBox.AppendText("ウィンドウスナップの一部機能を有効化します。`r`n")
        Set-ItemProperty $Window_snap_Path -Name $Window_snap_key1 -Value "1" -Force
    }

    if(($OS -eq "Win11") -and ($conWin10.Checked)){
        $TextBox.AppendText("コンテキストメニューをWindows10仕様に変更します。`r`n")
        reg add “HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32” /f /ve
    } elseif(($OS -eq "Win11") -and ($conWin11.Checked)){
        $TextBox.AppendText("コンテキストメニューをWindows11仕様に変更します。`r`n")
    }

    if(($OS -eq "Win11") -and ($xboxOFF.Checked)){
        # XBox Game bar の無効化
        $TextBox.AppendText("XBox Game bar を無効化します。`r`n")
        Set-ItemProperty $XBox_Game_bar_Path -Name $XBox_Game_bar_Key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($xboxON.Checked)){
        $TextBox.AppendText("XBOX Game bar を有効化します。`r`n")
        Set-ItemProperty $XBox_Game_bar_Path -Name $Xbox_Game_bar_Key1 -Value "1" -Force
    }

    if(($OS -eq "Win11") -and ($adsOFF.Checked)){
    # Windows 広告の無効化
        $TextBox.AppendText("Windows 広告を無効化します。`r`n")
        Set-ItemProperty $AdvertisingInfo_Path -Name $AdvertisingInfo_Key1 -Value "0" -Force
        Set-ItemProperty $AdvertisingInfo_Path -Name $SyncProviderNotif_Key1 -Value "0" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $ContentDeliver_Key1 -Value "0" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $ContentDeliver_Key2 -Value "0" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $ContentDeliver_Key3 -Value "0" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $LockScreenOverlay_Key1 -Value "0" -Force
        Set-ItemProperty $UserProfileEngagement_Path -Name $UserProfileEngagement_Key1 -Value "0" -Force
        Set-ItemProperty $Privacy_Path -Name $Privacy_Key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($adsON.Checked)){
        $TextBox.AppendText("Windows 広告を有効化します。`r`n")
        Set-ItemProperty $AdvertisingInfo_Path -Name $AdvertisingInfo_Key1 -Value "1" -Force
        Set-ItemProperty $AdvertisingInfo_Path -Name $SyncProviderNotif_Key1 -Value "1" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $ContentDeliver_Key1 -Value "1" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $ContentDeliver_Key2 -Value "1" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $ContentDeliver_Key3 -Value "1" -Force
        Set-ItemProperty $ContentDeliver_Path -Name $LockScreenOverlay_Key1 -Value "1" -Force
        Set-ItemProperty $UserProfileEngagement_Path -Name $UserProfileEngagement_Key1 -Value "1" -Force
        Set-ItemProperty $Privacy_Path -Name $Privacy_Key1 -Value "1" -Force
    }

    $TextBox.AppendText("タスクバーの設定を反映させる為にexplorer.exeを再起動します。`r`n")
    $nid = (Get-Process explorer).id
    Stop-Process -Id $nid
    Wait-Process -Id $nid
    Start-Process "explorer.exe"

    # タスクアイコンの位置を左揃えにする
    if(($OS -eq "Win11") -and ($IconPosLeft.Checked)){
        $TextBox.AppendText("タスクアイコンを左揃えにします。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskIcon_Position_Key1 -Value "0" -Force
    } elseif(($OS -eq "Win11") -and ($IconPosCenter.Checked)){
        $TextBox.AppendText("タスクアイコンを中央揃えにします。`r`n")
        Set-ItemProperty $TaskBar_Path -Name $TaskIcon_Position_Key1 -Value "1" -Force
    }

    # 固定キーの無効化
    if($keyOFF.Checked){
        $TextBox.AppendText("固定キー機能を無効化します。`r`n")
        Set-ItemProperty $StickyKeys_Path -Name $StickyKeys_Key1 -Value "0" -Force
    } else {
        $TextBox.AppendText("固定キー機能を有効化します。`r`n")
        Set-ITemProperty $StickyKeys_Path -Name $StickyKeys_Key1 -Value "1" -Force
    }

    if($pwrON.Checked){
        $TextBox.AppendText("電源プランを変更をします。`r`n")
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
    } else {
        $TextBox.AppendText("電源プランを変更します。`r`n")
        powercfg /hibernate on
        powercfg -setacvalueindex scheme_balanced sub_buttons pbuttonaction 1
        powercfg /setactive scheme_balanced
    }
    $TextBox.AppendText("全ての処理が完了しました。`r`n")
    $TextBox.AppendText("このウィンドウを閉じても構いません。`r`n")
    $TextBox.AppendText("なお、一部の設定を正しく反映させるためにPCの再起動を行ってください。")
}

####FuncDef
function apply_Click(){
    $SubForm.Visible = $false
}

####FuncDef
function Options_Click(){
    $SubForm.Visible = $True
}