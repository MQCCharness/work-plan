$ErrorActionPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI8 {
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@
Start-Process cmd.exe -ArgumentList '/k','G:\G_cursor\work-plan\sample\run_files.bat'
$hwnd = [IntPtr]::Zero
for ($i = 0; $i -lt 10 -and $hwnd -eq [IntPtr]::Zero; $i++) {
  Start-Sleep -Seconds 1
  $p = Get-Process cmd,WindowsTerminal -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like '*LLM_FILES*' } | Select-Object -First 1
  if ($p) { $hwnd = $p.MainWindowHandle }
}
if ($hwnd -ne [IntPtr]::Zero) {
  [WinAPI8]::MoveWindow($hwnd, 1000, 40, 1500, 1340, $true) | Out-Null
  [WinAPI8]::SetForegroundWindow($hwnd) | Out-Null
  "moved"
} else { "no hwnd" }
