#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Build v2: replace S3/S4 with real terminal recording; reuse v1 S1/S2/S5/S6."""
import io, os, json, subprocess

BASE = r"G:\G_cursor\work-plan\sample"
ASSETS = os.path.join(BASE, "assets")
SEGS = os.path.join(BASE, "segs")
REC = os.path.join(BASE, "rec_terminal.mp4")
FONT = "sample/assets/msyh.ttc"
FONT_B = "sample/assets/msyhbd.ttc"
W, H = 1080, 1920
dur = json.load(io.open(os.path.join(ASSETS, "tts_durations.json"), encoding="utf-8"))

def esc(t):
    return t.replace("\\", "\\\\").replace(":", "\\:").replace("'", "\\'").replace(",", "\\,")

def dt(text, size, y, font=FONT_B, color="white", enable=None, x="(w-text_w)/2"):
    e = f":enable='{enable}'" if enable else ""
    return (f"drawtext=fontfile={font}:text='{esc(text)}':fontsize={size}:fontcolor={color}"
            f":x={x}:y={y}{e}")

def topband(title):
    return (f"drawbox=x=0:y=0:w={W}:h=170:color=0xC8102E@1:t=fill,"
            + dt(title, 52, 55))

def ticker(text):
    return (f"drawbox=x=0:y={H-170}:w={W}:h=170:color=0xC8102E@1:t=fill,"
            + dt(text, 40, H-115, FONT, "white", x=f"w-mod(t*220\\,{1200+len(text)*44})"))

CROP = "crop=1700:870:2780:410"

def build_rec(name, rec_start, segdur, audio, title, caption, tick, speedline=None):
    out = os.path.join(SEGS, f"{name}_v2.mp4")
    vf = (f"{CROP},scale=1020:-2,pad={W}:{H}:0:560:color=0x111111,"
          + topband(title) + ","
          + dt(caption, 44, 1320, FONT, "0xFFD400") + ",")
    if speedline:
        vf += dt(speedline, 72, 1440, FONT_B, "0x7CFC00") + ","
    vf += ticker(tick)
    cmd = ["ffmpeg", "-y", "-ss", str(rec_start), "-t", str(segdur), "-i", REC,
           "-i", audio, "-filter_complex", vf,
           "-c:v", "libx264", "-preset", "fast", "-crf", "21", "-pix_fmt", "yuv420p",
           "-c:a", "aac", "-af", "aresample=async=1:first_pts=0", "-shortest", out]
    subprocess.run(cmd, check=True, capture_output=True)
    return out

s3d = dur["s3_proof"] + 0.4
s4d = dur["s4_demo"] + 0.4
s3 = build_rec("s3", 6.5, s3d, os.path.join(ASSETS, "tts_s3_proof.mp3"),
               "就一个软件 一个模型文件", "llama.cpp 真实启动加载 · 一镜到底", "显卡小别硬上 GPU · 实测负优化")
s4 = build_rec("s4", 9.0, s4d, os.path.join(ASSETS, "tts_s4_demo.mp3"),
               "写周报 改文案 答问题", "GLM-4-9B 全 GPU 真实生成过程",
               "64G 内存游戏本 · 非工作站", speedline="42.7 t/s 实测")

lst = os.path.join(BASE, "concat_v2.txt")
parts = ["s1.mp4", "s2.mp4", "s3_v2.mp4", "s4_v2.mp4", "s5.mp4", "s6.mp4"]
io.open(lst, "w", encoding="utf-8").write("\n".join(f"file '{os.path.join(SEGS, p)}'" for p in parts))
final = os.path.join(BASE, "A版样片_v2.mp4")
subprocess.run(["ffmpeg", "-y", "-f", "concat", "-safe", "0", "-i", lst, "-c", "copy", final],
               check=True, capture_output=True)
r = subprocess.run(["ffprobe", "-v", "quiet", "-show_entries", "format=duration", "-of", "csv=p=0", final],
                   capture_output=True, text=True)
print("FINAL:", final, r.stdout.strip(), "s")
