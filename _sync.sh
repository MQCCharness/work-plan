#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
old = "- [ ] **本周**：闲鱼挂「本地大模型部署咨询 9.9」链接 + 朋友圈/即刻发免费 30min 名额（30min 可完成）"
new = "- [x] **本周**：闲鱼挂「本地大模型部署咨询 9.9」链接（✅ 2026-10-04 已挂单，三档 9.9/199/500，封面图 sample/xianyu_cover.png）"
if old in t:
    t = t.replace(old, new)
    io.open(p, "w", encoding="utf-8", newline="\n").write(t)
    print("checked")
else:
    print("MISS")
PYEOF
git add -A
git commit -m "里程碑: 闲鱼挂单完成（三档定价+封面图），视频工作安排排定" 2>&1 | tail -1
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 5
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 5
done
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f _qa_feishu.md _cover.py
