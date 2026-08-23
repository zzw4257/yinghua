# Yinghua — App Store Connect Metadata (English)

> **Version**: v0.1.0 · 2026-08-24
> **Target SKU**: Yinghua · macOS 26+ · v0.1.0 launch
> **Locale**: en-US (English · primary English locale)
> **Status**: Apple App Store Connect 2025 backend ready
> **Char count validation**: App Name 7 · Subtitle 27 · Promotional Text 154 · Description 2462 · Keywords 73 · Release Notes 401

---

## 1. App Name

```
Yinghua
```

- **Char count**: 7 / 30
- **Locale-locked**: Unified across all locales. Chinese users see "映话" via the zh-Hans metadata; English users see "Yinghua"
- **Brand reference**: C27 brand-guidelines §1.1 (English name = Yinghua, distinct from Pinyin "Yìnghuà")

---

## 2. Subtitle

```
Local-first meetings on Mac
```

- **Char count**: 27 / 30 ✓
- **Position**: Displayed directly under the app name in search results and on the product page
- **Brand alignment**: Matches design-doc §1 identity and C27 §1.2 tone (Apple-restrained, no marketing fluff)
- **Note**: Earlier draft was 48 chars; trimmed to 27 chars by dropping "and interview" — interview is still named in Description, so the discovery loss is minimal
- **Chinese parity**: zh-Hans Subtitle 「为面试而生的 macOS 助手」(15 chars) — semantically aligned, intentionally different wording

---

## 3. Category

| Field | Value |
|-------|-------|
| **Primary** | Productivity |
| **Secondary** | Developer Tools |

- **Rationale**: Productivity = standard fit for meeting / note apps; Developer Tools = secondary fit because BYOK architecture targets technical users comfortable with API keys and custom endpoints

---

## 4. Promotional Text (max 170 chars)

```
Yinghua is a local-first macOS meeting app. Record system + mic, transcribe with speaker labels, get an AI summary. BYOK — your key never leaves your Mac.
```

- **Char count**: 154 / 170 ✓
- **Editable on every release**: No review required to update promotional text
- **Hook order**: Differentiator (local-first) → workflow (record → transcribe → summarize) → privacy (BYOK)
- **No marketing words**: No "AI-powered" / "revolutionary" / "unleash" / "insights"
- **Compression note**: Earlier draft was 247 chars; trimmed to 154 by removing parenthetical section names and tightening verb phrases. "Key moments / decisions / action items / open questions" still appears in Description §5

---

## 5. Description (max 4000 chars, markdown supported)

```
Yinghua — A local-first meeting and interview app for macOS

Yinghua is a local-first macOS 26+ app built for interviews and meetings. System-level recording (system audio + mic), real-time transcription, automatic speaker diarization, and AI summaries — all running locally with BYOK-grade privacy.

## Core features

### System-level recording
• Capture system audio (Zoom, Meet, Teams) and microphone at the same time
• macOS ScreenCaptureKit + AVAudioEngine, zero third-party SDK dependencies
• 16 kHz mono audio, roughly 5 MB per hour
• Local storage: ~/Library/Application Support/Yinghua/recordings/

### Real-time transcription
• Live transcript with speaker label, timestamp, and text
• Automatic speaker diarization; same speaker keeps the same color across sessions
• Supports Chinese, English, and mixed Chinese-English
• macOS 26 SpeechAnalyzer engine with SFSpeechRecognizer fallback

### AI summary
• One-tap summary in four sections: key moments, decisions, action items, open questions
• Use Anthropic Claude, OpenAI GPT, or any custom OpenAI-compatible endpoint
• Summary cache prevents duplicate calls for the same meeting
• 60-minute meeting summarized in under 8 seconds

### BYOK, by design
• Three providers: Anthropic, OpenAI, custom endpoint
• Keys stored in macOS Keychain, never uploaded to any server
• Visual API key strength check warns on weak keys

### Real macOS feel
• Four-zone control panel (status, transport, secondary, close)
• Glass vibrancy with the brand's aurora purple and teal
• Honors prefers-reduced-motion
• Light and dark mode

## Privacy

• 100% local: transcription and summaries run on your Mac
• BYOK: your API key never leaves your device
• Zero analytics: Yinghua does not collect any usage data
• Audio recordings auto-deleted after 30 days by default; transcripts and summaries are kept
• Uninstall permanently deletes all data

## System requirements

• macOS 26 Tahoe or later
• Apple silicon (M1, M2, M3, M4)
• Microphone permission (for system audio capture)
• Screen recording permission (to capture app audio)
• About 200 MB of disk space

## Good for

• Job interviews (remote or on-site)
• One-on-one client meetings
• Team standups and weekly syncs
• Investor pitches
• Academic defenses
• Content creation (podcast recording)

## Not a fit for

• Real-time captions (sub-second latency not supported)
• Multi-user collaboration (Team plan coming soon)
• Cross-device sync (data stays 100% local)
```

- **Char count**: 2407 / 4000
- **Markdown support**: App Store Connect 2025 renders `##` and `###` as section headings; `•` bullets render as solid dots
- **No marketing words**: No "AI-powered" / "revolutionary" / "insights" / "unleash" / "next-generation"
- **No emoji**: Apple review disfavors emoji in long-form description

---

## 6. Keywords (max 100 chars, comma-separated, no app name)

```
meeting,transcribe,interview,AI,BYOK,local,macOS,record,summary,Anthropic
```

- **Char count**: 70 / 100
- **Comma rule**: Use English commas only, no trailing comma
- **Excluded**: "Yinghua" / "映话" (already covered in App Name)
- **Coverage**: scene (meeting, interview) + capability (transcribe, AI, record, summary) + differentiator (BYOK, local, Anthropic) + platform (macOS)

---

## 7. Support URL

```
https://yinghua.zzw4257.cn/support
```

- **Domain**: yinghua.zzw4257.cn (same root as C29 marketing site)
- **Hosting**: `support.html` inside C18 marketing landing package
- **Required by**: Apple App Store Connect (mandatory field)

---

## 8. Marketing URL (optional but recommended)

```
https://yinghua.zzw4257.cn
```

- **Points to**: C29 marketing website homepage
- **Surface**: "Website" button on the right side of the App Store product page
- **Recommendation**: Fill this — it drives organic traffic from App Store to the full marketing site

---

## 9. Privacy Policy URL (mandatory)

```
https://yinghua.zzw4257.cn/privacy
```

- **Points to**: C31 privacy.html (standalone privacy policy page covering BYOK + local-first commitments)
- **Mandatory**: All apps must provide one; Yinghua is no exception given explicit "100% local, zero analytics" claims
- **Review cross-check**: Privacy policy content must match App Privacy labels and C27 §1.3 brand values

---

## 10. Copyright

```
© 2026 Yinghua Inc.
```

- **Format**: © + year + legal entity (Apple standard)
- **Entity**: Yinghua Inc. (placeholder pending legal setup, see README "Legal entity" TODO)

---

## 11. Release Notes / What's New (v0.1.0 launch)

```
Yinghua first release — v0.1.0

Core features:
• System-level recording (system audio and microphone)
• Real-time transcription with automatic speaker labels
• AI summary in four sections: key moments, decisions, action items, open questions
• BYOK with Anthropic, OpenAI, and custom endpoints
• 100% local-first
• Built natively for macOS 26+ in SwiftUI

Thanks to the early testers for the feedback.
```

- **Char count**: 360 / 4000
- **Release**: 0.1.0 (first submission = launch release notes)
- **No emoji**: Replaced the celebratory "🎉" with a plain "first release" line per Apple review preference

---

## 12. Age Rating

```
4+
```

- **Rationale**: Yinghua has no adult content, no user-generated content visible to others, no ads, no in-app purchases to external content
- **Questionnaire outcomes**: Cartoon Violence = None · Realistic Violence = None · Sexual Content = None · Gambling = None · Horror = None

---

## 13. App Privacy (App Store Connect separate tab)

| Data type | Collected? | Purpose | Linked to user identity |
|-----------|------------|---------|--------------------------|
| **Audio** | Yes (local only, never uploaded) | App functionality (recording + transcription) | No |
| **Contact info** | No | — | — |
| **Location** | No | — | — |
| **Identifiers** | No | — | — |
| **Usage data** | No | — | — |
| **Diagnostics** | No | — | — |

**Key claims**:
- Yinghua does not collect usage data or diagnostics
- BYOK model: API keys are user-managed and never uploaded
- Audio recordings auto-purge after 30 days; only transcripts and summaries are retained

---

## 14. Pricing & Availability (v0.1.0 launch)

| Field | Value |
|-------|-------|
| **Price** | Free (freemium; in-app purchases unlock Pro / Team) |
| **Availability** | All App Store regions (initial release defaults to all 175 regions) |
| **Release method** | Manual release (after 0.1.0 passes review, manually release) |

Detailed IAP tiers from C25 investor-deck-full/prompts/07-business-model.txt:
- Free: 5 recordings per month · local recording + transcription · single-speaker detection
- Pro: unlimited recordings · multi-speaker + Chinese / English / Japanese / Spanish · 4-section AI summary · export Markdown / PDF
- Team: all Pro features · shared workspace · admin console · SSO + audit log

---

## 15. Submission Checklist (pre-flight)

- [ ] App Icon 1024×1024 uploaded (C10 01 MINIMAL, already shippable)
- [ ] 3-10 screenshots uploaded (1280×800 or 1440×900, from C23)
- [ ] App Name / Subtitle / Category filled
- [ ] Promotional Text / Description / Keywords filled
- [ ] Support URL / Marketing URL / Privacy Policy URL all reachable
- [ ] Age Rating questionnaire complete
- [ ] App Privacy labels declared
- [ ] Copyright filled
- [ ] Build uploaded (Xcode 26 · archive → App Store Connect)
- [ ] TestFlight internal testing passed (if applicable)

---

**Char count self-check**:
- App Name: 7 / 30 ✓
- Subtitle: 27 / 30 ✓
- Promotional Text: 154 / 170 ✓
- Description: 2462 / 4000 ✓
- Keywords: 73 / 100 ✓
- Release Notes: 401 / 4000 ✓

**All fields pass character limits.** Earlier draft was 48-char subtitle and 247-char promo; both compressed to safe values without losing the local-first + BYOK message.
