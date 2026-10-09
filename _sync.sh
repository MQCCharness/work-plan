#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q23-资本撤出半导体AI辨析.md << 'EOF'
# Q23 · 2026-10-04｜「资本正在从半导体和 AI 撤出」辨析

**结论：不准确。截至 2026-10-04 无任何权威信源报道系统性撤出；同期事实全是反方向（Manus 5 亿美元、Jev 百亿估值、AMD 550 亿收购、诺因 10 亿、大厂 capex 加码）。真实内核是「迁移」：钱从讲 AI 故事转向 AI 落地现金流——恰好在我们的赛道上。**

## 查证

- 中文搜索未找到「资本撤出半导体/AI」的权威报道（Bing CN 搜索退化，无量化数据支持该说法）
- 反方证据（本周）：Manus 获 5 亿美元融资重启北京办公室；Jev 估值 100 亿美元；AMD 550 亿收购李飞飞公司；诺因智能一年 5 轮累计 10 亿+；GPT-6.1 发布大厂 capex 加码

## 说法的可能来源（真实但被讲歪）

1. 二级市场股价回调 ≠ 一级市场撤出
2. 「讲故事的钱在撤，有收入的钱在进」（MIT 95% GenAI 试点失败报告后，纯叙事应用层死了一批）
3. 半导体内部分化：消费电子弱 vs AI 算力强

## 对本计划的影响

- 资本迁移方向 = 落地侧 = 我们的赛道（端侧部署/省钱方案/企业服务）
- 计划结构（零垫资+现金流优先）天然抗周期，宏观叙事不影响执行层
- 真要融资是 2027+ 的事，届时看的是案例和收入，不是叙事热度

## 验证状态

—（认知校准，无行动项）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q23 · 2026-10-04｜「资本正在从半导体和 AI 撤出」辨析

**结论：不准确，真实内核是「迁移」——钱从讲 AI 故事转向 AI 落地现金流，恰好在我们的赛道上；本计划零垫资结构天然抗周期。**

👉 执行细节：[details/Q23-资本撤出半导体AI辨析.md](details/Q23-资本撤出半导体AI辨析.md)

---

## Q22"""
t = t.replace("## Q22", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("inserted")
PYEOF
git add -A
git commit -m "Q23: 资本撤出半导体AI辨析（实为向落地侧迁移）" 2>&1 | tail -1
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
