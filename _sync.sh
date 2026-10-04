#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat >> .gitignore << 'EOF'
sample/rec_terminal.mp4
sample/segs/
sample/qc/
sample/concat*.txt
sample/rec_ffmpeg.log
EOF
git add -A
git commit -m "Q22: 样片v2（真实录屏替换S3/S4，隐私裁剪+质检通过）" 2>&1 | tail -1
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 3
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 3
done
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f _qa_feishu.md
cd sample
lark-cli drive +upload --file "A版样片_v2.mp4" --folder-token N9NDf7SzQlAMymdDmGQcAPewnK1 --name "A版样片_v2（真实录屏版）.mp4" 2>&1 | grep -E '"(ok|url)"' | head -2
