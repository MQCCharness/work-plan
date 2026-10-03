#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result|revision_id)"' | head -3
rm -f _qa_feishu.md
git add -A
git commit -m "chore: 清理误提交临时文件" 2>&1 | tail -1
out=$(git push origin main 2>&1 | tail -1); echo "$out" | grep -q "main -> main\|up-to-date" && echo PUSHED || { sleep 3; git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1; }
