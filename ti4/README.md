# TI4 Tracker — Twilight Imperium IV Companion App

A free, web-based companion app for **Twilight Imperium IV**. Tracks scores, objectives, technology, voting, faction sheets, and full game history across multiple devices in real time.

Runs on Android, iOS, and any modern browser. Install as a PWA for a native-app feel on phone or tablet.

---

## ✨ Features

**Game tracking**
- Real-time multi-device sync (admin controls, guests follow along, ~3s latency)
- Public objectives (Stage 1 & 2) with the official deal-out flow, plus optional **Reveal All** mode
- **+ Add Stage 1 / Stage 2** tiles for custom extra objectives (random pick)
- Secret objective scoring (max 3 per player) with **Make Public** conversion to a third row of public objectives
- Other scoring sources (Imperial, Custodians, Support for the Throne, Mutiny, relics, etc.) plus free-text Other
- Per-player technology tracking with full prereq display, color-coded tech tree, and starting techs

**Full faction database**
- All 30 dropdown faction picks (including base, Prophecy of Kings, Codex, and Tales of Empires factions)
- Each sheet shows: starting units, tech (color-coded by type), planets, commodities, difficulty
- Faction abilities, promissory note, flagship, mech, faction-specific units, breakthrough (with prereq markers), and leaders (agent / commander / hero)
- Combined Firmament / Obsidian sheet with toggle to view either form

**Voting phase (simplified)**
- Two votes per round, automatically triggered after Custodians (Mecatol Rex) is claimed
- Every claimed player gets a popup with a number field + free-text comment
- Admin sees **Results** screen with scrambled anonymous votes by default; toggle to reveal voters
- Auto-refresh every 3 seconds
- **🗳 Vote tab** (admin-only) records every past vote by round for review
- **Advanced voting** placeholder for future feature

**Player claim & messaging**
- Each player claims their slot from their own device
- 💬 in-game messaging between claimed players (works like iMessage threads)
- Sound + popup notifications, no spam (one alert per sender until you read the thread)

**Quality of life**
- Strategy card tracking with per-round picks (1 or 2 cards each for ≤4 players)
- Round photos via native camera, automatically rotated and bundled into history
- Game timer with pause/resume
- Round-by-round history with full event log and exportable PNG share
- Friendly setup with VP goal selector, randomize colors, faction-uniqueness enforcement

---

## 🚀 Setup Guide

This app needs a **Supabase** database (free tier is more than enough) to enable real-time sync between devices. Setup takes about 10 minutes.

### Step 1 — Create a free Supabase account

1. Go to [https://supabase.com](https://supabase.com) and click **Start your project** (or **Sign in**)
2. Sign up with GitHub, Google, or email
3. Once signed in, click **New Project**
4. Fill in:
   - **Project name** — anything you want (e.g., "TI4-Tracker")
   - **Database password** — generate a strong one (you won't need to remember it for normal use)
   - **Region** — pick the one closest to where you'll play
   - **Pricing plan** — **Free** is fine
5. Click **Create new project** and wait ~1 minute for it to provision

### Step 2 — Run the database setup script

1. In your Supabase project dashboard, click **SQL Editor** in the left sidebar
2. Click **+ New query** (top right)
3. Open `supabase-setup.sql` from this repo, copy its entire contents
4. Paste into the SQL Editor and click **Run** (or `Ctrl+Enter` / `Cmd+Enter`)
5. You should see "Success. No rows returned." — that's correct

This creates three tables: `ti4_rooms` (current game state), `ti4_history` (cloud-saved completed games), and `ti4_chat` (in-game private messages).

> **Note about new projects after May 30, 2026:** Supabase changed its default so that new tables in the public schema are no longer automatically exposed to the Data API — they need explicit `GRANT` statements. The included `supabase-setup.sql` already contains the required grants, so this script works correctly on both old and new projects with no further action needed. Existing projects created before that date continue working as-is until October 30, 2026.

### Step 3 — Get your API credentials

1. In Supabase, click the **Settings** ⚙ icon (bottom left)
2. Click **API Keys**
3. You'll need two things:
   - **Project URL** — looks like `https://abcdefghij.supabase.co`
   - **Project API Key** → the **anon / public** key (a long string starting with `eyJ…`)
4. Keep this tab open — you'll paste these into the front-page Settings in a moment.

### Step 4 — Open the app

Open the Board Game Assistant front page at **[https://luphold.github.io/bg-assistant/](https://luphold.github.io/bg-assistant/)**.

1. On first visit, a Settings modal opens automatically asking for your Supabase URL and Anon Key
2. Paste them in and tap **Save** — credentials are saved locally and shared across all games
3. Enter your **Username** in the username field at the top (used for player claim and messaging)
4. Tap **Twilight Imperium IV → Companion** to launch the TI4 app
5. Tap **Enter as Admin** (or **Enter as Guest** + room code if joining)

You're done with setup! Credentials are saved locally on this device — you won't need to enter them again unless you clear browser data. To change them later, tap the **⚙** gear icon in the top-right of the front page.

> ⚠️ **Don't share your Supabase password.** Only share the **URL** and the **anon key**. The anon key is public-safe and is meant to be embedded in client apps.

---

## 🎮 How to Use

### Starting a game (Admin)

1. Tap **Enter as Admin** — a 6-letter room code appears at the top. Share it with your players.
2. In the **Setup** tab, two default players are already added. Tap **+ Add Player** for each additional player (up to 8).
3. Edit names, pick faction (each faction can only be used once), tap the circle to pick a color, or use **🎲 Randomize Colors** for a quick spread.
4. View any faction sheet by tapping **📜 Sheet** — shows starting units, tech, planets, abilities, breakthrough, leaders.
5. **Features row** — tap to toggle: **Strategy**, **Tech**, **Messaging**, **Reveal objectives** (all face-up from start). Active features have a gold border.
6. **Voting row** — pick **Advanced** (placeholder for future), **Simplified** (default, used now), or **Off**.
7. Tap **⚔ Start Game**. With ≤4 players and Strategy on, you're asked whether each player picks 1 or 2 strategy cards per round. Then claim a player slot (or pick **🛠 Admin Only Device**).

### Joining a game (Guest)

1. Enter Username + the admin's Room Code → tap **Enter as Guest**
2. The score board updates live (3s sync)
3. You'll get a prompt to claim a player slot. Once claimed, the **💬** message button appears.

Guests can view Setup, Score, Tech, and History tabs. They can't edit scores or settings, and the Strategy/Vote tabs are admin-only.

### Scoring (Admin)

- **Public objectives** are at the top. Round 1 reveals two stage-1 cards; each Next Round reveals one more, alternating stage 1 → stage 2 (or all face-up immediately if **Reveal objectives** is on).
- Tap any face-up objective to open the enlarged view:
  - **Score** → pick a player who completed it
  - **♻** recycle → replace with new random card from the same stage
  - **✕** next to a scored player → undo
- Tap the **+ ADD STAGE 1/2** tiles at the end of each row to add an extra random objective (max 1 extra per stage).
- **Secret Objectives**: tap **+ Score Secret** → pick objective (grouped by Status/Action/Agenda) → pick player. Max 3 per player.
- **Make Public** button on a scored secret converts it into a 1-VP public objective in a new third row. The original scorer keeps their VP; their secret count drops by 1.
- **Other Objectives**: Custodians, Imperial, Support for the Throne, Mutiny, Shard of the Throne, Crown of Emphidia, plus free-text "Other".

### Strategy cards

Every round, each player picks their strategy card on the **Strategy** tab (admin-only). Cards are unique per round — same card can't be picked by two players. All 8 standard TI4 cards. With ≤4 players + "2 cards each" mode, each player picks two cards per round.

### Round flow

1. Admin taps **Next Round ▶** — strategy gate checks every player has picked
2. Optional board photo (saved with the round)
3. If Voting = Simplified AND Custodians has been claimed → **Voting Phase** runs
4. Otherwise the round advances directly

### Voting phase

- Two votes per round (vote 1 → results → admin taps **Next Vote ▸** → vote 2 → results → **Finish & Advance**)
- Every claimed player gets a popup with a number field (or empty = abstain) and free-text comment
- Admin sees the **📊 Results** screen in the top bar:
  - While votes are pending → only the waiting list is shown
  - When all in → scrambled order, no names; tap **👁 Reveal voter names** to expose who voted what
- All past votes are saved to the **🗳 Vote** tab (admin only), grouped by round

### Messaging

- Only claimed players can send/receive messages. Tap **💬** in the top bar to open thread list.
- Pop-up + sound when a new message arrives — only triggers once per sender until you read the thread.

### After the game

- Setup, Strategy, and Tech tabs are locked. Score, Vote, and History stay accessible for review.
- **History** preserves every event of every round, plus all round photos bundled at end-of-game.
- Tap **📤** on a history entry to export as a PNG image to share.

---

## ⚠️ Things to keep in mind

- **Games of 2 rounds or less are not saved to history** — these are assumed to be test/debug games.
- **The admin must keep the app open** (or running in the background) for sync to work. If the admin closes the app, use **↺ Resume Previous Game** on the launch screen.
- **Round photos stay local on the admin device** during the game and only get attached to history when the game ends. Clearing storage before End Game loses them.
- **Sync polls every 3 seconds** — small delay between admin actions and what guests see.
- **Free Supabase tier is plenty.** A typical game stores well under 100 KB of data.

---

## 🌐 Hosting

You can host this app anywhere static files can be served:

**GitHub Pages (free, recommended):**
1. Fork or upload this repo to your own GitHub account
2. In the repo settings, enable Pages → deploy from `main` branch, root
3. Visit `https://<your-username>.github.io/<repo-name>/`

**Other free options:** Netlify, Vercel, Cloudflare Pages — drag-and-drop the folder onto their dashboard.

**Locally:** since this is just static HTML, you can also just open `index.html` directly in a browser, but PWA features (offline, install) require it to be served from a real URL.

---

## 🛠️ Troubleshooting

**"Failed to connect" when saving Supabase settings**
- Double-check that you pasted the URL (not the key) into the URL field
- The URL should look like `https://abcdefghij.supabase.co` — no `/rest/v1/` at the end
- The anon key should start with `eyJ…` and be very long
- Make sure you ran `supabase-setup.sql` and got "Success. No rows returned."

**Guest can't see admin's game**
- Both must use the same Supabase URL and anon key
- Room code must match exactly (uppercase, 6 characters)
- Tap the **🐞** button (bottom right) to see the connection log

**Buttons not responding / weird behavior after an update**
- Open the front-page **⚙** Settings and tap the **↺** button (left side) to clear cache and reload

---

## 📋 Tech notes

- Single-file HTML PWA — no build step, no npm, no framework
- Vanilla JS (ES5-friendly for broad mobile compatibility)
- IndexedDB for local settings + history + photo cache
- Supabase REST API (polling every 3s — no WebSocket needed)
- Service worker is intentionally **no-cache** so updates roll out instantly
- Web Audio API for notification sounds (no audio file needed)

Enjoy your games of TI4! 🚀⚔
