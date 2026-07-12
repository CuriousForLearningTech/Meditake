CREATE SCHEMA IF NOT EXISTS medication;

/*
-- Documentation:
-- The medication schema stores the global catalog of medications, dosage forms, and manufacturers.
-- This data is generally read-only for regular users, and managed by administrators.

-- Edge Cases:
-- - Users could theoretically search for inactive medications if they have historical prescriptions.
-- - Brand names vs generic names can overlap; the schema captures both.
*/

CREATE TABLE medication.manufacturers (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    name text NOT NULL UNIQUE,
    website text,
    created_at timestamp WITH time zone NOT NULL DEFAULT now()
);

-- RLS for manufacturers
ALTER TABLE medication.manufacturers ENABLE ROW LEVEL SECURITY;
-- Anyone can read manufacturers
CREATE POLICY manufacturers_read_all ON medication.manufacturers FOR SELECT USING (true);
-- Only admins can modify (Assuming admin check logic or bypass RLS for admins)

CREATE TABLE medication.dosage_forms (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    name text NOT NULL UNIQUE,
    abbreviation text
);

-- RLS for dosage_forms
ALTER TABLE medication.dosage_forms ENABLE ROW LEVEL SECURITY;
CREATE POLICY dosage_forms_read_all ON medication.dosage_forms FOR SELECT USING (true);

CREATE TABLE medication.strength_units (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    name text NOT NULL UNIQUE,
    symbol text NOT NULL UNIQUE
);

-- RLS for strength_units
ALTER TABLE medication.strength_units ENABLE ROW LEVEL SECURITY;
CREATE POLICY strength_units_read_all ON medication.strength_units FOR SELECT USING (true);

CREATE TABLE medication.medicines (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
    generic_name text NOT NULL,
    brand_name text,
    description text,
    manufacturer_id uuid REFERENCES medication.manufacturers (id),
    dosage_form_id uuid REFERENCES medication.dosage_forms (id),
    strength numeric(10, 2),
    strength_unit_id uuid REFERENCES medication.strength_units (id),
    is_prescription_required boolean NOT NULL DEFAULT TRUE,
    is_active boolean NOT NULL DEFAULT TRUE,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- RLS for medicines
ALTER TABLE medication.medicines ENABLE ROW LEVEL SECURITY;
CREATE POLICY medicines_read_active ON medication.medicines FOR SELECT USING (is_active = true);
-- Also allow reading inactive if it's referenced by a user's prescription, but for simplicity, allow all reads or active only.
CREATE POLICY medicines_read_all ON medication.medicines FOR SELECT USING (true);
