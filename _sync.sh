#!/bin/bash
cd /g/G_cursor/work-plan || exit 1
rm -f _dev.sh
cat >> details/Q37-KaCo汽车视频特效拆解.md << 'EOF'

## 补：「虚拟+现实结合」的三层工艺（帧证据）

- **实拍层**：鱼眼桌面/双手/展厅/车（真）
- **真 AI 对话层**：大屏上是连贯无错字的中文 LLM 对话（展厅光线导致车漆发灰怎么办→AI 给 HSL 蓝通道饱和+15、色温+300K 建议）——执行「月薪6000要被AI取代」的叙事
- **合成 HUD 层（AI 生成马脚）**：小屏 HUD 界面文字崩坏——「YESDIO RAAS」（无意义）、「ENGNE LOAD」（ENGINE 少 I）、「MAEECT」、「SI.90 KG」——AI 生图/视频工具的典型文字错误，铁证 HUD 是 AI 生成的假界面

**贴入工艺**：平面跟踪+角点替换（AE mocha/Corner Pin 或剪映屏幕替换+运动跟踪），后期钉到设备屏幕并叠环境辉光（证据：亮度均匀、无摩尔纹、无曝光溢出）；静止镜头可能直接真机播放。

**对我们的反超机会**：他用 AI 生 HUD 文字全错，我们用代码（Remotion/GSAP）生 HUD 文字全对——同样的虚拟屏嵌现实，我们版没有破绽。哈机密「桌面小屏」形态路径：管线生 HUD（狗状态面板/记忆进度条）→ 静止镜头真机播放 / 运动镜头剪映跟踪四角钉入。
EOF
git add -A
git commit -m "Q37-补: 虚拟+现实三层工艺拆解（AI生成HUD文字马脚+反超机会）" 2>&1 | tail -1
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
