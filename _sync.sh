#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat >> details/Q31-A2工牌开场版分镜.md << 'EOF'

## 型号口径定稿（2026-10-04 补充）

用户确认芯片为 AI Cube 里的**玄戒O3 D100**。公开渠道未能独立核实「D100」后缀的官宣记录 → 口径规则：官方材料（发布会 PPT/官网/官宣新闻）明确写过「玄戒O3 D100」才可照说；否则镜头只说「玄戒O3」，吞掉 D100。

开场台词定稿：
- M1（举工牌 0–5s）：「看清楚了，这不是网图。一个月前，我用我们的玄戒O3芯片，把一个 1200 亿参数的大模型，塞进了我们自己做的 AI Cube 里。」
- M2（放牌 5–10s）：「然后我发现一件更离谱的事——我教公司把 AI 装进盒子，我自己每个月还在给 AI 交 2000 块。」
- 「玄戒O3」「1200 亿」「AI Cube」均为已公开发布信息，安全。
EOF
git add -A
git commit -m "Q31-补: 型号口径定稿（玄戒O3可说，D100按官方口径定夺）" 2>&1 | tail -1
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
