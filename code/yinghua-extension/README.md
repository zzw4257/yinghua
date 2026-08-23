# 映话 Yinghua · Chrome Browser Extension

> 录你在浏览器里开的会。**全部本地**。零上传。零第三方依赖。

This is the Yinghua Chrome browser extension — the browser-side companion
to the macOS 映话 app (`code/Yinghua/`). It captures the tab audio of Zoom /
Google Meet / Microsoft Teams meetings using `chrome.tabCapture` + a hidden
`MediaRecorder` running in an offscreen document, and persists the resulting
audio as a `Blob` in IndexedDB.

**Status**: v0.1.0 manifest (C21 audit · **PASS**). On top of that audit-frozen
base, this build adds three advanced features shipped under v0.2:

- **Popover panel** — click the bubble → a 400×600 glass console drops down
  with live timecode, VU meter, rolling transcript, and an AI summary preview.
- **Live VU meter** — 12-band spectrum analyzer driven by
  `AnalyserNode.getByteFrequencyData()`, rendered at 60fps with green/yellow/red
  thresholds. The data flows: `offscreen` (Web Audio) → `background` →
  `content` (bubble page) → `panel` (iframe).
- **Export to Markdown / .webm** — every recording in the popup has an
  `Export ▾` menu that downloads either a `.md` (transcript + 4-section AI
  summary) or the raw `.webm` blob. No new permissions needed — the popup
  uses a synthetic `<a download>` on a `blob:` URL.

This MVP is intentionally narrow on the **transcription/summary** axis: the
extension captures audio only; transcription and summarization land via the
macOS app's `AVAudioEngine` + `SpeechAnalyzer` pipeline.

---

## Install (developer / unpacked)

1. Open `chrome://extensions/` in Chrome (or any Chromium-based browser:
   Edge, Brave, Arc, etc.).
2. Toggle **Developer mode** in the top-right.
3. Click **Load unpacked**.
4. Select this directory (`code/yinghua-extension/`).
5. Pin the extension to the toolbar (puzzle piece → pin).

The Yinghua icon (purple→teal gradient Y) should appear in your toolbar.

## Use

1. Open a meeting in your browser:
   - `https://zoom.us/j/<meeting-id>`
   - `https://meet.google.com/<meeting-code>`
   - `https://teams.microsoft.com/...`
2. A small circular **Y bubble** appears at the top-right of the page
   (60×60, glass, animated REC dot when active).
3. Click the bubble → the **400×600 popover panel** drops down with:
   - **Big timecode** (56pt JetBrains Mono, tabular-nums, gradient when active)
   - **Live VU meter** (12 bars, green → yellow → red)
   - **Rolling transcript** (5 lines visible, scrolls to bottom)
   - **AI summary preview** (4 collapsible sections: Key moments / Decisions /
     Action items / Open questions)
   - **Stop** + **Settings** footer
4. Click **开始录制** (from the panel or the popup). The bubble's REC dot
   pulses, the timecode ticks, the VU meter mirrors the spectrum of the tab
   audio (voice energy peaks at the center bars).
5. Click **停止录制**. The audio is written to IndexedDB as a WebM/Opus Blob.
6. Click the **extension toolbar icon** to open the popup. For each recording:
   - **在桌面 App 中打开** — hand off to the macOS app (requires the
     `nativeMessagingHost` to be installed; otherwise the call is a no-op).
   - **Export ▾** → **Markdown** (transcript + 4-section AI summary) or
     **.webm** (raw audio blob). Files land in your default Downloads.
   - **×** — delete.

## Data flow

```
┌────────────────────┐   chrome.tabCapture   ┌──────────────────────┐
│ Zoom/Meet/Teams    │ ────────────────────► │  Offscreen document  │
│ (active tab audio) │   getMediaStreamId    │  MediaRecorder       │
└────────────────────┘                       │  (Opus/WebM, 5s slice)│
                                             └──────────┬───────────┘
                                                        │ blob chunks
                                                        ▼
                                             ┌──────────────────────┐
                                             │  IndexedDB           │
                                             │  yinghua-recordings  │
                                             │  (browser-local)     │
                                             └──────────────────────┘
                                                        ▲
                                                        │ list / delete
                                             ┌──────────┴───────────┐
                                             │  Popup (UI)          │
                                             │  + Content bubble    │
                                             └──────────────────────┘
```

**No data ever leaves the browser.** There are no `fetch` / `XMLHttpRequest`
calls in this extension. The manifest's `host_permissions` only exist so the
content script can inject the bubble; they do not enable network egress.

## File map

| File | Role |
|------|------|
| `manifest.json` | MV3 manifest. Permissions: `tabCapture`, `offscreen`, `activeTab`, `storage`, `scripting`. **Frozen at v0.1.0** (C21 audit · PASS). |
| `content.js` + `content.css` | Detects platform, injects bubble + popover panel iframe into Zoom/Meet/Teams. Bridges `postMessage` between the panel and the SW. |
| `background.js` | Service worker. Owns recording state, routes messages, manages offscreen lifecycle, forwards `vuMeter` / `transcriptLine` to the active tab. |
| `offscreen.html` + `offscreen.js` | Hidden document. Receives the tab stream ID, runs `MediaRecorder`, writes Blobs to IndexedDB. Also owns the **Web Audio `AnalyserNode` chain** that produces the 12-band VU signal (logarithmic 60 Hz – 8 kHz, mirrored). |
| `popup.html` + `popup.js` + `popup.css` | Extension action popup. Shows current tab, start/stop, recordings list, and the **Export ▾ menu** (Markdown / .webm). |
| `panel.html` + `panel.css` + `panel.js` | 400×600 popover panel (rendered inside a `chrome-extension://…/panel.html` iframe). Big timecode, VU meter, transcript, AI summary preview, Stop / Settings. |
| `vu-meter.css` | VU meter styles — 12 bars, green / yellow / red color thresholds, `prefers-reduced-motion` honored. |
| `export.js` | Popup-side `YinghuaExport` namespace: `exportMarkdown(rec, summary, transcript)`, `exportWebm(rec)`, `suggestFilename(rec, ext)`. Uses a synthetic `<a download>` on a `blob:` URL (no `chrome.downloads` permission required). |
| `icons/icon-{16,48,128}.png` | Resized from `C10_vector-icon/icon-02-gradient-1024__260823.png` via `sips`. |
| `README.md` | This file. |

## Design

Visual language follows `design/design-tokens.json` and `design/design-doc.md`
§2.5 (glass) and §3 (iconography):

- **Brand gradient**: `linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%)`
- **Glass**: `backdrop-filter: blur(40px) saturate(180%)` on top of `rgba(10, 10, 15, 0.7)`
- **REC red**: `#FF3B30` (1.4s pulse animation, 1.0 → 1.18 → 1.0)
- **Hairline**: `rgba(244, 241, 236, 0.08)` — 1px borders
- **Card radius**: 12–14px. **Bubble radius**: 50% (60×60 circle)
- **Type**: system-ui (SF Pro on macOS), JetBrains Mono for durations
- **`prefers-reduced-motion`**: honored — pulse + spring transitions degrade to plain fade

The Y mark inside the bubble is an inline SVG using the same 135° purple→teal
gradient as the app icon (matches `C07` 02 GRADIENT). The popup uses the same
SVG with the same gradient.

## MVP limitations (deliberate)

| Limitation | Why | When it lands |
|------------|-----|---------------|
| Audio only, no video capture | Matches macOS app's MVP (`code/Yinghua/README.md` — `AVAudioEngine` only) | v0.3 — possibly never, by design |
| No live transcription in the extension | Browser Web Speech API is too unreliable + forces network | macOS app handles it with `SpeechAnalyzer` (macOS 26) |
| No AI summary in the extension | BYOK is already in the macOS app; we won't duplicate it | Already in macOS app |
| `openInMacApp` requires a native messaging host to be installed | Bridge to the macOS app — separate deliverable | v0.3 — needs `nativeMessagingHosts/com.yinghua.macbridge.json` registered |
| Zoom meeting URLs must be `zoom.us/j/*` (no `zoom.us/wc/join/*`) | Simplest URL pattern that matches the in-meeting page; we can broaden later | v0.3 |
| Recordings live only in the browser profile | Profile wipe = recordings gone | v0.3 — hand off to the macOS app via native messaging |
| Export Markdown has no real transcript / summary to embed | The extension captures audio only; transcript + summary come from the macOS app | Once the macOS app writes them back into the IndexedDB record |

## Privacy stance

- **No network.** No fetch / XHR / WebSocket / `<img src=remote>` / telemetry.
- **No third-party scripts.** Pure vanilla JS + Chrome MV3 APIs.
- **No analytics.** No `chrome.telemetry` etc.
- **No upload to any server.** All audio stays in `chrome-extension://<id>/...`'s
  IndexedDB (`yinghua-recordings`).

To verify: open DevTools on the popup → Network tab. Even after recording a
5-minute meeting, the network log will be empty.

## Next steps (out of MVP scope)

1. **Native messaging host** so the popup's "在桌面 App 中打开" button hands
   the recording blob to the macOS app (which already knows how to import,
   transcribe, summarize, and store it under
   `~/Library/Application Support/Yinghua/`).
2. **In-popup audio playback** via `<audio src=URL.createObjectURL(blob)>`.
3. **Meeting detection on more patterns** (`zoom.us/wc/join/*`,
   `teams.live.com/...`).
4. **Sync with the macOS app** via the native messaging host — show the same
   list of recordings, with a "Last synced X minutes ago" indicator.
5. **Real transcript / summary in Export Markdown** — once the macOS app
   writes them back into the IndexedDB record, the `.md` exporter can embed
   them instead of rendering an empty template.

## Sanity-check (load unpacked)

After loading unpacked in `chrome://extensions/`:

- No errors should appear under the extension card.
- Open `https://meet.google.com/abc-defg-hij` (any valid code; doesn't need
  to actually start a meeting) — the bubble should appear top-right within
  ~200ms.
- Click the bubble → the **400×600 popover panel** should drop in (glass +
  aurora wash + brand-gradient timecode, even before any recording starts).
- Click **开始录制** in the panel — the VU meter should mirror your voice /
  meeting audio in real time (center bars loudest, red on peaks).
- Open DevTools on the page → check the Console for any message starting with
  `[yinghua]`. Nothing should print unless recording fails.
- Click the toolbar icon → the 360×460 popup should open with glass + gradient
  + hairline + JetBrains Mono duration. Stop a recording, then on its list
  item click **Export ▾ → Markdown** — a `yinghua-2026-08-23-1530-…md` file
  should land in your Downloads.

## License

Personal project (周子为 / Yinghua). Not currently published to the Chrome Web
Store.
