#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
cat > details/Q37-KaCo汽车视频特效拆解.md << 'EOF'
# Q37 · 2026-10-14｜KaCo 帕加尼视频特效拆解

**结论：该视频「特效感」几乎全部来自运镜+剪辑而非后期 VFX。七招词汇表：鱼眼桌面、画中画小屏、钻屏转场、甩镜转场（运动模糊当剪辑点）、浅景深微距、低机位环绕、色彩联动。可迁移三招：甩镜当剪辑点（字卡→录屏的硬切升级）、画中画小屏（哈机密线天然形态）、色彩联动（红底模板与内容主色呼应）。**

## 视频档案

- 原片：@KaCo（只值3000）「6000月薪，真的到头了吗」29s/60fps/竖屏，帕加尼 Huayra @景枫车俱会
- 本地副本 sample/ref/kaco.mp4；抽帧 ref/qc_tile_*.png（5fps 拼图墙）+ f_*.png（切点帧）
- 结构：0–15s 鱼眼剪辑台叙事框架（月薪6000梗）→ 15.3s BTS 晒云台装备 → 15.8s 起正片

## 验证状态

✅ 拆解完成；转场三招待融入后续视频模板
EOF
python - << 'PYEOF'
import io
p = r"G:\G_cursor\work-plan\QA.md"
t = io.open(p, encoding="utf-8").read()
entry = """## Q37 · 2026-10-14｜KaCo 帕加尼视频特效拆解

**结论：特效感来自运镜+剪辑而非 VFX。七招词汇表（鱼眼桌面/画中画小屏/钻屏转场/甩镜转场/浅景深微距/低机位环绕/色彩联动）；可迁移三招：甩镜当剪辑点、画中画小屏、色彩联动。**

👉 执行细节：[details/Q37-KaCo汽车视频特效拆解.md](details/Q37-KaCo汽车视频特效拆解.md)

---

## Q36"""
t = t.replace("## Q36", entry, 1)
io.open(p, "w", encoding="utf-8", newline="\n").write(t)
print("ok")
PYEOF
git add -A
git commit -m "Q37: KaCo帕加尼视频特效拆解（运镜>后期VFX，可迁移三招）" 2>&1 | tail -1
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
rm -f _qa_feishu.md _ref.sh
