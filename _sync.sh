#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat >> details/Q22-样片v2真实录屏素材.md << 'EOF'

## v4 更新（2026-10-04 深夜，多素材版）

用户指出素材单薄（只有 llama.cpp 一个镜头）→ 新增三类实拍素材并合成 v4（72.7s）：
- **模型文件特写** rec_files.mp4：dir 列出 GLM-4-9B 6.17GB / 32B 19.6GB（「一个模型文件」实证）
- **内存曲线** rec_taskmgr.mp4：资源监视器实拍 32B 加载时物理内存 70%、网络 0（「不联网」实证）
- 结构：S1账单→S2立约→S3a启动加载→**S3b文件特写**→S4a问答演示（41.5 t/s）→**S4b内存曲线**→S5算账→S6钩子

踩坑记录：① cmd 批处理 llama-cli 对话模式会卡在 `>` 等待输入 → 命令尾部加 `< nul` ② Windows Terminal 窗口 FindWindow 按标题失败率高 → 用 Get-Process MainWindowHandle + 重试循环 ③ Taskmgr/resmon 进程默认提权运行，普通 shell 杀不掉也关不掉（MoveWindow/最小化会被还原）→ 拍摄时把自有窗口放右侧区域+裁剪规避 ④ Stop-Process 全杀 cmd 会误杀工具宿主 shell → 只按 MainWindowTitle 精确杀
EOF
rm -f _rec3q.sh _rectm.sh sample/_close_windows.ps1 sample/_park_windows.ps1 sample/_minimize.ps1 sample/_screens.ps1
git add -A
git commit -m "样片v4: 多素材版（+模型文件特写+内存曲线实拍，72.7s）" 2>&1 | tail -1
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 5
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED_PROXY; break; }
  sleep 5
done
cd sample
lark-cli drive +upload --file "A版样片_v4.mp4" --folder-token N9NDf7SzQlAMymdDmGQcAPewnK1 --name "A版样片_v4（多素材版）.mp4" 2>&1 | grep -E '"(ok|url)"' | head -2
