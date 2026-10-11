#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q34-系列七问答卷.md << 'EOF'
# Q34 · 2026-10-12｜四站系列 × 拍前七问：系列版答卷

**结论：系列化后七问无一项变弱，第 3/5/7 问显著变强。单条回答问题，系列回答「我为什么值得长期存在」。**

## 答卷

1. 服务谁：单条守纪律（三选一），系列分工（二站大众/客户，三站情绪，四站养成，一站背书）
2. 前 3 秒：工牌实拍「看清楚了，这不是网图」+ 1200 亿数字
3. 关注理由：四站地图（未走完的地图 > 下集预告），系列化根本增强
4. 验真伪：工牌+实测录屏+文件特写+内存曲线+真实账单，五重实证且随系列累积
5. 导流：置顶评论+公众号+新增「主页合集」终点，完播流量不浪费
6. 资产：知乎图文+教程入仓+合集+四站地图模板+逐字稿，一条五份
7. 常青：系列首集是永久入口，新粉考古回流；「笔记本能跑大模型吗」搜索词五年有效

## 验证状态

✅ 系列版答卷通过；A 版第 1 期可按此发布
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q34 · 2026-10-12｜四站系列 × 拍前七问答卷

**结论：系列化后第 3/5/7 问显著变强（四站地图追更/合集导流/首集永久入口），无变弱项。单条回答问题，系列回答「我为什么值得长期存在」。**

👉 执行细节：[details/Q34-系列七问答卷.md](details/Q34-系列七问答卷.md)

---

## Q33"""
t = t.replace("## Q33", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q34: 系列版七问答卷（第3/5/7问显著增强）" 2>&1 | tail -1
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
