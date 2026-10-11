#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q28-人生持久战布局.md << 'EOF'
# Q28 · 2026-10-04｜人生全局的持久战布局（主业/身体/副业/小智哈机密）

**结论：主业是后方兵工厂（绝不裸辞）、身体是后勤线（睡眠+减重是后勤工程）、副业是前线（本周三仗：挂单/审片/拍A版）、小智+哈机密是反攻期武器（现在只练兵不决战，esp32 接小智只做内容素材级投入）。反攻唯一信号：副业月收入连续三个月超过工资。**

## 四层布局

| 层 | 角色 | 纪律 |
|---|---|---|
| 主业（玄戒） | 后方兵工厂：供给身份锚点+月薪弹药+技术情报 | 不裸辞；后方丢了前线再热闹也是流寇 |
| 身体 | 后勤线：三年消耗战的地基 | 23:30 前睡、戒游戏、通勤读书、十月减 6–8 斤 |
| 副业 | 前线：任务是侦察（询单=市场反馈）+练兵（案例库/产能） | 闲鱼挂单、账单截图、A 版投放 |
| 小智/哈机密 | 反攻武器 | 防御期禁止大开发；只做能拍成内容的最小动作（E02 接小智） |

## 验证状态

—（人生框架；反攻信号=副业月收入连续三月超工资）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q28 · 2026-10-04｜人生全局的持久战布局

**结论：主业=后方（不裸辞）、身体=后勤（睡眠+减重）、副业=前线（本周三仗）、小智/哈机密=反攻武器（只练不造）。反攻信号：副业月收入连续三月超工资。**

👉 执行细节：[details/Q28-人生持久战布局.md](details/Q28-人生持久战布局.md)

---

## Q27"""
t = t.replace("## Q27", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q28: 人生持久战布局（后方/后勤/前线/武器四层）" 2>&1 | tail -1
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
