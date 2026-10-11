$ErrorActionPreference = 'SilentlyContinue'
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
  [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)] public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
  [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
Start-Process cmd.exe -ArgumentList '/k','G:\G_cursor\work-plan\sample\run_demo.bat'
Start-Sleep -Seconds 2
$hwnd = [WinAPI]::FindWindow("ConsoleWindowClass", "LLM_DEMO")
if ($hwnd -eq [IntPtr]::Zero) { $hwnd = [WinAPI]::FindWindow("CASCADIA_HOSTING_WINDOW_CLASS", "LLM_DEMO") }
if ($hwnd -ne [IntPtr]::Zero) {
  [WinAPI]::ShowWindow($hwnd, 3) | Out-Null
  [WinAPI]::MoveWindow($hwnd, 0, 0, 2560, 1440, $true) | Out-Null
  [WinAPI]::SetForegroundWindow($hwnd) | Out-Null
  "moved $hwnd"
} else { "no hwnd" }
