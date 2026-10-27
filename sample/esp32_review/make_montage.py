import os, subprocess
from PIL import Image, ImageDraw
base = r"G:\G_cursor\work-plan\sample\esp32_review"
times = [0.5, 1, 3, 5, 10, 20, 23, 30, 45, 60, 90, 120, 150, 180, 205, 218]
thumbs = []
for i, t in enumerate(times):
    p = os.path.join(base, f"f{i:02d}.jpg")
    subprocess.run(["ffmpeg", "-y", "-ss", str(t), "-i", os.path.join(base, "esp32.mp4"), "-frames:v", "1", "-vf", "scale=480:270", p], capture_output=True, check=True)
    im = Image.open(p).convert("RGB")
    canvas = Image.new("RGB", (480, 300), "#111111")
    canvas.paste(im, (0, 30))
    ImageDraw.Draw(canvas).text((8, 8), f"{t}s", fill="white")
    thumbs.append(canvas)
out = Image.new("RGB", (1920, 1200), "#111111")
for i, im in enumerate(thumbs):
    out.paste(im, ((i % 4) * 480, (i // 4) * 300))
out.save(os.path.join(base, "montage.jpg"), quality=92)
print(os.path.join(base, "montage.jpg"))
