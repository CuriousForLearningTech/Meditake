CREATE SCHEMA IF NOT EXISTS schedule;

/*
-- Documentation:
-- The schedule schema manages the specific times a medication should be taken, 
-- and the logs of actual scheduled doses.

-- Edge Cases:
-- - Daylight saving time shifts can cause scheduled times to be off by an hour if not handled in code.
-- - Missed doses might need to be automatically marked as missed after a certain time window.
*/

CREATE TYPE schedule.schedule_status AS ENUM (
    'active',
    'paused',
    'completed',
    'cancelled'
);

CREATE TYPE schedule.dose_status AS ENUM (
    'pending',
    'taken',
    'skipped',
    'missed'
);

CREATE TABLE schedule.medication_schedules (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    prescription_medication_id uuid NOT NULL REFERENCES prescription.prescription_medications (id) ON DELETE CASCADE,
    recurrence_rule_id uuid REFERENCES prescription.recurrence_rules (id),
    scheduled_time time NOT NULL,
    effective_from date NOT NULL,
    effective_until date,
    status schedule.schedule_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    CHECK (effective_until IS NULL OR effective_until >= effective_from)
);

-- RLS for medication_schedules
ALTER TABLE schedule.medication_schedules ENABLE ROW LEVEL SECURITY;
CREATE POLICY med_schedules_patient_read ON schedule.medication_schedules FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM prescription.prescription_medications pm
        JOIN prescription.prescriptions p ON p.id = pm.prescription_id
        WHERE pm.id = medication_schedules.prescription_medication_id
        AND p.patient_id = current_setting('app.current_user_id', true)::uuid
    )
);
CREATE POLICY med_schedules_patient_manage ON schedule.medication_schedules FOR ALL USING (
    EXISTS (
        SELECT 1 FROM prescription.prescription_medications pm
        JOIN prescription.prescriptions p ON p.id = pm.prescription_id
        WHERE pm.id = medication_schedules.prescription_medication_id
        AND p.patient_id = current_setting('app.current_user_id', true)::uuid
    )
);

CREATE TABLE schedule.scheduled_doses (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    schedule_id uuid NOT NULL REFERENCES schedule.medication_schedules (id) ON DELETE CASCADE,
    scheduled_at timestamptz NOT NULL,
    status schedule.dose_status NOT NULL DEFAULT 'pending',
    taken_at timestamptz,
    skipped_at timestamptz,
    notes text,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- RLS for scheduled_doses
ALTER TABLE schedule.scheduled_doses ENABLE ROW LEVEL SECURITY;
CREATE POLICY sched_doses_patient_read ON schedule.scheduled_doses FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM schedule.medication_schedules ms
        JOIN prescription.prescription_medications pm ON pm.id = ms.prescription_medication_id
        JOIN prescription.prescriptions p ON p.id = pm.prescription_id
        WHERE ms.id = scheduled_doses.schedule_id
        AND p.patient_id = current_setting('app.current_user_id', true)::uuid
    )
);
CREATE POLICY sched_doses_patient_manage ON schedule.scheduled_doses FOR ALL USING (
    EXISTS (
        SELECT 1 FROM schedule.medication_schedules ms
        JOIN prescription.prescription_medications pm ON pm.id = ms.prescription_medication_id
        JOIN prescription.prescriptions p ON p.id = pm.prescription_id
        WHERE ms.id = scheduled_doses.schedule_id
        AND p.patient_id = current_setting('app.current_user_id', true)::uuid
    )
);