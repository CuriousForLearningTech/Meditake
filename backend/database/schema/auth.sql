CREATE SCHEMA IF NOT EXISTS auth;

-- Documentation:
-- The auth schema handles all user authentication, sessions, devices, and audit logging.
-- RLS (Row Level Security) is enabled on all tables to ensure users can only access their own data.
-- We assume the application sets a session variable 'app.current_user_id' for queries.

CREATE TABLE auth.users (
    id uuid NOT NULL DEFAULT gen_random_uuid (),
    encrypted_password character varying,
    email character varying,
    email_confirmed_at timestamp WITH time zone,
    phone text DEFAULT NULL::CHARACTER varying UNIQUE,
    phone_confirmed_at timestamp WITH time zone,
    confirmation_token character varying,
    confirmation_sent_at timestamp WITH time zone,
    recovery_token character varying,
    recovery_sent_at timestamp WITH time zone,
    reauthentication_token character varying DEFAULT ''::character varying,
    reauthentication_sent_at timestamp WITH time zone,
    confirmed_at timestamp WITH time zone DEFAULT LEAST (email_confirmed_at, phone_confirmed_at),
    last_sign_in_at timestamp WITH time zone,
    created_at timestamp WITH time zone DEFAULT now(),
    updated_at timestamp WITH time zone DEFAULT now(),
    deleted_at timestamp WITH time zone,
    CONSTRAINT users_pkey PRIMARY KEY (id)
);

CREATE INDEX idx_users_email ON auth.users (email);

-- RLS for auth.users
ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;
CREATE POLICY users_self_read ON auth.users FOR SELECT USING (id = current_setting('app.current_user_id', true)::uuid);
CREATE POLICY users_self_update ON auth.users FOR UPDATE USING (id = current_setting('app.current_user_id', true)::uuid);

CREATE TABLE auth.audit_log_entries (
    id uuid NOT NULL DEFAULT gen_random_uuid (),
    payload json,
    created_at timestamp WITH time zone DEFAULT now(),
    ip_address inet NOT NULL DEFAULT '',
    CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id)
);

CREATE INDEX idx_audit_created ON auth.audit_log_entries (created_at);

-- RLS for audit_log_entries
ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;
-- Edge Case: Audit logs should generally be insert-only and only readable by admins.
CREATE POLICY audit_insert ON auth.audit_log_entries FOR INSERT WITH CHECK (true);
-- Select policy omitted: only superusers/admins can read audit logs.

CREATE TABLE auth.identities (
    id uuid NOT NULL DEFAULT gen_random_uuid (),
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text,
    email text DEFAULT NULL,
    last_sign_in_at timestamp WITH time zone,
    created_at timestamp WITH time zone DEFAULT now(),
    updated_at timestamp WITH time zone DEFAULT now(),
    CONSTRAINT identities_pkey PRIMARY KEY (id),
    CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
);

CREATE INDEX idx_identity_email ON auth.identities (email);

-- RLS for identities
ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;
CREATE POLICY identities_self_read ON auth.identities FOR SELECT USING (user_id = current_setting('app.current_user_id', true)::uuid);
CREATE POLICY identities_self_manage ON auth.identities FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE TABLE auth.devices ( 
    id uuid NOT NULL DEFAULT gen_random_uuid (),
    user_id uuid NOT NULL,
    device_name text NOT NULL,
    os text,
    browser text,
    last_seen timestamp WITHOUT time zone,
    created_at timestamp WITH time zone DEFAULT now(),
    CONSTRAINT devices_pkey PRIMARY KEY (id),
    CONSTRAINT devices_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
);

-- RLS for devices
ALTER TABLE auth.devices ENABLE ROW LEVEL SECURITY;
CREATE POLICY devices_self_manage ON auth.devices FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL DEFAULT gen_random_uuid (),
    user_id uuid NOT NULL,
    token_type VARCHAR NOT NULL,
    token_hash text NOT NULL CHECK (char_length(token_hash) > 0),
    relates_to text NOT NULL,
    expires_at timestamp WITH time zone,
    created_at timestamp WITH time zone NOT NULL DEFAULT now(),
    updated_at timestamp WITH time zone NOT NULL DEFAULT now(),
    CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id),
    CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
);

CREATE INDEX idx_otp_user ON auth.one_time_tokens (user_id);

-- RLS for one_time_tokens
ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;
-- Edge Case: Tokens are typically only managed by the system, so no RLS policies for standard users.
-- Application logic will bypass RLS (e.g. using a service role) to manage tokens.

CREATE TABLE auth.sessions (
    id uuid NOT NULL DEFAULT gen_random_uuid (),
    user_id uuid NOT NULL,
    created_at timestamp WITH time zone DEFAULT now(),
    updated_at timestamp WITH time zone DEFAULT now(),
    refreshed_at timestamp WITH time zone DEFAULT now(),
    ip inet,
    tag_device_name text,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    session_scopes text CHECK (char_length(session_scopes) <= 4096),
    CONSTRAINT sessions_pkey PRIMARY KEY (id),
    CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users (id) ON DELETE CASCADE
);

CREATE INDEX idx_sessions_user ON auth.sessions (user_id);

-- RLS for sessions
ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY sessions_self_manage ON auth.sessions FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE TABLE auth.refresh_tokens (
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    token character varying UNIQUE,
    user_id uuid REFERENCES auth.users (id) ON DELETE CASCADE,
    revoked boolean DEFAULT false,
    created_at timestamp WITH time zone DEFAULT now(),
    updated_at timestamp WITH time zone DEFAULT now(),
    parent_token character varying,
    session_id uuid,
    CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions (id) ON DELETE CASCADE
);

CREATE INDEX idx_refresh_session ON auth.refresh_tokens (session_id);

-- RLS for refresh_tokens
ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;
CREATE POLICY refresh_tokens_self_manage ON auth.refresh_tokens FOR ALL USING (user_id = current_setting('app.current_user_id', true)::uuid);
