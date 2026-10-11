@echo off
title LLM_DEMO
echo === Q1: weekly report ===
G:\G_cursor\llama\cuda\llama-cli.exe -m G:\G_cursor\models\GLM-4-9B-0414-Q4_K_M.gguf -ngl 99 -fa on -c 2048 -f G:\G_cursor\work-plan\sample\prompt_weekly.txt -n 150 --temp 0.7 < nul
echo.
echo === Q2: polish text ===
G:\G_cursor\llama\cuda\llama-cli.exe -m G:\G_cursor\models\GLM-4-9B-0414-Q4_K_M.gguf -ngl 99 -fa on -c 2048 -f G:\G_cursor\work-plan\sample\prompt_q2.txt -n 150 --temp 0.7 < nul
echo.
echo === Q3: what is MoE ===
G:\G_cursor\llama\cuda\llama-cli.exe -m G:\G_cursor\models\GLM-4-9B-0414-Q4_K_M.gguf -ngl 99 -fa on -c 2048 -f G:\G_cursor\work-plan\sample\prompt_q3.txt -n 120 --temp 0.7 < nul
echo.
pause
