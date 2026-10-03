#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
rm -f QA.md.bak.split
git add -A
git commit -m "重构: QA分级目录（索引层+details细节层），README同步更新" 2>&1 | tail -2
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 3
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 3
done
# Feishu version: rewrite relative detail links to absolute GitHub URLs
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > /tmp/qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @/tmp/qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f /tmp/qa_feishu.md
