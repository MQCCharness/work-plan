#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q25-产品壁垒分析.md << 'EOF'
# Q25 · 2026-10-04｜Manus / Kimi Code / ZCode / DeepSeek Harness / Today 的壁垒分析

**结论：四类产品四种壁垒，没有一个是「技术本身」：Kimi Code/ZCode=模型垂直整合（模型即产品，自己收税）；DSH=生态默认位（所有人都在它骨架上二开，用户本人做三套主题就是证据）；Manus=品类心智+资本飞轮（第一个名字→融资→工程）；Today=数据沉淀+习惯迁移成本（最弱但最持久）。**

## 对用户的映射

- 模型垂直整合：学不了（没模型厂）
- 生态默认位：可借力不可自建（DSH 主题视频=借位）
- 品牌心智：能——「亲手搭 AI Cube 的工程师」就是品类心智位
- 数据沉淀：远期哈机密用户数据
- 与 Q12 壁垒清单兼容：身份锚点=心智壁垒，案例库/私域=数据沉淀；工具层壁垒是大厂游戏，不需要学

## 验证状态

—（认知分析，无行动项）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q25 · 2026-10-04｜四类产品壁垒分析（Manus/KimiCode/ZCode/DSH）

**结论：壁垒都不在「技术本身」——KimiCode/ZCode=模型垂直整合，DSH=生态默认位，Manus=品类心智+资本飞轮，Today=数据沉淀。用户可学的是心智位（身份锚点）与数据沉淀（案例库/私域），与 Q12 壁垒清单兼容。**

👉 执行细节：[details/Q25-产品壁垒分析.md](details/Q25-产品壁垒分析.md)

---

## Q24"""
t = t.replace("## Q24", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q25: 四类产品壁垒分析（垂直整合/生态位/心智/数据沉淀）" 2>&1 | tail -1
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
