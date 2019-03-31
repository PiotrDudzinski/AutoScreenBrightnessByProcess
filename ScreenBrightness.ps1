$code = @'
    [DllImport("user32.dll")]
     public static extern IntPtr GetForegroundWindow();
'@
Add-Type $code -Name Utils -Namespace Win32
$Brightness = (Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
while(1)
{
    $hwnd = [Win32.Utils]::GetForegroundWindow()
    $focus = (Get-Process | 
        Where-Object { $_.mainWindowHandle -eq $hwnd } | 
        Select-Object processName, MainWindowTItle, MainWindowHandle).ProcessName

    if($focus -eq 'chrome')
    {
        (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,0)
    }
    else
    {
        (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,$Brightness)
        $Brightness = (Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
    }
    sleep -Milliseconds 200
    Write-Host $focus
}
