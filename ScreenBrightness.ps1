$code = @'
    [DllImport("user32.dll")]
     public static extern IntPtr GetForegroundWindow();
'@
Add-Type $code -Name Utils -Namespace Win32
while(1){
    $hwnd = [Win32.Utils]::GetForegroundWindow()
    $focus = (Get-Process | 
        Where-Object { $_.mainWindowHandle -eq $hwnd } | 
        Select-Object processName, MainWindowTItle, MainWindowHandle).ProcessName
    sleep -Milliseconds 200
    if($focus -eq 'chrome')
    {
        (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,0)
    }
    else
    {
        (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,70)
    }
    Write-Host $focus
}
