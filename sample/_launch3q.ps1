$ErrorActionPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI3 {
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
# kill leftover demo windows
Get-Process cmd,WindowsTerminal -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like '*LLM_DEMO*' } | Stop-Process -Force
Start-Process cmd.exe -ArgumentList '/k','G:\G_cursor\work-plan\sample\run_3q.bat'
$hwnd = [IntPtr]::Zero
for ($i = 0; $i -lt 10 -and $hwnd -eq [IntPtr]::Zero; $i++) {
  Start-Sleep -Seconds 1
  $p = Get-Process cmd,WindowsTerminal -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like '*LLM_DEMO*' } | Select-Object -First 1
  if ($p) { $hwnd = $p.MainWindowHandle }
}
if ($hwnd -ne [IntPtr]::Zero) {
  [WinAPI3]::ShowWindow($hwnd, 3) | Out-Null
  [WinAPI3]::MoveWindow($hwnd, 0, 0, 2560, 1440, $true) | Out-Null
  [WinAPI3]::SetForegroundWindow($hwnd) | Out-Null
  "moved $hwnd"
} else { "no hwnd after 10s" }
