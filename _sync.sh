#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q26-规模游戏与累积游戏.md << 'EOF'
# Q26 · 2026-10-04｜展开解释：为什么规模游戏碰不起、累积游戏够得着

**结论：四种壁垒实为两种游戏。规模游戏（模型层/生态位）入场券是资本与时机，努力不值钱，赢家通吃；累积游戏（心智位/数据沉淀）入场券是唯一性与持续动作，起步慢但差距无捷径可抹平。用户的心智位「亲手搭 Cube 的工程师」已验证（11.9万赞），数据沉淀四池（案例库/知乎长尾/私域/哈机密用户数据）今天开始攒。**

## 要点

- 模型层=造光刻机（资本物理门槛）；生态位=鸡生蛋死结（没人押注无名平台，DSH 靠 DeepSeek 光环+时机）→ 只能借位不能自建
- 心智位：手工耿/何同学/稚晖君的位置都买不来，靠「唯一性+重复」；每条内容往同一个词砸，一年后该词长在身上
- 数据沉淀：案例库（每单+1）、知乎长尾（每篇+1）、私域（每人+信任复利）、哈机密用户数据；对手今天开始也得攒一年
- 行动原则：不做「比大厂强」，做「细分位置的唯一 + 没人开始的最早」；A 版视频发布=同时给心智位和数据沉淀充值

## 验证状态

—（认知校准，无行动项）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q26 · 2026-10-04｜规模游戏 vs 累积游戏（Q25 展开）

**结论：模型层/生态位是规模游戏（资本+时机定胜负，碰不起也不用碰）；心智位/数据沉淀是累积游戏（唯一性+时间复利，够得着）。行动原则：细分位置做唯一，没人开始的事做最早。**

👉 执行细节：[details/Q26-规模游戏与累积游戏.md](details/Q26-规模游戏与累积游戏.md)

---

## Q25"""
t = t.replace("## Q25", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q26: 规模游戏vs累积游戏（心智位与数据沉淀的展开解释）" 2>&1 | tail -1
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
