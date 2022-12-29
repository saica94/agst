# Auto Gaming Setting Tool Ver.GUI-1.1.1

# 管理者権限の確認
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$bool_admin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# アセンブリの読み込み
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# 先に関数定義をしたくないので
$SKIP=$true;iex ((gc $MyInvocation.InvocationName|%{
    if($SKIP -and ($_ -notmatch "^####FuncDef\s*$")){return}
    $SKIP=$false
    $_
})-join "`r`n")

# global変数の定義
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

# フォームの設定
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(390,310)
$Form.Text = "Auto Gaming Setting Tool Ver1.1.0"
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.FormBorderStyle = "Fixed3D"
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
$TaskBar_Size = New-Object System.Windows.Forms.GroupBox
$TaskBar_Size.Location = New-Object System.Drawing.Point(185,5)
$TaskBar_Size.Size = New-Object System.Drawing.Size(180,100)
$TaskBar_Size.Text = "タスクバー設定"
 # ラジオボタン配置
$LARGE = New-Object System.Windows.Forms.RadioButton
$LARGE.Location = New-Object System.Drawing.Point(10,15)
$LARGE.Size = New-Object System.Drawing.Size(120,30)
$LARGE.Text = "タスクバーサイズ：大"
$MEDIUM = New-Object System.Windows.Forms.RadioButton
$MEDIUM.Location = New-Object System.Drawing.Point(10,40)
$MEDIUM.Size = New-Object System.Drawing.Size(120,30)
$MEDIUM.Text = "タスクバーサイズ：中"
$MEDIUM.Checked = $True
$SMALL = New-Object System.Windows.Forms.RadioButton
$SMALL.Location = New-Object System.Drawing.Point(10,65)
$SMALL.Size = New-Object System.Drawing.Size(120,30)
$SMALL.Text = "タスクバーサイズ：小"

# グループにラジオボタンを入れる
$Mouse_acc.Controls.AddRange(@($ON,$OFF))
$TaskBar_Size.Controls.AddRange(@($LARGE,$MEDIUM,$SMALL))
$Form.Controls.Add($Mouse_acc)
$Form.Controls.Add($TaskBar_Size)

# テキストボックスの設定
$TextBox = New-Object System.Windows.Forms.RichTextbox
$TextBox.Location = New-Object System.Drawing.Point(5,140)
$TextBox.Size = New-Object System.Drawing.Size(360,120)
$TextBox.Multiline = $True
$TextBox.ScrollBars = [Windows.Forms.ScrollBars]::Vertical
$Form.Controls.Add($TextBox)
$TextBox.SelectionColor = "Red"
if($bool_admin){
    $TextBox.AppendText("管理者権限で実行されています。`r`n")
} else {
    $TextBox.AppendText("管理者権限で起動されていない為、一部の設定を変更できません。`r`n")
    $TextBox.SelectionColor = "Red"
    $TextBox.AppendText("全ての設定を正しく変更する為に、管理者権限で実行しなおして下さい。`r`n")
}

# フォームの表示
$Form.Icon = $MyIcon
$Form.Add_Shown({$Form.Activate()})
$DialogResult = $Form.ShowDialog()

####FuncDef
function Btn_Click(){
    $TextBox.SelectionColor = "Black"
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
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key1 -Value "0" -Force
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key2 -Value "0" -Force
        Set-ItemProperty $Mouse_acc_Path -name $Mouse_acc_Key3 -Value "0" -Force
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

    # Windows 10のようなスタートメニューに変更する
    $TextBox.AppendText("Windows10仕様のスタートメニューに変更します。`r`n")
    Set-ItemProperty $TaskBar_Path -Name $TaskBar_ClassicMode_Key1 -Value "0" -Force
    $TextBox.AppendText("タスクバーの検索アイコンを非表示にします。`r`n")
    Set-ItemProperty $TaskBar_Search_Disabled_Path -Name $TaskBar_Search_Disabled_Key1 -Value "0" -Force
    $TextBox.AppendText("タスクバーのウィジェットアイコンを非表示にします。`r`n")
    Set-ItemProperty $TaskBar_Path -Name $TaskBar_Widged_Key1 -Value "0" -Force
    # XBox Game bar の無効化
    $TextBox.AppendText("XBox Game bar を無効化します。`r`n")
    Set-ItemProperty $XBox_Game_bar_Path -Name $XBox_Game_bar_Key1 -Value "0" -Force

    # 固定キーの無効化
    $TextBox.AppendText("固定キー機能を無効化します。`r`n")
    Set-ItemProperty $StickyKeys_Path -Name $StickyKeys_Key1 -Value "0" -Force

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

    $TextBox.AppendText("タスクバーの設定を反映させる為にexplorer.exeを再起動します。`r`n")
    $nid = (Get-Process explorer).id

    Stop-Process -Id $nid
    Wait-Process -Id $nid
    Start-Process "explorer.exe"

    # タスクバーの位置を左揃えにする
    $TextBox.AppendText("タスクアイコンを左揃えにします。`r`n")
    Set-ItemProperty $TaskBar_Path -Name $TaskIcon_Position_Key1 -Value "0" -Force

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