#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat >> details/Q22-样片v2真实录屏素材.md << 'EOF'

## v3 更新（2026-10-04 晚间）

用户要求只录主显示器：gdigrab `-offset_x 0 -offset_y 0 -video_size 2560x1440` 直录主屏（DISPLAY5），FindWindow(ConsoleWindowClass,"LLM_DEMO") 强制窗口铺满主屏。产出 rec_primary.mp4（45s，41.5 t/s 实测行可见），S3/S4 换用全屏素材无需裁剪，S3 起点 8.0s 避开桌面闪现。最终版 `sample/A版样片_v3.mp4`（66.2s），抽帧终检通过。
EOF
git add -A
git commit -m "样片v3: 主显示器全屏录屏素材（rec_primary.mp4, 41.5t/s）" 2>&1 | tail -1
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 5
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED_PROXY; break; }
  sleep 5
done
cd sample
lark-cli drive +upload --file "A版样片_v3.mp4" --folder-token N9NDf7SzQlAMymdDmGQcAPewnK1 --name "A版样片_v3（主屏全屏录屏版）.mp4" 2>&1 | grep -E '"(ok|url)"' | head -2
