$ErrorActionPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI6 {
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
Start-Process resmon.exe
$hwnd = [IntPtr]::Zero
for ($i = 0; $i -lt 10 -and $hwnd -eq [IntPtr]::Zero; $i++) {
  Start-Sleep -Seconds 1
  $p = Get-Process perfmon -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($p) { $hwnd = $p.MainWindowHandle }
}
if ($hwnd -ne [IntPtr]::Zero) {
  [WinAPI6]::ShowWindow($hwnd, 3) | Out-Null
  [WinAPI6]::MoveWindow($hwnd, 0, 0, 2560, 1440, $true) | Out-Null
  [WinAPI6]::SetForegroundWindow($hwnd) | Out-Null
  "perfmon moved"
} else { "no hwnd" }
