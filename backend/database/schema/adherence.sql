CREATE SCHEMA IF NOT EXISTS adherence;

/*
-- Documentation:
-- The adherence schema tracks the patient's compliance with their medication schedules.
-- It records doses taken/missed and calculates streaks and overall adherence reports.

-- Edge Cases:
-- - Adherence calculation should ignore doses scheduled in the future.
-- - Streaks calculations need to account for 'skipped' vs 'missed' appropriately (e.g. skipped might not break a streak if advised by doctor).
*/

CREATE TYPE adherence.dose_logs_status AS ENUM (
    'taken',
    'skipped',
    'missed'
);

CREATE TABLE adherence.adherence_reports (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    doses_count_expected INT NOT NULL,
    doses_count_taken INT NOT NULL,
    adherence_percentage DECIMAL(5, 2) NOT NULL,
    generated_at timestamptz NOT NULL DEFAULT now ()
);

-- RLS for adherence_reports
ALTER TABLE adherence.adherence_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY adherence_reports_self_read ON adherence.adherence_reports FOR SELECT USING (user_id = current_setting('app.current_user_id', true)::uuid);
CREATE POLICY adherence_reports_self_manage ON adherence.adherence_reports FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE TABLE adherence.dose_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    scheduled_dose_id uuid NOT NULL REFERENCES schedule.scheduled_doses (id) ON DELETE CASCADE,
    user_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
    status adherence.dose_logs_status NOT NULL DEFAULT 'missed',
    notes text,
    logged_at timestamptz NOT NULL DEFAULT now ()
);

-- RLS for dose_logs
ALTER TABLE adherence.dose_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY dose_logs_self_read ON adherence.dose_logs FOR SELECT USING (user_id = current_setting('app.current_user_id', true)::uuid);
CREATE POLICY dose_logs_self_manage ON adherence.dose_logs FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE TABLE adherence.streaks (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id uuid NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
    current_streak INT DEFAULT 0,
    longest_streak INT DEFAULT 0,
    last_calculated_at timestamptz NOT NULL DEFAULT now ()
);

-- RLS for streaks
ALTER TABLE adherence.streaks ENABLE ROW LEVEL SECURITY;
CREATE POLICY streaks_self_read ON adherence.streaks FOR SELECT USING (user_id = current_setting('app.current_user_id', true)::uuid);
CREATE POLICY streaks_self_manage ON adherence.streaks FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);