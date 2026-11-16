# nvimtree上に、`,iv` コマンドを追加

1. windowsのクリップボードの画像を一時ファイルに保存
powershell.exe -command 'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::GetImage().Save("C:\temp\clip.png")'

2. nvimtree上で、`,iv`を実行されたホルダに`{timestamp}.png`でファイル移動
