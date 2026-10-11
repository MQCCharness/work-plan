#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q32-内容池金字塔.md << 'EOF'
# Q32 · 2026-10-12｜内容池缺乏系列深度：金字塔结构 + 合集化

**结论：用户发现内容缺系列池子缺深度——诊断正确。深度=主题下内容互相咬合而非单条深。解法：三层金字塔（引流层热点情绪/信任层实测教程/收藏层体系化工具帖）+ 统一系列前缀「第N期」+ 抖音合集 + 拍前第八问「这条挂在内容池哪根枝上」（挂不上不拍）。**

## 要点

- 病因补充：47 条散点内容是「关注转化崩」的另一半原因（Q6 补充）——观众没有理由翻第二条
- 收藏层=知乎/公众号/置顶合集，不追播放追收藏率与搜索长尾（B 端获客地基，接 Q10）
- 池子=Q26 累积游戏在内容侧的具象化：每条新内容给旧内容导流
- 第一期池子骨架：本地跑大模型（A→B→C→进阶）/ 芯片工程师回家作业（T 系列知乎）/ 电子狗养成（E01–E06）/ 答网友问（私信驱动）

## 验证状态

⬜ 待执行（A 版发布时统一加「第 1 期」前缀并建合集）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q32 · 2026-10-12｜内容池缺乏系列深度：金字塔+合集化方案

**结论：深度=主题内互相咬合而非单条深。三层金字塔（引流/信任/收藏）+ 系列前缀「第N期」+ 抖音合集 + 拍前第八问「挂哪根枝上」（挂不上不拍）。池子是累积游戏在内容侧的具象化。**

👉 执行细节：[details/Q32-内容池金字塔.md](details/Q32-内容池金字塔.md)

---

## Q31"""
t = t.replace("## Q31", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q32: 内容池金字塔（三层结构+系列前缀+合集+拍前第八问）" 2>&1 | tail -1
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
