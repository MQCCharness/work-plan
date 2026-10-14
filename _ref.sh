#!/bin/bash
cd /g/G_cursor/work-plan/sample/ref
for t in 15.3 15.8 16.2 21.5 25.7 27.2; do
  ffmpeg -y -ss $t -i kaco.mp4 -frames:v 1 "f_${t}.png" 2>/dev/null
done
ls f_*.png
