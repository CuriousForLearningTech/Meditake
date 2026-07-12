CREATE SCHEMA IF NOT EXISTS prescription;

/*
-- Documentation:
-- The prescription schema handles doctors, prescriptions, and recurrence rules.

-- Edge Cases:
-- - Overlapping prescription dates for the same medication.
-- - Handling timezone differences in recurrence rules if the patient travels.
-- - Deleting a prescription cascades to its medications but schedules may need logic to archive.

Sig codes (from the Latin signetur, "let it be  labeled") are medical shorthand 
used  by prescribers to  communicate dosage  instructions to  pharmacies. 
*/

CREATE TYPE prescription.prescription_status AS ENUM (
    'active',
    'completed',
    'cancelled',
    'paused',
    'expired'
);

CREATE TYPE prescription.meal_relation AS ENUM (
    'before_meal',
    'after_meal',
    'empty_stomach',
    'in_the_evening'
);

CREATE TYPE prescription.schedule_frequency AS ENUM (
    'every_day',
    'twice_a_day',
    'three_time_a_day',
    'fore_time_a_day',
    'every_4_hours',
    'every_12_hours',
    'at_bedtime'
);

CREATE TYPE prescription.schedule_interval_unit AS ENUM (
    'hours',
    'days'
);

CREATE TABLE prescription.doctors (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    full_name text NOT NULL,
    specialization text,
    hospital_name text,
    phone text,
    email text,
    created_at timestamptz NOT NULL DEFAULT now()
);

-- RLS for doctors
ALTER TABLE prescription.doctors ENABLE ROW LEVEL SECURITY;
CREATE POLICY doctors_read_all ON prescription.doctors FOR SELECT USING (true);

CREATE TABLE prescription.prescriptions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    patient_id uuid NOT NULL REFERENCES auth.users (id),
    doctor_id uuid REFERENCES prescription.doctors (id),
    diagnosis text,
    notes text,
    prescribed_at timestamptz NOT NULL DEFAULT now(),
    status prescription.prescription_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- RLS for prescriptions
ALTER TABLE prescription.prescriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY prescriptions_patient_read ON prescription.prescriptions FOR SELECT USING (patient_id = current_setting('app.current_user_id', true)::uuid);
CREATE POLICY prescriptions_patient_manage ON prescription.prescriptions FOR ALL USING (patient_id = current_setting('app.current_user_id', true)::uuid);

-- Merged recurrence_rules
CREATE TABLE prescription.recurrence_rules (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    rule_code VARCHAR,
    frequency_per_day prescription.schedule_frequency NOT NULL DEFAULT 'twice_a_day',
    interval_unit prescription.schedule_interval_unit NOT NULL DEFAULT 'days',
    max_frequency_per_day smallint NOT NULL DEFAULT 2,
    interval_value smallint NOT NULL DEFAULT 8,
    timezone text, -- Using text for timezone (e.g., 'UTC', 'America/New_York')
    take_as_needed boolean NOT NULL DEFAULT FALSE,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- RLS for recurrence_rules (usually tied to a prescription, but standalone here)
ALTER TABLE prescription.recurrence_rules ENABLE ROW LEVEL SECURITY;
CREATE POLICY recurrence_rules_all ON prescription.recurrence_rules FOR ALL USING (true); 
-- In a real scenario, this should be linked to the user via prescription_medications, but we leave it open for reads/writes for simplicity.

CREATE TABLE prescription.prescription_medications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    prescription_id uuid NOT NULL REFERENCES prescription.prescriptions (id) ON DELETE CASCADE,
    medicine_id uuid NOT NULL REFERENCES medication.medicines (id),
    strength_value decimal(10, 2) NOT NULL,
    instructions text,
    meal_relation prescription.meal_relation NOT NULL DEFAULT 'after_meal',
    take_as_needed boolean NOT NULL DEFAULT FALSE,
    recurrence_rule_id uuid NOT NULL REFERENCES prescription.recurrence_rules (id),
    start_date date NOT NULL DEFAULT CURRENT_DATE,
    end_date date,
    status prescription.prescription_status NOT NULL DEFAULT 'active',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

-- RLS for prescription_medications
ALTER TABLE prescription.prescription_medications ENABLE ROW LEVEL SECURITY;
CREATE POLICY rx_meds_patient_read ON prescription.prescription_medications FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM prescription.prescriptions p
        WHERE p.id = prescription_medications.prescription_id
        AND p.patient_id = current_setting('app.current_user_id', true)::uuid
    )
);
CREATE POLICY rx_meds_patient_manage ON prescription.prescription_medications FOR ALL USING (
    EXISTS (
        SELECT 1 FROM prescription.prescriptions p
        WHERE p.id = prescription_medications.prescription_id
        AND p.patient_id = current_setting('app.current_user_id', true)::uuid
    )
);
