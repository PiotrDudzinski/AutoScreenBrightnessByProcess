$code = @'
    [DllImport("user32.dll")]
     public static extern IntPtr GetForegroundWindow();
'@
Add-Type $code -Name Utils -Namespace Win32
$prevBrig = (Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
while(1)
{
    $hwnd = [Win32.Utils]::GetForegroundWindow()
    $focus = (Get-Process | 
        Where-Object { $_.mainWindowHandle -eq $hwnd } | 
        Select-Object processName, MainWindowTItle, MainWindowHandle).ProcessName

    if($focus -eq 'chrome')
    {
      if((Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness -ne 0)
        {
            $prevBrig = (Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness
        }
      (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,0)
    }
    else
    {
        if((Get-Ciminstance -Namespace root/WMI -ClassName WmiMonitorBrightness).CurrentBrightness -eq 0)
            {
                (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1, $prevBrig)
            }
    }
    sleep -Milliseconds 200
    Write-Host $focus
}

