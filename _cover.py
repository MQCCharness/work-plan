#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""闲鱼挂单封面图 1080x1080"""
import subprocess, os

BASE = "sample/assets"
FONT = BASE + "/msyh.ttc"
FONT_B = BASE + "/msyhbd.ttc"
OUT = "sample/xianyu_cover.png"

def esc(t):
    return t.replace("\\", "\\\\").replace(":", "\\:").replace("'", "\\'").replace(",", "\\,")

def dt(text, size, y, font=FONT_B, color="white", x="(w-text_w)/2"):
    return (f"drawtext=fontfile={font}:text='{esc(text)}':fontsize={size}:fontcolor={color}:x={x}:y={y}")

filters = [
    "drawbox=x=0:y=0:w=1080:h=200:color=0xC8102E@1:t=fill",
    dt("本地大模型部署", 76, 58),
    "drawbox=x=60:y=280:w=960:h=110:color=0x1E1E1E@1:t=fill",
    dt("芯片公司 AI 工程师 · 亲手搭建小米 AI Cube", 44, 315, FONT, "0xFFD400"),
    dt("远程调试 / 选型方案 / 北京可上门", 40, 430, FONT, "0xAAAAAA"),
    "drawbox=x=60:y=560:w=300:h=230:color=0x1E1E1E@1:t=fill",
    dt("¥9.9", 72, 610, FONT_B, "0x7CFC00", x="210-text_w/2"),
    dt("部署清单", 36, 700, FONT, "white", x="210-text_w/2"),
    "drawbox=x=390:y=560:w=300:h=230:color=0xC8102E@1:t=fill",
    dt("¥199", 72, 610, FONT_B, "white", x="540-text_w/2"),
    dt("远程诊断", 36, 700, FONT, "white", x="540-text_w/2"),
    "drawbox=x=720:y=560:w=300:h=230:color=0x1E1E1E@1:t=fill",
    dt("¥500", 72, 610, FONT_B, "0x7CFC00", x="870-text_w/2"),
    dt("北京上门", 36, 700, FONT, "white", x="870-text_w/2"),
    dt("GLM / DeepSeek / Qwen 全支持", 40, 860, FONT, "white"),
    dt("数据不出你的电脑 · 断网可用", 40, 930, FONT, "0xFFD400"),
    dt("发你的电脑配置 · 我告诉你能不能跑", 36, 1000, FONT, "0xAAAAAA"),
]

cmd = ["ffmpeg", "-y", "-f", "lavfi", "-i", "color=c=0x111111:s=1080x1080:r=30:d=1",
       "-filter_complex", ",".join(filters), "-frames:v", "1", OUT]
subprocess.run(cmd, check=True, capture_output=True)
print(OUT)
