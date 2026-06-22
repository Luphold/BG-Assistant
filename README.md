# Board Game Assistant

A collection of companion apps and setup guides for tabletop games. The front page is a launcher that routes to per-game subpages. Each game is self-contained in its own folder so it loads fast and can be developed independently.

Currently included:

| Game | Companion | Setup Guide |
|---|---|---|
| Twilight Imperium IV | ✅ Available (`/ti4/`) | Coming soon |
| Catan | Placeholder | Coming soon |
| Small World | Placeholder | Coming soon |

---

## Project structure

```
/                       ← front page (game picker + global stats)
  index.html
  sw.js
  manifest.json
  icons/
  
/ti4/                   ← Twilight Imperium IV companion app
  index.html
  sw.js
  manifest.json
  images/
  icons/
  README.md             ← TI4-specific docs
  supabase-setup.sql    ← required database setup
```

Each game folder is fully self-contained — its own HTML, JS, service worker, and assets. No build step. No framework. Vanilla JS so it works on any modern browser.

---

## Getting started

1. **Supabase setup** — required for TI4 and any future games that sync across devices. Run `ti4/supabase-setup.sql` in your Supabase project's SQL editor. This creates the database schema (TI4 tables + the cross-game stats log).
2. **Open the app** — visit [https://luphold.github.io/bg-assistant/](https://luphold.github.io/bg-assistant/). You'll land on the front page. Tap **Twilight Imperium IV → Companion** to enter the TI4 app, then paste your Supabase URL + anon key in the settings screen.
3. **Username** — set once on the front page. Stored in `localStorage` under the key `bg_username`. All sub-apps read it, so you only enter it once.

---

## Adding a new game

To add a game (e.g. Wingspan):

1. Create a new folder at the root: `wingspan/`
2. Copy `ti4/index.html` as a starting point, or write a fresh file
3. Drop in a `manifest.json` and `sw.js` (the TI4 ones are good templates — adjust the name)
4. Add database tables to `supabase-setup.sql` if it needs sync, prefixed with the game name (e.g. `wingspan_games`, `wingspan_history`)
5. On the front page (`/index.html`), turn the placeholder card into an active card by removing the `placeholder` class and pointing the link to `wingspan/`

That's the whole template. Each game is independent — bugs in one don't crash the others, and load times stay snappy because each page only ships its own code.

---

## Hosting

Designed to work on any static host:

- **GitHub Pages** (recommended, free) — just upload the whole folder, the front page is at the repo root
- **Netlify / Vercel / Cloudflare Pages** — drag-and-drop the folder
- **Local file** — works for individual games but the front page's PWA features require a real URL

---

## Tech stack

- Pure HTML / CSS / vanilla JS (ES5-safe for broad mobile support)
- Supabase for real-time multi-device sync (REST polling)
- IndexedDB for local-only settings and game caches
- localStorage for shared cross-app state (username only)
- Service workers in network-first mode so updates roll out immediately

---

## License & credits

This is a personal project. Twilight Imperium IV, Catan, Small World, and all referenced game names/content are trademarks of their respective publishers. This project is a fan-made companion, not officially affiliated with any publisher.
