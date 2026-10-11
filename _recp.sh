#!/bin/bash
cd /g/G_cursor/work-plan/sample
rm -f rec_primary.mp4
# record ONLY primary monitor: offset 0,0 size 2560x1440
ffmpeg -y -f gdigrab -framerate 15 -offset_x 0 -offset_y 0 -video_size 2560x1440 -i desktop \
  -t 45 -c:v libx264 -preset ultrafast -crf 22 -pix_fmt yuv420p rec_primary.mp4 > rec_p.log 2>&1 &
REC_PID=$!
sleep 3
powershell -NoProfile -ExecutionPolicy Bypass -File "G:\G_cursor\work-plan\sample\_launch.ps1"
wait $REC_PID
sleep 1
powershell -NoProfile -Command "Get-Process cmd -ErrorAction SilentlyContinue | Where-Object {\$_.MainWindowTitle -like '*LLM_DEMO*'} | Stop-Process -Force" 2>/dev/null
ffprobe -v quiet -show_entries stream=width,height -of csv=p=0 rec_primary.mp4
ffmpeg -y -ss 15 -i rec_primary.mp4 -frames:v 1 qc/recp_15.png 2>/dev/null
ffmpeg -y -ss 30 -i rec_primary.mp4 -frames:v 1 qc/recp_30.png 2>/dev/null
echo done
