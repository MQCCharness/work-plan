#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat >> details/Q30-A版真实动机故事.md << 'EOF'

## 标题候选（2026-10-04 用户提案+修正）

- 用户原案：「亲手搭建AI Cube的AI Infra工程师如何解决自己的token账单问题」——方向对（身份+动机），但 infra/token 是行话（违背「说大众听得懂的话」）、超 20 字会被折叠、缺数字钩子
- 首选（抖音）：「亲手搭建小米 AI Cube 的工程师，如何把自己的 AI 账单砍到 0」
- 次选（知乎/公众号）：「一年 2 万 4 的 AI 账单，我用一台游戏本解决了」
- A/B 测试版：「我亲手搭了 AI Cube，却在为 AI 会员费发愁」
EOF
git add -A
git commit -m "Q30-补: 标题候选（用户提案修正版3条）" 2>&1 | tail -1
git push origin main 2>&1 | tail -1
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f _qa_feishu.md
