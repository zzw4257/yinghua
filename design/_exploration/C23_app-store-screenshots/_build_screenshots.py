#!/usr/bin/env python3
"""
C23 App Store Screenshots — Post-process C15 shippable (16:9 4K) into 2880x1800 (16:10) PNGs
with marketing title + subtitle overlay in the top padding area.

Approach:
1. Load C15 shippable image (5504x3072 = 16:9)
2. Create new canvas with 16:10 ratio (5504x3440), fill with sampled top-edge dark color
3. Paste C15 image in lower portion (so menu bar sits below the marketing text area)
4. Render marketing title + subtitle on the top padding area
5. Resize to exactly 2880x1800
6. Save as PNG (no transparency)

Mapping (App Store idx -> C15 source, with marketing text):
  01 meeting      <- C15/01-meeting
  02 transcript   <- C15/03-transcript
  03 summary      <- C15/04-review
  04 onboarding   <- C15/05-onboarding
  05 empty        <- C15/02-empty
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os
import sys

# ----- Paths -----
C15_DIR = "/Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon/design/_exploration/C15_dark-shippable/design"
OUT_DIR = "/Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon/design/_exploration/C23_app-store-screenshots"

# ----- Output spec -----
TARGET_W = 2880
TARGET_H = 1800  # 16:10 = 1.6

# Intermediate canvas: preserve 4K text rendering then downscale
# We pad C15 (16:9) to 16:10 by adding top/bottom, then resize.
# 5504 / 1.6 = 3440 -> need 3440 height, original is 3072, so add 368 px total.
# Use 280 top (for text) + 88 bottom (visual balance).
INTERMEDIATE_W = 5504
INTERMEDIATE_H = 3440
TOP_PAD = 280     # top padding for marketing title + subtitle
BOTTOM_PAD = 88   # bottom padding for visual breathing room

# ----- App Store scenes -----
# (c15_subdir, output_filename, title_zh, subtitle_zh)
SCENES = [
    ("01-meeting",   "01-meeting__260824.png",      "边开会、边记录",        "系统级录音 · 实时落字"),
    ("03-transcript", "02-transcript__260824.png",   "每一句都不漏",         "自动分说话人 · 时间码同步"),
    ("04-review",    "03-summary__260824.png",       "48 分钟，4 段总结",     "关键瞬间 · 决定 · 待办"),
    ("05-onboarding","04-onboarding__260824.png",    "5 分钟开始",            "本地优先 · 无需账号"),
    ("02-empty",     "05-empty__260824.png",         "本地优先 · 高级 BYOK",  "数据你的 · 模型你选"),
]

# ----- Font resolution -----
# Prefer Noto Serif SC / Noto Sans SC (per design doc), but on macOS the equivalents are:
# - Songti SC Bold        (Noto Serif SC equivalent) — for marketing title
# - Heiti SC Medium       (Noto Sans SC equivalent) — for subtitle
# Falls back to system fonts if missing.

def find_font(candidates, size):
    """Try multiple font paths; return the first one that loads."""
    for path in candidates:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    # Last resort — PIL default (small bitmap)
    return ImageFont.load_default()

# macOS system fonts (tested on the host machine)
TITLE_FONT_CANDIDATES = [
    "/System/Library/Fonts/Supplemental/Songti.ttc",          # Songti SC
    "/System/Library/Fonts/STHeiti Medium.ttc",                # Heiti SC
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/PingFang.ttc",
]
SUBTITLE_FONT_CANDIDATES = [
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/STHeiti Medium.ttc",
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/Supplemental/Songti.ttc",
]
EN_FONT_CANDIDATES = [
    "/System/Library/Fonts/Hiragino Sans GB.ttc",
    "/System/Library/Fonts/PingFang.ttc",
    "/System/Library/Fonts/SFNS.ttf",
    "/Library/Fonts/Arial.ttf",
]


def render_text_with_shadow(draw, xy, text, font, fill, shadow_color=(0, 0, 0, 90), shadow_offset=(0, 4)):
    """Render text with a soft drop shadow for legibility on busy wallpapers."""
    x, y = xy
    # Shadow first
    if shadow_color:
        sx, sy = shadow_offset
        draw.text((x + sx, y + sy), text, font=font, fill=shadow_color)
    draw.text(xy, text, font=font, fill=fill)


def process_scene(c15_subdir, out_filename, title_zh, subtitle_zh):
    src = os.path.join(C15_DIR, c15_subdir)
    # Pick the C15 file (jpg or png)
    for fn in os.listdir(src):
        if fn.startswith("product-") and not fn.endswith(".md"):
            src_path = os.path.join(src, fn)
            break
    else:
        print(f"  [ERR] No product- file in {src}")
        return False

    print(f"  -> loading {os.path.basename(src_path)}")
    base = Image.open(src_path).convert("RGB")
    bw, bh = base.size
    assert (bw, bh) == (5504, 3072), f"unexpected size: {base.size}"

    # ---- 1. Sample background color from the C15 image's top edge
    # (avoid making the top pad a hard rectangle — sample the actual wallpaper)
    top_strip = base.crop((0, 0, bw, 8))
    # Take the central region's average color
    small = top_strip.resize((1, 1), Image.LANCZOS)
    bg_color = small.getpixel((0, 0))
    print(f"     sampled wallpaper color: {bg_color}")

    # Slightly darken the background to give text better contrast
    def darken(c, amount=0.6):
        return tuple(int(v * amount) for v in c)
    bg_dark = darken(bg_color, 0.55)
    print(f"     darkened to: {bg_dark}")

    # ---- 2. Build intermediate 16:10 canvas
    canvas = Image.new("RGB", (INTERMEDIATE_W, INTERMEDIATE_H), bg_dark)

    # ---- 3. Add a subtle aurora-tint gradient at the very top to soften the join
    # We'll add a small gradient from deep-purple to the sampled bg color
    grad = Image.new("RGB", (INTERMEDIATE_W, TOP_PAD), bg_dark)
    gdraw = ImageDraw.Draw(grad)
    # Vertical gradient: top deep purple #1a0a3a -> bg_dark at bottom
    top_color = (26, 10, 58)   # deep purple, subtle
    for y in range(TOP_PAD):
        ratio = y / TOP_PAD
        # Interpolate top_color -> bg_dark
        r = int(top_color[0] * (1 - ratio) + bg_dark[0] * ratio)
        g = int(top_color[1] * (1 - ratio) + bg_dark[1] * ratio)
        b = int(top_color[2] * (1 - ratio) + bg_dark[2] * ratio)
        gdraw.line([(0, y), (INTERMEDIATE_W, y)], fill=(r, g, b))
    canvas.paste(grad, (0, 0))

    # ---- 4. Paste the C15 image below the top pad
    canvas.paste(base, (0, TOP_PAD))

    # ---- 5. Render title + subtitle
    # The macOS menu bar in the C15 image sits at y=0 to y=~100 (in 5504x3072).
    # After paste at y=280, it sits at y=280 to y=380 in the 5504x3440 canvas.
    # So all overlay text must be at y < 280 to stay above the menu bar.
    draw = ImageDraw.Draw(canvas, "RGBA")

    # Font sizes — sized so 5504 -> 2880 downscale yields ~50-60pt title and ~22pt subtitle
    title_font = find_font(TITLE_FONT_CANDIDATES, 130)  # ~68px after 0.523x downscale (~50pt visual)
    subtitle_font = find_font(SUBTITLE_FONT_CANDIDATES, 50)  # ~26px after downscale (~20pt visual)

    # Layout: left-aligned, fits in 0-275px (above menu bar)
    title_x = 180
    title_y = 30       # 30 -> 16px in 1800-scale
    sub_x = 180
    sub_y = title_y + 155  # subtitle below title with gap

    # Drop shadow for legibility
    draw.text((title_x + 2, title_y + 4), title_zh, font=title_font, fill=(0, 0, 0, 130))
    draw.text((title_x, title_y), title_zh, font=title_font, fill=(244, 241, 236, 255))  # 暖白 #F4F1EC

    draw.text((sub_x + 2, sub_y + 3), subtitle_zh, font=subtitle_font, fill=(0, 0, 0, 110))
    draw.text((sub_x, sub_y), subtitle_zh, font=subtitle_font, fill=(244, 241, 236, 220))

    # ---- 6. Downscale to 2880x1800
    final = canvas.resize((TARGET_W, TARGET_H), Image.LANCZOS)

    # ---- 7. Save as PNG (no alpha)
    out_path = os.path.join(OUT_DIR, out_filename)
    final.save(out_path, "PNG", optimize=True)
    print(f"     saved {out_filename} -> {out_path}")
    return True


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    print(f"Output: {OUT_DIR}")
    print(f"Target: {TARGET_W}x{TARGET_H} (16:10)")
    print(f"Intermediate: {INTERMEDIATE_W}x{INTERMEDIATE_H} (16:10, 4K text fidelity)")
    print("---")
    for i, (subdir, out_fn, title, sub) in enumerate(SCENES, 1):
        print(f"[{i}/5] {out_fn}  <-  C15/{subdir}")
        process_scene(subdir, out_fn, title, sub)
    print("---")
    print("DONE.")


if __name__ == "__main__":
    main()
