#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Build v4: multi-material (loading + files closeup + Q&A demo + memory curve)."""
import io, os, json, subprocess

BASE = r"G:\G_cursor\work-plan\sample"
ASSETS = os.path.join(BASE, "assets")
SEGS = os.path.join(BASE, "segs")
FONT = "sample/assets/msyh.ttc"
FONT_B = "sample/assets/msyhbd.ttc"
W, H = 1080, 1920
dur = json.load(io.open(os.path.join(ASSETS, "tts_durations.json"), encoding="utf-8"))

def esc(t):
    return t.replace("\\", "\\\\").replace(":", "\\:").replace("'", "\\'").replace(",", "\\,")

def dt(text, size, y, font=FONT_B, color="white", x="(w-text_w)/2"):
    return f"drawtext=fontfile={font}:text='{esc(text)}':fontsize={size}:fontcolor={color}:x={x}:y={y}"

def topband(title):
    return f"drawbox=x=0:y=0:w={W}:h=170:color=0xC8102E@1:t=fill," + dt(title, 52, 55)

def ticker(text):
    return (f"drawbox=x=0:y={H-170}:w={W}:h=170:color=0xC8102E@1:t=fill,"
            + dt(text, 40, H-115, FONT, "white", x=f"w-mod(t*220\\,{1200+len(text)*44})"))

def build_rec(name, src, rec_start, segdur, audio, title, caption, tick,
              crop=None, speedline=None):
    out = os.path.join(SEGS, f"{name}_v4.mp4")
    pre = crop + "," if crop else ""
    vf = (f"{pre}scale=1020:-2,pad={W}:{H}:0:560:color=0x111111,"
          + topband(title) + "," + dt(caption, 44, 1320, FONT, "0xFFD400") + ",")
    if speedline:
        vf += dt(speedline, 72, 1440, FONT_B, "0x7CFC00") + ","
    vf += ticker(tick)
    cmd = ["ffmpeg", "-y", "-ss", str(rec_start), "-t", str(segdur), "-i", src,
           "-i", audio, "-filter_complex", vf,
           "-c:v", "libx264", "-preset", "fast", "-crf", "21", "-pix_fmt", "yuv420p",
           "-c:a", "aac", "-af", "aresample=async=1:first_pts=0", "-shortest", out]
    subprocess.run(cmd, check=True, capture_output=True)
    return out

def build_silent(name, src, rec_start, segdur, title, caption, tick, crop=None):
    out = os.path.join(SEGS, f"{name}_v4.mp4")
    pre = crop + "," if crop else ""
    vf = (f"{pre}scale=1020:-2,pad={W}:{H}:0:560:color=0x111111,"
          + topband(title) + "," + dt(caption, 44, 1320, FONT, "0xFFD400") + ","
          + ticker(tick))
    cmd = ["ffmpeg", "-y", "-ss", str(rec_start), "-t", str(segdur), "-i", src,
           "-filter_complex", vf,
           "-c:v", "libx264", "-preset", "fast", "-crf", "21", "-pix_fmt", "yuv420p",
           "-an", out]
    subprocess.run(cmd, check=True, capture_output=True)
    return out

REC_P = os.path.join(BASE, "rec_primary.mp4")
REC_F = os.path.join(BASE, "rec_files.mp4")
REC_T = os.path.join(BASE, "rec_taskmgr.mp4")

parts = []
# S1/S2 from v1
parts.append(os.path.join(SEGS, "s1.mp4"))
parts.append(os.path.join(SEGS, "s2.mp4"))
# S3a: loading (with audio tts_s3)
s3d = dur["s3_proof"] + 0.4
parts.append(build_rec("s3", REC_P, 8.0, s3d, os.path.join(ASSETS, "tts_s3_proof.mp3"),
                       "就一个软件 一个模型文件", "llama.cpp 真实启动加载 · 一镜到底", "显卡小别硬上 GPU · 实测负优化"))
# S3b: files close-up (silent, 3s)
parts.append(build_silent("s3b", REC_F, 4.0, 3.0,
                          "一个模型文件", "GLM-4-9B · 单文件 5.8GB · 照抄就行", "开源免费 · hf-mirror 直连",
                          crop="crop=1500:1400:1050:20"))
# S4a: Q&A demo (with audio tts_s4)
s4d = dur["s4_demo"] + 0.4
parts.append(build_rec("s4", REC_P, 9.0, s4d, os.path.join(ASSETS, "tts_s4_demo.mp3"),
                       "写周报 改文案 答问题", "GLM-4-9B 全 GPU 真实生成过程",
                       "64G 内存游戏本 · 非工作站", speedline="41.5 t/s 实测"))
# S4b: memory curve (silent, 3.5s)
parts.append(build_silent("s4b", REC_T, 22.0, 3.5,
                          "64G 内存扛起来", "资源监视器实拍 · 内存占用 70% · 无网络流量", "数据不出这台电脑",
                          crop="crop=1400:950:20:40"))
# S5/S6 from v1
parts.append(os.path.join(SEGS, "s5.mp4"))
parts.append(os.path.join(SEGS, "s6.mp4"))

lst = os.path.join(BASE, "concat_v4.txt")
io.open(lst, "w", encoding="utf-8").write("\n".join(f"file '{p}'" for p in parts))
final = os.path.join(BASE, "A版样片_v4.mp4")
subprocess.run(["ffmpeg", "-y", "-f", "concat", "-safe", "0", "-i", lst, "-c", "copy", final],
               check=True, capture_output=True)
r = subprocess.run(["ffprobe", "-v", "quiet", "-show_entries", "format=duration", "-of", "csv=p=0", final],
                   capture_output=True, text=True)
print("FINAL:", final, r.stdout.strip(), "s")
