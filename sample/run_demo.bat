@echo off
chcp 65001 >nul
title LLM_DEMO
G:\G_cursor\llama\cuda\llama-cli.exe -m G:\G_cursor\models\GLM-4-9B-0414-Q4_K_M.gguf -ngl 99 -fa on -c 2048 -f G:\G_cursor\work-plan\sample\prompt_weekly.txt -n 220 --temp 0.7
echo.
pause
