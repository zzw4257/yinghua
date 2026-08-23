# C28 · Yinghua macOS .icns — Mac App Store Icon Assets

**Date**: 2026-08-23
**Owner**: worker (parent session: `mvs_4f13d64598fd4b129a1bc6f60c5b25e1`)
**Task**: C28 — package the C10 vector master into real multi-resolution `.icns` files for Mac App Store submission.
**Status**: ✅ COMPLETE — both `.icns` files round-trip-verified, all 10 sub-icon pixel sizes match spec.

---

## 1. Deliverables

| File | Size | Variant | Purpose |
|---|---|---|---|
| `Yinghua.icns` | 93 839 B | **01 MINIMAL** | Primary Mac App Store icon. Warm-white Y on near-black. |
| `Yinghua-gradient.icns` | 314 291 B | **02 GRADIENT** | Marketing / alt-store-listing fallback. Aurora purple→teal Y on tinted near-black. |

Both files are real, valid, multi-resolution macOS icon containers (type `com.apple.icns`), produced via Apple's official `iconutil` so the Mac App Store uploader will accept them as-is.

---

## 2. Internal structure

Each `.icns` contains **10 image sub-icons** + 1 `info` metadata plist block. `iconutil` packaged them straight from the `.iconset` directories; the sub-icon type tags are Apple's standard ASCII codes:

| Sub-icon tag | Pixel size | Role | Source filename in `.iconset` |
|---|---|---|---|
| `ic04` | 16 × 16 | Dock minimum | `icon_16x16.png` |
| `ic05` | 32 × 32 | Finder list | `icon_32x32.png` |
| `ic07` | 128 × 128 | Finder preview | `icon_128x128.png` |
| `ic08` | 256 × 256 | Finder icon | `icon_256x256.png` |
| `ic09` | 512 × 512 | Launchpad | `icon_512x512.png` |
| `ic10` | 1024 × 1024 | **Launchpad retina = App Store master** | `icon_512x512@2x.png` |
| `ic11` | 32 × 32 | Dock retina (16 @2x) | `icon_16x16@2x.png` |
| `ic12` | 64 × 64 | Finder list retina (32 @2x) | `icon_32x32@2x.png` |
| `ic13` | 256 × 256 | Finder preview retina (128 @2x) | `icon_128x128@2x.png` |
| `ic14` | 512 × 512 | Finder icon retina (256 @2x) | `icon_256x256@2x.png` |
| `info` | — | `kIconServicesVersionInfo` plist (Apple metadata, **not an image**) | — |

`file(1)` reports `"ic12" type` for both files because that is the first sub-icon tag in the stream — it is not the largest one. The **App Store master** sub-icon is `ic10` (1024 × 1024).

`info` is the version-info plist that Apple adds automatically; it does not affect rendering.

---

## 3. Layout in this directory

```
C28_mas-icon-icns/
├── README.md                       ← you are here
├── iconutil-verification.txt       ← full QA report (file, sips, raw icns parse, round-trip)
│
├── Yinghua.icns                    ← 01 MINIMAL — App Store primary
├── Yinghua.iconset/                ← source for Yinghua.icns (10 PNGs, Apple naming)
│   ├── icon_16x16.png
│   ├── icon_16x16@2x.png
│   ├── icon_32x32.png
│   ├── icon_32x32@2x.png
│   ├── icon_128x128.png
│   ├── icon_128x128@2x.png
│   ├── icon_256x256.png
│   ├── icon_256x256@2x.png
│   ├── icon_512x512.png
│   └── icon_512x512@2x.png
│
├── Yinghua-gradient.icns           ← 02 GRADIENT — marketing fallback
├── Yinghua-gradient.iconset/       ← source for Yinghua-gradient.icns (10 PNGs, Apple naming)
│
├── individual/                     ← raw rasterized PNGs at unique pixel sizes
│   ├── 01-minimal/
│   │   ├── icon_16.png
│   │   ├── icon_32.png     ← also serves as the @2x of 16 (ic11)
│   │   ├── icon_64.png     ← also serves as the @2x of 32 (ic12)
│   │   ├── icon_128.png
│   │   ├── icon_256.png    ← also serves as the @2x of 128 (ic13)
│   │   ├── icon_512.png    ← also serves as the @2x of 256 (ic14)
│   │   └── icon_1024.png   ← also serves as the @2x of 512 (ic10, App Store master)
│   └── 02-gradient/       ← same 7 files, gradient variant
│
└── _extracted-verify/              ← QA only: iconutil round-trip output of each .icns
    ├── Yinghua.iconset/             (decoded from Yinghua.icns for pixel-size check)
    └── Yinghua-gradient.iconset/    (decoded from Yinghua-gradient.icns)
```

The 14 individual PNGs (7 per variant) collapse to 10 entries in each `.iconset` because `32/64/256/512` PNGs each fill two slots — once as a base size and once as the `@2x` of the previous step. The raster is identical, but Apple expects both filenames.

---

## 4. Verification

Run by the worker on 2026-08-23 02:17 UTC. Full output in `iconutil-verification.txt`. Summary:

| Check | Method | Result |
|---|---|---|
| Container type | `file Yinghua.icns` | `Mac OS X icon, 93839 bytes, "ic12" type` ✅ |
| Container type | `file Yinghua-gradient.icns` | `Mac OS X icon, 314291 bytes, "ic12" type` ✅ |
| Container sips | `sips -g all` | `typeIdentifier: com.apple.icns`, `pixelWidth: 1024`, `hasAlpha: yes`, `format: icns` ✅ |
| Raw sub-icon count | Python `icns` parser | 10 image sub-icons + 1 `info` plist block per file ✅ |
| Sub-icon pixel dims | `iconutil -c iconset` round-trip → `sips` | All 10 sub-icons in each `.icns` decode to the correct pixel size (16/32/64/128/256/512 + 5 @2x) ✅ |
| Source fidelity | rsvg-convert against C10 SVG | 7 raster sizes (16/32/64/128/256/512/1024) per variant, all square, all with alpha ✅ |

Geometry & color are inherited **verbatim** from the C10 master SVGs:
- 1024×1024 viewBox, 22.4 % corner radius squircle
- 01 MINIMAL: stroke `#F4F1EC` (warm white), background `#0A0A0F`
- 02 GRADIENT: stroke `url(#yGradient)` (B57BFF → 8A5BFF → 2DD4BF, 135°), background `#0A0A0F` + 15 % aurora wash
- Y path: `M 372 256 L 512 416 L 652 256 M 512 416 L 512 768`, stroke-width 58, round caps + round joins (single `<path>`, no seam at the V/stem junction)

---

## 5. Lineage

```
C07 _audit-verdict.md  (decisions on Y geometry, squircle, stroke)
   │
C10_vector-icon/        (SVG masters + small-PNG previews, 2026-08-23)
   │  icon-01-minimal__260823.svg
   │  icon-02-gradient__260823.svg
   │
   ▼
C28_mas-icon-icns/      (this folder — multi-resolution .icns for macOS)
   │  Yinghua.icns          ← App Store primary
   │  Yinghua-gradient.icns ← App Store / marketing fallback
   │
   └── (sibling) C24_ios-icon-set/   ← iOS App Store .appiconset (1024 only, plus device slots)
```

C28 fills the **macOS** slot. C24 (when generated) will fill the **iOS** slot. Both are derived from the same C10 SVG, so geometry and color will stay identical across the two store submissions.

---

## 6. App Store submission handoff

### Option A — drag into Xcode (recommended for first-time upload)

1. Open the Xcode project for the macOS app target.
2. In the Project Navigator, select **`Assets.xcassets`**.
3. Click **`AppIcon`** (or `AppIcon-macOS`) in the asset catalog.
4. In the inspector, set **Source = "Single Size"** and **Size = macOS 1024×1024**, **or** leave it on "Individual Sizes" and the catalog will map each `.iconset` filename to the correct slot automatically.
5. Drag the **`.icns`** (or the `.iconset` folder) from Finder into the AppIcon well.
6. Xcode will unpack the 10 sub-icons into the catalog slots and the build will carry them into the `.app` bundle.
7. Archive the app and submit via Organizer → Distribute App → App Store Connect.

### Option B — direct file-system placement (advanced)

1. Build the `.app` once with a placeholder icon.
2. Copy `Yinghua.icns` over `YourApp.app/Contents/Resources/YourApp.icns` (and update the `CFBundleIconFile` key in `Info.plist` if it isn't already `Yinghua`).
3. Re-codesign the bundle: `codesign --force --deep --sign "Apple Development: …" YourApp.app`.
4. Re-archive and submit.

### App Store Connect

- The App Store Connect app-icon upload field accepts a single 1024 × 1024 PNG **or** a `.icns`. Submitting the `.icns` is preferred because App Store Connect then displays correctly on the store page across all viewing sizes without re-encoding.
- Marketing variants (`Yinghua-gradient.icns`) can be used for product page hero banners / alt-store-listing, but the **primary** app icon slot must be 01 MINIMAL per `design/design-doc.md §3.1`.

---

## 7. Reproduce

If you ever need to regenerate (e.g. after a C10 master update):

```bash
cd design/_exploration/C28_mas-icon-icns

# 1. Rasterize the 7 unique sizes from each SVG
for size in 16 32 64 128 256 512 1024; do
  rsvg-convert -w $size -h $size ../C10_vector-icon/icon-01-minimal__260823.svg \
    -a -b "#00000000" -o "individual/01-minimal/icon_${size}.png"
  rsvg-convert -w $size -h $size ../C10_vector-icon/icon-02-gradient__260823.svg \
    -a -b "#00000000" -o "individual/02-gradient/icon_${size}.png"
done

# 2. Stage the .iconset directories (Apple's required filename mapping)
#    (see the shell helper in C28 build log; mapping: 32→16@2x, 64→32@2x, 256→128@2x, 512→256@2x, 1024→512@2x)

# 3. Pack
iconutil -c icns Yinghua.iconset          -o Yinghua.icns
iconutil -c icns Yinghua-gradient.iconset -o Yinghua-gradient.icns

# 4. Round-trip-verify
iconutil -c iconset Yinghua.icns -o _extracted-verify/Yinghua.iconset
sips -g pixelWidth -g pixelHeight _extracted-verify/Yinghua.iconset/*.png
```

---

## 8. Out of scope

- **C24 iOS app-iconset** (1024 only + device-specific slots) — separate work package, not generated here. Empty placeholder directory exists; future agent should follow the same rsvg-convert → Xcode `.appiconset` workflow.
- **Windows .ico** packaging — out of scope for this task.
- **PWA / favicon** — out of scope.
- **Squircle → true superellipse** conversion — the C10 spec deliberately uses the rounded-rect approximation (rx 22.4 %), so the rasterized `ic10` (1024 × 1024) is the rounded-rect. macOS will apply its own continuous-curvature squircle mask on top in Finder/Launchpad, which is the expected behavior.
