#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q35-ESP32控iPhone热点视频方案.md << 'EOF'
# Q35 · 2026-10-13｜ESP32-S3 直控 iPhone 热点跟拍方案

**结论：热点视频（算力炼丹炉，2026-10-12 发，数小时 8142 赞/4244 收藏）跟拍方案定稿：「我把十几块的 ESP32 接上了 iPhone，顺手答了评论区的三个质疑」。机制=BLE HID 模拟键盘鼠标（GitHub: esp32-iphone-agent）。属四站系列「第四站」前哨——与哈机密「狗打字」同技术底座。48h 内跟上最佳。**

## 侦察数据

- 原视频：8142 赞/370 评/4244 藏/2405 转（收藏>点赞=实用型爆款形态）
- 评论区三大质疑（内容富矿）：费 Token（100 赞）/ 只能当玩具做不了精细操作 / 手机自带 AI 不就行了
- 技术机制：ESP32-S3 BLE HID 模拟键鼠 + LLM Agent 指挥

## 视频结构（四拍）

- 成果前置 3s：板子连手机自动打字实拍
- 拆解 15s：BLE HID 一句话原理 + 实测能力边界
- 答质疑 20s：①token 消耗实测数字 ②玩具边界诚实说（HID 只能输入不能读屏，读屏要截图回传）③「自带 AI 是哑巴不会动手，这是外挂的手」
- 钩子 5s：「这块板子正在长身体——关注看第四站」

## 素材分工

- 用户：ESP32+iPhone 实拍、评论区质疑截图
- AI：esp32-iphone-agent 项目技术拆解文档、逐字稿骨架

## 验证状态

⬜ 待执行（用户确认后我出技术拆解文档）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q35 · 2026-10-13｜ESP32 直控 iPhone 热点跟拍方案

**结论：跟拍今日热点（算力炼丹炉 8k 赞实用型爆款）：「我把十几块的 ESP32 接上了 iPhone，顺手答了评论区三个质疑」。机制=BLE HID+Agent（esp32-iphone-agent）。第四站前哨，与哈机密狗打字同底座，48h 内跟上。**

👉 执行细节：[details/Q35-ESP32控iPhone热点视频方案.md](details/Q35-ESP32控iPhone热点视频方案.md)

---

## Q34"""
t = t.replace("## Q34", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q35: ESP32控iPhone热点跟拍方案（第四站前哨，答评论区三质疑）" 2>&1 | tail -1
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 5
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED_PROXY; break; }
  sleep 5
done
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f _qa_feishu.md
