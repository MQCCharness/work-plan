# esp32-iphone-agent 技术拆解（拍摄工程文档）

> 项目：[onehumanbeing/esp32-iphone-agent](https://github.com/onehumanbeing/esp32-iphone-agent)（988★，MIT，2026-10 活跃）
> 一句话：让 AI 模型操作一台真 iPhone——**AirPlay 当眼睛，USB HID 当手，任何兼容 OpenAI 接口的视觉模型当大脑**。不要 Mac、不要开发者账号、不要越狱。
> 最近更新：2026-10-13（北京时间）

## 三段式架构（拍视频就按这个讲）

| 部件 | 实现 | 人话 |
|---|---|---|
| 👁 眼睛 | iPhone 开「屏幕镜像」投到电脑上的 UxPlay，GStreamer 转成 JPEG 帧喂给模型 | AI 看的是实时投屏画面 |
| ✋ 手 | ESP32-S3 插进手机 USB 口，伪装成标准 USB 鼠标键盘；iOS 开「辅助触控」后屏幕上出现指针，点=点按、拖=滑动 | 板子是外挂的手 |
| 🧠 大脑 | Planner 写计划 + Actor 看截图选动作（点/滑/打字/回家/完成），两个角色可用同一个模型 | 任何视觉模型都能当脑，包括本地跑的 |

**闭环细节（工程亮点，可讲）**：指针是相对坐标，服务器先抖一下指针在镜像里找到它再校准；每次动作后检查屏幕是否真的变了，没点到会重试；重复动作触发重新规划。

## 物料清单（复现用）

| 物料 | 说明 | 价格 |
|---|---|---|
| ESP32-S3 开发板 | 官方测试用 Seeed XIAO ESP32S3（无预焊排针版）；任何 USB-C 直连 S3 原生 USB 的板子都行 | ~¥40–50 淘宝 |
| iPhone | USB-C 口直插；Lightning 口需要相机转接器 | 手头现有 |
| 电脑 | **macOS 或 Linux**（跑 UxPlay+服务端）——⚠️ 你的主力机是 Windows，**用家里那台 Orin（Ubuntu）跑服务端正好** | 0 |
| 视觉模型 | 云端 API 即可；**可接你本地部署的 GLM/Qwen**（OpenAI 兼容接口）——这条直接联动 A 版省钱叙事 | 0（本地） |

## 复现步骤（周末实操顺序）

1. 刷固件：arduino-cli + ESP32 core 3.x，改 `secrets.h`（WiFi 名/密码/服务器 IP），跑 `hardware/flash.sh`
2. Orin 上：`sudo apt install uxplay gstreamer1.0-plugins-good` + `pip install -e server/` + 配 `.env`（LLM_BASE_URL 可以指向你笔记本的 llama.cpp）
3. iPhone 一次性设置：设置→辅助功能→触控→辅助触控 打开 → 插板子出现圆指针 → 控制中心→屏幕镜像→选「iPhone Agent」→ 网页里点 Calibrate 自动校准
4. 网页 `http://<orin-ip>:8890` 输入任务开跑

## 拍摄要点（视频素材角度）

- **必拍镜头**：板子插手机上手机自己打字/打开 App（成果前置）；网页 UI 的 step wall（每一步截图+红圈点击动画，视觉极好）
- **token 消耗实测法**（答质疑①）：服务端日志有每次模型调用的 tokens，跑一个完整任务（如定闹钟）总 token ÷ 任务数 = 单任务成本；接本地模型时成本=0，「费 token？我接的是自己家免费的模型」——一句话同时答质疑+联动 A 版
- **边界诚实讲**（答质疑②）：竖屏 only、中文输入暂不支持（ASCII 键盘）、锁屏即断、不能看密码/Apple Pay 页面
- **为什么不用手机自带 AI**（答质疑③）：「自带的是大脑里的助手，这是外挂的手——它能替你在任何 App 里动手，包括没有开放接口的」

## 与哈机密的关系

这块板子 + USB HID 打字 = E05「狗在键盘上敲出我爱你」的技术底座。本期视频结尾钩子：「这块板子我正在给它装身体——关注看第四站」。
