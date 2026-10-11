#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q33-四站系列架构.md << 'EOF'
# Q33 · 2026-10-12｜「把 AI 搬到身边」四站系列架构

**结论：本地部署/AI Cube/人生上下文/哈机密 = 同一条故事线的四站：①把 120B 装进盒子（身份锚点）→ ②把 AI 装进每个人自己的电脑（引流+信任）→ ③给 AI 装记忆（情绪共鸣）→ ④给 AI 一个身体（养成追更）。共享信仰：AI 不该住在云端机房里。**

## 三个落地机制

1. 统一片尾「四站地图」进度条：盒子✅→电脑✅→记忆(进行中)→身体(未来)；与哈机密「第 N 天」同一视觉语言
2. 站间互导口播：每条结尾一句话搭桥（A 版→「下一站给它装记忆」；小智→「再下一站给它身体」）
3. 先导片（系列第 0 期，45s 置顶）：「在公司把 1200 亿塞进盒子，回家把 AI 一步步搬到身边」——内容池总入口

## 与既有结构的关系

- 四站=Q32 金字塔的叙事外壳（金字塔管功能分层，四站管故事动线，叠加不冲突）
- A 版标题前缀改「把 AI 搬到身边 · 第二站」，系列从第一条开始注册
- 哈机密 E01「公司造盒子回家造狗」= 四站线的浓缩，一直是对的，现显性化

## 验证状态

⬜ 待执行（A 版发布时改前缀；先导片择机拍）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q33 · 2026-10-12｜「把 AI 搬到身边」四站系列架构

**结论：四项目=同一条线的四站：盒子(身份)→电脑(引流信任)→记忆(共鸣)→身体(养成)。三机制：四站地图片尾进度条、站间互导口播、45s 先导片做池子总入口。A 版前缀改「第二站」开始注册系列。**

👉 执行细节：[details/Q33-四站系列架构.md](details/Q33-四站系列架构.md)

---

## Q32"""
t = t.replace("## Q32", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q33: 四站系列架构（把AI搬到身边：盒子→电脑→记忆→身体）" 2>&1 | tail -1
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
