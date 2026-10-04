#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
rm -f _gen_demo.sh _dbg.sh _qc.sh _tts.py _build_sample.py
cat > .gitignore_sample << 'EOF'
sample/segs/
sample/qc/
sample/assets/*.ttc
sample/assets/raw_*.txt
sample/concat.txt
EOF
cat .gitignore_sample >> .gitignore 2>/dev/null || true
rm .gitignore_sample
git add -A
git commit -m "Q21: A版样片v1合成完成（TTS+9B真实演示，66s质检通过）" 2>&1 | tail -1
for i in 1 2 3 4; do
  out=$(git push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 3
  out=$(git -c http.proxy=http://127.0.0.1:17891 push origin main 2>&1 | tail -1)
  echo "$out" | grep -q "main -> main\|up-to-date" && { echo PUSHED; break; }
  sleep 3
done
# Feishu QA doc sync
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f _qa_feishu.md
# Upload sample video to Feishu folder
cd sample
lark-cli drive +upload --file "A版样片_v1.mp4" --folder-token N9NDf7SzQlAMymdDmGQcAPewnK1 --name "A版样片_v1（笔记本跑大模型·省钱叙事）.mp4" 2>&1 | grep -E '"(ok|url)"' | head -2
