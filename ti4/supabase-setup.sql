-- ============================================================================
-- Board Game Assistant — Supabase Database Setup
-- ============================================================================
-- Run this in your Supabase project → SQL Editor → New Query → Run
--
-- This script is idempotent for fresh installs. You can paste it whole:
--   • First-time setup → creates everything from scratch
--   • Rebuilding from scratch → drops old tables (DATA LOSS) and recreates them
--
-- If you already have a working v1 TI4 deployment (just ti4_rooms, ti4_history,
-- ti4_chat) and want to add the new cross-game tables WITHOUT losing your data,
-- use `supabase-migration-v1-to-v2.sql` instead.
--
-- Compatible with the May 30, 2026 Supabase Data API permissions change:
-- explicit GRANTs are included below so new projects with opt-out defaults
-- still expose the tables to PostgREST / supabase-js.
-- ============================================================================

-- ── Drop existing tables (safe if they don't exist) ─────────────────────────
DROP TABLE IF EXISTS bg_game_log CASCADE;
DROP TABLE IF EXISTS ti4_chat    CASCADE;
DROP TABLE IF EXISTS ti4_history CASCADE;
DROP TABLE IF EXISTS ti4_rooms   CASCADE;

-- ============================================================================
-- TI4-SPECIFIC TABLES
-- ============================================================================

-- ── Active rooms (live game state) ──────────────────────────────────────────
CREATE TABLE ti4_rooms (
  room_code   TEXT PRIMARY KEY,
  state       JSONB NOT NULL DEFAULT '{}',
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Completed game history (full state snapshots) ───────────────────────────
CREATE TABLE ti4_history (
  id          BIGSERIAL PRIMARY KEY,
  room_code   TEXT,
  state       JSONB NOT NULL DEFAULT '{}',
  played_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  players     JSONB,
  winner      TEXT,
  rounds      INT,
  vp_goal     INT
);

-- ── In-game messages between players ────────────────────────────────────────
CREATE TABLE ti4_chat (
  id          BIGSERIAL PRIMARY KEY,
  room_code   TEXT NOT NULL,
  sender      TEXT NOT NULL,
  recipient   TEXT NOT NULL,
  body        TEXT NOT NULL,
  sent_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX ti4_chat_room_recipient ON ti4_chat(room_code, recipient);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE ti4_rooms    ENABLE ROW LEVEL SECURITY;
ALTER TABLE ti4_history  ENABLE ROW LEVEL SECURITY;
ALTER TABLE ti4_chat     ENABLE ROW LEVEL SECURITY;

CREATE POLICY "rooms_select" ON ti4_rooms  FOR SELECT USING (true);
CREATE POLICY "rooms_insert" ON ti4_rooms  FOR INSERT WITH CHECK (true);
CREATE POLICY "rooms_update" ON ti4_rooms  FOR UPDATE USING (true);
CREATE POLICY "rooms_delete" ON ti4_rooms  FOR DELETE USING (true);

CREATE POLICY "history_select" ON ti4_history FOR SELECT USING (true);
CREATE POLICY "history_insert" ON ti4_history FOR INSERT WITH CHECK (true);
CREATE POLICY "history_delete" ON ti4_history FOR DELETE USING (true);

CREATE POLICY "messages_select" ON ti4_chat FOR SELECT USING (true);
CREATE POLICY "messages_insert" ON ti4_chat FOR INSERT WITH CHECK (true);
CREATE POLICY "messages_delete" ON ti4_chat FOR DELETE USING (true);

-- ============================================================================
-- EXPLICIT GRANTS (required for new projects after 2026-05-30)
-- ============================================================================
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ti4_rooms,  ti4_history, ti4_chat TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON ti4_rooms,  ti4_history, ti4_chat TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON ti4_rooms,  ti4_history, ti4_chat TO service_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- ============================================================================
-- REALTIME (live sync — optional, app uses REST polling)
-- ============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE ti4_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE ti4_chat;

NOTIFY pgrst, 'reload schema';
