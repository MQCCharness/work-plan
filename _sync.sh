#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q30-A版真实动机故事.md << 'EOF'
# Q30 · 2026-10-04｜A 版需要真实动机故事：防止「为本地部署而本地部署」

**结论：用户指出 A 版缺真实动机，「省钱是结果不是动机」——正确。修正：开头先讲工作经历中「非本地部署不可」的真实故事（动机是真的），省钱变成白捡的福利。候选故事三选一：A 展会断网窘境 / B 公司保密数据不能上云 / C 德国 IFA 展出客户问断网。待用户确认哪个真发生过并补细节后，改 A2 版逐字稿与知乎稿开头。**

## 要点

- 问题定位：七问第 3/4 问（凭什么信你/关注你）靠真实故事回答；纯省钱叙事有「为拍而拍」味
- 叙事顺序：动机故事（为什么非本地不可）→ 省钱（跟我有什么关系）→ 后面结构不动
- 纪律：只用真发生过的故事，假故事经不起扒；细节糙一点更可信
- 待用户输入：确认 A/B/C 哪个真实 + 补两句现场细节 → 我改 A2 稿

## 验证状态

⬜ 等用户确认真实故事细节
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q30 · 2026-10-04｜A 版需真实动机故事（用户修正）

**结论：省钱是结果不是动机。开头改为工作经历中「非本地部署不可」的真实故事（候选：展会断网/保密数据/IFA 客户问断网），动机是真的、省钱是白捡的。待用户确认真实细节后改 A2 稿。**

👉 执行细节：[details/Q30-A版真实动机故事.md](details/Q30-A版真实动机故事.md)

---

## Q29"""
t = t.replace("## Q29", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q30: A版需要真实动机故事（三候选待用户确认）" 2>&1 | tail -1
sed 's#](details/#](https://github.com/MQCCharness/work-plan/blob/main/details/#g' QA.md > _qa_feishu.md
lark-cli docs +update --api-version v2 --doc "https://ecnbxf2wq712.feishu.cn/docx/YkFJdErLeoD2AQxjUkecoq0vnwg" --command overwrite --doc-format markdown --content @_qa_feishu.md 2>&1 | grep -E '"(ok|result)"' | head -2
rm -f _qa_feishu.md
git push origin main 2>&1 | tail -1
