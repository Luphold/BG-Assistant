-- ============================================================================
-- Board Game Assistant — Migration from v1 (TI4-only) to v2 (multi-game)
-- ============================================================================
-- Run this in your EXISTING Supabase project → SQL Editor → New Query → Run
--
-- This is SAFE — it does NOT touch your existing ti4_rooms, ti4_history, or
-- ti4_chat tables. It only ADDS the new bg_game_log table needed for the
-- cross-game stats feature on the Board Game Assistant front page.
--
-- After running this, the front page's "Global Stats" panel will start
-- showing real numbers as games finish.
-- ============================================================================

-- ── Add the new cross-game log table ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bg_game_log (
  id              BIGSERIAL PRIMARY KEY,
  game_type       TEXT NOT NULL,
  played_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  duration_min    INT,
  player_count    INT,
  players         JSONB,
  winner          TEXT,
  data            JSONB
);

CREATE INDEX IF NOT EXISTS bg_game_log_game_type ON bg_game_log(game_type);
CREATE INDEX IF NOT EXISTS bg_game_log_played_at ON bg_game_log(played_at DESC);

-- ── Row-level security & policies ──────────────────────────────────────────
ALTER TABLE bg_game_log ENABLE ROW LEVEL SECURITY;

-- Drop policies if they already exist (safe re-run)
DROP POLICY IF EXISTS "gamelog_select" ON bg_game_log;
DROP POLICY IF EXISTS "gamelog_insert" ON bg_game_log;

CREATE POLICY "gamelog_select" ON bg_game_log FOR SELECT USING (true);
CREATE POLICY "gamelog_insert" ON bg_game_log FOR INSERT WITH CHECK (true);

-- ── Explicit grants for the new table ──────────────────────────────────────
GRANT SELECT, INSERT, UPDATE, DELETE ON bg_game_log TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON bg_game_log TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON bg_game_log TO service_role;
-- Sequence grant (BIGSERIAL needs nextval at insert time)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;

-- ── Refresh PostgREST schema cache so the new table is visible immediately
NOTIFY pgrst, 'reload schema';

-- ── Done!
-- Verify with:
--   SELECT * FROM bg_game_log LIMIT 1;
-- (Should return 0 rows; that's expected.)
