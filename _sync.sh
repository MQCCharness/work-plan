#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q36-商业闭环担心.md << 'EOF'
# Q36 · 2026-10-13｜「Cube 人设/端侧部署没法商业闭环」的担心

**结论：担心合理但问错了对象——人设和技能不需要闭环（招牌不收钱，柜台收），需要闭环的是服务和产品。端侧部署三层解剖：①一次性咨询闭环成立但天花板低（不复购）②「部署+月费维护」MRR 是真闭环（部署 1-3 万 + 维护 500-2000/月，10 客户=5000-2万/月底座；风向：数据合规+token 成本+一体机热销）③哈机密 C 端远期靠众筹验证。**

## 要点

- 闭环测试器=闲鱼挂单：闭环成立定义=有人付钱+交付完+愿意再付/转介绍；D+90 止损线就是干这个的
- 已有水流信号：Q14 陌生人私信（带硬件需求找上门）
- 最坏情况兜底：闭环失败时资产栈（爆款/案例/教程/人设/管线）整体平移到企业 AI 培训/顾问，人设不塌
- 闭环答案在未来 90 天询单数里，不在推演里；我盯数字，用户发视频

## 验证状态

⬜ 验证中（D+90 止损线：零询单→换引擎）
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q36 · 2026-10-13｜商业闭环担心：三层解剖 + 测试器已在跑

**结论：人设技能不需闭环，服务产品才需要。端侧部署①一次性咨询闭环成立天花板低②「部署+月费维护」MRR 是真闭环（10 客户=5k-2万/月）③哈机密远期众筹。闭环测试器=闲鱼挂单+D+90 止损线；闭环失败资产栈可平移企业培训，人设不塌。**

👉 执行细节：[details/Q36-商业闭环担心.md](details/Q36-商业闭环担心.md)

---

## Q35"""
t = t.replace("## Q35", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q36: 商业闭环担心三层解剖（MRR部署+维护是真闭环）" 2>&1 | tail -1
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
