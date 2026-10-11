#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q29-拍摄顺序与双线策略.md << 'EOF'
# Q29 · 2026-10-04｜先拍本地部署还是小智人生上下文：双线策略

**结论：先拍本地部署 A 版（本周），小智人生上下文排第二条（本月内，理念宣言形态，不等 demo）。A 版=痛点钩子（省钱，需求驱动）导咨询服务收银台；小智=惊奇钩子（AI 记得我，愿景驱动）给哈机密产品线播种。「人生上下文」正是哈机密「记忆成长」功能的概念母体——现在拍小智=提前一年给众筹做世界观铺垫。**

## 要点

- A 版先拍三因：热点时效（48h 法则）、素材就绪（样片 v2 完成）、十月两视频配额
- 小智建议形态：理念宣言「我给 AI 装了我的人生上下文」，素材用 life_context 落库记录截屏，钩子「等它长成狗的样子，你们是看着它长大的人」→ 引流哈机密养成线
- 长期关系：本地部署线=防御/相持期现金流引擎（梯子 1–2 级）；小智/哈机密线=反攻期产品引线（梯子第 4 级，期权播种）

## 验证状态

⬜ A 版待拍摄（等用户口播+账单截图）；小智宣言排期本月第二条
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q29 · 2026-10-04｜先拍本地部署还是小智：双线策略

**结论：先拍 A 版（本周，痛点钩子导咨询收银台）；小智人生上下文第二条（惊奇钩子给哈机密播种，「人生上下文」= 哈机密记忆功能的概念母体）。A 版=现金流引擎，小智=产品引线。**

👉 执行细节：[details/Q29-拍摄顺序与双线策略.md](details/Q29-拍摄顺序与双线策略.md)

---

## Q28"""
t = t.replace("## Q28", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q29: 拍摄顺序（先A版后小智宣言）与双线长期关系" 2>&1 | tail -1
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
rm -f _qa_feishu.md
