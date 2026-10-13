#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat >> details/Q35-ESP32控iPhone热点视频方案.md << 'EOF'

## 技术拆解已完成（2026-10-13）

产出 [esp32-iphone-agent拆解.md](../esp32-iphone-agent拆解.md)：三段式架构（AirPlay 眼/USB HID 手/任意视觉模型脑）、物料清单（XIAO ESP32S3 ¥40-50 + Orin 跑服务端规避 Windows 不支持问题）、复现四步、拍摄要点（step wall 红圈动画必拍、token 实测法、边界诚实讲）。

**关键联动发现**：大脑可接本地模型——「费 token？我接的是自己免费的模型」一句话同时答评论区质疑① + 联动 A 版省钱叙事。服务端需 macOS/Linux → 用家里 Orin 跑。
EOF
git add -A
git commit -m "Q35-补: esp32-iphone-agent技术拆解文档完成" 2>&1 | tail -1
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
cd /g/G_cursor/work-plan && lark-cli drive +upload --file "esp32-iphone-agent拆解.md" --folder-token N9NDf7SzQlAMymdDmGQcAPewnK1 --name "esp32-iphone-agent技术拆解.md" 2>&1 | grep -E '"(ok|url)"' | head -2
